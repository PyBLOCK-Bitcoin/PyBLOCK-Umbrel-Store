# PATUM (Knots) para Umbrel con Bitcoin Knots v29.5.knots20260508: nuestra imagen 1.2.20-knots29.4.3-pyblock1 (ya parchada,
# con 29.4.3 compilado por PyBLOCK) + bitcoind/bitcoin-cli de los tarballs OFICIALES de Knots 29.5 (SHA256SUMS firmado por
# Luke Dashjr, 1A3E761F…5D0C504A, verificado antes del build). Consenso idéntico a 29.4.3 (cambios de red/IO/build y
# política de mempool knots#400). 29.5 pasa a "latest"; las versiones anteriores siguen instaladas para quien las fijó.
FROM registry.gitlab.com/astrolexis-group1/pyblock-umbrel-store/umbrel-patum-node@sha256:a16f1cb52fe70f9b5ce2288b86b3bc89a002a1b76963b4f65d1d105b33fc8510
ARG TARGETARCH
USER root
COPY --chown=root:root --chmod=0755 bin/${TARGETARCH}/ /opt/bitcoind/v29.5.knots20260508/
RUN set -e; cd /app \
 && sed -i "s|\['v29.4.3.knots20260508', |['v29.5.knots20260508', 'v29.4.3.knots20260508', |" libs/settings/dist/settings.meta.js \
 && sed -i "s|^\(\s*\)'v29.4.3.knots20260508': { default: 83 },|\1'v29.5.knots20260508': { default: 83 },\n\1'v29.4.3.knots20260508': { default: 83 },|" libs/settings/dist/settings.meta.js \
 && grep -q "\['v29.5.knots20260508', 'v29.4.3.knots20260508'" libs/settings/dist/settings.meta.js \
 && grep -q "'v29.5.knots20260508': { default: 83 }" libs/settings/dist/settings.meta.js \
 && for f in dist/public/assets/*.js; do sed -i 's|\["v29.4.3.knots20260508",|["v29.5.knots20260508","v29.4.3.knots20260508",|; s|"v29.4.3.knots20260508":{default:83}|"v29.5.knots20260508":{default:83},"v29.4.3.knots20260508":{default:83}|' "$f"; done \
 && grep -lq '"v29.5.knots20260508","v29.4.3.knots20260508"' dist/public/assets/*.js \
 && grep -lq '"v29.5.knots20260508":{default:83}' dist/public/assets/*.js \
 && ln -sfn /opt/bitcoind/v29.5.knots20260508 /opt/bitcoind/current \
 && /opt/bitcoind/current/bitcoin-cli -version | head -1 | grep -q 'v29.5.knots20260508'
LABEL org.opencontainers.image.source="https://gitlab.com/astrolexis-group1/pyblock-umbrel-store" \
      org.opencontainers.image.description="PATUM (Knots) (Umbrel): official Bitcoin Knots v29.5.knots20260508 release binaries" \
      org.opencontainers.image.version="v29.5.knots20260508"
