# patum-refresh

Rebuilds the PATUM Node and PATUM Plumb app images on top of their pinned base image with security fixes only:
Debian 12 `apt-get upgrade`, Node.js 22 LTS (zeromq uses N-API) and the web panel's npm dependencies updated within
their semver ranges. bitcoind, the UI and the settings are unchanged.

```
docker buildx build --platform linux/amd64,linux/arm64 \
  --build-arg BASE=ghcr.io/horizon-btc/umbrel-bitcoin-knots:1.2.20@sha256:f75bc07728667773396e029ff88ddb30227693df225f1d4dac4c0646a7112c73 \
  -t registry.gitlab.com/astrolexis-group1/pyblock-umbrel-store/umbrel-patum-node:1.2.20-pyblock1 --push images/patum-refresh

docker buildx build --platform linux/amd64,linux/arm64 \
  --build-arg BASE=registry.gitlab.com/astrolexis-group1/pyblock-umbrel-store/umbrel-plumb:v29.4.2.knots20260508.plumb7@sha256:2d1c8bdd1133b79013d37c295280278e31e5cba7de68875bf2dd621b7ed68067 \
  -t registry.gitlab.com/astrolexis-group1/pyblock-umbrel-store/umbrel-plumb:v29.4.2.knots20260508.plumb7-pyblock1 --push images/patum-refresh
```
