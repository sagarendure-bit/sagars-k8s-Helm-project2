#!/usr/bin/env bash
set -euo pipefail

RELEASE="${RELEASE:-myrel}"
NS="${NS:-helm-lab}"
TO_REV="${1:-0}"

echo "==> Current history"
helm history "$RELEASE" -n "$NS"

echo "==> Rolling back to revision $TO_REV"
helm rollback "$RELEASE" "$TO_REV" -n "$NS" --wait --timeout 2m

echo "==> History after rollback"
helm history "$RELEASE" -n "$NS"

echo "==> Verify rendered config"
kubectl get cm -n "$NS" -l app.kubernetes.io/instance="$RELEASE" -o yaml | grep -A5 '^data:' || true
