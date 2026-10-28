# PATUM Node para Umbrel con Bitcoin Knots v29.4.3.knots20260508 (final): nuestra imagen 1.2.20-pyblock1 (ya parchada)
# + bitcoind/bitcoin-cli compilados por PyBLOCK desde el tag firmado por Luke Dashjr (1A3E761F…5D0C504A) con la
# herramienta release-tarball de Plumb (Debian 11, depends, test_bitcoin, symbol/security-check). Knots todavía no
# publicó binarios de 29.4.3. 29.4.3 pasa a "latest"; las versiones anteriores siguen instaladas para quien las fijó.
FROM registry.gitlab.com/astrolexis-group1/pyblock-umbrel-store/umbrel-patum-node@sha256:9c37f72292dfe6be8cbbaf0b5be9c3382a2b0c5516b38025b2064fb09040ee13
ARG TARGETARCH
USER root
COPY --chown=root:root --chmod=0755 bin/${TARGETARCH}/ /opt/bitcoind/v29.4.3.knots20260508/
RUN set -e; cd /app \
 && sed -i "s|\['v29.4.2.knots20260508', |['v29.4.3.knots20260508', 'v29.4.2.knots20260508', |" libs/settings/dist/settings.meta.js \
 && sed -i "s|^\(\s*\)'v29.4.2.knots20260508': { default: 83 },|\1'v29.4.3.knots20260508': { default: 83 },\n\1'v29.4.2.knots20260508': { default: 83 },|" libs/settings/dist/settings.meta.js \
 && grep -q "\['v29.4.3.knots20260508', 'v29.4.2.knots20260508'" libs/settings/dist/settings.meta.js \
 && grep -q "'v29.4.3.knots20260508': { default: 83 }" libs/settings/dist/settings.meta.js \
 && for f in dist/public/assets/*.js; do sed -i 's|\["v29.4.2.knots20260508",|["v29.4.3.knots20260508","v29.4.2.knots20260508",|; s|"v29.4.2.knots20260508":{default:83}|"v29.4.3.knots20260508":{default:83},"v29.4.2.knots20260508":{default:83}|' "$f"; done \
 && grep -lq '"v29.4.3.knots20260508","v29.4.2.knots20260508"' dist/public/assets/*.js \
 && grep -lq '"v29.4.3.knots20260508":{default:83}' dist/public/assets/*.js \
 && ln -sfn /opt/bitcoind/v29.4.3.knots20260508 /opt/bitcoind/current \
 && /opt/bitcoind/current/bitcoin-cli -version | head -1 | grep -q 'v29.4.3.knots20260508'
LABEL org.opencontainers.image.source="https://gitlab.com/astrolexis-group1/pyblock-umbrel-store" \
      org.opencontainers.image.description="PATUM Node (Umbrel): Bitcoin Knots v29.4.3.knots20260508 built by PyBLOCK from the signed tag" \
      org.opencontainers.image.version="v29.4.3.knots20260508"
