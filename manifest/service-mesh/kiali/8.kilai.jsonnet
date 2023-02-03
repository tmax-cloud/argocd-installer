function(
  is_offline="false",
  private_registry="registry.tmaxcloud.org",
  KIALI_VERSION="v1.21",
  HYPERAUTH_DOMAIN="hyperauth.domain",
  CUSTOM_DOMAIN_NAME="custom-domain",
  CUSTOM_CLUSTER_ISSUER="tmaxcloud-issuer",
  kiali_subdomain="kiali",
  kiali_loglevel="3",
  kiali_client_id="kiali",
  time_zone="UTC"
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";

[
  {
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRole",
    "metadata": {
      "name": "kiali",
      "labels": {
        "app": "kiali",
        "release": "istio"
      }
    },
    "rules": [
      {
        "apiGroups": [
          ""
        ],
        "resources": [
          "configmaps",
          "endpoints",
          "namespaces",
          "nodes",
          "pods",
          "pods/log",
          "replicationcontrollers",
          "services"
        ],
        "verbs": [
          "get",
          "list",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "extensions",
          "apps"
        ],
        "resources": [
          "deployments",
          "replicasets",
          "statefulsets"
        ],
        "verbs": [
          "get",
          "list",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "autoscaling"
        ],
        "resources": [
          "horizontalpodautoscalers"
        ],
        "verbs": [
          "get",
          "list",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "batch"
        ],
        "resources": [
          "cronjobs",
          "jobs"
        ],
        "verbs": [
          "get",
          "list",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "config.istio.io",
          "networking.istio.io",
          "authentication.istio.io",
          "rbac.istio.io",
          "security.istio.io"
        ],
        "resources": [
          "*"
        ],
        "verbs": [
          "create",
          "delete",
          "get",
          "list",
          "patch",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "monitoring.kiali.io"
        ],
        "resources": [
          "monitoringdashboards"
        ],
        "verbs": [
          "get",
          "list"
        ]
      }
    ]
  },
  {
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRole",
    "metadata": {
      "name": "kiali-viewer",
      "labels": {
        "app": "kiali",
        "release": "istio"
      }
    },
    "rules": [
      {
        "apiGroups": [
          ""
        ],
        "resources": [
          "configmaps",
          "endpoints",
          "namespaces",
          "nodes",
          "pods",
          "pods/log",
          "replicationcontrollers",
          "services"
        ],
        "verbs": [
          "get",
          "list",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "extensions",
          "apps"
        ],
        "resources": [
          "deployments",
          "replicasets",
          "statefulsets"
        ],
        "verbs": [
          "get",
          "list",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "autoscaling"
        ],
        "resources": [
          "horizontalpodautoscalers"
        ],
        "verbs": [
          "get",
          "list",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "batch"
        ],
        "resources": [
          "cronjobs",
          "jobs"
        ],
        "verbs": [
          "get",
          "list",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "config.istio.io",
          "networking.istio.io",
          "authentication.istio.io",
          "rbac.istio.io",
          "security.istio.io"
        ],
        "resources": [
          "*"
        ],
        "verbs": [
          "get",
          "list",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "monitoring.kiali.io"
        ],
        "resources": [
          "monitoringdashboards"
        ],
        "verbs": [
          "get",
          "list"
        ]
      }
    ]
  },
  {
    "apiVersion": "v1",
    "kind": "ServiceAccount",
    "metadata": {
      "name": "kiali-service-account",
      "namespace": "istio-system",
      "labels": {
        "app": "kiali",
        "release": "istio"
      }
    }
  },
  {
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRoleBinding",
    "metadata": {
      "name": "kiali",
      "labels": {
        "app": "kiali",
        "release": "istio"
      }
    },
    "roleRef": {
      "apiGroup": "rbac.authorization.k8s.io",
      "kind": "ClusterRole",
      "name": "kiali"
    },
    "subjects": [
      {
        "kind": "ServiceAccount",
        "name": "kiali-service-account",
        "namespace": "istio-system"
      }
    ]
  },
  {
    "apiVersion": "v1",
    "kind": "Secret",
    "metadata": {
      "name": "kiali",
      "namespace": "istio-system",
      "labels": {
        "app": "kiali",
        "release": "istio"
      }
    },
    "type": "Opaque",
    "data": {
      "username": "YWRtaW4=",
      "passphrase": "YWRtaW4="
    }
  },
  {
    "apiVersion": "v1",
    "kind": "ConfigMap",
    "metadata": {
      "name": "kiali",
      "namespace": "istio-system",
      "labels": {
        "app": "kiali",
        "release": "istio"
      }
    },
    "data": {
      "config.yaml": std.join("\n",
      [
        "istio_component_namespaces:",
        "  grafana: monitoring",
        "  tracing: istio-system",
        "  pilot: istio-system",
        "  prometheus: monitoring",
        "istio_namespace: istio-system",
        "auth:",
        "  strategy: openid",
        "  openid:",
        std.join("", ["    client_id: ", kiali_client_id]),
        std.join("", ["    issuer_url: https://", HYPERAUTH_DOMAIN, "/auth/realms/tmax"]),
        std.join("", ["    authorization_endpoint: https://", HYPERAUTH_DOMAIN, "/auth/realms/tmax/protocol/openid-connect/auth"]),
        "deployment:",
        "  accessible_namespaces: ['**']",
        "login_token:",
        "  signing_key: wl5oStULbP",
        "server:",
        "  port: 20001",
        "  web_root: /api/kiali",
        "external_services:",
        "  istio:",
        "    url_service_version: http://istio-pilot.istio-system:8080/version",
        "  tracing:",
        "    url:",
        "    in_cluster_url: http://tracing/api/jaeger",
        "  grafana:",
        "    url:",
        "    in_cluster_url: http://grafana.monitoring:3000",
        "  prometheus:",
        "    url: http://prometheus-k8s.monitoring:9090"
        ]
      )
    }
  },
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "labels": {
        "app": "kiali",
        "release": "istio"
      },
      "name": "kiali",
      "namespace": "istio-system"
    },
    "spec": {
      "replicas": 1,
      "selector": {
        "matchLabels": {
          "app": "kiali"
        }
      },
      "template": {
        "metadata": {
          "annotations": {
            "kiali.io/runtimes": "go,kiali",
            "prometheus.io/port": "9090",
            "prometheus.io/scrape": "true",
            "scheduler.alpha.kubernetes.io/critical-pod": "",
            "sidecar.istio.io/inject": "false"
          },
          "labels": {
            "app": "kiali",
            "release": "istio"
          },
          "name": "kiali"
        },
        "spec": {
          "affinity": {
            "nodeAffinity": {
              "preferredDuringSchedulingIgnoredDuringExecution": [
                {
                  "preference": {
                    "matchExpressions": [
                      {
                        "key": "beta.kubernetes.io/arch",
                        "operator": "In",
                        "values": [
                          "amd64"
                        ]
                      }
                    ]
                  },
                  "weight": 2
                },
                {
                  "preference": {
                    "matchExpressions": [
                      {
                        "key": "beta.kubernetes.io/arch",
                        "operator": "In",
                        "values": [
                          "ppc64le"
                        ]
                      }
                    ]
                  },
                  "weight": 2
                },
                {
                  "preference": {
                    "matchExpressions": [
                      {
                        "key": "beta.kubernetes.io/arch",
                        "operator": "In",
                        "values": [
                          "s390x"
                        ]
                      }
                    ]
                  },
                  "weight": 2
                }
              ],
              "requiredDuringSchedulingIgnoredDuringExecution": {
                "nodeSelectorTerms": [
                  {
                    "matchExpressions": [
                      {
                        "key": "beta.kubernetes.io/arch",
                        "operator": "In",
                        "values": [
                          "amd64",
                          "ppc64le",
                          "s390x"
                        ]
                      }
                    ]
                  }
                ]
              }
            }
          },
          "containers": [
            {
              "command": [
                "/opt/kiali/kiali",
                "-config",
                "/kiali-configuration/config.yaml",
                "-v",
                std.join("", [kiali_loglevel])
              ],
              "env": [
                {
                  "name": "ACTIVE_NAMESPACE",
                  "valueFrom": {
                    "fieldRef": {
                      "fieldPath": "metadata.namespace"
                    }
                  }
                }
              ],
              "image": std.join("", [target_registry, "quay.io/kiali/kiali:", KIALI_VERSION]),
              "imagePullPolicy": "IfNotPresent",
              "livenessProbe": {
                "httpGet": {
                  "path": "/api/kiali/healthz",
                  "port": 20001,
                  "scheme": "HTTP"
                },
                "initialDelaySeconds": 5,
                "periodSeconds": 30
              },
              "name": "kiali",
              "readinessProbe": {
                "httpGet": {
                  "path": "/api/kiali/healthz",
                  "port": 20001,
                  "scheme": "HTTP"
                },
                "initialDelaySeconds": 5,
                "periodSeconds": 30
              },
              "resources": {
                "requests": {
                  "cpu": "10m",
                  "memory": "50Mi"
                },
                "limits": {
                  "cpu": "50m",
                  "memory": "100Mi"
                }
              },
              "volumeMounts": [
                {
                  "mountPath": "/kiali-configuration",
                  "name": "kiali-configuration"
                },
                {
                  "mountPath": "/kiali-cert",
                  "name": "kiali-cert"
                },
                {
                  "mountPath": "/kiali-secret",
                  "name": "kiali-secret"
                }
              ] + ( if time_zone != "UTC" then [
                  {
                    "name": "timezone-config",
                    "mountPath": "/etc/localtime"
                  }
                ] else []
              )
            }
          ],
          "serviceAccountName": "kiali-service-account",
          "volumes": [
            {
              "configMap": {
                "name": "kiali"
              },
              "name": "kiali-configuration"
            },
            {
              "name": "kiali-cert",
              "secret": {
                "optional": true,
                "secretName": "istio.kiali-service-account"
              }
            },
            {
              "name": "kiali-secret",
              "secret": {
                "optional": true,
                "secretName": "kiali"
              }
            }
          ] + (
            if time_zone != "UTC" then [
              {
                "name": "timezone-config",
                "hostPath": {
                  "path": std.join("", ["/usr/share/zoneinfo/", time_zone])
                }
              }
            ] else []
          )
        }
      }
    }
  },
  {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
      "name": "kiali",
      "namespace": "istio-system",
      "labels": {
        "app": "kiali",
        "release": "istio"
      }
    },
    "spec": {
      "ports": [
        {
          "name": "http-kiali",
          "protocol": "TCP",
          "port": 20001
        }
      ],
      "selector": {
        "app": "kiali"
      }
    }
  },
  {
    "apiVersion": "cert-manager.io/v1",
    "kind": "Certificate",
    "metadata": {
      "name": "kiali-cert",
      "namespace": "istio-system"
    },
    "spec": {
      "secretName": "kiali-secret",
      "usages": [
        "digital signature",
        "key encipherment",
        "server auth",
        "client auth"
      ],
      "dnsNames": [
          "tmax-cloud",
          "kiali.istio-system.svc"
      ],
      "issuerRef": {
        "kind": "ClusterIssuer",
        "group": "cert-manager.io",
        "name": CUSTOM_CLUSTER_ISSUER
      }
    }
  },
  {
    "apiVersion": "networking.k8s.io/v1",
    "kind": "Ingress",
    "metadata": {
      "name": "kiali-ingress",
      "namespace": "istio-system",
      "annotations": {
        "traefik.ingress.kubernetes.io/router.entrypoints": "websecure"
      },
      "labels": {
        "ingress.tmaxcloud.org/name": "kiali"
      }
    },
    "spec": {
      "ingressClassName": "tmax-cloud",
      "tls": [
        {
          "hosts": [
            std.join("", [kiali_subdomain, ".", CUSTOM_DOMAIN_NAME]),
          ]
        }
      ],
      "rules": [
        {
          "host": std.join("", [kiali_subdomain, ".", CUSTOM_DOMAIN_NAME]),
          "http": {
            "paths": [
              {
                "path": "/",
                "pathType": "Prefix",
                "backend": {
                  "service": {
                    "name": "kiali",
                    "port": {
                      "number": 20001
                    }
                  }
                }
              },
              {
                "path": "/api/kiali",
                "pathType": "Prefix",
                "backend": {
                  "service": {
                    "name": "kiali",
                    "port": {
                      "number": 20001
                    }
                  }
                }
              }
            ]
          }
        }
      ]
    }
  }
]
