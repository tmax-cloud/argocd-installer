function (
  params = import 'params.libsonnet'
)

local repo_url_protocol = if std.substr(params.repo_url, 0, 5) == "https" then params.repo_url else "https://" + params.repo_url;
local target_repo = if params.repo_provider == "gitlab" then repo_url_protocol + ".git" else repo_url_protocol;

{
  "apiVersion": "argoproj.io/v1alpha1",
  "kind": "Application",
  "metadata": {
    "name": "hyperauth",
    "namespace": "argocd"
  },
  "spec": {
    "destination": {
      "namespace": "kafka",
    } + (
      if params.cluster_info_type == "name" then {
        "name": params.cluster_info
      } else if params.cluster_info_type == "server" then {
        "server": params.cluster_info
      }
    ),
    "source": {
      "directory": {
        "jsonnet": {
          "tlas": [
            {
              "name": "is_offline",
              "value": params.network_disabled
            },
            {
              "name": "private_registry",
              "value": params.private_registry
            },
            {
              "name": "hyperauth_svc_type",
              "value": params.hyperauth_svc_type
            },
            {
              "name": "hyperauth_external_dns",
              "value": params.keycloak_domain
            },
          ],
        },
      },
      "path": "manifest/hyerauth",
      "repoURL": target_repo,
      "targetRevision": params.branch
    },
    "project": params.project
  }
}