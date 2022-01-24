function (
  params = import 'params.libsonnet'
)

local repo_url_protocol = if std.substr(params.repo_url, 0, 5) == "https" then params.repo_url else "https://" + params.repo_url;
local target_repo = if params.repo_provider == "gitlab" then repo_url_protocol + ".git" else repo_url_protocol;

local module_names = ["strimzi kafka operator", "hyperauth"];
local module_ns = ["kafka", "hyperauth"];
local module_paths = ["strimzi kafka operator", "hyperauth"];

[
  {
    "apiVersion": "argoproj.io/v1alpha1",
    "kind": "Application",
    "metadata": {
      "name": module_names[i],
      "namespace": "argocd"
    },
    "spec": {
      "destination": {
        "namespace": module_ns[i],
      } + (
        if params.cluster_name != "" then {
          "name": params.cluster_name
        } else {}
      ) + (
        if params.cluster_server != "" then {
          "server": params.cluster_server
        } else {}
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
            ],
          },
        },
        "path": module_paths[i],
        "repoURL": target_repo,
        "targetRevision": params.branch
      },
      "project": params.project
    }
  } for i in std.range(std.length(module_names))
]