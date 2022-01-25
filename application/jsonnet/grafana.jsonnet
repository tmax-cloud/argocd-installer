function (
  params = import 'params.libsonnet'
)

local repo_url_protocol = if std.substr(params.repo_url, 0, 5) == "https" then params.repo_url else "https://" + params.repo_url;
local target_repo = if params.repo_provider == "gitlab" then repo_url_protocol + ".git" else repo_url_protocol;

{
  "apiVersion": "argoproj.io/v1alpha1",
  "kind": "Application",
  "metadata": {
    "name": "grafana",
    "namespace": "argocd"
  },
  "spec": {
    "destination": {
      "namespace": "monitoring",
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
              "name": "tmax_client_secret",
              "value": params.keycloak_client_secret
            },
            {
              "name": "keycloak_addr",
              "value": params.keycloak_domain
            },
            {
              "name": "grafana_pvc",
              "value": params.grafana_pvc_size
            },
            {
              "name": "grafana_version",
              "value": params.grafana_version
            },
            {
              "name": "grafana_image_repo",
              "value": params.grafana_image_repo
            },
            {
              "name": "ingress_domain",
              "value": params.domain
            }
          ],
        },
      },
      "path": "manifest/grafana",
      "repoURL": target_repo,
      "targetRevision": params.branch
    },
    "project": params.project
  }
}