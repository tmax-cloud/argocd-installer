function (
  params = import 'params.libsonnet'
)

local repo_url_protocol = if std.substr(params.repo_url, 0, 5) == "https" then params.repo_url else "https://" + params.repo_url;
local target_repo = if params.repo_provider == "gitlab" then repo_url_protocol + ".git" else repo_url_protocol;

{
  "apiVersion": "argoproj.io/v1alpha1",
  "kind": "Application",
  "metadata": {
    "name": "prometheus",
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
              "name": "configmap_reload_version",
              "value": params.configmap_reload_version
            },
            {
              "name": "configmap_reloader_version",
              "value": params.configmap_reloader_version
            },
            {
              "name": "prometheus_operator_version",
              "value": params.prometheus_operator_version
            },
            {
              "name": "alertmanager_version",
              "value": params.alertmanager_version
            },
            {
              "name": "kube_rbac_proxy_version",
              "value": params.prometheus_kube_rbac_proxy_version
            },
            {
              "name": "kube_state_metrics_version",
              "value": params.kube_state_metrics_version
            },
            {
              "name": "node_exporter_version",
              "value": params.prometheus_node_exporter_version
            },
            {
              "name": "prometheus_adapter_version",
              "value": params.prometheus_adapter_version
            },
            {
              "name": "prometheus_pvc",
              "value": params.prometheus_pvc_size
            },
            {
              "name": "prometheus_version",
              "value": params.prometheus_version
            }
          ],
        },
      },
      "path": "manifest/prometheus",
      "repoURL": target_repo,
      "targetRevision": params.branch
    },
    "project": params.project
  }
}