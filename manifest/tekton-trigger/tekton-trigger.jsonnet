function (
  is_offline="false",
  private_registry="registry.tmaxcloud.org",
  timezone="UTC",
  log_level="info"
)

local gcr_registry = if is_offline == "false" then "" else private_registry + "/";

[
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "name": "tekton-triggers-controller",
      "namespace": "tekton-pipelines",
      "labels": {
        "app.kubernetes.io/name": "controller",
        "app.kubernetes.io/component": "controller",
        "app.kubernetes.io/instance": "default",
        "app.kubernetes.io/version": "v0.15.0",
        "app.kubernetes.io/part-of": "tekton-triggers",
        "triggers.tekton.dev/release": "v0.15.0"
      }
    },
    "spec": {
      "replicas": 1,
      "selector": {
        "matchLabels": {
          "app.kubernetes.io/name": "controller",
          "app.kubernetes.io/component": "controller",
          "app.kubernetes.io/instance": "default",
          "app.kubernetes.io/part-of": "tekton-triggers"
        }
      },
      "template": {
        "metadata": {
          "annotations": {
            "cluster-autoscaler.kubernetes.io/safe-to-evict": "false"
          },
          "labels": {
            "app.kubernetes.io/name": "controller",
            "app.kubernetes.io/component": "controller",
            "app.kubernetes.io/instance": "default",
            "app.kubernetes.io/version": "v0.15.0",
            "app.kubernetes.io/part-of": "tekton-triggers",
            "app": "tekton-triggers-controller",
            "triggers.tekton.dev/release": "v0.15.0",
            "version": "v0.15.0"
          }
        },
        "spec": {
          "serviceAccountName": "tekton-triggers-controller",
          "containers": [
            {
              "name": "tekton-triggers-controller",
              "image": std.join("", [gcr_registry,"gcr.io/tekton-releases/github.com/tektoncd/triggers/cmd/controller:v0.15.0"]),
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
              "args": [
                "-logtostderr",
                "-stderrthreshold",
                "INFO",
                "-el-image",
                std.join("", [gcr_registry,"gcr.io/tekton-releases/github.com/tektoncd/triggers/cmd/eventlistenersink:v0.15.0"]),
                "-el-port",
                "8080",
                "-el-readtimeout",
                "5",
                "-el-writetimeout",
                "40",
                "-el-idletimeout",
                "120",
                "-el-timeouthandler",
                "30",
                "-period-seconds",
                "10",
                "-failure-threshold",
                "1"
              ],
              "env": [
                {
                  "name": "SYSTEM_NAMESPACE",
                  "valueFrom": {
                    "fieldRef": {
                      "fieldPath": "metadata.namespace"
                    }
                  }
                },
                {
                  "name": "CONFIG_LOGGING_NAME",
                  "value": "config-logging-triggers"
                },
                {
                  "name": "CONFIG_OBSERVABILITY_NAME",
                  "value": "config-observability-triggers"
                },
                {
                  "name": "METRICS_DOMAIN",
                  "value": "tekton.dev/triggers"
                },
                {
                  "name": "METRICS_PROMETHEUS_PORT",
                  "value": "9000"
                }
              ],
              "securityContext": {
                "allowPrivilegeEscalation": false,
                "runAsUser": 65532
              }
            } + (
            if timezone != "UTC" then {
              "volumeMounts": [
                {
                  "name": "timezone-config",
                  "mountPath": "/etc/localtime"
                }
              ]
            } else {}
          )
          ]
        } + (
          if timezone != "UTC" then {
            "volumes": [
              {
                "name": "timezone-config",
                "hostPath": {
                  "path": std.join("", ["/usr/share/zoneinfo/", timezone])
                }
              }
            ]
          } else {}
        )
      }
    }
  },
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "name": "tekton-triggers-webhook",
      "namespace": "tekton-pipelines",
      "labels": {
        "app.kubernetes.io/name": "webhook",
        "app.kubernetes.io/component": "webhook",
        "app.kubernetes.io/instance": "default",
        "app.kubernetes.io/version": "v0.15.0",
        "app.kubernetes.io/part-of": "tekton-triggers",
        "triggers.tekton.dev/release": "v0.15.0"
      }
    },
    "spec": {
      "replicas": 1,
      "selector": {
        "matchLabels": {
          "app.kubernetes.io/name": "webhook",
          "app.kubernetes.io/component": "webhook",
          "app.kubernetes.io/instance": "default",
          "app.kubernetes.io/part-of": "tekton-triggers"
        }
      },
      "template": {
        "metadata": {
          "annotations": {
            "cluster-autoscaler.kubernetes.io/safe-to-evict": "false"
          },
          "labels": {
            "app.kubernetes.io/name": "webhook",
            "app.kubernetes.io/component": "webhook",
            "app.kubernetes.io/instance": "default",
            "app.kubernetes.io/version": "v0.15.0",
            "app.kubernetes.io/part-of": "tekton-triggers",
            "app": "tekton-triggers-webhook",
            "triggers.tekton.dev/release": "v0.15.0",
            "version": "v0.15.0"
          }
        },
        "spec": {
          "serviceAccountName": "tekton-triggers-webhook",
          "containers": [
            {
              "name": "webhook",
              "image": std.join("", [gcr_registry,"gcr.io/tekton-releases/github.com/tektoncd/triggers/cmd/webhook:v0.15.0"]),
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
              "env": [
                {
                  "name": "SYSTEM_NAMESPACE",
                  "valueFrom": {
                    "fieldRef": {
                      "fieldPath": "metadata.namespace"
                    }
                  }
                },
                {
                  "name": "CONFIG_LOGGING_NAME",
                  "value": "config-logging-triggers"
                },
                {
                  "name": "WEBHOOK_SERVICE_NAME",
                  "value": "tekton-triggers-webhook"
                },
                {
                  "name": "WEBHOOK_SECRET_NAME",
                  "value": "triggers-webhook-certs"
                },
                {
                  "name": "METRICS_DOMAIN",
                  "value": "tekton.dev/triggers"
                }
              ],
              "ports": [
                {
                  "name": "metrics",
                  "containerPort": 9000
                },
                {
                  "name": "profiling",
                  "containerPort": 8008
                },
                {
                  "name": "https-webhook",
                  "containerPort": 8443
                }
              ],
              "securityContext": {
                "allowPrivilegeEscalation": false,
                "runAsUser": 65532
              }
            } + (
            if timezone != "UTC" then {
              "volumeMounts": [
                {
                  "name": "timezone-config",
                  "mountPath": "/etc/localtime"
                }
              ]
            } else {}
          )
          ]
        } + (
          if timezone != "UTC" then {
            "volumes": [
              {
                "name": "timezone-config",
                "hostPath": {
                  "path": std.join("", ["/usr/share/zoneinfo/", timezone])
                }
              }
            ]
          } else {}
        )
      }
    }
  },
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "name": "tekton-triggers-core-interceptors",
      "namespace": "tekton-pipelines",
      "labels": {
        "app.kubernetes.io/name": "core-interceptors",
        "app.kubernetes.io/component": "interceptors",
        "app.kubernetes.io/instance": "default",
        "app.kubernetes.io/version": "v0.15.0",
        "app.kubernetes.io/part-of": "tekton-triggers",
        "triggers.tekton.dev/release": "v0.15.0"
      }
    },
    "spec": {
      "replicas": 1,
      "selector": {
        "matchLabels": {
          "app.kubernetes.io/name": "core-interceptors",
          "app.kubernetes.io/component": "interceptors",
          "app.kubernetes.io/instance": "default",
          "app.kubernetes.io/part-of": "tekton-triggers"
        }
      },
      "template": {
        "metadata": {
          "labels": {
            "app.kubernetes.io/name": "core-interceptors",
            "app.kubernetes.io/component": "interceptors",
            "app.kubernetes.io/instance": "default",
            "app.kubernetes.io/version": "v0.15.0",
            "app.kubernetes.io/part-of": "tekton-triggers",
            "app": "tekton-triggers-core-interceptors",
            "triggers.tekton.dev/release": "v0.15.0",
            "version": "v0.15.0"
          }
        },
        "spec": {
          "serviceAccountName": "tekton-triggers-core-interceptors",
          "containers": [
            {
              "name": "tekton-triggers-core-interceptors",
              "image": std.join("",[gcr_registry,"gcr.io/tekton-releases/github.com/tektoncd/triggers/cmd/interceptors:v0.15.0"]),
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
              "args": [
                "-logtostderr",
                "-stderrthreshold",
                "INFO"
              ],
              "env": [
                {
                  "name": "SYSTEM_NAMESPACE",
                  "valueFrom": {
                    "fieldRef": {
                      "fieldPath": "metadata.namespace"
                    }
                  }
                },
                {
                  "name": "CONFIG_LOGGING_NAME",
                  "value": "config-logging-triggers"
                },
                {
                  "name": "CONFIG_OBSERVABILITY_NAME",
                  "value": "config-observability-triggers"
                },
                {
                  "name": "METRICS_DOMAIN",
                  "value": "tekton.dev/triggers"
                }
              ],
              "readinessProbe": {
                "httpGet": {
                  "path": "/ready",
                  "port": 8082,
                  "scheme": "HTTP"
                },
                "initialDelaySeconds": 5,
                "periodSeconds": 10,
                "timeoutSeconds": 5
              },
              "securityContext": {
                "allowPrivilegeEscalation": false,
                "runAsUser": 65532,
                "runAsGroup": 65532,
                "capabilities": {
                  "drop": [
                    "all"
                  ]
                }
              }
            } + (
            if timezone != "UTC" then {
              "volumeMounts": [
                {
                  "name": "timezone-config",
                  "mountPath": "/etc/localtime"
                }
              ]
            } else {}
          )
          ]
        } + (
          if timezone != "UTC" then {
            "volumes": [
              {
                "name": "timezone-config",
                "hostPath": {
                  "path": std.join("", ["/usr/share/zoneinfo/", timezone])
                }
              }
            ]
          } else {}
        )
      }
    }
  },
  {
    apiVersion: 'v1',
    kind: 'ConfigMap',
    metadata: {
      name: 'config-logging-triggers',
      namespace: 'tekton-pipelines',
      labels: {
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-triggers',
      },
    },
    data: {
      'zap-logger-config': std.join("", ['{\n  "level": ', log_level, ',\n  "development": false,\n  "sampling": {\n    "initial": 100,\n    "thereafter": 100\n  },\n  "outputPaths": ["stdout"],\n  "errorOutputPaths": ["stderr"],\n  "encoding": "json",\n  "encoderConfig": {\n    "timeKey": "ts",\n    "levelKey": "level",\n    "nameKey": "logger",\n    "callerKey": "caller",\n    "messageKey": "msg",\n    "stacktraceKey": "stacktrace",\n    "lineEnding": "",\n    "levelEncoder": "",\n    "timeEncoder": "iso8601",\n    "durationEncoder": "",\n    "callerEncoder": ""\n  }\n}\n']),
      'loglevel.controller': log_level,
      'loglevel.webhook': log_level,
      'loglevel.eventlistener': log_level,
    },
  }
]
