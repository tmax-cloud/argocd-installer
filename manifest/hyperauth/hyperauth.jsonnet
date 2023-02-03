function (
  is_offline="false",
  private_registry="172.22.6.2:5000",
  hyperauth_svc_type="Ingress",
  hyperauth_external_ip="172.22.6.8",
  is_kafka_enabled="true",
  hyperauth_subdomain="hyperauth",
  hypercloud_domain_host="tmaxcloud.org",
  storage_class="default",
  timezone_setting="UTC",
  self_signed="false",
  log_level="INFO",
)

local svcType = if hyperauth_svc_type == "Ingress" then "ClusterIP" else hyperauth_svc_type;
local target_registry = if is_offline == "false" then "" else private_registry + "/";
local hyperauth_external_dns = hyperauth_subdomain + "." + hypercloud_domain_host;

[
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "name": "postgresql",
      "namespace": "hyperauth",
      "labels": {
        "app": "postgresql"
      }
    },
    "spec": {
      "replicas": 1,
      "selector": {
        "matchLabels": {
          "app": "postgresql"
        }
      },
      "strategy": {
        "type": "Recreate"
      },
      "template": {
        "metadata": {
          "labels": {
            "app": "postgresql",
            "tier": "postgreSQL"
          }
        },
        "spec": {
          "serviceAccount": "hyperauth-admin",
          "containers": [
            {
              "image": std.join("", [target_registry, "docker.io/postgres:9.6.2-alpine"]),
              "name": "postgresql",
              "env": [
                {
                  "name": "POSTGRES_USER",
                  "value": "keycloak"
                },
                {
                  "name": "POSTGRES_DB",
                  "value": "keycloak"
                },
                {
                  "name": "POSTGRES_PASSWORD",
                  "valueFrom": {
                    "secretKeyRef": {
                      "name": "passwords",
                      "key": "DB_PASSWORD"
                    }
                  }
                }
              ],
              "resources": {
                "limits": {
                  "cpu": "1",
                  "memory": "5Gi"
                },
                "requests": {
                  "cpu": "1",
                  "memory": "5Gi"
                }
              },
              "ports": [
                {
                  "containerPort": 5432,
                  "name": "postgresql"
                }
              ],
              "volumeMounts": [
                {
                  "name": "postgresql",
                  "mountPath": "/var/lib/postgresql/data",
                  "subPath": "postgres"
                },
              ] + (
                if timezone_setting != "UTC" then [
                  {
                    "name": "timezone-config",
                    "mountPath": "/etc/localtime"
                  }
                ] else []
              ),
            }
          ],
          "volumes": [
            {
              "name": "postgresql",
              "persistentVolumeClaim": {
                "claimName": "postgres-pvc"
              }
            }
          ] + (
            if timezone_setting != "UTC" then [
              {
                "name": "timezone-config",
                "hostPath": {
                  "path": std.join("", ["/usr/share/zoneinfo/", timezone_setting])
                }
              }
            ] else []
          ),
        }
      }
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
            },
            {
              "name": "hyperauth-admin-token",
              "secret": {
                "secretName": "hyperauth-admin-token"
              },
            },
          ]+ (
            if timezone_setting != "UTC" then [
              {
                "name": "timezone-config",
                "hostPath": {
                  "path": std.join("", ["/usr/share/zoneinfo/", timezone_setting])
                }
              }
            ] else []
          ),
          "containers": [
            {
              "name": "hyperauth",
              "image": std.join("", [target_registry, "docker.io/tmaxcloudck/hyperauth:b1.1.2.1"]),
              "args": [
                "-c standalone-ha.xml",
                "-Dkeycloak.profile.feature.upload_scripts=enabled",
                "-Dkeycloak.profile.feature.docker=enabled -b 0.0.0.0"
              ],
              "env": [
                {
                  "name": "LOG_LEVEL",
                  "value": log_level
                },
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
                },
                {
                  "name": "hyperauth-admin-token",
                  "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount"
                }
              ]+ (
                if timezone_setting != "UTC" then [
                  {
                    "name": "timezone-config",
                    "mountPath": "/etc/localtime"
                  }
                ] else []
              ),
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
      "duration": "8760h0m0s",
      "renewBefore": "720h0m0s",
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
      "issuerRef": {
        "kind": "ClusterIssuer",
        "group": "cert-manager.io",
        "name": "tmaxcloud-issuer"
      }
    } + (
      if hyperauth_svc_type == "LoadBalancer" then {
        "ipAddresses": [
          hyperauth_external_ip
        ]
      } else {}
    )
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
        }
      ]
    }
  } else {},
  {
    "apiVersion": "v1",
    "kind": "PersistentVolumeClaim",
    "metadata": {
      "name": "postgres-pvc",
      "namespace": "hyperauth",
      "labels": {
        "app": "postgresql"
      }
    },
    "spec": {
      "accessModes": [
        "ReadWriteOnce"
      ],
      "resources": {
        "requests": {
          "storage": "100Gi"
        }
      }
    } + (
      if storage_class != "default" then {
        "storageClassName": storage_class
      } else {}
    )
  }
]
