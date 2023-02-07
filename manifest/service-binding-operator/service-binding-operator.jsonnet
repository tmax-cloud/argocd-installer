function (
  is_offline="false",
  private_registry="registry.hypercloud.org",
  time_zone="UTC",
  log_level="INFO"
)


local target_registry = if is_offline == "false" then "" else private_registry + "/";

{
  "apiVersion": "apps/v1",
  "kind": "Deployment",
  "metadata": {
    "labels": {
      "control-plane": "service-binding-controller-manager"
    },
    "name": "service-binding-operator",
    "namespace": "service-binding-operator"
  },
  "spec": {
    "replicas": 1,
    "selector": {
      "matchLabels": {
        "control-plane": "service-binding-controller-manager"
      }
    },
    "template": {
      "metadata": {
        "annotations" : {
          "kubectl.kubernetes.io/default-container": "manager"
        },
        "labels": {
          "control-plane": "service-binding-controller-manager"
        }
      },
      "spec": {
        "containers": [
          {
            "args": [
              "--leader-elect",
              "--zap-encoder=json",
              std.join("", ["--zap-log-level=", log_level])
            ],
            "command": [
              "/manager"
            ],
            "imagePullPolicy": "Always",
            "image": std.join("", [target_registry, "quay.io/redhat-developer/servicebinding-operator:b3693e45"]),
            "livenessProbe": {
              "httpGet": {
                "path": "/healthz",
                "port": 8081
              },
              "initialDelaySeconds": 15,
              "periodSeconds": 20
            },
            "name": "manager",
            "ports": [
              {
                "containerPort": 9443,
                "name": "webhook-server",
                "protocol": "TCP"
              }
            ],
            "resources": {
                "limits": {
                  "cpu": "1000m",
                  "memory": "1Gi"
                },
                "requests": {
                  "cpu": "100m",
                  "memory": "128Mi"
                }
            },
            "readinessProbe": {
              "httpGet": {
                "path": "/readyz",
                "port": 8081
              },
              "initialDelaySeconds": 5,
              "periodSeconds": 10
            },
            "volumeMounts": [
              {
                "mountPath": "/tmp/k8s-webhook-server/serving-certs",
                "name": "cert",
                "readOnly": true
              }
            ] + (
                if time_zone != "UTC" then [
                  {
                    "name": "timezone-config",
                    "mountPath": "/etc/localtime"
                  }
                ] else []
              )
          }
        ],
        "serviceAccountName": "service-binding-operator",
        "terminationGracePeriodSeconds": 10,
        "volumes": [
          {
            "name": "cert",
            "secret": {
              "defaultMode": 420,
              "secretName": "service-binding-operator-service-cert"
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
          ),
      }
    }
  }
}
