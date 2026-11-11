#!/usr/bin/env bash
# Tests for the pre-start hook of the pool apps (CAROUSEL, CHIRP, WAVICLES and their -fallback twins). Run before every store push
# (the push script refuses to push if this fails). Needs bash, jq and root (for the chown checks).
#   bash tests/pool-app-hooks.sh
# 2026-11-01: 1.1.0 shipped a hook that stopped before setting the settings password when the PATUM (Knots)
# variables were missing (PATUM (Plumb) users), and nobody had tried that case. Every case a user can be in is here.
set -uo pipefail
cd "$(dirname "$0")/.."
FAIL=0; N=0
BASE=$(mktemp -d)
trap 'rm -rf "${BASE:?}"' EXIT
ok()  { N=$((N+1)); }
bad() { N=$((N+1)); FAIL=$((FAIL+1)); echo "  ✗ $*"; }

declare -A STRATUM=([carousel]=23338 [chirp]=23341 [wavicles]=23342 [carousel-fallback]=23343 [chirp-fallback]=23344 [wavicles-fallback]=23345)
declare -A WEB=([carousel]=21008 [chirp]=21011 [wavicles]=21012 [carousel-fallback]=21013 [chirp-fallback]=21014 [wavicles-fallback]=21015)
KNOTS=(APP_BITCOIN_KNOTS_RPC_USER=ku APP_BITCOIN_KNOTS_RPC_PASS=kp APP_BITCOIN_KNOTS_NODE_IP=10.21.21.8 APP_BITCOIN_KNOTS_INTERNAL_RPC_PORT=9332)
PLUMB=(APP_PLUMB_NODE_RPC_USER=pu APP_PLUMB_NODE_RPC_PASS=pp APP_PLUMB_NODE_NODE_IP=10.21.21.110 APP_PLUMB_NODE_RPC_PORT=10332)

# run <app> <config jq filter> <env…> → path of the resulting config
run() {
  local app=$1 filter=$2; shift 2
  local d; d=$(mktemp -d -p "$BASE")/pyblock-datum-$app
  mkdir -p "$d/hooks" "$d/data/settings"
  cp "pyblock-datum-$app/hooks/pre-start" "$d/hooks/"
  jq "$filter" "pyblock-datum-$app/data/settings/datum_gateway_config.json" > "$d/data/settings/datum_gateway_config.json"
  env -i PATH=/usr/bin:/bin APP_PASSWORD=app-pw "$@" bash "$d/hooks/pre-start" > "$d/out.log" 2>&1 || bad "$app: hook exited non-zero ($(tail -1 "$d/out.log"))"
  echo "$d/data/settings/datum_gateway_config.json"
}
check() {   # check <name> <config> <jq expression that must be true>
  if jq -e "$3" "$2" > /dev/null; then ok; else bad "$1: $3 — got $(jq -c '{pw:.api.admin_password,rpc:.bitcoind.rpcurl,s:.stratum.listen_port,a:.api.listen_port,addr:.mining.pool_address}' "$2")"; fi
}

# 2026-11-11: the -fallback twins (own ports) prefer PATUM (Plumb) when both nodes are installed; the main apps prefer Knots
for app in carousel chirp wavicles carousel-fallback chirp-fallback wavicles-fallback; do
  [ -x "pyblock-datum-$app/hooks/pre-start" ] && ok || bad "$app: hooks/pre-start is not executable (Umbrel skips it)"
  S=${STRATUM[$app]} A=${WEB[$app]}
  grep -q "^port: $A\$" "pyblock-datum-$app/umbrel-app.yml" && ok || bad "$app: umbrel-app.yml port is not $A"
  grep -q "APP_PORT: $A\$" "pyblock-datum-$app/docker-compose.yml" && ok || bad "$app: compose APP_PORT is not $A"
  grep -q -- "- $S:$S\$" "pyblock-datum-$app/docker-compose.yml" && ok || bad "$app: compose does not map $S"

  f=$(run "$app" '.mining.pool_address="bc1qkeep" | .api.admin_password="umbrel"' "${PLUMB[@]}")
  check "$app plumb" "$f" '.api.admin_password=="app-pw" and .bitcoind.rpcurl=="10.21.21.110:10332" and .mining.pool_address=="bc1qkeep"'
  f=$(run "$app" '.api.admin_password=""' "${KNOTS[@]}")
  check "$app knots, empty password" "$f" '.api.admin_password=="app-pw" and .bitcoind.rpcurl=="10.21.21.8:9332"'
  f=$(run "$app" '.bitcoind.rpcurl="keep:1" | .api.admin_password="umbrel"')
  check "$app no node" "$f" '.api.admin_password=="app-pw" and .bitcoind.rpcurl=="keep:1"'
  f=$(run "$app" '.api.admin_password="mine"' "${KNOTS[@]}" "${PLUMB[@]}")
  case $app in *-fallback) both=10.21.21.110:10332 ;; *) both=10.21.21.8:9332 ;; esac
  check "$app own password, both nodes" "$f" ".api.admin_password==\"mine\" and .bitcoind.rpcurl==\"$both\""
  f=$(run "$app" ".stratum.listen_port=23339 | .api.listen_port=21009" "${PLUMB[@]}")
  check "$app old ports" "$f" ".stratum.listen_port==$S and .api.listen_port==$A"
  if [ "$(id -u)" = 0 ]; then
    [ "$(stat -c '%u:%g %a' "$f")" = "1000:1000 600" ] && ok || bad "$app: config is $(stat -c '%u:%g %a' "$f"), want 1000:1000 600"
    [ "$(stat -c '%u' "$(dirname "$f")")" = 1000 ] && ok || bad "$app: settings folder not owned by 1000"
  fi
done
echo "pool app hooks: $((N-FAIL))/$N ok"
[ "$FAIL" = 0 ]
