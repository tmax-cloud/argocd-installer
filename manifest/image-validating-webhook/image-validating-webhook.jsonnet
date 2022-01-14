function(
    tmax_registry = "tmaxcloudck"
)

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
              "image": std.join("",[tmax_registry,"/image-validation-webhook:v5.0.3"]),
              "imagePullPolicy": "Always"
            }
          ],
          "serviceAccountName": "image-validation-webhook"
        }
      }
    }
  }
]