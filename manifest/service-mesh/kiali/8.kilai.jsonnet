function(
  is_offline="false",
  private_registry="registry.tmaxcloud.org",
  KIALI_VERSION="v1.59.0",
  CUSTOM_DOMAIN_NAME="custom-domain",
  kiali_subdomain="kiali",
  kiali_loglevel="info",
  grafana_external_url="https://grafana.domain",
  time_zone="UTC",
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
          "pods/log"
        ],
        "verbs": [
          "get",
          "list",
          "watch"
        ]
      },
      {
        "apiGroups": [
          ""
        ],
        "resources": [
          "namespaces",
          "pods",
          "replicationcontrollers",
          "services"
        ],
        "verbs": [
          "get",
          "list",
          "watch",
          "patch"
        ]
      },
      {
        "apiGroups": [
          ""
        ],
        "resources": [
          "pods/portforward"
        ],
        "verbs": [
          "create",
          "post"
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
          "statefulsets",
          "daemonsets"
        ],
        "verbs": [
          "get",
          "list",
          "watch",
          "patch"
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
          "watch",
          "patch"
        ]
      },
      {
        "apiGroups": [
          "networking.istio.io",
          "security.istio.io",
          "extensions.istio.io",
          "telemetry.istio.io",
          "gateway.networking.k8s.io"
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
          "app.openshift.io"
        ],
        "resources": [
          "deploymentconfigs"
        ],
        "verbs": [
          "get",
          "list",
          "watch",
          "patch"
        ]
      },
      {
        "apiGroups": [
          "project.openshift.io"
        ],
        "resources": [
          "projects"
        ],
        "verbs": [
          "get"
        ]
      },
      {
        "apiGroups": [
          "route.openshift.io"
        ],
        "resources": [
          "routes"
        ],
        "verbs": [
          "get"
        ]
      },
      {
        "apiGroups": [
          "authentication.k8s.io"
        ],
        "resources": [
          "tokenreviews"
        ],
        "verbs": [
          "create"
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
          "pods/log"
        ],
        "verbs": [
          "get",
          "list",
          "watch"
        ]
      },
      {
        "apiGroups": [
          ""
        ],
        "resources": [
          "namespaces",
          "pods",
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
          ""
        ],
        "resources": [
          "pods/portforward"
        ],
        "verbs": [
          "create",
          "post"
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
          "statefulsets",
          "daemonsets"
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
          "watch",
          "patch"
        ]
      },
      {
        "apiGroups": [
          "networking.istio.io",
          "security.istio.io",
          "extensions.istio.io",
          "telemetry.istio.io",
          "gateway.networking.k8s.io"
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
          "app.openshift.io"
        ],
        "resources": [
          "deploymentconfigs"
        ],
        "verbs": [
          "get",
          "list",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "project.openshift.io"
        ],
        "resources": [
          "projects"
        ],
        "verbs": [
          "get"
        ]
      },
      {
        "apiGroups": [
          "route.openshift.io"
        ],
        "resources": [
          "routes"
        ],
        "verbs": [
          "get"
        ]
      },
      {
        "apiGroups": [
          "authentication.k8s.io"
        ],
        "resources": [
          "tokenreviews"
        ],
        "verbs": [
          "create"
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
        "  istiod: istio-system",
        "  prometheus: monitoring",
        "istio_namespace: istio-system",
        "auth:",
        "  strategy: anonymous",
        "deployment:",
        "  accessible_namespaces: ['**']",
        "login_token:",
        "  signing_key: 0123456789012345",
        "server:",
        "  port: 20001",
        "  web_root: /api/kiali",
        "  metrics_enabled: true",
        "  metrics_port: 9090",
        "external_services:",
        "  istio:",
        "    root_namespace: istio-system",
        "    component_status:",
        "      enabled: true",
        "      components:",
        "        - app_label: istiod",
        "          is_core: true",
        "        - app_label: ingressgateway",
        "          is_core: true",
        "          is_proxy: true",
        "    url_service_version: http://istiod.istio-system.svc:15014/version",
        "  tracing:",
        "    url:",
        "    in_cluster_url: http://jaeger-query.istio-system.svc:16685",
        "  grafana:",
        "    auth:",
        "      insecure_skip_verify: true",
        "      username: admin",
        "      password: admin",
        std.join("", ["    url: ", grafana_external_url]),
        "    in_cluster_url: http://grafana.monitoring.svc:3000",
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
            "sidecar.istio.io/inject": "false"
          },
          "labels": {
            "app": "kiali",
            "release": "istio"
          },
          "name": "kiali"
        },
        "spec": {
          "containers": [
            {
              "command": [
                "/opt/kiali/kiali",
                "-config",
                "/kiali-configuration/config.yaml"
              ],
              "env": [
                {
                  "name": "ACTIVE_NAMESPACE",
                  "valueFrom": {
                    "fieldRef": {
                      "fieldPath": "metadata.namespace"
                    }
                  }
                },
                {
                  "name": "LOG_LEVEL",
                  "value": kiali_loglevel
                }
              ],
              "ports": [
                {
                  "name": "api-port",
                  "containerPort": 20001
                },
                {
                  "name": "http-metrics",
                  "containerPort": 9090
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
                  "memory": "64Mi"
                },
                "limits": {
                  "cpu": "50m",
                  "memory": "512Mi"
                }
              },
              "volumeMounts": [
                {
                  "mountPath": "/kiali-configuration",
                  "name": "kiali-configuration"
                },
                {
                  "mountPath": "/kiali-cert",
                  "name": "kiali-cert",
                  "readOnly": true
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
                "name": "kiali",
                "items": [
                  {
                    "key": "config.yaml",
                    "path": "config.yaml"
                  }
                ]
              },
              "name": "kiali-configuration"
            },
            {
              "name": "kiali-cert",
              "secret": {
                "secretName": "kiali-service-account",
                "optional": true
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
        },
        {
          "name": "http-metrics",
          "protocol": "TCP",
          "port": 9090
        }
      ],
      "selector": {
        "app": "kiali"
      }
    }
  },
  {
    "apiVersion": "networking.k8s.io/v1",
    "kind": "Ingress",
    "metadata": {
      "name": "kiali-ingress",
      "namespace": "istio-system",
      "labels": {
        "ingress.tmaxcloud.org/name": "kiali"
      }
    },
    "spec": {
      "ingressClassName": "nginx-system",
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
