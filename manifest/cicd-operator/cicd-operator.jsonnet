function (
  is_offline = "false",
  private_registry = "registry.tmaxcloud.org",
  custom_domain = "tmaxcloud.org",
  cicd_subdomain = "cicd-webhook",
  timezone="UTC",
  log_level="info"

)

local target_registry = if is_offline == "false" then "" else private_registry + "/";
local cicd_domain = std.join("", [cicd_subdomain, ".", custom_domain]);

[
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "name": "cicd-operator",
      "namespace": "cicd-system",
      "labels": {
        "control-plane": "controller-manager",
        "cicd.tmax.io/part-of": "controller"
      }
    },
    "spec": {
      "selector": {
        "matchLabels": {
          "control-plane": "controller-manager"
        }
      },
      "replicas": 1,
      "template": {
        "metadata": {
          "labels": {
            "control-plane": "controller-manager"
          }
        },
        "spec": {
          "serviceAccount": "cicd-service-account",
          "containers": [
            {
              "command": [
                "/controller"
              ],
              "args": [
                std.join("", ["--zap-log-level=", log_level])
              ],
              "image": std.join("", [target_registry, "docker.io/tmaxcloudck/cicd-operator:v0.6.2"]),
              "imagePullPolicy": "Always",
              "name": "manager",
              "env": [
                {
                  "name": "EMAIL_TEMPLATE_PATH",
                  "value": "/templates/email",
                },
                {
                  "name": "REPORT_TEMPLATE_PATH",
                  "value": "/templates/report",
                },
              ],
              "resources": {
                "requests": {
                  "cpu": "100m",
                  "memory": "100Mi"
                },
                "limits": {
                  "cpu": "500m",
                  "memory": "500Mi"
                }
              },
              "volumeMounts": [
                {
                  "mountPath": "/logs",
                  "name": "operator-log"
                },
                {
                  "name": "email-template",
                  "mountPath": "/templates/email",
                },
                {
                  "name": "report-template",
                  "mountPath": "/templates/report",
                },
              ] + if timezone != "UTC" then [
                {
                  "name": "timezone-config",
                  "mountPath": "/etc/localtime"
                }
              ] else [],
              "readinessProbe": {
                "httpGet": {
                  "path": "/readyz",
                  "port": 8888,
                  "scheme": "HTTP"
                },
                "initialDelaySeconds": 5,
                "periodSeconds": 10,
                "timeoutSeconds": 5
              }
            }
          ],
          "volumes": [
            {
              "name": "operator-log",
              "hostPath": {
                "path": "/var/log/cicd-operator/logs"
              }
            },
            {
              "name": "email-template",
              "configMap": {
                "name": "email-template",
              },
            },
            {
              "name": "report-template",
              "configMap": {
                "name": "report-template",
              },
            }
          ] + if timezone != "UTC" then [
            {
              "name": "timezone-config",
              "hostPath": {
                "path": std.join("", ["/usr/share/zoneinfo/", timezone])
              }
            }
          ] else [],
          "terminationGracePeriodSeconds": 10
        }
      }
    }
  },
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "name": "blocker",
      "namespace": "cicd-system",
      "labels": {
        "control-plane": "controller-manager",
        "cicd.tmax.io/part-of": "blocker"
      }
    },
    "spec": {
      "selector": {
        "matchLabels": {
          "cicd.tmax.io/part-of": "blocker"
        }
      },
      "replicas": 1,
      "template": {
        "metadata": {
          "labels": {
            "cicd.tmax.io/part-of": "blocker"
          }
        },
        "spec": {
          "serviceAccount": "cicd-service-account",
          "containers": [
            {
              "command": [
                "/blocker"
              ],
              "args": [
                std.join("", ["--zap-log-level=", log_level])
              ],
              "image": std.join("", [target_registry, "docker.io/tmaxcloudck/cicd-blocker:v0.6.2"]),
              "imagePullPolicy": "Always",
              "name": "manager",
              "resources": {
                "requests": {
                  "cpu": "100m",
                  "memory": "100Mi"
                },
                "limits": {
                  "cpu": "500m",
                  "memory": "500Mi"
                }
              },
              "volumeMounts": [
                {
                  "mountPath": "/logs",
                  "name": "operator-log"
                }
              ] + if timezone != "UTC" then [
                {
                  "name": "timezone-config",
                  "mountPath": "/etc/localtime"
                }
              ] else [],
              "readinessProbe": {
                "httpGet": {
                  "path": "/readyz",
                  "port": 8888,
                  "scheme": "HTTP"
                },
                "initialDelaySeconds": 5,
                "periodSeconds": 10,
                "timeoutSeconds": 5
              }
            }
          ],
          "volumes": [
            {
              "name": "operator-log",
              "hostPath": {
                "path": "/var/log/cicd-operator/logs"
              }
            }
          ] + if timezone != "UTC" then [
            {
              "name": "timezone-config",
              "hostPath": {
                "path": std.join("", ["/usr/share/zoneinfo/", timezone])
              }
            }
          ] else [],
          "terminationGracePeriodSeconds": 10
        }
      }
    }
  },
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "name": "webhook-server",
      "namespace": "cicd-system",
      "labels": {
        "control-plane": "controller-manager",
        "cicd.tmax.io/part-of": "webhook"
      }
    },
    "spec": {
      "selector": {
        "matchLabels": {
          "cicd.tmax.io/part-of": "webhook"
        }
      },
      "replicas": 1,
      "template": {
        "metadata": {
          "labels": {
            "cicd.tmax.io/part-of": "webhook"
          }
        },
        "spec": {
          "serviceAccountName": "cicd-service-account",
          "containers": [
            {
              "command": [
                "/webhook"
              ],
              "args": [
                std.join("", ["--zap-log-level=", log_level])
              ],
              "image": std.join("", [target_registry, "docker.io/tmaxcloudck/cicd-webhook:v0.6.2"]),
              "imagePullPolicy": "Always",
              "name": "manager",
              "resources": {
                "requests": {
                  "cpu": "100m",
                  "memory": "100Mi"
                },
                "limits": {
                  "cpu": "500m",
                  "memory": "500Mi"
                }
              },
              "volumeMounts": [
                {
                  "mountPath": "/logs",
                  "name": "operator-log",
                }
              ] + if timezone != "UTC" then [
                {
                  "name": "timezone-config",
                  "mountPath": "/etc/localtime"
                }
              ] else [],
              "readinessProbe": {
                "httpGet": {
                  "path": "/readyz",
                  "port": 8888,
                  "scheme": "HTTP"
                },
                "initialDelaySeconds": 5,
                "periodSeconds": 10,
                "timeoutSeconds": 5
              }
            }
          ],
          "volumes": [
            {
              "name": "operator-log",
              "hostPath": {
                "path": "/var/log/cicd-operator/logs",
              }
            }
          ] + if timezone != "UTC" then [
            {
              "name": "timezone-config",
              "hostPath": {
                "path": std.join("", ["/usr/share/zoneinfo/", timezone])
              }
            }
          ] else [],
          "terminationGracePeriodSeconds": 10
        }
      }
    }
  },
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "name": "api-server",
      "namespace": "cicd-system",
      "labels": {
        "control-plane": "controller-manager",
        "cicd.tmax.io/part-of": "api-server"
      }
    },
    "spec": {
      "selector": {
        "matchLabels": {
          "cicd.tmax.io/part-of": "api-server"
        }
      },
      "replicas": 1,
      "template": {
        "metadata": {
          "labels": {
            "cicd.tmax.io/part-of": "api-server"
          }
        },
        "spec": {
          "serviceAccountName": "cicd-service-account",
          "containers": [
            {
              "command": [
                "/apiserver"
              ],
              "args": [
                std.join("", ["--zap-log-level=", log_level])
              ],
              "image": std.join("", [target_registry, "docker.io/tmaxcloudck/cicd-api-server:v0.6.2"]),
              "imagePullPolicy": "Always",
              "name": "manager",
              "resources": {
                "requests": {
                  "cpu": "100m",
                  "memory": "100Mi"
                },
                "limits": {
                  "cpu": "500m",
                  "memory": "500Mi"
                }
              },
              "volumeMounts": [
                {
                  "mountPath": "/logs",
                  "name": "operator-log",
                }
              ] + if timezone != "UTC" then [
                {
                  "name": "timezone-config",
                  "mountPath": "/etc/localtime"
                }
              ] else [],
              "readinessProbe": {
                "httpGet": {
                  "path": "/readyz",
                  "port": 8888,
                  "scheme": "HTTP"
                },
                "initialDelaySeconds": 5,
                "periodSeconds": 10,
                "timeoutSeconds": 5
              }
            }
          ],
          "volumes": [
            {
              "name": "operator-log",
              "hostPath": {
                "path": "/var/log/cicd-operator/logs",
              }
            }
          ] + if timezone != "UTC" then [
            {
              "name": "timezone-config",
              "hostPath": {
                "path": std.join("", ["/usr/share/zoneinfo/", timezone])
              }
            }
          ] else [],
          "terminationGracePeriodSeconds": 10
        }
      }
    }
  },
  {
    "apiVersion": "v1",
    "kind": "ConfigMap",
    "metadata": {
      "name": "cicd-config",
      "namespace": "cicd-system",
      "labels": {
        "cicd.tmax.io/part-of": "controller"
      }
    },
    "data": {
      "maxPipelineRun": "5",
      "externalHostName": "",
      "reportRedirectUriTemplate": "",
      "enableMail": "false",
      "smtpHost": "",
      "smtpUserSecret": "",
      "collectPeriod": "120",
      "integrationJobTTL": "120",
      "exposeMode": "Ingress",
      "ingressClass": "",
      "ingressHost": cicd_domain,
      "gitImage": "docker.io/alpine/git:1.0.30",
      "gitCheckoutStepCPURequest": "30m",
      "gitCheckoutStepMemRequest": "100Mi"
    }
  },
  {
    "apiVersion": "networking.k8s.io/v1",
    "kind": "Ingress",
    "metadata": {
      "name": "cicd-webhook",
      "namespace": "cicd-system",
      "labels": {
        "cicd.tmax.io/part-of": "controller"
      }
    },
    "spec": {
      "rules": [
        {
          "host": cicd_domain,
          "http": {
            "paths": [
              {
                "pathType": "Prefix",
                "path": "/",
                "backend": {
                  "service": {
                    "name": "cicd-webhook",
                    "port": {
                      "number": 24335
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