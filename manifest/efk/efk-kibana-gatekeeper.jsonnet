function (
    kibana_client_secret="23077707-908e-4633-956d-5adcaed4caa7",
    hyperauth_url="172.23.4.105",
    encryption_key="AgXa7xRcoClDEU0ZDSH4X0XhL5Qy2Z2j"
    custom_clusterissuer="tmaxcloud-issuer"
)

[
  {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
       "name": "kibana",
       "namespace": "kube-logging",
       "labels": {
          "app": "kibana"
       },
       "annotations": {
          "traefik.ingress.kubernetes.io/service.serverstransport": "tmaxcloud@file"
       }
    },
    "spec": {
      "type": "LoadBalancer",
      "ports": [
        {
          "port": 3000,
          "name": "gatekeeper"
        }
      ],
      "selector": {
        "app": "kibana"
      }
    }
  },
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "name": "kibana",
      "namespace": "kube-logging",
      "labels": {
        "app": "kibana"
      }
    },
    "spec": {
      "replicas": 1,
      "selector": {
        "matchLabels": {
          "app": "kibana"
        }
      },
      "template": {
        "metadata": {
          "labels": {
            "app": "kibana"
          }
        },
        "spec": {
          "serviceAccount": "efk-service-account",
          "volumes": [
            {
              "name": "secret",
              "secret": {
                "secretName": "kibana-secret"
              },
            },
            {
              "name": "config",
              "configMap": {
                "name": "kibana-config"
              }
            }
          ],
          "containers": [
            {
              "name": "gatekeeper",
              "image": "quay.io/keycloak/keycloak-gatekeeper:10.0.0",
              "imagePullPolicy": "Always",
              "args": [
                "--client-id=kibana",
                std.join("", ["--client-secret=", kibana_client_secret]),
                "--listen=:3000",
                "--upstream-url=http://127.0.0.1:5601",
                std.join("", ["--discovery-url=https://", hyperauth_url, "/auth/realms/tmax"]),
                "--secure-cookie=false",
                "--skip-openid-provider-tls-verify=true",
                "--enable-self-signed-tls=false",
                "--tls-cert=/etc/secrets/tls.crt",
                "--tls-private-key=/etc/secrets/tls.key",
                "--tls-ca-certificate=/etc/secrets/ca.crt",
                "--skip-upstream-tls-verify=true",
                "--upstream-keepalives=false",
                "--enable-default-deny=true",
                "--enable-refresh-tokens=true",
                "--enable-metrics=true",
                std.join("", ["--encryption-key=", encryption_key]),
                "--resources=uri=/*|roles=kibana:kibana-manager",
                "--verbose"
              ],
              "ports": [
                {
                  "name": "service",
                  "containerPort": 3000
                }
              ],
              "volumeMounts": [
                {
                  "name": "secret",
                  "mountPath": "/etc/secrets",
                  "readOnly": true
                }
              ]
            },
            {
              "name": "kibana",
              "image": "docker.elastic.co/kibana/kibana:7.2.0",
              "resources": {
                "limits": {
                  "cpu": "500m",
                  "memory": "1000Mi"
                },
                "requests": {
                  "cpu": "500m",
                  "memory": "1000Mi"
                }
              },
              "env": [
                {
                  "name": "ELASTICSEARCH_URL",
                  "value": "http://elasticsearch.kube-logging.svc.cluster.local:9200"
                }
              ],
              "ports": [
                {
                  "containerPort": 5601
                }
              ],
              "volumeMounts": [
                {
                  "mountPath": "/usr/share/kibana/config/kibana.yml",
                  "name": "config",
                  "subPath": "kibana.yml"
                }
              ]
            }
          ]
        }
      }
    }
  },
  {
    "apiVersion": "v1",
    "kind": "ConfigMap",
    "metadata": {
      "name": "kibana-config",
      "namespace": "kube-logging"
    },
    "data": {
      "kibana.yml": std.join("", ["server.name: kibana", "\nserver.host: '0'", "\nelasticsearch.hosts: [ 'http://elasticsearch:9200' ]", "\nelasticsearch.requestTimeout: '100000ms'"])
    }
  }
]
