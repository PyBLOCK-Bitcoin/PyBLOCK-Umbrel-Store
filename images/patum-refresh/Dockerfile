# syntax=docker/dockerfile:1
# PATUM Node / PATUM Plumb (Umbrel): la misma imagen fijada por digest + parches de seguridad.
#   - Debian 12: apt-get upgrade (glibc, curl, zlib, gnutls, perl… del escaneo del 2026-10-23)
#   - Node 22 LTS en lugar de Node 20 (fin de soporte); zeromq usa N-API, no depende de la versión de Node
#   - dependencias npm del panel dentro de su rango semver (fastify, ws, fast-uri, zod, lodash…)
# bitcoind, la UI y la configuración no cambian.
#   docker buildx build --platform linux/amd64,linux/arm64 --build-arg BASE=<imagen@sha256:…> -t <tag> images/patum-refresh
ARG BASE
ARG NODE_IMAGE=node:22-bookworm-slim@sha256:de170b39439eb0e5a3444ad7d60b015614a381e10fecae2e30ec9e735122f38d
FROM ${NODE_IMAGE} AS node22

FROM ${BASE}
USER root
RUN set -eux; apt-get update; DEBIAN_FRONTEND=noninteractive apt-get -y upgrade; apt-get clean; rm -rf /var/lib/apt/lists/*
COPY --from=node22 /usr/local/bin/node /usr/local/bin/node
RUN set -eux; node -v | grep -q '^v22\.'; cd /app; \
    npm update --omit=dev --no-audit --no-fund \
      fastify @fastify/static find-my-way fast-uri ws zod ip-address lodash minimatch brace-expansion glob @isaacs/brace-expansion; \
    npm cache clean --force; \
    node -e "import('/app/node_modules/zeromq/lib/index.js').then(()=>console.log('zeromq ok'))"
