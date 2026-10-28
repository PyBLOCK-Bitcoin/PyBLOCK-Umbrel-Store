# patum-refresh

Rebuilds the PATUM Node and PATUM Plumb app images on top of their pinned base image with security fixes only:
Debian 12 `apt-get upgrade`, Node.js 22 LTS (zeromq uses N-API) and the web panel's npm dependencies updated within
their semver ranges. bitcoind, the UI and the settings are unchanged.

```
docker buildx build --platform linux/amd64,linux/arm64 \
  --build-arg BASE=ghcr.io/horizon-btc/umbrel-bitcoin-knots:1.2.20@sha256:f75bc07728667773396e029ff88ddb30227693df225f1d4dac4c0646a7112c73 \
  -t registry.gitlab.com/astrolexis-group1/pyblock-umbrel-store/umbrel-patum-node:1.2.20-pyblock1 --push images/patum-refresh

docker buildx build --platform linux/amd64,linux/arm64 \
  --build-arg BASE=ghcr.io/plumb-node/umbrel-plumb@sha256:222c70157d46b5311b2404532c103d0468c3d1de00a12ed7241c679f985caff7 \
  -t registry.gitlab.com/astrolexis-group1/pyblock-umbrel-store/umbrel-plumb:v29.4.3.knots20260508.plumb8-pyblock1 --push images/patum-refresh
```

PATUM Plumb 8 (2026-10-27): the base is upstream `ghcr.io/plumb-node/umbrel-plumb:v29.4.3.knots20260508.plumb8`. Its
`bitcoind` is byte-identical to the signed release tarballs (SHA256SUMS signed by Jason Sopko 89F0E41D…C40CD1BA):
x86_64 `1a9e12634065f3e5…`, aarch64 `836590294b09207f…`.
