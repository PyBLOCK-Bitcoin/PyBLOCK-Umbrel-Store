# umbrel-patum-node image (PATUM (Knots), Bitcoin Knots 29.5.1)

`registry.gitlab.com/astrolexis-group1/pyblock-umbrel-store/umbrel-patum-node:1.2.20-knots29.5.1-pyblock1`
(linux/amd64 + linux/arm64; pin the index digest the push prints in `pyblock-bitcoinknots/docker-compose.yml`).

It is our `umbrel-patum-node:1.2.20-knots29.5-pyblock1` (index `sha256:abc2da0e…`, the PATUM (Knots) 1.0.6 image) plus
`bitcoind` and `bitcoin-cli` of Bitcoin Knots `v29.5.1.knots20260508` as the new "latest". These are the OFFICIAL release
binaries: `SHA256SUMS` carries a valid signature by Luke Dashjr (1A3E761F19D2CC7785C5502EA291A2C45D0C504A) and the
tarballs match it. 29.5.1 fixes CVE-2026-117348 and tightens mempool policy (knots#298, #470, #514); knots#520 splits the
BLAKE2b fork rules into separate flags and keeps the annex banned on every input (no block since 961640 uses one), so an
existing datadir upgrades without a reindex. Earlier versions stay installed for anyone who pinned one in the settings.

- Build: put `bitcoind` and `bitcoin-cli` from the tarballs below in `bin/amd64/` and `bin/arm64/` (not committed), then
  `docker buildx build --platform linux/amd64,linux/arm64 -t <tag> --push .`

Release tarball SHA-256 (from the signed SHA256SUMS):
- 7a15eca0ea948d3ec162e571551374ebe4b41e5c0daa88f58d48a03ef3f1b93a  bitcoin-29.5.1.knots20260508-x86_64-linux-gnu.tar.gz
- 7d60e2245e7a26539b1e166a4daa3546dea99e310d868f693cc65739c7051793  bitcoin-29.5.1.knots20260508-aarch64-linux-gnu.tar.gz

bitcoind SHA-256: x86_64 `b5c1693a91fcad37…`, aarch64 `7f932c9a815ed596…`.
