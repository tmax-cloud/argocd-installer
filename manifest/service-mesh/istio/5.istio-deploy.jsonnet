function (
  is_offline="false",
  private_registry="registry.tmaxcloud.org",
  ISTIO_VERSION= "1.5.1",
  istiod_pilot_discovery_loglevel="default:info",
  ingressgateway_pilot_agent_loglevel="default:info",
  istio_proxy_loglevel="warning",
  time_zone="UTC"
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";

[
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "labels": {
        "app": "istiod",
        "istio": "pilot",
        "release": "istio"
      },
      "name": "istiod",
      "namespace": "istio-system"
    },
    "spec": {
      "selector": {
        "matchLabels": {
          "istio": "pilot"
        }
      },
      "strategy": {
        "rollingUpdate": {
          "maxSurge": "100%",
          "maxUnavailable": "25%"
        }
      },
      "template": {
        "metadata": {
          "annotations": {
            "sidecar.istio.io/inject": "false"
          },
          "labels": {
            "app": "istiod",
            "istio": "pilot"
          }
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
              "args": [
                "discovery",
                "--monitoringAddr=:15014",
                std.join("", ["--log_output_level=", istiod_pilot_discovery_loglevel]),
                "--domain",
                "cluster.local",
                "--secureGrpcAddr=:15011",
                "--trust-domain=cluster.local",
                "--keepaliveMaxServerConnectionAge",
                "30m",
                "--disable-install-crds=true"
              ],
              "env": [
                {
                  "name": "JWT_POLICY",
                  "value": "first-party-jwt"
                },
                {
                  "name": "PILOT_CERT_PROVIDER",
                  "value": "istiod"
                },
                {
                  "name": "POD_NAME",
                  "valueFrom": {
                    "fieldRef": {
                      "apiVersion": "v1",
                      "fieldPath": "metadata.name"
                    }
                  }
                },
                {
                  "name": "POD_NAMESPACE",
                  "valueFrom": {
                    "fieldRef": {
                      "apiVersion": "v1",
                      "fieldPath": "metadata.namespace"
                    }
                  }
                },
                {
                  "name": "SERVICE_ACCOUNT",
                  "valueFrom": {
                    "fieldRef": {
                      "apiVersion": "v1",
                      "fieldPath": "spec.serviceAccountName"
                    }
                  }
                },
                {
                  "name": "PILOT_TRACE_SAMPLING",
                  "value": "10"
                },
                {
                  "name": "CONFIG_NAMESPACE",
                  "value": "istio-config"
                },
                {
                  "name": "PILOT_ENABLE_PROTOCOL_SNIFFING_FOR_OUTBOUND",
                  "value": "true"
                },
                {
                  "name": "PILOT_ENABLE_PROTOCOL_SNIFFING_FOR_INBOUND",
                  "value": "false"
                },
                {
                  "name": "INJECTION_WEBHOOK_CONFIG_NAME",
                  "value": "istio-sidecar-injector"
                },
                {
                  "name": "ISTIOD_ADDR",
                  "value": "istiod.istio-system.svc:15012"
                },
                {
                  "name": "PILOT_EXTERNAL_GALLEY",
                  "value": "false"
                }
              ],
              "envFrom": [
                {
                  "configMapRef": {
                    "name": "istiod",
                    "optional": true
                  }
                }
              ],
              "image": std.join("", [target_registry, "docker.io/istio/pilot:", ISTIO_VERSION]),
              "imagePullPolicy": "IfNotPresent",
              "name": "discovery",
              "ports": [
                {
                  "containerPort": 8080
                },
                {
                  "containerPort": 15010
                },
                {
                  "containerPort": 15017
                }
              ],
              "readinessProbe": {
                "httpGet": {
                  "path": "/ready",
                  "port": 8080
                },
                "initialDelaySeconds": 5,
                "periodSeconds": 5,
                "timeoutSeconds": 5
              },
              "resources": {
                "requests": {
                  "cpu": "250m",
                  "memory": "512Mi"
                },
                "limits": {
                  "cpu": "500m",
                  "memory": "1Gi"
                }
              },
              "securityContext": {
                "capabilities": {
                  "drop": [
                    "ALL"
                  ]
                },
                "runAsGroup": 1337,
                "runAsNonRoot": true,
                "runAsUser": 1337
              },
              "volumeMounts": [
                {
                  "mountPath": "/etc/istio/config",
                  "name": "config-volume"
                },
                {
                  "mountPath": "/var/run/secrets/istio-dns",
                  "name": "local-certs"
                },
                {
                  "mountPath": "/etc/cacerts",
                  "name": "cacerts",
                  "readOnly": true
                },
                {
                  "mountPath": "/var/lib/istio/inject",
                  "name": "inject",
                  "readOnly": true
                },
                {
                  "mountPath": "/var/lib/istio/local",
                  "name": "istiod",
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
          "securityContext": {
            "fsGroup": 1337
          },
          "serviceAccountName": "istiod-service-account",
          "volumes": [
            {
              "emptyDir": {
                "medium": "Memory"
              },
              "name": "local-certs"
            },
            {
              "configMap": {
                "name": "istiod",
                "optional": true
              },
              "name": "istiod"
            },
            {
              "name": "cacerts",
              "secret": {
                "optional": true,
                "secretName": "cacerts"
              }
            },
            {
              "configMap": {
                "name": "istio-sidecar-injector",
                "optional": true
              },
              "name": "inject"
            },
            {
              "configMap": {
                "name": "istio"
              },
              "name": "config-volume"
            },
            {
              "configMap": {
                "name": "pilot-envoy-config"
              },
              "name": "pilot-envoy-config"
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
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "labels": {
        "app": "istio-ingressgateway",
        "istio": "ingressgateway",
        "release": "istio"
      },
      "name": "istio-ingressgateway",
      "namespace": "istio-system"
    },
    "spec": {
      "selector": {
        "matchLabels": {
          "app": "istio-ingressgateway",
          "istio": "ingressgateway"
        }
      },
      "strategy": {
        "rollingUpdate": {
          "maxSurge": "100%",
          "maxUnavailable": "25%"
        }
      },
      "template": {
        "metadata": {
          "annotations": {
            "sidecar.istio.io/inject": "false"
          },
          "labels": {
            "app": "istio-ingressgateway",
            "chart": "gateways",
            "heritage": "Tiller",
            "istio": "ingressgateway",
            "release": "istio",
            "service.istio.io/canonical-name": "istio-ingressgateway",
            "service.istio.io/canonical-revision": "1.5"
          }
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
              "args": [
                "proxy",
                "router",
                "--domain",
                "$(POD_NAMESPACE).svc.cluster.local",
                "--proxyLogLevel=warning",
                "--proxyComponentLogLevel=misc:error",
                std.join("", ["--log_output_level=", ingressgateway_pilot_agent_loglevel]),
                "--drainDuration",
                "45s",
                "--parentShutdownDuration",
                "1m0s",
                "--connectTimeout",
                "10s",
                "--serviceCluster",
                "istio-ingressgateway",
                "--zipkinAddress",
                "zipkin.istio-system:9411",
                "--proxyAdminPort",
                "15000",
                "--statusPort",
                "15020",
                "--controlPlaneAuthPolicy",
                "NONE",
                "--discoveryAddress",
                "istio-pilot.istio-system.svc:15012",
                "--trust-domain=cluster.local"
              ],
              "env": [
                {
                  "name": "JWT_POLICY",
                  "value": "first-party-jwt"
                },
                {
                  "name": "PILOT_CERT_PROVIDER",
                  "value": "istiod"
                },
                {
                  "name": "ISTIO_META_USER_SDS",
                  "value": "true"
                },
                {
                  "name": "CA_ADDR",
                  "value": "istio-pilot.istio-system.svc:15012"
                },
                {
                  "name": "NODE_NAME",
                  "valueFrom": {
                    "fieldRef": {
                      "apiVersion": "v1",
                      "fieldPath": "spec.nodeName"
                    }
                  }
                },
                {
                  "name": "POD_NAME",
                  "valueFrom": {
                    "fieldRef": {
                      "apiVersion": "v1",
                      "fieldPath": "metadata.name"
                    }
                  }
                },
                {
                  "name": "POD_NAMESPACE",
                  "valueFrom": {
                    "fieldRef": {
                      "apiVersion": "v1",
                      "fieldPath": "metadata.namespace"
                    }
                  }
                },
                {
                  "name": "INSTANCE_IP",
                  "valueFrom": {
                    "fieldRef": {
                      "apiVersion": "v1",
                      "fieldPath": "status.podIP"
                    }
                  }
                },
                {
                  "name": "HOST_IP",
                  "valueFrom": {
                    "fieldRef": {
                      "apiVersion": "v1",
                      "fieldPath": "status.hostIP"
                    }
                  }
                },
                {
                  "name": "SERVICE_ACCOUNT",
                  "valueFrom": {
                    "fieldRef": {
                      "fieldPath": "spec.serviceAccountName"
                    }
                  }
                },
                {
                  "name": "ISTIO_META_WORKLOAD_NAME",
                  "value": "istio-ingressgateway"
                },
                {
                  "name": "ISTIO_META_OWNER",
                  "value": "kubernetes://apis/apps/v1/namespaces/istio-system/deployments/istio-ingressgateway"
                },
                {
                  "name": "ISTIO_META_MESH_ID",
                  "value": "cluster.local"
                },
                {
                  "name": "ISTIO_AUTO_MTLS_ENABLED",
                  "value": "true"
                },
                {
                  "name": "ISTIO_META_POD_NAME",
                  "valueFrom": {
                    "fieldRef": {
                      "apiVersion": "v1",
                      "fieldPath": "metadata.name"
                    }
                  }
                },
                {
                  "name": "ISTIO_META_CONFIG_NAMESPACE",
                  "valueFrom": {
                    "fieldRef": {
                      "fieldPath": "metadata.namespace"
                    }
                  }
                },
                {
                  "name": "ISTIO_META_ROUTER_MODE",
                  "value": "sni-dnat"
                },
                {
                  "name": "ISTIO_META_CLUSTER_ID",
                  "value": "Kubernetes"
                }
              ],
              "image": std.join("", [target_registry, "docker.io/istio/proxyv2:", ISTIO_VERSION]),
              "imagePullPolicy": "IfNotPresent",
              "name": "istio-proxy",
              "ports": [
                {
                  "containerPort": 15020
                },
                {
                  "containerPort": 80
                },
                {
                  "containerPort": 443
                },
                {
                  "containerPort": 15029
                },
                {
                  "containerPort": 15030
                },
                {
                  "containerPort": 15031
                },
                {
                  "containerPort": 15032
                },
                {
                  "containerPort": 15443
                },
                {
                  "containerPort": 31400
                },
                {
                  "containerPort": 15011
                },
                {
                  "containerPort": 15012
                },
                {
                  "containerPort": 8060
                },
                {
                  "containerPort": 853
                },
                {
                  "containerPort": 15090,
                  "name": "http-envoy-prom",
                  "protocol": "TCP"
                }
              ],
              "readinessProbe": {
                "failureThreshold": 30,
                "httpGet": {
                  "path": "/healthz/ready",
                  "port": 15020,
                  "scheme": "HTTP"
                },
                "initialDelaySeconds": 1,
                "periodSeconds": 2,
                "successThreshold": 1,
                "timeoutSeconds": 1
              },
              "resources": {
                "limits": {
                  "cpu": "200m",
                  "memory": "512Mi"
                },
                "requests": {
                  "cpu": "50m",
                  "memory": "128Mi"
                }
              },
              "volumeMounts": [
                {
                  "mountPath": "/var/run/secrets/istio",
                  "name": "istiod-ca-cert"
                },
                {
                  "mountPath": "/var/run/ingress_gateway",
                  "name": "ingressgatewaysdsudspath"
                },
                {
                  "mountPath": "/etc/istio/pod",
                  "name": "podinfo"
                },
                {
                  "mountPath": "/etc/istio/ingressgateway-certs",
                  "name": "ingressgateway-certs",
                  "readOnly": true
                },
                {
                  "mountPath": "/etc/istio/ingressgateway-ca-certs",
                  "name": "ingressgateway-ca-certs",
                  "readOnly": true
                }
              ] + ( 
                if time_zone != "UTC" then [
                  {
                    "name": "timezone-config",
                    "mountPath": "/etc/localtime"
                  }
                ] else []
              )
            }
          ],
          "serviceAccountName": "istio-ingressgateway-service-account",
          "volumes": [
            {
              "configMap": {
                "name": "istio-ca-root-cert"
              },
              "name": "istiod-ca-cert"
            },
            {
              "downwardAPI": {
                "items": [
                  {
                    "fieldRef": {
                      "fieldPath": "metadata.labels"
                    },
                    "path": "labels"
                  },
                  {
                    "fieldRef": {
                      "fieldPath": "metadata.annotations"
                    },
                    "path": "annotations"
                  }
                ]
              },
              "name": "podinfo"
            },
            {
              "emptyDir": {},
              "name": "ingressgatewaysdsudspath"
            },
            {
              "name": "ingressgateway-certs",
              "secret": {
                "optional": true,
                "secretName": "istio-ingressgateway-certs"
              }
            },
            {
              "name": "ingressgateway-ca-certs",
              "secret": {
                "optional": true,
                "secretName": "istio-ingressgateway-ca-certs"
              }
            }
          ]  + (
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
  }
]
