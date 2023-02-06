function (
  is_offline = "false",
  private_registry = "registry.tmaxcloud.org",
  v_level = "0",
  time_zone="UTC"
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";

[
  {
    "kind": "Deployment",
    "apiVersion": "apps/v1",
    "metadata": {
      "name": "catalog-catalog-controller-manager",
      "namespace": "catalog",
      "labels": {
        "app": "catalog-catalog",
        "chart": "catalog-0.3.0",
        "release": "catalog",
        "heritage": "Tiller"
      }
    },
    "spec": {
      "replicas": 1,
      "strategy": {
        "type": "RollingUpdate"
      },
      "minReadySeconds": 1,
      "selector": {
        "matchLabels": {
          "app": "catalog-catalog-controller-manager"
        }
      },
      "template": {
        "metadata": {
          "annotations": {
            "prometheus.io/scrape": "false"
          },
          "labels": {
            "app": "catalog-catalog-controller-manager",
            "chart": "catalog-0.3.0",
            "release": "catalog",
            "heritage": "Tiller"
          }
        },
        "spec": {
          "serviceAccountName": "service-catalog-controller-manager",
          "volumes": [
            {
              "name": "run",
              "emptyDir": {}
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
          ),
          "containers": [
            {
              "name": "controller-manager",
              "image": std.join("", [target_registry, "quay.io/kubernetes-service-catalog/service-catalog:v0.3.0"]),
              "imagePullPolicy": "Always",
              "resources": {
                "requests": {
                  "cpu": "100m",
                  "memory": "80Mi"
                },
                "limits": {
                  "cpu": "150m",
                  "memory": "130Mi"
                }
              },
              "env": [
                {
                  "name": "K8S_NAMESPACE",
                  "valueFrom": {
                    "fieldRef": {
                      "fieldPath": "metadata.namespace"
                    }
                  }
                }
              ],
              "args": [
                "controller-manager",
                "--secure-port",
                "8444",
                "--cluster-id-configmap-namespace=catalog",
                "--leader-elect=false",
                "--profiling=false",
                "-v",
                v_level,
                "--resync-interval",
                "5m",
                "--broker-relist-interval",
                "5m",
                "--operation-polling-maximum-backoff-duration",
                "20m",
                "--osb-api-request-timeout",
                "60s",
                "--feature-gates",
                "OriginatingIdentity=true",
                "--feature-gates",
                "ServicePlanDefaults=false"
              ],
              "volumeMounts": [
                {
                  "mountPath": "/var/run",
                  "name": "run"
                }
              ] + (
                if time_zone != "UTC" then [
                  {
                    "name": "timezone-config",
                    "mountPath": "/etc/localtime"
                  }
                ] else []
              ),
              "ports": [
                {
                  "containerPort": 8444
                }
              ],
              "readinessProbe": {
                "httpGet": {
                  "port": 8444,
                  "path": "/healthz/ready",
                  "scheme": "HTTPS"
                },
                "failureThreshold": 1,
                "initialDelaySeconds": 20,
                "periodSeconds": 10,
                "successThreshold": 1,
                "timeoutSeconds": 5
              },
              "livenessProbe": {
                "httpGet": {
                  "port": 8444,
                  "path": "/healthz",
                  "scheme": "HTTPS"
                },
                "failureThreshold": 3,
                "initialDelaySeconds": 40,
                "periodSeconds": 10,
                "successThreshold": 1,
                "timeoutSeconds": 5
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
      "name": "catalog-catalog-webhook",
      "namespace": "catalog",
      "labels": {
        "app": "catalog-catalog-webhook",
        "chart": "catalog-0.3.0",
        "release": "catalog",
        "heritage": "Tiller"
      }
    },
    "spec": {
      "replicas": 1,
      "strategy": {
        "type": "RollingUpdate"
      },
      "minReadySeconds": 1,
      "selector": {
        "matchLabels": {
          "app": "catalog-catalog-webhook"
        }
      },
      "template": {
        "metadata": {
          "labels": {
            "app": "catalog-catalog-webhook",
            "chart": "catalog-0.3.0",
            "release": "catalog",
            "releaseRevision": "1",
            "heritage": "Tiller"
          }
        },
        "spec": {
          "serviceAccountName": "service-catalog-webhook",
          "imagePullSecrets": [],
          "containers": [
            {
              "name": "svr",
              "image": std.join("", [target_registry, "quay.io/kubernetes-service-catalog/service-catalog:v0.3.0"]),
              "imagePullPolicy": "Always",
              "resources": {
                "requests": {
                  "cpu": "100m",
                  "memory": "80Mi"
                },
                "limits": {
                  "cpu": "120m",
                  "memory": "100Mi"
                }
              },
              "args": [
                "webhook",
                "--secure-port",
                "8443",
                "--healthz-server-bind-port",
                "8081",
                "-v",
                v_level,
                "--feature-gates",
                "OriginatingIdentity=true",
                "--feature-gates",
                "ServicePlanDefaults=false"
              ],
              "ports": [
                {
                  "containerPort": 8443
                }
              ],
              "volumeMounts": [
                {
                  "name": "service-catalog-webhook-cert",
                  "mountPath": "/var/run/service-catalog-webhook",
                  "readOnly": true
                }
              ] + (
                if time_zone != "UTC" then [
                  {
                    "name": "timezone-config",
                    "mountPath": "/etc/localtime"
                  }
                ] else []
              ),
              "readinessProbe": {
                "httpGet": {
                  "port": 8081,
                  "path": "/healthz/ready",
                  "scheme": "HTTP"
                },
                "failureThreshold": 1,
                "initialDelaySeconds": 10,
                "periodSeconds": 10,
                "successThreshold": 1,
                "timeoutSeconds": 5
              },
              "livenessProbe": {
                "httpGet": {
                  "port": 8081,
                  "path": "/healthz",
                  "scheme": "HTTP"
                },
                "failureThreshold": 3,
                "initialDelaySeconds": 10,
                "periodSeconds": 10,
                "successThreshold": 1,
                "timeoutSeconds": 5
              }
            }
          ],
          "volumes": [
            {
              "name": "service-catalog-webhook-cert",
              "secret": {
                "secretName": "catalog-webhook-cert",
                "items": [
                  {
                    "key": "tls.crt",
                    "path": "tls.crt"
                  },
                  {
                    "key": "tls.key",
                    "path": "tls.key"
                  }
                ]
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
  }
]
