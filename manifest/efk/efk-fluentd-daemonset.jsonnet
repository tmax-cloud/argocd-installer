function (
    fluentd_image_repo="fluent/fluentd-kubernetes-daemonset",
    fluentd_image_tag="v1.4.2-debian-elasticsearch-1.1"
)

[
  {
    "apiVersion": "apps/v1",
    "kind": "DaemonSet",
    "metadata": {
      "name": "fluentd",
      "namespace": "kube-logging",
      "labels": {
        "app": "fluentd"
      }
    },
    "spec": {
      "selector": {
        "matchLabels": {
          "app": "fluentd"
         }
      },
      "template": {
        "metadata": {
          "labels": {
            "app": "fluentd"
          }
        },
        "spec": {
          "serviceAccount": "fluentd",
          "serviceAccountName": "fluentd",
          "tolerations": [
            {
              "operator": "Exists"
            }
          ],
          "containers": [
            {
              "name": "fluentd",
              "image": std.join("",[fluentd_image_repo, ":", fluentd_image_tag]),
              "env": [
                {
                  "name": "FLUENT_ELASTICSEARCH_HOST",
                  "value": "elasticsearch.kube-logging.svc.cluster.local",
                },
                {
                  "name": "FLUENT_ELASTICSEARCH_PORT",
                  "value": "9200",
                },
                {
                  "name": "FLUENT_ELASTICSEARCH_SCHEME",
                  "value": "http",
                 },
                {
                  "name": "FLUENTD_SYSTEMD_CONF",
                  "value": "disable",
                },
                {
                  "name": "FLUENT_ELASTICSEARCH_SED_DISABLE",
                  "value": "true",
                }
              ],
              "resources": {
                "limits": {
                  "cpu": "300m",
                  "memory": "512Mi"
                },
                "requests": {
                  "cpu": "50m",
                  "memory": "100Mi"
                }
              },
              "volumeMounts": [
                {
                  "name": "varlog",
                  "mountPath": "/var/log"
                },
                {
                  "name": "varlibdockercontainers",
                  "mountPath": "/var/lib/docker/containers",
                  "readOnly": true
                },
                {
                  "name": "config",
                  "mountPath": "/fluentd/etc/kubernetes.conf",
                  "subPath": "kubernetes.conf"
                },
                {
                  "name": "index-template",
                  "mountPath": "/fluentd/etc/index_template.json",
                  "subPath": "index_template.json"
                }
              ]
            }
          ],
          "terminationGracePeriodSeconds": 30,
          "volumes": [
            {
              "name": "varlog",
              "hostPath": {
                "path": "/var/log"
              }
            },
            {
              "name": "varlibdockercontainers",
              "hostPath": {
                "path": "/var/lib/docker/containers"
              }
            },
            {
              "name": "config",
              "configMap": {
                "name": "fluentd-config",
                "items": [
                  {
                    "key": "kubernetes.conf",
                    "path": "kubernetes.conf"
                  }
                ]
              }
            },
            {
              "name": "index-template",
              "configMap": {
                "name": "fluentd-config",
                "items": [
                  {
                    "key": "index_template.json",
                    "path": "index_template.json"
                  }
                ]
              }
            }
          ]
        }
      }
    }
  }
]
