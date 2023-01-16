function (
  is_offline="false",
  private_registry="registry.tmaxcloud.org",
  time_zone="UTC",
  log_level="info"
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";

[
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "name": "image-validation-admission",
      "namespace": "registry-system",
      "labels": {
        "name": "image-validation-admission"
      }
    },
    "spec": {
      "replicas": 1,
      "selector": {
        "matchLabels": {
          "app": "image-validation-admission"
        }
      },
      "template": {
        "metadata": {
          "labels": {
            "app": "image-validation-admission"
          }
        },
        "spec": {
          "containers": [
            {
              "name": "webhook",
              "image": std.join("", [target_registry, "docker.io/tmaxcloudck/image-validation-webhook:v5.0.5"]),
              "imagePullPolicy": "Always",
              "args": [
                std.join("", ["--zap-log-level=", log_level])
              ],
              "resources": {
                  "limits": {
                      "cpu": "300m",
                      "memory": "512Mi"
                  },
                  "requests": {
                      "cpu": "100m",
                      "memory": "256Mi"
                  }
              },
              "volumeMounts": [
                {
                  "mountPath": "/etc/webhook/certs",
                  "name": "webhook-certs",
                  "readOnly": true
                }
              ] + (
                if time_zone != "UTC" then [
                  {
                    "name": "timezone-config",
                    "mountPath": "/etc/localtime"
                  },
                ] else []
              )
            }
          ],
          "serviceAccountName": "image-validation-webhook",
          "volumes": [
            {
              "name": "webhook-certs",
              "secret": {
                "secretName": "image-validation-webhook-cert"
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