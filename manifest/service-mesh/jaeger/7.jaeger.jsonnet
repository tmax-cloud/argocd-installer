function(
  is_offline="false",
  private_registry="registry.tmaxcloud.org",
  JAEGER_VERSION="1.27",
  cluster_name="master",
  tmax_client_secret="tmax_client_secret",
  HYPERAUTH_DOMAIN="hyperauth.domain",
  GATEKEEPER_VERSION="v1.0.2",
  CUSTOM_DOMAIN_NAME="custom-domain",
  CUSTOM_CLUSTER_ISSUER="tmaxcloud-issuer",
  jaeger_client_id="jaeger",
  jaeger_subdomain="jaeger",
  storage_type="opensearch",
  jaeger_collector_log_level="info",
  jaeger_agent_log_level="info",
  jaeger_query_log_level="info",
  gatekeeper_log_level="info",
  time_zone="UTC"
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";
local REDIRECT_URL = jaeger_subdomain + "." + CUSTOM_DOMAIN_NAME;

[
  {
    "apiVersion": "v1",
    "kind": "ServiceAccount",
    "metadata": {
      "name": "jaeger-service-account",
      "namespace": "istio-system",
      "labels": {
        "app": "jaeger"
      }
    }
  },
  {
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRole",
    "metadata": {
      "name": "jaeger-istio-system",
      "labels": {
        "app": "jaeger"
      }
    },
    "rules": [
      {
        "apiGroups": [
          "extensions",
          "apps"
        ],
        "resources": [
          "deployments"
        ],
        "verbs": [
          "get",
          "list",
          "create",
          "patch",
          "update",
          "delete"
        ]
      },
      {
        "apiGroups": [
          ""
        ],
        "resources": [
          "pods",
          "services"
        ],
        "verbs": [
          "get",
          "list",
          "watch",
          "create",
          "delete"
        ]
      },
      {
        "apiGroups": [
          "networking.k8s.io"
        ],
        "resources": [
          "ingresses"
        ],
        "verbs": [
          "get",
          "list",
          "watch",
          "create",
          "delete",
          "update"
        ]
      },
      {
        "apiGroups": [
          "apps"
        ],
        "resources": [
          "daemonsets"
        ],
        "verbs": [
          "get",
          "list",
          "watch",
          "create",
          "delete",
          "update"
        ]
      }
    ]
  },
  {
    "kind": "ClusterRoleBinding",
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "metadata": {
      "name": "jaeger-istio-system"
    },
    "subjects": [
      {
        "kind": "ServiceAccount",
        "name": "jaeger-service-account",
        "namespace": "istio-system"
      }
    ],
    "roleRef": {
      "apiGroup": "rbac.authorization.k8s.io",
      "kind": "ClusterRole",
      "name": "jaeger-istio-system"
    }
  },
  {
    "apiVersion": "v1",
    "kind": "ConfigMap",
    "metadata": {
      "name": "jaeger-configuration",
      "namespace": "istio-system",
      "labels": {
        "app": "jaeger",
        "app.kubernetes.io/name": "jaeger"
      }
    },
    "data": {
      "span-storage-type": "opensearch",
      "collector": std.join("\n", 
        [
          "es:",
          "  server-urls: https://opensearch.kube-logging.svc:9200",
          "  tls:",
          "    enabled: true",
          "    ca: /ca/cert/ca.crt",
          "    cert: /ca/cert/tls.crt",
          "    key: /ca/cert/tls.key",
          "  username: admin",
          "  password: admin",
          "collector:",
          "  zipkin:",
          "    host-port: 9411"
        ]
      ),
      "query": std.join("\n",
        [
          "es:",
          "  server-urls: https://opensearch.kube-logging.svc:9200",
          "  tls:",
          "    enabled: true",
          "    ca: /ca/cert/ca.crt",
          "    cert: /ca/cert/tls.crt",
          "    key: /ca/cert/tls.key",
          "  username: admin",
          "  password: admin"
        ]
      ),
      "agent": std.join("\n",
        [
          "reporter:",
          "  grpc:",
          "    host-port: \"jaeger-collector:14250\""
        ]
      )
    }
  },
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "namespace": "istio-system",
      "name": "jaeger-collector",
      "labels": {
        "app": "jaeger",
        "app.kubernetes.io/name": "jaeger",
        "app.kubernetes.io/component": "collector"
      }
    },
    "spec": {
      "selector": {
        "matchLabels": {
          "app": "jaeger"
        }
      },
      "replicas": 1,
      "strategy": {
        "type": "Recreate"
      },
      "template": {
        "metadata": {
          "labels": {
            "app": "jaeger",
            "app.kubernetes.io/name": "jaeger",
            "app.kubernetes.io/component": "collector"
          },
          "annotations": {
            "prometheus.io/scrape": "true",
            "prometheus.io/port": "14268"
          }
        },
        "spec": {
          "serviceAccountName": "jaeger-service-account",
          "containers": [
            {
              "image": std.join("", [target_registry, "docker.io/jaegertracing/jaeger-collector:", JAEGER_VERSION]),
              "name": "jaeger-collector",
              "args": [
                "--config-file=/conf/collector.yaml",
                std.join("", ["--log-level=", jaeger_collector_log_level])
              ],
              "ports": [
                {
                  "containerPort": 14250,
                  "protocol": "TCP"
                },
                {
                  "containerPort": 14268,
                  "protocol": "TCP"
                },
                {
                  "containerPort": 9411,
                  "protocol": "TCP"
                }
              ],
              "readinessProbe": {
                "httpGet": {
                  "path": "/",
                  "port": 14269
                }
              },
              "volumeMounts": [
                {
                  "name": "jaeger-configuration-volume",
                  "mountPath": "/conf"
                },
                {
                  "name": "jaeger-certs",
                  "mountPath": "/ca/cert",
                  "readOnly": true
                }
              ] + ( if time_zone != "UTC" then [
                  {
                    "name": "timezone-config",
                    "mountPath": "/etc/localtime"
                  }
                ] else []
              ),
              "env": [
                {
                  "name": "SPAN_STORAGE_TYPE",
                  "valueFrom": {
                    "configMapKeyRef": {
                      "name": "jaeger-configuration",
                      "key": "span-storage-type"
                    }
                  }
                }
              ]
            }
          ],
          "volumes": [
            {
              "name": "jaeger-certs",
              "secret":
                {
                  "defaultMode": 420,
                  "secretName": "jaeger-secret"
                }
            },
            {
              "configMap": {
                "name": "jaeger-configuration",
                "items": [
                  {
                    "key": "collector",
                    "path": "collector.yaml"
                  }
                ]
              },
              "name": "jaeger-configuration-volume"
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
      "namespace": "istio-system",
      "name": "jaeger-collector",
      "labels": {
        "app": "jaeger",
        "app.kubernetes.io/name": "jaeger",
        "app.kubernetes.io/component": "collector"
      }
    },
    "spec": {
      "ports": [
        {
          "name": "jaeger-collector-grpc",
          "port": 14250,
          "protocol": "TCP",
          "targetPort": 14250
        },
        {
          "name": "jaeger-collector-http",
          "port": 14268,
          "protocol": "TCP",
          "targetPort": 14268
        },
        {
          "name": "jaeger-collector-zipkin",
          "port": 9411,
          "protocol": "TCP",
          "targetPort": 9411
        }
      ],
      "selector": {
        "app.kubernetes.io/name": "jaeger",
        "app.kubernetes.io/component": "collector"
      },
      "type": "ClusterIP"
    }
  },
  {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
      "namespace": "istio-system",
      "name": "zipkin",
      "labels": {
        "app": "jaeger",
        "app.kubernetes.io/name": "jaeger",
        "app.kubernetes.io/component": "zipkin"
      }
    },
    "spec": {
      "ports": [
        {
          "name": "jaeger-collector-zipkin",
          "port": 9411,
          "protocol": "TCP",
          "targetPort": 9411
        }
      ],
      "selector": {
        "app.kubernetes.io/name": "jaeger",
        "app.kubernetes.io/component": "collector"
      },
      "type": "ClusterIP"
    }
  },
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "annotations": null,
      "labels": {
        "app": "jaeger",
        "app.kubernetes.io/component": "query",
        "app.kubernetes.io/name": "jaeger"
      },
      "name": "jaeger-query",
      "namespace": "istio-system"
    },
    "spec": {
      "replicas": 1,
      "selector": {
        "matchLabels": {
          "app": "jaeger"
        }
      },
      "strategy": {
        "type": "Recreate"
      },
      "template": {
        "metadata": {
          "annotations": {
            "prometheus.io/port": "16686",
            "prometheus.io/scrape": "true"
          },
          "creationTimestamp": null,
          "labels": {
            "app": "jaeger",
            "app.kubernetes.io/component": "query",
            "app.kubernetes.io/name": "jaeger"
          }
        },
        "spec": {
          "serviceAccountName": "jaeger-service-account",
          "containers": [
            {
              "name": "gatekeeper",
              "image": std.join("", [target_registry, "docker.io/tmaxcloudck/gatekeeper:", GATEKEEPER_VERSION]),
              "imagePullPolicy": "Always",
              "args": [
                std.join("", ["--client-id=", jaeger_client_id]),
                std.join("", ["--client-secret=", tmax_client_secret]),
                "--listen=:3000",
                "--upstream-url=http://127.0.0.1:16686",
                std.join("", ["--discovery-url=https://", HYPERAUTH_DOMAIN, "/auth/realms/tmax"]),
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
                "--encryption-key=AgXa7xRcoClDEU0ZDSH4X0XhL5Qy2Z2j",
                "--forbidden-page=/html/access-forbidden.html",
                std.join("", ["--resources=uri=/*|roles=", jaeger_client_id, ":jaeger-manager"]),
                "--enable-encrypted-token",
                std.join("", ["--log-level=", gatekeeper_log_level])
              ],
              "ports": [
                {
                  "containerPort": 3000,
                  "name": "gatekeeper"
                }
              ],
              "volumeMounts": [
                {
                  "name": "gatekeeper-files",
                  "mountPath": "/html"
                },
                {
                  "name": "secret",
                  "mountPath": "/etc/secrets",
                  "readOnly": true
                }
              ] + ( if time_zone != "UTC" then [
                  {
                    "name": "timezone-config",
                    "mountPath": "/etc/localtime"
                  }
                ] else []
              )
            },
            {
              "args": [
                "--config-file=/conf/query.yaml",
                std.join("", ["--log-level=", jaeger_query_log_level])
              ],
              "env": [
                {
                  "name": "SPAN_STORAGE_TYPE",
                  "valueFrom": {
                    "configMapKeyRef": {
                      "key": "span-storage-type",
                      "name": "jaeger-configuration"
                    }
                  }
                },
                {
                  "name": "BASE_QUERY_PATH",
                  "value": "/api/jaeger"
                }
              ],
              "image": std.join("", [target_registry, "docker.io/jaegertracing/jaeger-query:", JAEGER_VERSION]),
              "imagePullPolicy": "IfNotPresent",
              "name": "jaeger-query",
              "ports": [
                {
                  "containerPort": 16686,
                  "protocol": "TCP"
                }
              ],
              "readinessProbe": {
                "failureThreshold": 3,
                "httpGet": {
                  "path": "/",
                  "port": 16687,
                  "scheme": "HTTP"
                },
                "initialDelaySeconds": 20,
                "periodSeconds": 5,
                "successThreshold": 1,
                "timeoutSeconds": 4
              },
              "resources": {},
              "terminationMessagePath": "/dev/termination-log",
              "terminationMessagePolicy": "File",
              "volumeMounts": [
                {
                  "mountPath": "/conf",
                  "name": "jaeger-configuration-volume"
                },
                {
                  "name": "secret",
                  "mountPath": "/ca/cert",
                  "readOnly": true
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
          "dnsPolicy": "ClusterFirst",
          "restartPolicy": "Always",
          "schedulerName": "default-scheduler",
          "terminationGracePeriodSeconds": 30,
          "volumes": [
            {
              "name": "secret",
              "secret": {
                "defaultMode": 420,
                "secretName": "jaeger-secret"
              }
            },
            {
              "name": "gatekeeper-files",
              "configMap": {
                "name": "gatekeeper-files"
              }
            },
            {
              "configMap": {
                "defaultMode": 420,
                "items": [
                  {
                    "key": "query",
                    "path": "query.yaml"
                  }
                ],
                "name": "jaeger-configuration"
              },
              "name": "jaeger-configuration-volume"
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
      "annotations": {
        "traefik.ingress.kubernetes.io/service.serverstransport": "tmaxcloud@file"
      },
      "labels": {
        "app": "jaeger",
        "app.kubernetes.io/component": "query",
        "app.kubernetes.io/name": "jaeger"
      },
      "name": "jaeger-query",
      "namespace": "istio-system"
    },
    "spec": {
      "ports": [
        {
          "name": "jaeger-query",
          "port": 443,
          "protocol": "TCP",
          "targetPort": 3000
        }
      ],
      "selector": {
        "app.kubernetes.io/component": "query",
        "app.kubernetes.io/name": "jaeger"
      },
      "type": "ClusterIP"
    }
  },
  {
    "apiVersion": "cert-manager.io/v1",
    "kind": "Certificate",
    "metadata": {
      "name": "jaeger-cert",
      "namespace": "istio-system"
    },
    "spec": {
      "secretName": "jaeger-secret",
      "usages": [
        "digital signature",
        "key encipherment",
        "server auth",
        "client auth"
      ],
      "dnsNames": [
          "tmax-cloud",
          "jaeger-query.istio-system.svc"
      ],
      "issuerRef": {
        "kind": "ClusterIssuer",
        "group": "cert-manager.io",
        "name": CUSTOM_CLUSTER_ISSUER
      }
    }
  },
  {
    "apiVersion": "apps/v1",
    "kind": "DaemonSet",
    "metadata": {
      "namespace": "istio-system",
      "name": "jaeger-agent",
      "labels": {
        "app": "jaeger",
        "app.kubernetes.io/name": "jaeger",
        "app.kubernetes.io/component": "agent"
      }
    },
    "spec": {
      "selector": {
        "matchLabels": {
          "app": "jaeger"
        }
      },
      "template": {
        "metadata": {
          "labels": {
            "app": "jaeger",
            "app.kubernetes.io/name": "jaeger",
            "app.kubernetes.io/component": "agent"
          },
          "annotations": {
            "prometheus.io/scrape": "true",
            "prometheus.io/port": "5778"
          }
        },
        "spec": {
          "containers": [
            {
              "image": std.join("", [target_registry, "docker.io/jaegertracing/jaeger-agent:", JAEGER_VERSION]),
              "name": "jaeger-agent",
              "args": [
                "--config-file=/conf/agent.yaml",
                std.join("", ["--log-level=", jaeger_agent_log_level])
              ],
              "volumeMounts": [
                {
                  "name": "jaeger-configuration-volume",
                  "mountPath": "/conf"
                },
                {
                  "name": "jaeger-certs",
                  "mountPath": "/ca/cert",
                  "readOnly": true
                }
              ] + ( if time_zone != "UTC" then [
                  {
                    "name": "timezone-config",
                    "mountPath": "/etc/localtime"
                  }
                ] else []
              ),
              "ports": [
                {
                  "containerPort": 5775,
                  "protocol": "UDP"
                },
                {
                  "containerPort": 6831,
                  "protocol": "UDP"
                },
                {
                  "containerPort": 6832,
                  "protocol": "UDP"
                },
                {
                  "containerPort": 5778,
                  "protocol": "TCP"
                }
              ],
              "readinessProbe": {
                "failureThreshold": 3,
                "httpGet": {
                  "path": "/",
                  "port": 14271,
                  "scheme": "HTTP"
                }
              }
            }
          ],
          "hostNetwork": true,
          "dnsPolicy": "ClusterFirstWithHostNet",
          "volumes": [
            {
              "name": "jaeger-certs",
              "secret":
                {
                  "defaultMode": 420,
                  "secretName": "jaeger-secret"
                }
            },
            {
              "configMap": {
                "name": "jaeger-configuration",
                "items": [
                  {
                    "key": "agent",
                    "path": "agent.yaml"
                  }
                ]
              },
              "name": "jaeger-configuration-volume"
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
    "kind": "ConfigMap",
    "metadata": {
      "name": "gatekeeper-files",
      "namespace": "istio-system",
    },
    "data": {
      "access-forbidden.html": std.join("",
        [
          "<html lang='en'><head> <title>Access Forbidden</title><style>*{font-family: 'Courier', 'Courier New', 'sans-serif'; margin:0; padding: 0;}body{background: #233142;}.whistle{width: 20%; fill: #f95959; margin: 100px 40%; text-align: left; transform: translate(-50%, -50%); transform: rotate(0); transform-origin: 80% 30%; animation: wiggle .2s infinite;}@keyframes wiggle{0%{transform: rotate(3deg);}50%{transform: rotate(0deg);}100%{transform: rotate(3deg);}}h1{margin-top: -100px; margin-bottom: 20px; color: #facf5a; text-align: center; font-size: 90px; font-weight: 800;}h2, a{color: #455d7a; text-align: center; font-size: 30px; text-transform: uppercase;}</style> </head><body> <use> <svg version='1.1' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' x='0px' y='0px' viewBox='0 0 1000 1000' enable-background='new 0 0 1000 1000' xml:space='preserve' class='whistle'><g><g transform='translate(0.000000,511.000000) scale(0.100000,-0.100000)'><path d='M4295.8,3963.2c-113-57.4-122.5-107.2-116.8-622.3l5.7-461.4l63.2-55.5c72.8-65.1,178.1-74.7,250.8-24.9c86.2,61.3,97.6,128.3,97.6,584c0,474.8-11.5,526.5-124.5,580.1C4393.4,4001.5,4372.4,4001.5,4295.8,3963.2z'/><path d='M3053.1,3134.2c-68.9-42.1-111-143.6-93.8-216.4c7.7-26.8,216.4-250.8,476.8-509.3c417.4-417.4,469.1-463.4,526.5-463.4c128.3,0,212.5,88.1,212.5,224c0,67-26.8,97.6-434.6,509.3c-241.2,241.2-459.5,449.9-488.2,465.3C3181.4,3180.1,3124,3178.2,3053.1,3134.2z'/><path d='M2653,1529.7C1644,1445.4,765.1,850,345.8-32.7C62.4-628.2,22.2-1317.4,234.8-1960.8C451.1-2621.3,947-3186.2,1584.6-3500.2c1018.6-501.6,2228.7-296.8,3040.5,515.1c317.8,317.8,561,723.7,670.1,1120.1c101.5,369.5,158.9,455.7,360,553.3c114.9,57.4,170.4,65.1,1487.7,229.8c752.5,93.8,1392,181.9,1420.7,193.4C8628.7-857.9,9900,1250.1,9900,1328.6c0,84.3-67,172.3-147.4,195.3c-51.7,15.3-790.8,19.1-2558,15.3l-2487.2-5.7l-55.5-63.2l-55.5-61.3v-344.6V719.8h-411.7h-411.7v325.5c0,509.3,11.5,499.7-616.5,494C2921,1537.3,2695.1,1533.5,2653,1529.7z'/></g></g></svg></use><h1>403</h1><h2>Not this time, access forbidden!</h2><h2><a href='/oauth/logout?redirect=https://",
          REDIRECT_URL,
          ":3000'>Logout</h2></body></html>\n"
        ]
      ),
    },
  },
  {
    "apiVersion": "networking.k8s.io/v1",
    "kind": "Ingress",
    "metadata": {
      "name": "jaeger-ingress",
      "namespace": "istio-system",
      "labels": {
        "app": "jaeger",
        "app.kubernetes.io/name": "jaeger",
        "app.kubernetes.io/component": "query",
        "ingress.tmaxcloud.org/name": "jaeger"
      },
      "annotations": {
        "traefik.ingress.kubernetes.io/router.entrypoints": "websecure"
      }
    },
    "spec": {
      "ingressClassName": "tmax-cloud",
      "rules": [
        {
          "host": std.join("", [jaeger_subdomain, ".", CUSTOM_DOMAIN_NAME]),
          "http": {
            "paths": [
              {
                "backend": {
                  "service": {
                    "name": "jaeger-query",
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
            std.join("", [jaeger_subdomain, ".", CUSTOM_DOMAIN_NAME]),
          ]
        }
      ]
    }
  }
]
