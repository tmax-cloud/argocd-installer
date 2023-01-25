function (
  timezone="UTC",
  is_offline="false",
  private_registry="172.22.6.2:5000",
  os_image_tag="1.3.7",
  busybox_image_tag="1.32.0",
  os_resource_limit_memory="8Gi",
  os_resource_request_memory="5Gi",
  os_jvm_heap="-Xms4g -Xmx4g",
  os_volume_size="50Gi",
  dashboard_image_tag="1.3.7",
  dashboard_svc_type="ClusterIP",
  opensearch_client_id="opensearch",
  tmax_client_secret="tmax_client_secret",
  hyperauth_url="172.23.4.105",
  hyperauth_realm="tmax",
  custom_domain_name="domain_name",
  fluentd_image_tag="fluentd-v1.15.3-debian-elasticsearch-1.0",
  custom_clusterissuer="tmaxcloud-issuer",
  is_master_cluster="true",
  opensearch_subdomain="opensearch-dashboard",
  log_level="info",
  storageClass="default"
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
      "config.yml": std.join("\n", 
        [
          "_meta:",
          "  type: 'config'",
          "  config_version: 2",
          "config:",
          "  dynamic:",
          "    authc:",
          "      basic_internal_auth_domain:",
          "        http_enabled: true",
          "        transport_enabled: true",
          "        order: 1",
          "        http_authenticator:",
          "          type: basic",
          "          challenge: false",
          "        authentication_backend:",
          "          type: internal",
          "      openid_auth_domain:",
          "        http_enabled: true",
          "        transport_enabled: true",
          "        order: 0",
          "        http_authenticator:",
          "          type: 'openid'",
          "          challenge: false",
          "          config:",
          "            subject_key: preferred_username",
          "            roles_key: roles",
          std.join("", ["            openid_connect_url: https://", hyperauth_url, "/auth/realms/", hyperauth_realm, "/.well-known/openid-configuration"]),
          "        authentication_backend:",
          "          type: noop"
        ]
      )
    }
  }
] else []
