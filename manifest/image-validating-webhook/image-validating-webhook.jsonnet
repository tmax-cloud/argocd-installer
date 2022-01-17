function(
    is_offline="false",
    private_registry="registry.tmaxcloud.org"
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
              "image": std.join("",[target_registry,"docker.io/tmaxcloudck/image-validation-webhook:v5.0.3"]),
              "imagePullPolicy": "Always"
            }
          ],
          "serviceAccountName": "image-validation-webhook"
        }
      }
    }
  }
]