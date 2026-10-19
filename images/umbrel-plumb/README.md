# umbrel-plumb image (PATUM Plumb)

`registry.gitlab.com/astrolexis-group1/pyblock-umbrel-store/umbrel-plumb:v29.4.2.knots20260508.plumb7`
(linux/amd64 + linux/arm64, index digest `sha256:2d1c8bdd1133b79013d37c295280278e31e5cba7de68875bf2dd621b7ed68067`).

It is the upstream `ghcr.io/plumb-node/umbrel-plumb` plumb6 image (pinned by digest) with `bitcoind` and `bitcoin-cli`
of Plumb `v29.4.2.knots20260508.plumb7`. Those binaries are built by PyBLOCK from the signed tag (Jason Sopko,
89F0E41D72CE523F4AA1CDB692CDFFB7C40CD1BA) with the Knots `depends` system. Upstream has not published a plumb7 Umbrel image yet.

- plumb7 becomes the "latest" version in the app's settings. plumb6 stays installed for anyone who pinned it.
- Build: put the extracted binaries in `bin/amd64/` and `bin/arm64/`, then
  `docker buildx build --platform linux/amd64,linux/arm64 -t <tag> --push .`

Release tarball SHA-256 (the binaries come from these):
- e4a0e898c7da62f1f0538263d34d0b3f76bc619282f1e8b4984a7325971e2890  bitcoin-29.4.2.knots20260508.plumb7-x86_64-linux-gnu.tar.gz
- 6106cacfff0d7db37d72b298ec059064efbecb0cf40ea9bf8710f057b27ad7e9  bitcoin-29.4.2.knots20260508.plumb7-aarch64-linux-gnu.tar.gz
