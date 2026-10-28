# umbrel-patum-node image (PATUM Node, Bitcoin Knots 29.4.3)

`registry.gitlab.com/astrolexis-group1/pyblock-umbrel-store/umbrel-patum-node:1.2.20-knots29.4.3-pyblock1`
(linux/amd64 + linux/arm64, index digest `sha256:a16f1cb52fe70f9b5ce2288b86b3bc89a002a1b76963b4f65d1d105b33fc8510`).

It is our `umbrel-patum-node:1.2.20-pyblock1` (already security-refreshed) with `bitcoind` and `bitcoin-cli` of Bitcoin Knots
`v29.4.3.knots20260508` added as the new "latest". Knots had not published 29.4.3 binaries when this was built, so PyBLOCK built
them from the tag signed by Luke Dashjr (1A3E761F19D2CC7785C5502EA291A2C45D0C504A) with Plumb's release-tarball tool (Debian 11,
GCC 12.3, the tree's depends system, test_bitcoin, contrib/devtools symbol-check and security-check, a regtest start).
Earlier versions stay installed for anyone who pinned one in the app's settings.

- Build: put the extracted binaries in `bin/amd64/` and `bin/arm64/` (not committed), then
  `docker buildx build --platform linux/amd64,linux/arm64 -t <tag> --push .`

Release tarball SHA-256 (the binaries come from these):
- a07fd6dda8d108c8eff33e08cfead3ca2d3c72dfaa4337ed11855218be7bee8f  bitcoin-29.4.3.knots20260508-x86_64-linux-gnu.tar.gz
- f1f04b199885d6d408c2a9fd999f5a9e77ca492156a5abd0b99e799a171dea34  bitcoin-29.4.3.knots20260508-aarch64-linux-gnu.tar.gz

bitcoind SHA-256: x86_64 `3b47afc5a88a2796…`, aarch64 `3163fd0cd3275a0a…`. When Knots publishes official 29.4.3 binaries,
compare them; if they differ (builds are not bit-reproducible across toolchains), switch to the official ones.
