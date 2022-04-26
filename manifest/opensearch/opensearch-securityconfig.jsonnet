function (
    is_offline="false",
    private_registry="172.22.6.2:5000",
    os_image_tag="1.2.3",
    busybox_image_tag="1.32.0",
    os_resource_limit_memory="8Gi",
    os_resource_request_memory="5Gi",
    os_jvm_heap="-Xms4g -Xmx4g",
    os_volume_size="50Gi",
    dashboard_image_tag="1.2.0",
    dashboard_svc_type="ClusterIP",
    opensearch_client_id="opensearch",
    tmax_client_secret="tmax_client_secret",
    hyperauth_url="172.23.4.105",
    hyperauth_realm="tmax",
    custom_domain_name="domain_name",
    fluentd_image_tag="fluentd-v1.4.2-debian-elasticsearch-1.1",
    custom_clusterissuer="tmaxcloud-issuer",
    is_master_cluster="true",
    opensearch_subdomain="opensearch-dashboard"
)

if hyperauth_url != "" then [
  {
    "apiVersion": "v1",
    "kind": "ConfigMap",
    "metadata": {
      "name": "opensearch-securityconfig",
      "namespace": "kube-logging",
      "labels": {
        "app": "opensearch"
      }
    },
    "data": {
      "config.yml": std.join("", 
        [
          "_meta:",
          "\n  type: 'config'",
          "\n  config_version: 2",
          "\nconfig:",
          "\n  dynamic:",
          "\n    authc:",
          "\n      basic_internal_auth_domain:",
          "\n        http_enabled: true",
          "\n        transport_enabled: true",
          "\n        order: 1",
          "\n        http_authenticator:",
          "\n          type: basic",
          "\n          challenge: false",
          "\n        authentication_backend:",
          "\n          type: internal",
          "\n      openid_auth_domain:",
          "\n        http_enabled: true",
          "\n        transport_enabled: true",
          "\n        order: 0",
          "\n        http_authenticator:",
          "\n          type: 'openid'",
          "\n          challenge: false",
          "\n          config:",
          "\n            subject_key: preferred_username",
          "\n            roles_key: roles",
          "\n            openid_connect_url: https://", hyperauth_url, "/auth/realms/", hyperauth_realm, "/.well-known/openid-configuration",
          "\n        authentication_backend:",
          "\n          type: noop"
        ]
      )
    }
  }
] else []
