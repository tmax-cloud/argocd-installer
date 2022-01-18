function (
    is_offline="false",
    private_registry="172.22.6.2:5000",
    es_image_tag="docker.io/tmaxcloudck/elasticsearch:7.2.1",
    busybox_image_tag="docker.io/busybox:1.32.0",
    es_volume_size="50Gi",
    kibana_image_tag="docker.elastic.co/kibana/kibana:7.2.0",
    kibana_svc_type="ClusterIP",
    gatekeeper_image_tag="quay.io/keycloak/keycloak-gatekeeper:10.0.0",
    kibana_client_id="kibana",
    kibana_client_secret="23077707-908e-4633-956d-5adcaed4caa7",
    hyperauth_url="172.23.4.105",
    hyperauth_realm="tmax",
    custom_domain_name="domain_name",
    encryption_key="AgXa7xRcoClDEU0ZDSH4X0XhL5Qy2Z2j",
    fluentd_image_tag="docker.io/fluent/fluentd-kubernetes-daemonset:v1.4.2-debian-elasticsearch-1.1",
    custom_clusterissuer="tmaxcloud-issuer"
)

if custom_domain_name != "" then [ 
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
                    "port": if hyperauth_url == "" then {
                      "number": 5601
                    } else {
                      "number" : 443
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
