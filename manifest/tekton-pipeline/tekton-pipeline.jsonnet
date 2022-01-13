function(
  gcr_registry = "gcr.io"
)

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
              "image": std.join("", [gcr_registry,"/tekton-releases/github.com/tektoncd/pipeline/cmd/controller:v0.26.0@sha256:db1d486fac10b1eca6d7b8daf4764a15f8c70e67961457c73d8c04964a3e4929"]),
              "args": [
                "-version",
                "v0.26.0",
                "-kubeconfig-writer-image",
                std.join("", [gcr_registry,"/tekton-releases/github.com/tektoncd/pipeline/cmd/kubeconfigwriter:v0.26.0@sha256:a4471a7ef4bdec4b4f4d08c20df0b762140142701c1197e1f57eca10b741db3a"]),
                "-git-image",
                std.join("", [gcr_registry,"/tekton-releases/github.com/tektoncd/pipeline/cmd/git-init:v0.26.0@sha256:8a5ed01f5a0684a90a2f42d247a10a2274f974759562329b200abaed4a804508"]),
                "-entrypoint-image",
                std.join("", [gcr_registry,"/tekton-releases/github.com/tektoncd/pipeline/cmd/entrypoint:v0.26.0@sha256:6a99fea33bb3dd1c20a16837cd88af0a120ba699c3f3e18ea9338fba78387556"]),
                "-nop-image",
                std.join("", [gcr_registry,"/tekton-releases/github.com/tektoncd/pipeline/cmd/nop:v0.26.0@sha256:8c6a241f71b54c39c001c94128013e6abd8693c64aa1231f1d19b2e50f57d3af"]),
                "-imagedigest-exporter-image",
                std.join("", [gcr_registry,"/tekton-releases/github.com/tektoncd/pipeline/cmd/imagedigestexporter:v0.26.0@sha256:92a090944f89a679bb3632ae1b8c8afa30ef5a9eb7d4a3bdbca6f13967db8d3d"]),
                "-pr-image",
                std.join("", [gcr_registry,"/tekton-releases/github.com/tektoncd/pipeline/cmd/pullrequest-init:v0.26.0@sha256:1ab4207300c431f2098e6f6cbdb3fd6c8058900bbf06b398f159668419903b68"]),
                "-gsutil-image",
                std.join("", [gcr_registry,"/google.com/cloudsdktool/cloud-sdk@sha256:27b2c22bf259d9bc1a291e99c63791ba0c27a04d2db0a43241ba0f1f20f4067f"]),
                "-shell-image",
                std.join("", [gcr_registry,"/distroless/base@sha256:aa4fd987555ea10e1a4ec8765da8158b5ffdfef1e72da512c7ede509bc9966c4"])
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
          ]
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
              "image": std.join("", [gcr_registry,"/tekton-releases/github.com/tektoncd/pipeline/cmd/webhook:v0.26.0@sha256:79cf8b670ab008d605362641443648d9ac0ff247f1f943bb4d5209716a9b49fa"]),
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
            }
          ]
        }
      }
    }
  }
]