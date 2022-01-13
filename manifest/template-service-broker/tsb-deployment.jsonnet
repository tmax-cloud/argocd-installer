function (
    tmax_registry = "tmaxcloudck",
    template_operator_version = "0.2.6",
    cluster_tsb_version = "0.1.3",
    tsb_version = "0.1.3"
)


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
        "containers": [
          {
            "command": [
              "/manager"
            ],
            "args": [
              "--enable-leader-election"
            ],
            "image": std.join("", [tmax_registry, "/template-operator:", template_operator_version]),
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
        "containers": [
          {
            "image": std.join("", [tmax_registry, "/cluster-tsb:", cluster_tsb_version]),
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
        "containers": [
          {
            "image": std.join("", [tmax_registry, "/tsb:", tsb_version]),
            "name": "tsb",
            "imagePullPolicy": "Always"
          }
        ]
        }
      }
    }
  }
]
