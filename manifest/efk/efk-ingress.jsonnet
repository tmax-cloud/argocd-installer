function (
    es_image_repo="docker.elastic.co/elasticsearch/elasticsearch",
    es_image_tag="7.2.0",
    busybox_image_repo="busybox",
    busybox_image_tag="1.32.0",
    es_volume_size="50Gi",
    kibana_image_repo="docker.elastic.co/kibana/kibana",
    kibana_image_tag="7.2.0",
    kibana_svc_type="ClusterIP",
    gatekeeper_image_repo="quay.io/keycloak/keycloak-gatekeeper",
    gatekeeper_image_tag="10.0.0",
    kibana_client_id="kibana",
    kibana_client_secret="23077707-908e-4633-956d-5adcaed4caa7",
    hyperauth_url="172.23.4.105",
    hyperauth_realm="tmax",
    custom_domain_name="domain_name",
    encryption_key="AgXa7xRcoClDEU0ZDSH4X0XhL5Qy2Z2j",
    fluentd_image_repo="fluent/fluentd-kubernetes-daemonset",
    fluentd_image_tag="v1.4.2-debian-elasticsearch-1.1",
    custom_clusterissuer="tmaxcloud-issuer"
)

if kibana_svc_type == "ClusterIP" then [ 
  {
    "apiVersion": "networking.k8s.io/v1",
    "kind": "Ingress",
    "metadata": {
      "name": "kibana",
      "namespace": "kube-logging",
      "labels": {
        "ingress.tmaxcloud.org/name": "kibana"
      },
      "annotations": {
        "traefik.ingress.kubernetes.io/router.entrypoints": "websecure",
        "cert-manager.io/cluster-issuer": custom_clusterissuer
      }
    },
    "spec": {
      "ingressClassName": "tmax-cloud",
      "rules": [
        {
          "host": std.join("", ["kibana.", custom_domain_name]),
          "http": {
            "paths": [
              {
                "backend": {
                  "service": {
                    "name": "kibana",
                    "port": {
                      "number": 443
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
            std.join("", ["kibana.", custom_domain_name])
          ]
        }
      ]
    }
  }
] else []
