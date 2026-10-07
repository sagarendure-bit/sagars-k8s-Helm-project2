# Helm vs Manual Kubernetes YAML

| Concern | Manual YAML | Helm |
|---|---|---|
| Env config | Copy/paste per env | values-dev.yaml / values-prod.yaml |
| Release history | None | helm history (16 revisions) |
| Rollback | Reapply old YAML | helm rollback <release> <rev> |
| Dependencies | Hand-managed | Chart.yaml + helm dependency update |
| Versioning | Git tags | Chart.version + appVersion |
| Distribution | Copy files | helm package → .tgz |
| Hooks | CI scripts | helm.sh/hook annotations |
| Smoke tests | Separate CI step | helm test |

## What I Observed
- One chart, N environments via -f values-<env>.yaml
- helm rollback restored a broken upgrade in one command
- Hooks ran migrations automatically before each upgrade
- helm package produced a single portable .tgz
- Helm release secret is the source of truth for all deployed state

## Enterprise Takeaway
Helm scales with charts, not environments. Adding prod to dev = one new values file.
