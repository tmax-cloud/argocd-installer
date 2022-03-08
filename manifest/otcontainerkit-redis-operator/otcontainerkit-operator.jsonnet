function (
    is_offline="false",
    private_registry="172.22.6.2:5000",
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";

{
  "apiVersion": "apps/v1",
  "kind": "Deployment",
  "metadata": {
    "name": "redis-operator",
    "namespace": "redis-operator",
    "labels": {
      "control-plane": "redis-operator"
    }
  },
  "spec": {
    "replicas": 1,
    "selector": {
      "matchLabels": {
        "control-plane": "redis-operator"
      }
    },
    "template": {
      "metadata": {
        "labels": {
          "control-plane": "redis-operator"
        }
      },
      "spec": {
        "securityContext": {
          "runAsUser": 65532
        },
        "containers": [
          {
            "command": [
              "/manager"
            ],
            "args": [
              "--leader-elect"
            ],
            "image": std.join("", [target_registry, "quay.io/opstree/redis-operator:v0.9.0"]),
            "imagePullPolicy": "Always",
            "name": "manager",
            "securityContext": {
              "allowPrivilegeEscalation": false
            },
            "livenessProbe": {
              "httpGet": {
                "path": "/healthz",
                "port": 8081
              },
              "initialDelaySeconds": 15,
              "periodSeconds": 10
            },
            "resources": {
              "limits": {
                "cpu": "100m",
                "memory": "100Mi"
              },
              "requests": {
                "cpu": "100m",
                "memory": "100Mi"
              }
            },
          },
        ],
        "terminationGracePeriodSeconds": 10,
        "serviceAccount": "redis-operator",
        "serviceAccountName": "redis-operator"
      }
    },
  }
}