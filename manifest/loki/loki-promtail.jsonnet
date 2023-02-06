function (
  timezone="UTC",
  is_offline="false",
  private_registry="172.22.6.2:5000",
  loki_image_tag="2.7.1",
  loki_volume_size="50Gi",
  promtail_image_tag="2.7.1",
  custom_clusterissuer="tmaxcloud-issuer",
  is_master_cluster="true",
  log_level="info",
  storage_class="default"
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";
local loki_image_path = "docker.io/grafana/loki:" + loki_image_tag;
local promtail_image_path = "docker.io/grafana/promtail:" + promtail_image_tag;

[
  {
    "apiVersion": "apps/v1",
    "kind": "StatefulSet",
    "metadata": {
      "name": "loki",
      "namespace": "monitoring",
      "labels": {
        "app": "loki"
      }
    },
    "spec": {
      "serviceName": "loki",
      "replicas": 1,
      "selector": {
        "matchLabels": {
          "app": "loki"
        }
      },
      "template": {
        "metadata": {
          "labels": {
            "app": "loki"
          }
        },
        "spec": {
          "serviceAccount": "loki-sa",
          "containers": [
            {
              "name": "loki",
              "image": std.join("", [target_registry, loki_image_path]),
              "imagePullPolicy": "IfNotPresent",
              "args": [
                "-config.file=/etc/loki/loki.yaml"
              ],
              "securityContext": {
                "privileged": true
              },
              "resources": {
                "limits": {
                  "cpu": "400m",
                  "memory": "3000Mi"
                },
                "requests": {
                  "cpu": "200m",
                  "memory": "100Mi"
                }
              },
              "ports": [
                {
                  "name": "http-metrics",
                  "containerPort": 3100,
                  "protocol": "TCP"
                }
              ],
              "volumeMounts": [
                {
                  "name": "data",
                  "mountPath": "/loki"
                },
                {
                  "name": "config",
                  "mountPath": "/etc/loki/loki.yaml",
                  "subPath": "loki.yaml"
                }
              ] + if timezone != "UTC" then [
                  {
                    "name": "timezone-config",
                    "mountPath": "/etc/localtime"
                  }
              ] else []
            }
          ],
          "terminationGracePeriodSeconds": 4800,
          "volumes": [
            {
              "name": "config",
              "configMap": {
                "name": "loki-config"
              }
            }
          ] + if timezone != "UTC" then [
            {
              "name": "timezone-config",
              "hostPath": {
                "path": std.join("", ["/usr/share/zoneinfo/", timezone])
              }
            }
          ] else []
        }
      },     
      "volumeClaimTemplates": [
        {
          "metadata": {
            "name": "data",
            "labels": {
              "app": "loki"
            }
          },
          "spec": {
            "accessModes": [ "ReadWriteOnce" ],
            "resources": {
              "requests": {
                "storage": loki_volume_size
              }
            }
          } + (
            if storage_class != "default" then {
              "storageClassName": storage_class
            } else {}
          )
        }
      ]
    }  
  },
  {
    "apiVersion": "apps/v1",
    "kind": "DaemonSet",
    "metadata": {
      "name": "promtail",
      "namespace": "monitoring",
      "labels": {
        "app": "promtail"
      }
    },
    "spec": {
      "selector": {
        "matchLabels": {
          "app": "promtail"
        }
      },
      "template": {
        "metadata": {
          "labels": {
            "app": "promtail"
          }
        },
        "spec": {
          "serviceAccount": "promtail",
          "tolerations": [
            {
              "operator": "Exists"
            }
          ],
          "containers": [
            {
              "name": "promtail",
              "image": std.join("",[target_registry, promtail_image_path]),
              "imagePullPolicy": "IfNotPresent",
              "securityContext": {
                "readOnlyRootFilesystem": true,
                "capabilities" : {
                  "drop" : [
                    "all"
                  ]
                },
                "allowPrivilegeEscalation": false
              },
              "args": [
                "-config.file=/etc/promtail/promtail-config.yaml",
                "--client.external-labels=hostname=$(HOSTNAME)"
              ],
              "env": [
                {
                  "name": "HOSTNAME",
                  "valueFrom": {
                    "fieldRef": {
                      "fieldPath": "spec.nodeName"
                    }
                  }
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
                  "mountPath": "/etc/promtail/promtail-config.yaml",
                  "subPath": "promtail-config.yaml"
                }
              ] + if timezone != "UTC" then [
                {
                  "name": "timezone-config",
                  "mountPath": "/etc/localtime"
                }
              ] else []
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
                "name": "promtail-config"
              }
            }
          ] + if timezone != "UTC" then [
            {
              "name": "timezone-config",
              "hostPath": {
                "path": std.join("", ["/usr/share/zoneinfo/", timezone])
              }
            }
          ] else []
        }
      }
    }
  }
]
