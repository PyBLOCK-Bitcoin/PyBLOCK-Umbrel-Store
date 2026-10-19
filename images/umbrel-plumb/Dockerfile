# PATUM Plumb para Umbrel: imagen oficial plumb-node/umbrel-plumb (plumb6) + bitcoind/bitcoin-cli de Plumb 7
# compilados por PyBLOCK desde el tag firmado v29.4.2.knots20260508.plumb7 (firma Jason Sopko 89F0E41D…0BA).
# plumb7 pasa a ser la versión "latest"; plumb6 queda instalada para quien la haya fijado en los ajustes.
FROM ghcr.io/plumb-node/umbrel-plumb@sha256:934c945643faf8b4e41a18f88bd0451afe075c5d36c07a2005344b8123468529
ARG TARGETARCH
COPY --chown=root:root --chmod=0755 bin/${TARGETARCH}/ /opt/bitcoind/v29.4.2.knots20260508.plumb7/
RUN set -e; cd /app \
 && sed -i "s|\['v29.4.2.knots20260508.plumb6'\]|['v29.4.2.knots20260508.plumb7', 'v29.4.2.knots20260508.plumb6']|" libs/settings/dist/settings.meta.js \
 && grep -q "'v29.4.2.knots20260508.plumb7', 'v29.4.2.knots20260508.plumb6'" libs/settings/dist/settings.meta.js \
 && for f in dist/public/assets/*.js; do sed -i 's|\["v29.4.2.knots20260508.plumb6"\]|["v29.4.2.knots20260508.plumb7","v29.4.2.knots20260508.plumb6"]|' "$f"; done \
 && grep -lq '"v29.4.2.knots20260508.plumb7","v29.4.2.knots20260508.plumb6"' dist/public/assets/*.js \
 && ln -sfn /opt/bitcoind/v29.4.2.knots20260508.plumb7 /opt/bitcoind/current \
 && /opt/bitcoind/current/bitcoin-cli -version | head -1 | grep -q plumb7
LABEL org.opencontainers.image.source="https://gitlab.com/astrolexis-group1/pyblock-umbrel-store" \
      org.opencontainers.image.description="PATUM Plumb (Umbrel): plumb-node/umbrel-plumb with Plumb v29.4.2.knots20260508.plumb7 built by PyBLOCK from the signed tag" \
      org.opencontainers.image.version="v29.4.2.knots20260508.plumb7"
