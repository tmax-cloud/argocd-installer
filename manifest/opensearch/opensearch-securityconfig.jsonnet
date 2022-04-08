function (
    is_offline="false",
    cluster_name="master",
    private_registry="172.22.6.2:5000",
    os_image_tag="1.2.3",
    busybox_image_tag="1.32.0",
    os_resource_limit_memory="8Gi",
    os_resource_request_memory="5Gi",
    os_jvm_heap="-Xms4g -Xmx4g",
    os_volume_size="50Gi",
    dashboard_image_tag="1.2.0",
    dashboard_svc_type="ClusterIP",
    dashboard_client_id="dashboards",
    tmax_client_secret="tmax_client_secret",
    hyperauth_url="172.23.4.105",
    hyperauth_realm="tmax",
    custom_domain_name="domain_name",
    fluentd_image_tag="v1.4.2-debian-elasticsearch-1.1",
    custom_clusterissuer="tmaxcloud-issuer"
)

local hyperauth_ca_path= if cluster_name == "master" then "/usr/share/opensearch/config/certificates/ca.crt" else ""

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
          "_meta.type: 'config'",
          "\n_meta.config_version: 2",
          "\nconfig.dynamic.authc.basic_internal_auth_domain.http_enabled: true",
          "\nconfig.dynamic.authc.basic_internal_auth_domain.transport_enabled: true",
          "\nconfig.dynamic.authc.basic_internal_auth_domain.order: 1",
          "\nconfig.dynamic.authc.basic_internal_auth_domain.http_authenticator.type: basic",
          "\nconfig.dynamic.authc.basic_internal_auth_domain.http_authenticator.challenge: false",
          "\nconfig.dynamic.authc.basic_internal_auth_domain.authentication_backend.type: internal",
          "\nconfig.dynamic.authc.openid_auth_domain.http_enabled: true",
          "\nconfig.dynamic.authc.openid_auth_domain.transport_enabled: true",
          "\nconfig.dynamic.authc.openid_auth_domain.order: 0",
          "\nconfig.dynamic.authc.openid_auth_domain.http_authenticator.type: 'openid'",
          "\nconfig.dynamic.authc.openid_auth_domain.http_authenticator.challenge: false",
          "\nconfig.dynamic.authc.openid_auth_domain.http_authenticator.config.subject_key: preferred_username",
          "\nconfig.dynamic.authc.openid_auth_domain.http_authenticator.config.roles_key: roles",
          "\nconfig.dynamic.authc.openid_auth_domain.http_authenticator.config.openid_connect_url: https://", hyperauth_url, "/auth/realms/", hyperauth_realm, "/.well-known/openid-configuration",
          "\nconfig.dynamic.authc.openid_auth_domain.http_authenticator.config.openid_connect_idp.enable_ssl: true",
          "\nconfig.dynamic.authc.openid_auth_domain.http_authenticator.config.openid_connect_idp.verify_hostnames: false",
          "\nconfig.dynamic.authc.openid_auth_domain.http_authenticator.config.openid_connect_idp.pemtrustedcas_filepath: ", hyperauth_ca_path,
          "\nconfig.dynamic.authc.openid_auth_domain.authentication_backend.type: noop"
        ]
      )
    }
  }
] else []
