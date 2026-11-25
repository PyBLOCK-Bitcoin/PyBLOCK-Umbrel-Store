# PATUM (Knots) para Umbrel con Bitcoin Knots v29.5.1.knots20260508: nuestra imagen 1.2.20-knots29.5-pyblock1 (la de 1.0.6)
# + bitcoind/bitcoin-cli de los tarballs OFICIALES de Knots 29.5.1 (SHA256SUMS firmado por Luke Dashjr, 1A3E761F…5D0C504A,
# verificado antes del build). Arregla CVE-2026-117348; filtros de mempool knots#298/#470/#514; knots#520 separa las reglas
# BLAKE2b en flags (el annex queda prohibido en toda entrada; ningún bloque desde 961640 lo usa). 29.5.1 pasa a "latest";
# las versiones anteriores siguen instaladas para quien las fijó.
FROM registry.gitlab.com/astrolexis-group1/pyblock-umbrel-store/umbrel-patum-node@sha256:abc2da0e2efc6d59d5e3934dd39ec6c4574b997b8ca51c945356659af8b651b6
ARG TARGETARCH
USER root
COPY --chown=root:root --chmod=0755 bin/${TARGETARCH}/ /opt/bitcoind/v29.5.1.knots20260508/
RUN set -e; cd /app \
 && sed -i "s|\['v29.5.knots20260508', |['v29.5.1.knots20260508', 'v29.5.knots20260508', |" libs/settings/dist/settings.meta.js \
 && sed -i "s|^\(\s*\)'v29.5.knots20260508': { default: 83 },|\1'v29.5.1.knots20260508': { default: 83 },\n\1'v29.5.knots20260508': { default: 83 },|" libs/settings/dist/settings.meta.js \
 && grep -q "\['v29.5.1.knots20260508', 'v29.5.knots20260508'" libs/settings/dist/settings.meta.js \
 && grep -q "'v29.5.1.knots20260508': { default: 83 }" libs/settings/dist/settings.meta.js \
 && for f in dist/public/assets/*.js; do sed -i 's|\["v29.5.knots20260508",|["v29.5.1.knots20260508","v29.5.knots20260508",|; s|"v29.5.knots20260508":{default:83}|"v29.5.1.knots20260508":{default:83},"v29.5.knots20260508":{default:83}|' "$f"; done \
 && grep -lq '"v29.5.1.knots20260508","v29.5.knots20260508"' dist/public/assets/*.js \
 && grep -lq '"v29.5.1.knots20260508":{default:83}' dist/public/assets/*.js \
 && ln -sfn /opt/bitcoind/v29.5.1.knots20260508 /opt/bitcoind/current \
 && /opt/bitcoind/current/bitcoin-cli -version | head -1 | grep -q 'v29.5.1.knots20260508'
LABEL org.opencontainers.image.source="https://gitlab.com/astrolexis-group1/pyblock-umbrel-store" \
      org.opencontainers.image.description="PATUM (Knots) (Umbrel): official Bitcoin Knots v29.5.1.knots20260508 release binaries" \
      org.opencontainers.image.version="v29.5.1.knots20260508"
