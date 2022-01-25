function (
  params = import 'params.libsonnet'
)

local repo_url_protocol = if std.substr(params.repo_url, 0, 5) == "https" then params.repo_url else "https://" + params.repo_url;
local target_repo = if params.repo_provider == "gitlab" then repo_url_protocol + ".git" else repo_url_protocol;

{
  "apiVersion": "argoproj.io/v1alpha1",
  "kind": "Application",
  "metadata": {
    "name": "template-service-broker",
    "namespace": "argocd"
  },
  "spec": {
    "destination": {
      "namespace": "template",
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
              "name": "template_operator_version",
              "value": params.template_operator_version
            },
            {
              "name": "cluster_tsb_version",
              "value": params.cluster_tsb_version
            },
            {
              "name": "tsb_version",
              "value": params.tsb_version
            }
          ],
        },
      },
      "path": "manifest/template-service-broker",
      "repoURL": target_repo,
      "targetRevision": params.branch
    },
    "project": params.project
  }
}