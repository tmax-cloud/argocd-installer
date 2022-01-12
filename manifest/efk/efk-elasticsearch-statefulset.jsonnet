function (
    es_image_repo="docker.elastic.co/elasticsearch/elasticsearch",
    es_image_tag="7.2.0",
    busybox_image_repo="busybox",
    busybox_image_tag="1.32.0",
    es_volume_size="50Gi"
)

[
  {
    "apiVersion": "apps/v1",
    "kind": "StatefulSet",
    "metadata": {
      "name": "es-cluster",
      "namespace": "kube-logging"
    },
    "spec": {
      "serviceName": "elasticsearch",
      "replicas": 1,
      "selector": {
        "matchLabels": {
          "app": "elasticsearch"
        }
      },
      "template": {
        "metadata": {
          "labels": {
            "app": "elasticsearch"
          }
        },
        "spec": {
          "serviceAccount": "efk-service-account",
          "containers": [
            {
              "name": "elasticsearch",
              "image": std.join("", [es_image_repo, ":", "es_image_tag"]),
              "securityContext": {
                "allowPrivilegeEscalation": true,
                "privileged": true
              },
              "resources": {
                "limits": {
                  "cpu": "500m",
                  "memory": "3000Mi"
                },
                "requests": {
                  "cpu": "100m",
                  "memory": "100Mi"
                }
              },
              "ports": [
                {
                  "name": "rest",
                  "containerPort": 9200,
                  "protocol": "TCP"
                },
                {
                  "name": "inter-node",
                  "containerPort": 9300,
                  "protocol": "TCP"
                }
              ],
              "volumeMounts": [
                {
                  "name": "data",
                  "mountPath": "/usr/share/elasticsearch/data"
                }
              ],
              "env": [
                {
                  "name": "cluster.name",
                  "value": "k8s-logs"
                },
                {
                  "name": "node.name",     
                  "valueFrom": {
                    "fieldRef": {
                      "fieldPath": "metadata.name"
                    }
                  }
                },
                {
                  "name": "discovery.seed_hosts",     
                  "value": "es-cluster-0.elasticsearch"
                },
                {
                  "name": "cluster.initial_master_nodes",     
                  "value": "es-cluster-0"
                },
                {
                  "name": "ES_JAVA_OPTS",     
                  "value": "-Xms2g -Xmx2g"
                }
              ]
            }
          ],
          "initContainers": [
            {
              "name": "fix-permissions",
              "image": std.join("", [busybox_image_repo, ":", busybox_image_tag]),
              "command": [
                "sh",
                "-c",
                "chown -R 1000:1000 /usr/share/elasticsearch/data"
              ],
              "securityContext": {
                "privileged": true
              },
              "volumeMounts": [
                {
                  "name": "data",
                  "mountPath": "/usr/share/elasticsearch/data"
                }
              ]
            },
            {
              "name": "increase-vm-max-map",
              "image": std.join("", [busybox_image_repo, ":", busybox_image_tag]),
              "command": [
                "sysctl", 
                "-w", 
                "vm.max_map_count=262144"
              ],
              "securityContext": {
                "privileged": true
              }
            },
            {
              "name": "increase-fd-ulimit",
              "image": std.join("", [busybox_image_repo, ":", busybox_image_tag]),
              "command": [
                "sh", 
                "-c", 
                "ulimit -n 65536"
              ],
              "securityContext": {
                "privileged": true
              }
            }
          ]
        }
      },
      "volumeClaimTemplates": [
        {
          "metadata": {
            "name": "data",
            "labels": {
              "app": "elasticsearch"
            }
          },
          "spec": {
            "accessModes": [ "ReadWriteOnce" ],
            "storageClassName": "nfs",
            "resources": {
              "requests": {
                "storage": es_volume_size
              }
            }
          }
        }
      ]
    }  
  }
]    
