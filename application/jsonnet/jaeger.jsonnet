function (
  params = import 'params.libsonnet'
)

local repo_url_protocol = if std.substr(params.repo_url, 0, 5) == "https" then params.repo_url else "https://" + params.repo_url;
local target_repo = if params.repo_provider == "gitlab" then repo_url_protocol + ".git" else repo_url_protocol;

{
  "apiVersion": "argoproj.io/v1alpha1",
  "kind": "Application",
  "metadata": {
    "name": "Jaeger",
    "namespace": "argocd"
  },
  "spec": {
    "destination": {
      "namespace": "istio-system",
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
              "name": "HYPERAUTH_DOMAIN",
              "value": params.keycloak_domain
            },
            {
              "name": "CUSTOM_DOMAIN_NAME",
              "value": params.domain
            },
          ],
        },
      },
      "path": "manifest/service-mesh/jaeger",
      "repoURL": target_repo,
      "targetRevision": params.branch
    },
    "project": params.project
  }
}