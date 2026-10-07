# Helm Lab

## Prerequisites
- Docker (for kind/minikube)
- kubectl
- helm 3.13+
- kind or minikube

## Cluster
    kind create cluster --name helm-lab
    kubectl cluster-info

## Install (dev)
    RELEASE=myrel NS=helm-lab ENV_FILE=./myapp/values-dev.yaml ./scripts/01-install.sh

## Access
    kubectl -n helm-lab port-forward svc/$(helm get manifest myrel -n helm-lab | yq '.metadata.name' 2>/dev/null || echo myrel-myapp) 8080:80
    open http://localhost:8080

## Upgrade (prod values, atomic)
    ./scripts/02-upgrade.sh

## Rollback to previous revision
    ./scripts/03-rollback.sh 0

## Rollback to specific revision
    ./scripts/03-rollback.sh 1

## Troubleshoot
    ./scripts/04-troubleshoot.sh

## Smoke test
    helm test myrel -n helm-lab --logs

## Package + index
    ./scripts/05-package-and-publish.sh

## Push to OCI (GHCR example)
    REGISTRY=oci://ghcr.io/<your-user>/charts ./scripts/05-package-and-publish.sh
