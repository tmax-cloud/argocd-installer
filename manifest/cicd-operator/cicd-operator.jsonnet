function(
    is_offline=false,
    private_registry="registry.tmaxcloud.org"
)

local tmax_registry = if is_offline == false then "tmaxcloudck" else private_registry;

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
          "containers": [
            {
              "command": [
                "/controller"
              ],
              "image": std.join("", [tmax_registry, "/cicd-operator:v0.4.2"]),
              "imagePullPolicy": "Always",
              "name": "manager",
              "resources": {
                "requests": {
                  "cpu": "100m",
                  "memory": "100Mi"
                }
              },
              "volumeMounts": [
                {
                  "mountPath": "/logs",
                  "name": "operator-log"
                }
              ],
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
          ],
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
          "containers": [
            {
              "command": [
                "/blocker"
              ],
              "image": std.join("", [tmax_registry, "/cicd-blocker:v0.4.2"]),
              "imagePullPolicy": "Always",
              "name": "manager",
              "resources": {
                "requests": {
                  "cpu": "100m",
                  "memory": "100Mi"
                }
              },
              "volumeMounts": [
                {
                  "mountPath": "/logs",
                  "name": "operator-log"
                }
              ],
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
          ],
          "terminationGracePeriodSeconds": 10
        }
      }
    }
  }
]