# umbrel-plumb image (PATUM (Plumb), Plumb 15)

`registry.gitlab.com/astrolexis-group1/pyblock-umbrel-store/umbrel-plumb:v29.5.1.knots20260508.plumb15-pyblock1`
(linux/amd64 + linux/arm64; pin the index digest the push prints in `pyblock-plumb/docker-compose.yml`).

From plumb10 on the base is the upstream `ghcr.io/plumb-node/umbrel-plumb` image of that release, pinned by digest, with
Debian's pending security updates applied (`images/patum-refresh/Dockerfile.apt`). For plumb15 the base is
`ghcr.io/plumb-node/umbrel-plumb@sha256:569bf88f3c9146f66408fd96e97d8871b2c99293d829782d874e6b963ec4a65c`; its `bitcoind`
is byte-identical to the signed release tarballs (Jason Sopko, 89F0E41D72CE523F4AA1CDB692CDFFB7C40CD1BA):
amd64 `13e6fb4ec8f777c5…`, arm64 `03aa1f2aa681f574…`.

- Build: `docker buildx build --platform linux/amd64,linux/arm64 --build-arg BASE=<upstream@sha256:…> -f images/patum-refresh/Dockerfile.apt -t <tag> --push images/patum-refresh`

Release tarball SHA-256 (from the signed SHA256SUMS):
- 8d65122250c196e3f789840f1b55815ba252be255d46c13f3511160de1f1da5c  bitcoin-29.5.1.knots20260508.plumb15-x86_64-linux-gnu.tar.gz
- b36866085aee8698f490e29fca35b03883f1ca571eadd89954afbe8159faac27  bitcoin-29.5.1.knots20260508.plumb15-aarch64-linux-gnu.tar.gz
