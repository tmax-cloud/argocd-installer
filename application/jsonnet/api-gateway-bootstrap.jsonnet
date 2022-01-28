function (
  params = import 'params.libsonnet'
)

local repo_url_protocol = if std.substr(params.repo_url, 0, 5) == "https" then params.repo_url else "https://" + params.repo_url;
local target_repo = if params.repo_provider == "gitlab" then repo_url_protocol + ".git" else repo_url_protocol;

{
  "apiVersion": "argoproj.io/v1alpha1",
  "kind": "Application",
  "metadata": {
    "name": "gateway-bootstrap",
    "namespace": "argocd"
  },
  "spec": {
    "destination": {
      "namespace": "api-gateway-system",
    } + (
      if params.cluster_info_type == "name" then {
        "name": params.cluster_info
      } else if params.cluster_info_type == "server" then {
        "server": params.cluster_info
      }
    ),
    "source": {
      "path": "manifest/api-gateway-bootstrap",
      "repoURL": target_repo,
      "targetRevision": params.branch
    },
    "syncPolicy": {
      "automated": {
        "prune": true
      },
      "syncOptions": [
        "ApplyOutOfSyncOnly=true"
      ]
    },
    "project": params.project
  }
}