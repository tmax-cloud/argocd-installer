function (
  params = import 'params.libsonnet'
)

local repo_url_protocol = if std.substr(params.repo_url, 0, 5) == "https" then params.repo_url else "https://" + params.repo_url;
local target_repo = if params.repo_provider == "gitlab" then repo_url_protocol + ".git" else repo_url_protocol;
local mode = if params.multimode_enabled == "true" then "multi" else "single";

{
  "apiVersion": "argoproj.io/v1alpha1",
  "kind": "Application",
  "metadata": {
    "name": "hypercloud",
    "namespace": "argocd"
  },
  "spec": {
    "destination": {
      "namespace": "hypercloud5-system",
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
              "name": "hypercloud_hpcd_mode",
              "value": mode
            },
            {
              "name": "hypercloud_kafka_enabled",
              "value": params.hypercloud_kafka_enabled
            },
            {
              "name": "hyperauth_url",
              "value": params.keycloak_domain
            }
          ],
        },
      },
      "path": "manifest/hypercloud",
      "repoURL": target_repo,
      "targetRevision": params.branch
    },
    "project": params.project
  }
}