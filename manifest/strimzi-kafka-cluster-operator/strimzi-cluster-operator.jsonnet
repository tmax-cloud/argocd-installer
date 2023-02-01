function (
  is_offline="false",
  private_registry="172.22.6.2:5000",
  time_zone="UTC",
  log_level="INFO"
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";

{
  "apiVersion": "apps/v1",
  "kind": "Deployment",
  "metadata": {
    "name": "strimzi-cluster-operator",
    "labels": {
      "app": "strimzi"
    },
    "namespace": "kafka"
  },
  "spec": {
    "replicas": 1,
    "selector": {
      "matchLabels": {
        "name": "strimzi-cluster-operator",
        "strimzi.io/kind": "cluster-operator"
      }
    },
    "template": {
      "metadata": {
        "labels": {
          "name": "strimzi-cluster-operator",
          "strimzi.io/kind": "cluster-operator"
        }
      },
      "spec": {
        "serviceAccountName": "strimzi-cluster-operator",
        "volumes": [
          {
            "name": "strimzi-tmp",
            "emptyDir": {
              "medium": "Memory",
              "sizeLimit": "1Mi"
            }
          },
          {
            "name": "co-config-volume",
            "configMap": {
              "name": "strimzi-cluster-operator"
            }
          },
          {
            "name": "strimzi-cluster-operator-service-account-token",
            "secret": {
              "defaultMode": 420,
              "secretName": "strimzi-cluster-operator-service-account-token"
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
        "containers": [
          {
            "name": "strimzi-cluster-operator",
            "image": std.join("", [target_registry, "quay.io/strimzi/operator:0.32.0"]),
            "ports": [
              {
                "containerPort": 8080,
                "name": "http"
              }
            ],
            "args": [
              "/opt/strimzi/bin/cluster_operator_run.sh"
            ],
            "volumeMounts": [
              {
                "name": "strimzi-tmp",
                "mountPath": "/tmp"
              },
              {
                "name": "co-config-volume",
                "mountPath": "/opt/strimzi/custom-config/"
              },
              {
                "name": "strimzi-cluster-operator-service-account-token",
                "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                "readOnly": true
              }
            ] + (
                if time_zone != "UTC" then [
                  {
                    "name": "timezone-config",
                    "mountPath": "/etc/localtime"
                  }
                ] else []
              ),
            "env": [
              {
                "name": "STRIMZI_LOG_LEVEL",
                "value": log_level
              },
              {
                "name": "STRIMZI_NAMESPACE",
                "value": "*"
              },
              {
                "name": "STRIMZI_FULL_RECONCILIATION_INTERVAL_MS",
                "value": "120000"
              },
              {
                "name": "STRIMZI_OPERATION_TIMEOUT_MS",
                "value": "300000"
              },
              {
                "name": "STRIMZI_DEFAULT_TLS_SIDECAR_ENTITY_OPERATOR_IMAGE",
                "value": std.join("", [target_registry, "quay.io/strimzi/kafka:0.32.0-kafka-3.3.1"])
              },
              {
                "name": "STRIMZI_DEFAULT_KAFKA_EXPORTER_IMAGE",
                "value": std.join("", [target_registry, "quay.io/strimzi/kafka:0.32.0-kafka-3.3.1"])
              },
              {
                "name": "STRIMZI_DEFAULT_CRUISE_CONTROL_IMAGE",
                "value": std.join("", [target_registry, "quay.io/strimzi/kafka:0.32.0-kafka-3.3.1"])
              },
              {
                "name": "STRIMZI_KAFKA_IMAGES",
                "value": std.join("",
                  [
                    "3.2.0=", target_registry, "quay.io/strimzi/kafka:0.32.0-kafka-3.2.0\n", 
                    "3.2.1=", target_registry, "quay.io/strimzi/kafka:0.32.0-kafka-3.2.1\n",
                    "3.2.3=", target_registry, "quay.io/strimzi/kafka:0.32.0-kafka-3.2.3\n",
                    "3.3.1=", target_registry, "quay.io/strimzi/kafka:0.32.0-kafka-3.3.1\n"
                  ]
                )
              },
              {
                "name": "STRIMZI_KAFKA_CONNECT_IMAGES",
                "value": std.join("",
                  [
                    "3.2.0=", target_registry, "quay.io/strimzi/kafka:0.32.0-kafka-3.2.0\n", 
                    "3.2.1=", target_registry, "quay.io/strimzi/kafka:0.32.0-kafka-3.2.1\n",
                    "3.2.3=", target_registry, "quay.io/strimzi/kafka:0.32.0-kafka-3.2.3\n",
                    "3.3.1=", target_registry, "quay.io/strimzi/kafka:0.32.0-kafka-3.3.1\n"
                  ]
                )
              },
              {
                "name": "STRIMZI_KAFKA_MIRROR_MAKER_IMAGES",
                "value": std.join("",
                  [
                    "3.2.0=", target_registry, "quay.io/strimzi/kafka:0.32.0-kafka-3.2.0\n", 
                    "3.2.1=", target_registry, "quay.io/strimzi/kafka:0.32.0-kafka-3.2.1\n",
                    "3.2.3=", target_registry, "quay.io/strimzi/kafka:0.32.0-kafka-3.2.3\n",
                    "3.3.1=", target_registry, "quay.io/strimzi/kafka:0.32.0-kafka-3.3.1\n"
                  ]
                )
              },
              {
                "name": "STRIMZI_KAFKA_MIRROR_MAKER_2_IMAGES",
                "value": std.join("",
                  [
                    "3.2.0=", target_registry, "quay.io/strimzi/kafka:0.32.0-kafka-3.2.0\n", 
                    "3.2.1=", target_registry, "quay.io/strimzi/kafka:0.32.0-kafka-3.2.1\n",
                    "3.2.3=", target_registry, "quay.io/strimzi/kafka:0.32.0-kafka-3.2.3\n",
                    "3.3.1=", target_registry, "quay.io/strimzi/kafka:0.32.0-kafka-3.3.1\n"
                  ]
                )
              },
              {
                "name": "STRIMZI_DEFAULT_TOPIC_OPERATOR_IMAGE",
                "value": std.join("", [target_registry, "quay.io/strimzi/operator:0.32.0"])
              },
              {
                "name": "STRIMZI_DEFAULT_USER_OPERATOR_IMAGE",
                "value": std.join("", [target_registry, "quay.io/strimzi/operator:0.32.0"])
              },
              {
                "name": "STRIMZI_DEFAULT_KAFKA_INIT_IMAGE",
                "value": std.join("", [target_registry, "quay.io/strimzi/operator:0.32.0"])
              },
              {
                "name": "STRIMZI_DEFAULT_KAFKA_BRIDGE_IMAGE",
                "value": std.join("", [target_registry, "quay.io/strimzi/kafka-bridge:0.22.3"])
              },
              {
                "name": "STRIMZI_DEFAULT_JMXTRANS_IMAGE",
                "value": std.join("", [target_registry, "quay.io/strimzi/jmxtrans:0.32.0"])
              },
              {
                "name": "STRIMZI_DEFAULT_KANIKO_EXECUTOR_IMAGE",
                "value": std.join("", [target_registry, "quay.io/strimzi/kaniko-executor:0.32.0"])
              },
              {
                "name": "STRIMZI_DEFAULT_MAVEN_BUILDER",
                "value": std.join("", [target_registry, "quay.io/strimzi/maven-builder:0.32.0"])
              },
              {
                "name": "STRIMZI_OPERATOR_NAMESPACE",
                "valueFrom": {
                  "fieldRef": {
                    "fieldPath": "metadata.namespace"
                  }
                }
              },
              {
                "name": "STRIMZI_FEATURE_GATES",
                "value": ""
              },
              {
                "name": "STRIMZI_LEADER_ELECTION_ENABLED",
                "value": "true"
              },
              {
                "name": "STRIMZI_LEADER_ELECTION_LEASE_NAME",
                "value": "strimzi-cluster-operator"
              },
              {
                "name": "STRIMZI_LEADER_ELECTION_LEASE_NAMESPACE",
                "valueFrom": {
                  "fieldRef": {
                    "fieldPath": "metadata.namespace"
                  }
                }
              },
              {
                "name": "STRIMZI_LEADER_ELECTION_IDENTITY",
                "valueFrom": {
                  "fieldRef": {
                    "fieldPath": "metadata.name"
                  }
                }
              }
            ],
            "livenessProbe": {
              "httpGet": {
                "path": "/healthy",
                "port": "http"
              },
              "initialDelaySeconds": 10,
              "periodSeconds": 30
            },
            "readinessProbe": {
              "httpGet": {
                "path": "/ready",
                "port": "http"
              },
              "initialDelaySeconds": 10,
              "periodSeconds": 30
            },
            "resources": {
              "limits": {
                "cpu": "1000m",
                "memory": "384Mi"
              },
              "requests": {
                "cpu": "200m",
                "memory": "384Mi"
              }
            }
          }
        ]
      }
    },
    "strategy": {
      "type": "Recreate"
    }
  }
}