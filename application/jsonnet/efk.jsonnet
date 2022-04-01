function (
  params = import 'params.libsonnet'
)

local repo_url_protocol = if std.substr(params.repo_url, 0, 5) == "https" then params.repo_url else "https://" + params.repo_url;
local target_repo = if params.repo_provider == "gitlab" then repo_url_protocol + ".git" else repo_url_protocol;

{
  "apiVersion": "argoproj.io/v1alpha1",
  "kind": "Application",
  "metadata": {
    "name": "efk",
    "namespace": "argocd"
  },
  "spec": {
    "destination": {
      "namespace": "kube-logging",
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
              "name": "es_image_tag",
              "value": params.es_image_tag
            },
            {
              "name": "busybox_image_tag",
              "value": params.busybox_image_tag
            },
            {
              "name": "es_resource_limit_memory",
              "value": params.es_resource_limit_memory
            },
            {
              "name": "es_resource_request_memory",
              "value": params.resource_request_memory
            },
            {
              "name": "es_jvm_heap",
              "value": params.es_jvm_heap
            },
            {
              "name": "es_volume_size",
              "value": params.es_volume_size
            },
            {
              "name": "kibana_image_tag",
              "value": params.kibana_image_tag
            },
            {
              "name": "kibana_svc_type",
              "value": params.kibana_svc_type
            },
            {
              "name": "gatekeeper_image_tag",
              "value": params.gatekeeper_image_tag
            },
            {
              "name": "tmax_client_secret",
              "value": params.keycloak_client_secret
            },
            {
              "name": "hyperauth_url",
              "value": params.keycloak_domain
            },
            {
              "name": "custom_domain_name",
              "value": params.domain
            },
            {
              "name": "fluentd_image_tag",
              "value": params.fluentd_image_tag
            }
          ],
        },
      },
      "path": "manifest/efk",
      "repoURL": target_repo,
      "targetRevision": params.branch
    },
    "project": params.project
  }
}
