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
      "name": "tekton-pipelines-controller",
      "namespace": "tekton-pipelines",
      "labels": {
        "app.kubernetes.io/name": "controller",
        "app.kubernetes.io/component": "controller",
        "app.kubernetes.io/instance": "default",
        "app.kubernetes.io/version": "v0.26.0",
        "app.kubernetes.io/part-of": "tekton-pipelines",
        "pipeline.tekton.dev/release": "v0.26.0",
        "version": "v0.26.0"
      }
    },
    "spec": {
      "replicas": 1,
      "selector": {
        "matchLabels": {
          "app.kubernetes.io/name": "controller",
          "app.kubernetes.io/component": "controller",
          "app.kubernetes.io/instance": "default",
          "app.kubernetes.io/part-of": "tekton-pipelines"
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
            "app.kubernetes.io/version": "v0.26.0",
            "app.kubernetes.io/part-of": "tekton-pipelines",
            "pipeline.tekton.dev/release": "v0.26.0",
            "app": "tekton-pipelines-controller",
            "version": "v0.26.0"
          }
        },
        "spec": {
          "affinity": {
            "nodeAffinity": {
              "requiredDuringSchedulingIgnoredDuringExecution": {
                "nodeSelectorTerms": [
                  {
                    "matchExpressions": [
                      {
                        "key": "kubernetes.io/os",
                        "operator": "NotIn",
                        "values": [
                          "windows"
                        ]
                      }
                    ]
                  }
                ]
              }
            }
          },
          "serviceAccountName": "tekton-pipelines-controller",
          "containers": [
            {
              "name": "tekton-pipelines-controller",
              "image": std.join("", [gcr_registry,"gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/controller:v0.26.0"]),
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
                "-version",
                "v0.26.0",
                "-kubeconfig-writer-image",
                std.join("", [gcr_registry,"gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/kubeconfigwriter:v0.26.0"]),
                "-git-image",
                std.join("", [gcr_registry,"gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/git-init:v0.26.0"]),
                "-entrypoint-image",
                std.join("", [gcr_registry,"gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/entrypoint:v0.26.0"]),
                "-nop-image",
                std.join("", [gcr_registry,"gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/nop:v0.26.0"]),
                "-imagedigest-exporter-image",
                std.join("", [gcr_registry,"gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/imagedigestexporter:v0.26.0"]),
                "-pr-image",
                std.join("", [gcr_registry,"gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/pullrequest-init:v0.26.0"]),
                "-gsutil-image",
                std.join("", [gcr_registry,"gcr.io/google.com/cloudsdktool/cloud-sdk:302.0.0-slim"]),
                "-shell-image",
                std.join("", [gcr_registry,"gcr.io/distroless/base:debug"])
              ],
              "volumeMounts": [
                {
                  "name": "config-logging",
                  "mountPath": "/etc/config-logging"
                },
                {
                  "name": "config-registry-cert",
                  "mountPath": "/etc/config-registry-cert"
                }
              ] + if timezone != "UTC" then [
                {
                  "name": "timezone-config",
                  "mountPath": "/etc/localtime"
                }
              ] else [],
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
                  "name": "AWS_ACCESS_KEY_ID",
                  "value": "foobarbaz"
                },
                {
                  "name": "AWS_SECRET_ACCESS_KEY",
                  "value": "foobarbaz"
                },
                {
                  "name": "AWS_DEFAULT_REGION",
                  "value": "foobarbaz"
                },
                {
                  "name": "CONFIG_DEFAULTS_NAME",
                  "value": "config-defaults"
                },
                {
                  "name": "CONFIG_LOGGING_NAME",
                  "value": "config-logging"
                },
                {
                  "name": "CONFIG_OBSERVABILITY_NAME",
                  "value": "config-observability"
                },
                {
                  "name": "CONFIG_ARTIFACT_BUCKET_NAME",
                  "value": "config-artifact-bucket"
                },
                {
                  "name": "CONFIG_ARTIFACT_PVC_NAME",
                  "value": "config-artifact-pvc"
                },
                {
                  "name": "CONFIG_FEATURE_FLAGS_NAME",
                  "value": "feature-flags"
                },
                {
                  "name": "CONFIG_LEADERELECTION_NAME",
                  "value": "config-leader-election"
                },
                {
                  "name": "SSL_CERT_FILE",
                  "value": "/etc/config-registry-cert/cert"
                },
                {
                  "name": "SSL_CERT_DIR",
                  "value": "/etc/ssl/certs"
                },
                {
                  "name": "METRICS_DOMAIN",
                  "value": "tekton.dev/pipeline"
                }
              ],
              "securityContext": {
                "allowPrivilegeEscalation": false,
                "capabilities": {
                  "drop": [
                    "all"
                  ]
                },
                "runAsUser": 65532,
                "runAsGroup": 65532
              },
              "ports": [
                {
                  "name": "probes",
                  "containerPort": 8080
                }
              ],
              "livenessProbe": {
                "httpGet": {
                  "path": "/health",
                  "port": "probes",
                  "scheme": "HTTP"
                },
                "initialDelaySeconds": 5,
                "periodSeconds": 10,
                "timeoutSeconds": 5
              },
              "readinessProbe": {
                "httpGet": {
                  "path": "/readiness",
                  "port": "probes",
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
              "name": "config-logging",
              "configMap": {
                "name": "config-logging"
              }
            },
            {
              "name": "config-registry-cert",
              "configMap": {
                "name": "config-registry-cert"
              }
            }
          ] + if timezone != "UTC" then [
            {
              "name": "timezone-config",
              "hostPath": {
                "path": std.join("", ["/usr/share/zoneinfo/", timezone])
              }
            }
          ] else []          
        }
      }
    }
  },
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "name": "tekton-pipelines-webhook",
      "namespace": "tekton-pipelines",
      "labels": {
        "app.kubernetes.io/name": "webhook",
        "app.kubernetes.io/component": "webhook",
        "app.kubernetes.io/instance": "default",
        "app.kubernetes.io/version": "v0.26.0",
        "app.kubernetes.io/part-of": "tekton-pipelines",
        "pipeline.tekton.dev/release": "v0.26.0",
        "version": "v0.26.0"
      }
    },
    "spec": {
      "replicas": 1,
      "selector": {
        "matchLabels": {
          "app.kubernetes.io/name": "webhook",
          "app.kubernetes.io/component": "webhook",
          "app.kubernetes.io/instance": "default",
          "app.kubernetes.io/part-of": "tekton-pipelines"
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
            "app.kubernetes.io/version": "v0.26.0",
            "app.kubernetes.io/part-of": "tekton-pipelines",
            "pipeline.tekton.dev/release": "v0.26.0",
            "app": "tekton-pipelines-webhook",
            "version": "v0.26.0"
          }
        },
        "spec": {
          "affinity": {
            "nodeAffinity": {
              "requiredDuringSchedulingIgnoredDuringExecution": {
                "nodeSelectorTerms": [
                  {
                    "matchExpressions": [
                      {
                        "key": "kubernetes.io/os",
                        "operator": "NotIn",
                        "values": [
                          "windows"
                        ]
                      }
                    ]
                  }
                ]
              }
            },
            "podAntiAffinity": {
              "preferredDuringSchedulingIgnoredDuringExecution": [
                {
                  "podAffinityTerm": {
                    "labelSelector": {
                      "matchLabels": {
                        "app.kubernetes.io/name": "webhook",
                        "app.kubernetes.io/component": "webhook",
                        "app.kubernetes.io/instance": "default",
                        "app.kubernetes.io/part-of": "tekton-pipelines"
                      }
                    },
                    "topologyKey": "kubernetes.io/hostname"
                  },
                  "weight": 100
                }
              ]
            }
          },
          "serviceAccountName": "tekton-pipelines-webhook",
          "containers": [
            {
              "name": "webhook",
              "image": std.join("", [gcr_registry,"gcr.io/tekton-releases/github.com/tektoncd/pipeline/cmd/webhook:v0.26.0"]),
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
                  "value": "config-logging"
                },
                {
                  "name": "CONFIG_OBSERVABILITY_NAME",
                  "value": "config-observability"
                },
                {
                  "name": "CONFIG_LEADERELECTION_NAME",
                  "value": "config-leader-election"
                },
                {
                  "name": "WEBHOOK_SERVICE_NAME",
                  "value": "tekton-pipelines-webhook"
                },
                {
                  "name": "WEBHOOK_SECRET_NAME",
                  "value": "webhook-certs"
                },
                {
                  "name": "METRICS_DOMAIN",
                  "value": "tekton.dev/pipeline"
                }
              ],
              "securityContext": {
                "allowPrivilegeEscalation": false,
                "capabilities": {
                  "drop": [
                    "all"
                  ]
                },
                "runAsUser": 65532,
                "runAsGroup": 65532
              },
              "ports": [
                {
                  "name": "metrics",
                  "containerPort": 9090
                },
                {
                  "name": "profiling",
                  "containerPort": 8008
                },
                {
                  "name": "https-webhook",
                  "containerPort": 8443
                },
                {
                  "name": "probes",
                  "containerPort": 8080
                }
              ],
              "livenessProbe": {
                "httpGet": {
                  "path": "/health",
                  "port": "probes",
                  "scheme": "HTTP"
                },
                "initialDelaySeconds": 5,
                "periodSeconds": 10,
                "timeoutSeconds": 5
              },
              "readinessProbe": {
                "httpGet": {
                  "path": "/readiness",
                  "port": "probes",
                  "scheme": "HTTP"
                },
                "initialDelaySeconds": 5,
                "periodSeconds": 10,
                "timeoutSeconds": 5
              }
            } + if timezone != "UTC" then {
              "volumeMounts": [
                {
                  "name": "timezone-config",
                  "mountPath": "/etc/localtime"
                }
              ],
            } else {},
          ]
        } + if timezone != "UTC" then {
          "volumes":[
            {
              "name": "timezone-config",
              "hostPath": {
                "path": std.join("", ["/usr/share/zoneinfo/", timezone])
              },
            },
          ],
        } else {},
      }
    }
  },
  {
    apiVersion: 'v1',
    kind: 'ConfigMap',
    metadata: {
      name: 'config-logging',
      namespace: 'tekton-pipelines',
      labels: {
        'app.kubernetes.io/instance': 'default',
        'app.kubernetes.io/part-of': 'tekton-pipelines',
      },
    },
    data: {
      'zap-logger-config': std.join("", ['{\n  "level": ', log_level, ',\n  "development": false,\n  "sampling": {\n    "initial": 100,\n    "thereafter": 100\n  },\n  "outputPaths": ["stdout"],\n  "errorOutputPaths": ["stderr"],\n  "encoding": "json",\n  "encoderConfig": {\n    "timeKey": "ts",\n    "levelKey": "level",\n    "nameKey": "logger",\n    "callerKey": "caller",\n    "messageKey": "msg",\n    "stacktraceKey": "stacktrace",\n    "lineEnding": "",\n    "levelEncoder": "",\n    "timeEncoder": "iso8601",\n    "durationEncoder": "",\n    "callerEncoder": ""\n  }\n}\n']),
      'loglevel.controller': log_level,
      'loglevel.webhook': log_level,
    },
  },
]
