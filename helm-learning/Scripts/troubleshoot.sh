#!/usr/bin/env bash
set -euo pipefail

RELEASE="${RELEASE:-myrel}"
NS="${NS:-helm-lab}"

echo "==== helm status ====";      helm status "$RELEASE" -n "$NS"
echo "==== helm get values ====";  helm get values "$RELEASE" -n "$NS" -a
echo "==== helm get manifest ===="; helm get manifest "$RELEASE" -n "$NS" | head -50
echo "==== helm get hooks ====";   helm get hooks "$RELEASE" -n "$NS"
echo "==== helm get notes ====";   helm get notes "$RELEASE" -n "$NS"
echo "==== pods ====";              kubectl get pods -n "$NS" -l app.kubernetes.io/instance="$RELEASE" -o wide
echo "==== events ====";            kubectl get events -n "$NS" --sort-by=.lastTimestamp | tail -30
echo "==== describe deployment ===="; kubectl describe deploy -n "$NS" -l app.kubernetes.io/instance="$RELEASE" | tail -60
echo "==== release secret ====";   kubectl get secret -n "$NS" -l owner=helm,name="$RELEASE"
