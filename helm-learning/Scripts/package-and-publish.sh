#!/usr/bin/env bash
set -euo pipefail

CHART_DIR="${CHART_DIR:-./myapp}"
OUT_DIR="${OUT_DIR:-./dist}"
REGISTRY="${REGISTRY:-}"

mkdir -p "$OUT_DIR"

echo "==> Lint"
helm lint "$CHART_DIR"

echo "==> Package"
helm package "$CHART_DIR" --destination "$OUT_DIR"

PKG=$(ls -t "$OUT_DIR"/myapp-*.tgz | head -1)
echo "Packaged: $PKG"

echo "==> Local repo index"
helm repo index "$OUT_DIR" --url "file://$PWD/$OUT_DIR"

echo "==> Install from package"
helm install pkgrel "$PKG" -n helm-lab --create-namespace --dry-run >/dev/null && echo "Dry-run OK"

if [[ -n "$REGISTRY" ]]; then
  echo "==> Push to OCI registry: $REGISTRY"
  helm push "$PKG" "$REGISTRY"
fi
