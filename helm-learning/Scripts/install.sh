#!/usr/bin/env bash
set -euo pipefail

RELEASE="${RELEASE:-myrel}"
NS="${NS:-helm-lab}"
CHART="${CHART:-./myapp}"
ENV_FILE="${ENV_FILE:-./myapp/values-dev.yaml}"

kubectl create namespace "$NS" --dry-run=client -o yaml | kubectl apply -f -

echo "==> Linting"
helm lint "$CHART" -f "$ENV_FILE"

echo "==> Dry-run render"
helm template "$RELEASE" "$CHART" -f "$ENV_FILE" >/tmp/rendered.yaml
echo "Rendered $(grep -c '^kind:' /tmp/rendered.yaml) resources -> /tmp/rendered.yaml"

echo "==> Install"
helm install "$RELEASE" "$CHART" -f "$ENV_FILE" -n "$NS" --wait --timeout 5m --rollback-on-failure

echo "==> Status"
helm status "$RELEASE" -n "$NS"

echo "==> History"
helm history "$RELEASE" -n "$NS"

echo "==> Workloads"
kubectl get all -n "$NS" -l app.kubernetes.io/instance="$RELEASE"
