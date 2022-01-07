function (
    strimzi_kafka_cluster_operator_installed=true,
    hyperauth_image="tmaxcloudck/hyperauth:latest",
    hyperauth_svc_type="Ingress",
    hyperauth_external_dns="hyperauth.172.22.6.18.nip.io",
    hyperauth_external_ip="172.22.6.8"
)

local svcType = if hyperauth_svc_type == "Ingress" then "ClusterIP" else hyperauth_svc_type;

[ 
  {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
      "name": "hyperauth",
      "namespace": "hyperauth",
      "labels": {
        "app": "keycloak"
      },
      "annotations": {
        "traefik.ingress.kubernetes.io/service.sticky.cookie": "true",
        "traefik.ingress.kubernetes.io/service.sticky.cookie.name": "hyperauth",
        "traefik.ingress.kubernetes.io/service.sticky.cookie.secure": "true"
      }
    },
    "spec": {
      "ports": [
        {
          "name": "http",
          "port": 8080,
          "targetPort": 8080
        },
        {
          "name": "https",
          "port": 443,
          "targetPort": 8443
        }
      ],
      "selector": {
        "app": "hyperauth"
      },
      "type": svcType
    }
  },
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "name": "hyperauth",
      "namespace": "hyperauth",
      "labels": {
        "app": "hyperauth"
      }
    },
    "spec": {
      "replicas": 2,
      "selector": {
        "matchLabels": {
          "app": "hyperauth"
        }
      },
      "template": {
        "metadata": {
          "labels": {
            "app": "hyperauth"
          }
        },
        "spec": {
          "serviceAccount": "hyperauth-admin",
          "volumes": [
            {
              "name": "ssl",
              "secret": {
                "secretName": "hyperauth-https-secret"
              }
            },
            {
              "name": "kafka",
              "secret": {
                "secretName": "hyperauth-kafka-jks"
              }
            },
            {
              "name": "log",
              "persistentVolumeClaim": {
                "claimName": "hyperauth-log-pvc"
              }
            },
            {
              "name": "picture",
              "persistentVolumeClaim": {
                "claimName": "hyperauth-profile-picture"
              }
            },
            {
              "name": "realm",
              "configMap": {
                "name": "tmax-realm-import-config"
              }
            }
          ],
          "containers": [
            {
              "name": "hyperauth",
              "image": hyperauth_image,
              "args": [
                "-c standalone-ha.xml",
                "-Dkeycloak.profile.feature.upload_scripts=enabled",
                "-Dkeycloak.profile.feature.docker=enabled -b 0.0.0.0"
              ],
              "env": [
                {
                  "name": "KEYCLOAK_IMPORT",
                  "value": "/tmp/realm-import/tmax-realm.json"
                },
                {
                  "name": "KEYCLOAK_USER",
                  "value": "admin"
                },
                {
                  "name": "KEYCLOAK_PASSWORD",
                  "valueFrom": {
                    "secretKeyRef": {
                      "name": "passwords",
                      "key": "HYPERAUTH_PASSWORD"
                    }
                  }
                },
                {
                  "name": "CERTS_PASSWORD",
                  "valueFrom": {
                    "secretKeyRef": {
                      "name": "passwords",
                      "key": "CERTS_PASSWORD"
                    }
                  }
                },
                {
                  "name": "PROXY_ADDRESS_FORWARDING",
                  "value": "true"
                },
                {
                  "name": "DB_VENDOR",
                  "value": "postgres"
                },
                {
                  "name": "DB_PORT",
                  "value": "5432"
                },
                {
                  "name": "DB_ADDR",
                  "value": "postgresql"
                },
                {
                  "name": "DB_USER",
                  "value": "keycloak"
                },
                {
                  "name": "DB_PASSWORD",
                  "valueFrom": {
                    "secretKeyRef": {
                      "name": "passwords",
                      "key": "DB_PASSWORD"
                    }
                  }
                },
                {
                  "name": "KEYCLOAK_WELCOME_THEME",
                  "value": "tmax"
                },
                {
                  "name": "TZ",
                  "value": "Asia/Seoul"
                },
                {
                  "name": "NAMESPACE",
                  "value": "hyperauth"
                },
                {
                  "name": "JGROUPS_DISCOVERY_PROTOCOL",
                  "value": "kubernetes.KUBE_PING"
                },
                {
                  "name": "JGROUPS_DISCOVERY_PROPERTIES",
                  "value": "namespace=hyperauth"
                },
                {
                  "name": "CACHE_OWNERS_COUNT",
                  "value": "2"
                },
                {
                  "name": "CACHE_OWNERS_AUTH_SESSIONS_COUNT",
                  "value": "2"
                },
                {
                  "name": "KAFKA_BROKERS_ADDR",
                  "value": "kafka-kafka-bootstrap.hyperauth:9092"
                }
              ],
              "ports": [
                {
                  "name": "http",
                  "containerPort": 8080
                },
                {
                  "name": "https",
                  "containerPort": 8443
                }
              ],
              "volumeMounts": [
                {
                  "name": "ssl",
                  "mountPath": "/etc/x509/https"
                },
                {
                  "name": "kafka",
                  "mountPath": "/etc/x509/kafka"
                },
                {
                  "name": "log",
                  "mountPath": "/opt/jboss/keycloak/standalone/log/hyperauth"
                },
                {
                  "name": "picture",
                  "mountPath": "/opt/jboss/keycloak/welcome-content/profile-picture"
                },
                {
                  "name": "realm",
                  "mountPath": "/tmp/realm-import"
                }
              ],
              "readinessProbe": {
                "httpGet": {
                  "path": "/auth/realms/master",
                  "port": 8080
                }
              },
              "resources": {
                "limits": {
                  "cpu": "1",
                  "memory": "1Gi"
                },
                "requests": {
                  "cpu": "1",
                  "memory": "1Gi"
                }
              }
            }
          ]
        }
      }
    }
  },
  {
    "apiVersion": "cert-manager.io/v1",
    "kind": "Certificate",
    "metadata": {
      "name": "hyperauth-certificate",
      "namespace": "hyperauth"
    },
    "spec": {
      "secretName": "hyperauth-https-secret",
      "duration": "8760h",
      "renewBefore": "720h",
      "isCA": false,
      "usages": [
        "digital signature",
        "key encipherment",
        "server auth",
        "client auth"
      ],
      "dnsNames": if hyperauth_svc_type == "Ingress" then [
        hyperauth_external_dns,
        "tmax-cloud"
      ] else [
        "tmax-cloud"
      ],
      "ipAddresses": if hyperauth_svc_type == "LoadBalancer" then [
        hyperauth_external_ip,
        "tmax-cloud"
      ] else [],
      "issuerRef": {
        "kind": "ClusterIssuer",
        "group": "cert-manager.io",
        "name": "tmaxcloud-issuer"
      }
    }
  },
  if hyperauth_svc_type == "Ingress" then {
    "apiVersion": "networking.k8s.io/v1",
    "kind": "Ingress",
    "metadata": {
      "labels": {
        "ingress.tmaxcloud.org/name": "hyperauth"
      },
      "annotations": {
        "traefik.ingress.kubernetes.io/router.entrypoints": "websecure"
      },
      "name": "hyperauth-api-gateway-ingress",
      "namespace": "hyperauth"
    },
    "spec": {
      "ingressClassName": "tmax-cloud",
      "rules": [
        {
          "host": hyperauth_external_dns,
          "http": {
            "paths": [
              {
                "backend": {
                  "service": {
                    "name": "hyperauth",
                    "port": {
                      "number": 8080
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
            hyperauth_external_dns
          ],
          "secretName": "hyperauth-https-secret"
        }
      ]
    }
  }else {}
]
