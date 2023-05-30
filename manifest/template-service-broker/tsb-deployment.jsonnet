function (
  is_offline = "false",
  private_registry="registry.tmaxcloud.org",
  template_operator_version = "0.2.8",
  log_level="info",
  time_zone="UTC"
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";

[
  {
  "apiVersion": "apps/v1",
  "kind": "Deployment",
  "metadata": {
    "name": "template-operator",
    "namespace": "template"
  },
  "spec": {
    "selector": {
      "matchLabels": {
        "name": "template-operator"
      }
    },
    "replicas": 1,
    "template": {
      "metadata": {
        "labels": {
          "name": "template-operator"
        }
      },
      "spec": {
        "serviceAccountName": "template-operator",
        "volumes": [
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
            "command": [
              "/manager"
            ],
            "args": [
              "--enable-leader-election",
              std.join("", ["--zap-log-level=", log_level])
            ],
            "volumeMounts": [
            ] + (
                if time_zone != "UTC" then [
                  {
                    "name": "timezone-config",
                    "mountPath": "/etc/localtime"
                  }
                ] else []
              ),
            "image": std.join("", [target_registry, "docker.io/tmaxcloudck/template-operator:", template_operator_version]),
            "imagePullPolicy": "Always",
            "name": "manager",
            "resources": {
                "limits": {
                    "cpu": "500m",
                    "memory": "400Mi"
                },
                "requests": {
                    "cpu": "200m",
                    "memory": "200Mi"
                }
            }
          }
        ],
        "terminationGracePeriodSeconds": 10
        }
      }
    }
  }
]
