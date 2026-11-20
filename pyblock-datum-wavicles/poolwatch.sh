#!/bin/bash
# PyBLOCK pool watch: runs the DATUM gateway and, when a backup pool is set, points it at the backup while its own
# pool is lost, then back. Shared by the PyBLOCK pool apps on Umbrel and StartOS (one copy per app, all identical;
# the store tests check that). Same rules as PATUM 0.6.1:
#   - the gateway page says the pool is lost ("Not Ready" / "Non-Pooled Mode") for 5 minutes and the backup pool
#     answers → the gateway is pointed at the backup and restarted (a few seconds without work);
#   - on the backup: once the main pool has answered for 10 minutes without a break it goes back; if the backup is
#     lost while the main pool answers, it goes back right away.
# Only datum.pool_port, datum.pool_pubkey and mining.coinbase_tag_primary change; the payout address, the name in
# blocks, the ports and the settings are kept. A config that points at neither pool (edited by hand) is left alone.
#
#   poolwatch.sh <config file> <gateway web port> <main pool> <backup pool|none>
#
# Like the launcher it replaces, it runs the gateway as a child (datum_gateway has no SIGTERM handler, and PID 1 does
# not get the default action), forwards TERM/INT and exits with the gateway's own exit code.
set -u
CONF=$1
API=$2
MAIN=$3
BACKUP=${4:-none}
GW=${PYBLOCK_GATEWAY_BIN:-/app/datum_gateway}
FAILOVER_AFTER=${PYBLOCK_FAILOVER_AFTER:-300}
FAILBACK_AFTER=${PYBLOCK_FAILBACK_AFTER:-600}
EVERY=${PYBLOCK_WATCH_EVERY:-30}
PROBE_HOST=${PYBLOCK_PROBE_HOST:-b.pyblock.xyz}
EVENTS="$(dirname "$CONF")/pool-events.log"

port_of() {
  case $1 in
    wavicles) echo 28915 ;;
    carousel) echo 28916 ;;
    chirp) echo 28917 ;;
  esac
}
pubkey_of() {
  case $1 in
    wavicles) echo b5e0b0326b964a92f3046c73a76b9e98173e0c3ea0e0ca771f4e6a3dd92e2935b2caad2a088fdd7bf0a48fc0c41776a9abb13c7d4c6964b53a9ceee4c775e036 ;;
    carousel) echo 36f94e73ae4c9b9c479c544f035bc9e69565e9d882112031cb27032ecbac818e35a7976501d5cd0453f9fc3e9823127839225e89c45a2cc80902ba0a7e09577b ;;
    chirp) echo cf995bb5b975ef4b90932f0608c98a033679092e976982621243cd1226803c6417442870dff8372b11363d8f80665b1f298cc23132bf2dab23958a4bcc7d4f72 ;;
  esac
}
upper() { echo "$1" | tr '[:lower:]' '[:upper:]'; }

say() {
  echo "pool watch: $*"
  { echo "$(date -u '+%Y-%m-%d %H:%M:%SZ') $*" >> "$EVENTS"; } 2>/dev/null
  if [ -f "$EVENTS" ] && [ "$(wc -l < "$EVENTS" 2>/dev/null || echo 0)" -gt 400 ]; then
    tail -n 200 "$EVENTS" > "$EVENTS.tmp" 2>/dev/null && mv -f "$EVENTS.tmp" "$EVENTS"
  fi
}

[ -n "$(port_of "$MAIN")" ] || { echo "pool watch: unknown pool '$MAIN'"; exit 2; }
if [ "$BACKUP" != none ] && { [ -z "$(port_of "$BACKUP")" ] || [ "$BACKUP" = "$MAIN" ]; }; then
  echo "pool watch: backup pool '$BACKUP' ignored (unknown, or the same pool)"
  BACKUP=none
fi

# The pool port the config points at now.
conf_port() { grep -oE '"pool_port"[[:space:]]*:[[:space:]]*[0-9]+' "$CONF" 2>/dev/null | grep -oE '[0-9]+$' | head -n 1; }

# Point the config at <pool>: pool port, pool key and the pool's coinbase tag; nothing else.
point_at() {
  local p=$1 port key tag tmp
  port=$(port_of "$p"); key=$(pubkey_of "$p"); tag="PyBLOCK $(upper "$p")"
  tmp="$CONF.poolwatch.$$"
  ( umask 077
    sed -E -e "s/(\"pool_port\"[[:space:]]*:[[:space:]]*)[0-9]+/\1$port/" \
           -e "s/(\"pool_pubkey\"[[:space:]]*:[[:space:]]*\")[0-9a-fA-F]*\"/\1$key\"/" \
           -e "s/(\"coinbase_tag_primary\"[[:space:]]*:[[:space:]]*\")[^\"]*\"/\1$tag\"/" "$CONF" > "$tmp" ) || { rm -f "$tmp"; return 1; }
  if grep -qE "\"pool_port\"[[:space:]]*:[[:space:]]*$port([^0-9]|$)" "$tmp" && grep -q "\"$key\"" "$tmp"; then
    mv -f "$tmp" "$CONF"
  else
    rm -f "$tmp"; return 1
  fi
}

# "ready", "lost" or "" (starting, error, page not answering) from the gateway's own status page.
state() {
  local page
  page=$(timeout 8 bash -c 'exec 3<>"/dev/tcp/127.0.0.1/$1" || exit 1
    printf "GET / HTTP/1.0\r\nHost: 127.0.0.1\r\nConnection: close\r\n\r\n" >&3
    cat <&3' _ "$API" 2>/dev/null)
  case $page in
    *"Connected and Ready"*) echo ready ;;
    *"Non-Pooled Mode"*|*"Not Ready"*) echo lost ;;
  esac
}

# Does the pool's DATUM port take a connection right now.
answers() { timeout 6 bash -c 'exec 3<>"/dev/tcp/$1/$2"' _ "$PROBE_HOST" "$(port_of "$1")" 2>/dev/null; }

PID=
STOP=
start_gateway() { "$GW" "--config=$CONF" & PID=$!; }
wait_gateway() {   # wait until the gateway has really exited; its exit code in RC
  RC=0
  wait "$PID" || RC=$?
  while [ "$RC" -gt 128 ] && kill -0 "$PID" 2>/dev/null; do RC=0; wait "$PID" || RC=$?; done
}
trap 'STOP=1; [ -n "$PID" ] && kill -TERM "$PID" 2>/dev/null' TERM INT

ulimit -n 65535 2>/dev/null || ulimit -n "$(ulimit -Hn)" 2>/dev/null || true

switch_to() {   # switch_to <pool> <why>
  if ! point_at "$1"; then
    say "could not rewrite $CONF for $(upper "$1"); staying"
    return
  fi
  say "$2"
  kill -TERM "$PID" 2>/dev/null
  wait_gateway
  [ -n "$STOP" ] && exit "$RC"
  start_gateway
  say "now mining for $(upper "$1")"
}

if [ "$BACKUP" = none ]; then
  echo "pool watch: no backup pool; the gateway mines for $(upper "$MAIN") only"
else
  echo "pool watch: main pool $(upper "$MAIN"), backup pool $(upper "$BACKUP")"
fi
start_gateway
since=0
while :; do
  for _ in $(seq "$EVERY"); do
    kill -0 "$PID" 2>/dev/null || break
    sleep 1
  done
  if [ -n "$STOP" ] || ! kill -0 "$PID" 2>/dev/null; then
    wait_gateway
    exit "$RC"
  fi
  [ "$BACKUP" = none ] && continue

  cur=$(conf_port)
  if [ "$cur" = "$(port_of "$MAIN")" ]; then onb=0
  elif [ "$cur" = "$(port_of "$BACKUP")" ]; then onb=1
  else since=0; continue
  fi
  st=$(state)
  now=$(date +%s)
  if [ $onb = 0 ]; then
    if [ "$st" != lost ]; then since=0; continue; fi
    [ "$since" = 0 ] && since=$now
    if [ $((now - since)) -ge "$FAILOVER_AFTER" ] && answers "$BACKUP"; then
      since=0
      switch_to "$BACKUP" "main pool $(upper "$MAIN") lost → backup $(upper "$BACKUP")"
    fi
  else
    if ! answers "$MAIN"; then since=0; continue; fi
    if [ "$st" = lost ] && ! answers "$BACKUP"; then
      since=0
      switch_to "$MAIN" "backup $(upper "$BACKUP") lost, main pool $(upper "$MAIN") answers → back"
      continue
    fi
    [ "$since" = 0 ] && since=$now
    if [ $((now - since)) -ge "$FAILBACK_AFTER" ]; then
      since=0
      switch_to "$MAIN" "main pool $(upper "$MAIN") back"
    fi
  fi
done
