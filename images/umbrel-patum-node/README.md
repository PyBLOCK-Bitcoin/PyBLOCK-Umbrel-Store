# umbrel-patum-node image (PATUM (Knots), Bitcoin Knots 29.5)

`registry.gitlab.com/astrolexis-group1/pyblock-umbrel-store/umbrel-patum-node:1.2.20-knots29.5-pyblock1`
(linux/amd64 + linux/arm64; pin the index digest the push prints in `pyblock-bitcoinknots/docker-compose.yml`).

It is our `umbrel-patum-node:1.2.20-knots29.4.3-pyblock1` (index `sha256:a16f1cb5…`, already security-refreshed, with
29.4.3) plus `bitcoind` and `bitcoin-cli` of Bitcoin Knots `v29.5.knots20260508` as the new "latest". These are the
OFFICIAL release binaries: `SHA256SUMS` carries a valid signature by Luke Dashjr (1A3E761F19D2CC7785C5502EA291A2C45D0C504A)
and the tarballs match it. Consensus code is the same as 29.4.3 (network/IO/build changes and mempool policy knots#400),
so an existing datadir upgrades without a reindex. Earlier versions stay installed for anyone who pinned one in the
app's settings.

- Build: put `bitcoind` and `bitcoin-cli` from the tarballs below in `bin/amd64/` and `bin/arm64/` (not committed), then
  `docker buildx build --platform linux/amd64,linux/arm64 -t <tag> --push .`

Release tarball SHA-256 (from the signed SHA256SUMS):
- 2e0c1a9f52d76ed1fa8ad3efce5d52dfacae1dfb161558c85ef37c9379ba3d13  bitcoin-29.5.knots20260508-x86_64-linux-gnu.tar.gz
- 47eb609d25f6de326dd0caaaab2cc093c3cc05540e18f203a6d8f60e33277569  bitcoin-29.5.knots20260508-aarch64-linux-gnu.tar.gz

bitcoind SHA-256: x86_64 `4eb2bf6cd9e50c64…`, aarch64 `461dc20d6eb6eef8…`.
