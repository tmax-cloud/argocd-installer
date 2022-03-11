function (
    is_offline = "false",
    private_registry="registry.tmaxcloud.org",
    template_operator_version = "0.2.7",
    cluster_tsb_version = "0.1.4",
    tsb_version = "0.1.4"
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
          {
            "name": "template-operator-token",
            "secret": {
              "defaultMode": 420,
              "secretName": "template-operator-token"
            }
          }
        ],
        "containers": [
          {
            "command": [
              "/manager"
            ],
            "args": [
              "--enable-leader-election"
            ],
            "volumeMounts": [
              {
                "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                "name": "template-operator-token",
                "readOnly": true
              }
            ],
            "image": std.join("", [target_registry, "docker.io/tmaxcloudck/template-operator:", template_operator_version]),
            "imagePullPolicy": "Always",
            "name": "manager"
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
    "labels": {
      "app": "cluster-template-service-broker"
    },
    "name": "cluster-template-service-broker",
    "namespace": "cluster-tsb-ns"
  },
  "spec": {
    "replicas": 1,
    "selector": {
      "matchLabels": {
        "app": "cluster-template-service-broker"
      }
    },
    "template": {
      "metadata": {
        "labels": {
          "app": "cluster-template-service-broker"
        }
      },
      "spec": {
        "serviceAccountName": "cluster-tsb-sa",
        "volumes": [
          {
            "name": "cluster-tsb-token",
            "secret": {
              "defaultMode": 420,
              "secretName": "cluster-tsb-token"
            }
          }
        ],
        "containers": [
          {
            "volumeMounts": [
              {
                "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                "name": "cluster-tsb-token",
                "readOnly": true
              }
            ],
            "image": std.join("", [target_registry, "docker.io/tmaxcloudck/cluster-tsb:", cluster_tsb_version]),
            "name": "cluster-tsb",
            "imagePullPolicy": "Always"
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
    "labels": {
      "app": "template-service-broker"
    },
    "name": "template-service-broker",
    "namespace": "tsb-ns"
  },
  "spec": {
    "replicas": 1,
    "selector": {
      "matchLabels": {
        "app": "template-service-broker"
      }
    },
    "template": {
      "metadata": {
        "labels": {
          "app": "template-service-broker"
        }
      },
      "spec": {
        "serviceAccountName": "tsb-sa",
        "volumes": [
          {
            "name": "tsb-token",
            "secret": {
              "defaultMode": 420,
              "secretName": "tsb-token"
            }
          }
        ],
        "containers": [
          {
            "volumeMounts": [
              {
                "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                "name": "tsb-token",
                "readOnly": true
              }
            ],
            "image": std.join("", [target_registry, "docker.io/tmaxcloudck/tsb:", tsb_version]),
            "name": "tsb",
            "imagePullPolicy": "Always"
          }
        ]
        }
      }
    }
  }
]
