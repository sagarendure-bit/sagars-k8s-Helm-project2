#!/usr/bin/env bash
set -euo pipefail

RELEASE="${RELEASE:-myrel}"
NS="${NS:-helm-lab}"
CHART="${CHART:-./myapp}"
ENV_FILE="${ENV_FILE:-./myapp/values-prod.yaml}"

echo "==> Upgrade (atomic, wait)"
helm upgrade "$RELEASE" "$CHART" \
  -f "$ENV_FILE" \
  --set config.LOG_LEVEL=debug \
  --set replicaCount=2 \
  -n "$NS" --atomic --wait --timeout 3m

echo "==> History after upgrade"
helm history "$RELEASE" -n "$NS"

echo "==> Diff of last two revisions (if plugin installed)"
if helm plugin list | grep -q diff; then
  helm diff revision "$RELEASE" $(( $(helm history "$RELEASE" -n "$NS" -o json | jq 'length') - 1 )) $(helm history "$RELEASE" -n "$NS" -o json | jq 'length') -n "$NS" || true
fi
