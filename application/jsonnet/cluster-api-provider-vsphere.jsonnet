function (
  params = import 'params.libsonnet'
)

local repo_url_protocol = if std.substr(params.repo_url, 0, 5) == "https" then params.repo_url else "https://" + params.repo_url;
local target_repo = if params.repo_provider == "gitlab" then repo_url_protocol + ".git" else repo_url_protocol;

{
  "apiVersion": "argoproj.io/v1alpha1",
  "kind": "Application",
  "metadata": {
    "name": "cluster-api-provider-vsphere",
    "namespace": "argocd"
  },
  "spec": {
    "destination": {
      "namespace": "capv-system",
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
              "name": "username",
              "value": params.vsphere_username
            },
            {
              "name": "password",
              "value": params.vsphere_password
            }
          ]
        },
      },
      "path": "manifest/cluster-api-provider-vsphere",
      "repoURL": params.repo_url,
      "targetRevision": params.branch
    },
    "project": params.project
  }
}