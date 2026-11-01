# syntax=docker/dockerfile:1
# DATUM Gateway de CONVOY (BLAKE2b) para las apps de pools de PyBLØCK en Umbrel y StartOS (CAROUSEL, CHIRP, WAVICLES).
# Reemplaza a ghcr.io/retropex/datum:v1.14-blake2b-4 (2026-09-08) con la misma receta: Debian trixie-slim, compilado con
# -DDATUM_API_FOR_UMBREL, binario en /app/datum_gateway, usuario datum. El código es el commit fijado de abajo, bajado de
# GitHub y comprobado por hash (v0.5.0beta = 69c61a9, el mismo que corren los gateways de PyBLØCK y el /gateway de PATUM).
#   docker buildx build --platform linux/amd64,linux/arm64 -t <tag> images/datum-convoy
ARG DEBIAN=debian:trixie-slim@sha256:f6b08b09a05725f9431502d3b5714f5c4576e82c1a84fa1debe0c24a7e0c3ec4
FROM ${DEBIAN} AS build
ARG DATUM_REPO=https://github.com/CONVOYMining/datum_gateway.git
ARG DATUM_COMMIT=69c61a95cb941c35138c30b8d738e789ad8cdac1
RUN set -eux; apt-get update; DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      build-essential cmake pkg-config git ca-certificates libmicrohttpd-dev libjansson-dev libcurl4-openssl-dev libsodium-dev; \
    rm -rf /var/lib/apt/lists/*
WORKDIR /app
RUN set -eux; git init -q .; git fetch -q --depth 1 "$DATUM_REPO" "$DATUM_COMMIT"; git checkout -q FETCH_HEAD; \
    test "$(git rev-parse HEAD)" = "$DATUM_COMMIT"; \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS=-DDATUM_API_FOR_UMBREL . && make -j"$(nproc)"; \
    ./datum_gateway --version

FROM ${DEBIAN}
RUN set -eux; apt-get update; DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      libmicrohttpd12 libjansson4 libsodium23 libcurl4t64; \
    rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY --from=build /app/datum_gateway /app/datum_gateway
RUN useradd --no-create-home --shell /usr/sbin/nologin datum
USER datum
LABEL org.opencontainers.image.source=https://gitlab.com/astrolexis-group1/pyblock-umbrel-store \
      org.opencontainers.image.description="CONVOY DATUM Gateway v0.5.0beta (BLAKE2b) for the PyBLOCK pool apps" \
      org.opencontainers.image.version=v0.5.0beta-69c61a9
CMD ["./datum_gateway"]
