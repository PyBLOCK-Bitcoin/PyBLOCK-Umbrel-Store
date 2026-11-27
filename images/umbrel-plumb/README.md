# umbrel-plumb image (PATUM (Plumb), Plumb 16)

`registry.gitlab.com/astrolexis-group1/pyblock-umbrel-store/umbrel-plumb:v29.5.1.knots20260508.plumb16-pyblock1`
(linux/amd64 + linux/arm64; pin the index digest the push prints in `pyblock-plumb/docker-compose.yml`).

From plumb10 on the base is the upstream `ghcr.io/plumb-node/umbrel-plumb` image of that release, pinned by digest, with
Debian's pending security updates applied (`images/patum-refresh/Dockerfile.apt`). For plumb16 the base is
`ghcr.io/plumb-node/umbrel-plumb@sha256:e6e3b4df916bf94f371dba1ec5506732bdda0bff4ef32669baf16c067b70e28d`; its `bitcoind`
is byte-identical to the signed release tarballs (Jason Sopko, 89F0E41D72CE523F4AA1CDB692CDFFB7C40CD1BA):
amd64 `1afea38ce0870a92…`, arm64 `974baf158186c7bc…`.

- Build: `docker buildx build --platform linux/amd64,linux/arm64 --build-arg BASE=<upstream@sha256:…> -f images/patum-refresh/Dockerfile.apt -t <tag> --push images/patum-refresh`

Release tarball SHA-256 (from the signed SHA256SUMS):
- 71a030f14a19ffa3fac8ccc711c522ed8766aecbaad73906ebd3cc0fcd365981  bitcoin-29.5.1.knots20260508.plumb16-x86_64-linux-gnu.tar.gz
- f71ebd0e518d0b0216e758bda297ad0c01c79f60d0e6ae6b5f0ab63acb5d4ecd  bitcoin-29.5.1.knots20260508.plumb16-aarch64-linux-gnu.tar.gz
