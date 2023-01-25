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

[
  {
    "apiVersion": "networking.k8s.io/v1",
    "kind": "Ingress",
    "metadata": {
      "name": "dashboards",
      "namespace": "kube-logging",
      "labels": {
        "ingress.tmaxcloud.org/name": "opensearch-dashboards"
      },
      "annotations": {
        "traefik.ingress.kubernetes.io/router.entrypoints": "websecure",
      }
    },
    "spec": {
      "ingressClassName": "tmax-cloud",
      "rules": [
        {
          "host": std.join("", [opensearch_subdomain, ".", custom_domain_name]),
          "http": {
            "paths": [
              {
                "backend": {
                  "service": {
                    "name": "dashboards",
                    "port": {
                      "number": 5601
                    }
                  }
                },
                "path": "/",
                "pathType": "Prefix"
              }
            ]
          }
        }
      ],
      "tls": [
        {
          "hosts": [
            std.join("", [opensearch_subdomain, ".", custom_domain_name])
          ],
        }
      ]
    }
  }
]
