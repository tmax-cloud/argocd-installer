function (
  is_offline="false",
  private_registry="172.22.6.2:5000",
  hyperauth_svc_type="Ingress",
  hyperauth_external_ip="172.22.6.8",
  is_kafka_enabled="false",
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
              "image": std.join("", [target_registry, "docker.io/postgres:14-alpine"]),
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
      "labels": {
        "app": "hyperauth"
      }
    },
    "spec": {
      "replicas": 1,
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
              "name" : "import-config",
              "configMap": {
                "name": "tmax-import-realm-config",
                "items": [
                    {
                      "key": "tmax-realm.json",
                      "path": "tmax-realm.json"
                    }
                  ]
              }
            },
            {
              "name": "hyperauth-admin-token",
              "secret": {
                "secretName": "hyperauth-admin-token"
              }
            }
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
              "image": std.join("", [target_registry, "docker.io/tmaxcloudck/hyperauth:b2.0.0.4"]),
              "args": [
                "start",
                "--import-realm"
              ],
              "env": [
                {
                  "name": "KEYCLOAK_ADMIN",
                  "value": "admin"
                },
                {
                  "name": "KEYCLOAK_ADMIN_PASSWORD",
                  "value": "admin"
                },
                {
                  "name": "KC_PROXY",
                  "value": "edge"
                },
                {
                  "name": "KC_DB",
                  "value": "postgres"
                },
                {
                  "name": "KC_DB_PASSWORD",
                  "valueFrom": {
                    "secretKeyRef": {
                      "name": "passwords",
                      "key": "DB_PASSWORD"
                    }
                  }
                },
                {
                  "name": "KC_DB_USERNAME",
                  "value": "keycloak"
                },
                {
                  "name": "KC_DB_URL",
                  "value": "jdbc:postgresql://postgresql/keycloak"
                },
                {
                  "name": "KC_LOG_LEVEL",
                  "value": log_level
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
              "readinessProbe": {
                "httpGet": {
                  "path": "/realms/master",
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
              },
              "volumeMounts": [
                {
                  "name": "hyperauth-admin-token",
                  "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount"
                },
                {
                  "name" : "import-config",
                  "mountPath" : "/opt/keycloak/data/import"
                }
              ]+ (
                   if timezone_setting != "UTC" then [
                     {
                       "name": "timezone-config",
                       "mountPath": "/etc/localtime"
                     }
                   ] else []
                 ),
            }
          ]
        }
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
      "name": "hyperauth-api-gateway-ingress",
      "namespace": "hyperauth"
    },
    "spec": {
      "ingressClassName": "nginx-system",
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
