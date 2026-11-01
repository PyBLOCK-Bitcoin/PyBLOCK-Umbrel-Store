# patum-refresh

Rebuilds the PATUM Node and PATUM Plumb app images on top of their pinned base image with security fixes only:
Debian 12 `apt-get upgrade`, Node.js 22 LTS (zeromq uses N-API) and the web panel's npm dependencies updated within
their semver ranges. bitcoind, the UI and the settings are unchanged.

```
docker buildx build --platform linux/amd64,linux/arm64 \
  --build-arg BASE=ghcr.io/horizon-btc/umbrel-bitcoin-knots:1.2.20@sha256:f75bc07728667773396e029ff88ddb30227693df225f1d4dac4c0646a7112c73 \
  -t registry.gitlab.com/astrolexis-group1/pyblock-umbrel-store/umbrel-patum-node:1.2.20-pyblock1 --push images/patum-refresh

docker buildx build --platform linux/amd64,linux/arm64 \
  --build-arg BASE=ghcr.io/plumb-node/umbrel-plumb@sha256:e8f8af2124b9ff74107f3eb0d994d0153ec8c8e87e611a207c0f5bc053621d31 \
  -t registry.gitlab.com/astrolexis-group1/pyblock-umbrel-store/umbrel-plumb:v29.4.3.knots20260508.plumb9-pyblock1 --push images/patum-refresh
```

PATUM Plumb 8 (2026-10-27): the base is upstream `ghcr.io/plumb-node/umbrel-plumb:v29.4.3.knots20260508.plumb8`. Its
`bitcoind` is byte-identical to the signed release tarballs (SHA256SUMS signed by Jason Sopko 89F0E41D…C40CD1BA):
x86_64 `1a9e12634065f3e5…`, aarch64 `836590294b09207f…`.

PATUM Plumb 9 (2026-11-01): the base is upstream `ghcr.io/plumb-node/umbrel-plumb:v29.4.3.knots20260508.plumb9`
(`sha256:e8f8af21…`). Its `bitcoind` is byte-identical to the signed release tarballs (SHA256SUMS signed by Jason
Sopko 89F0E41D…C40CD1BA): x86_64 `33a9dfafdc8b834c…`, aarch64 `02b24c2a0807fd35…`; so is the one in our image
`umbrel-plumb:v29.4.3.knots20260508.plumb9-pyblock1@sha256:9611e292…`.
