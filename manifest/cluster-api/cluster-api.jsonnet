function (
  is_offline="false",
  private_registry="172.22.6.2:5000"
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";

[
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "labels": {
        "cluster.x-k8s.io/provider": "cluster-api",
        "control-plane": "controller-manager"
      },
      "name": "capi-controller-manager",
      "namespace": "capi-system"
    },
    "spec": {
      "replicas": 1,
      "selector": {
        "matchLabels": {
          "cluster.x-k8s.io/provider": "cluster-api",
          "control-plane": "controller-manager"
        }
      },
      "template": {
        "metadata": {
          "labels": {
            "cluster.x-k8s.io/provider": "cluster-api",
            "control-plane": "controller-manager"
          }
        },
        "spec": {
          "containers": [
            {
              "args": [
                "--leader-elect",
                "--metrics-bind-addr=localhost:8080",
                "--feature-gates=MachinePool=${EXP_MACHINE_POOL:=false},ClusterResourceSet=${EXP_CLUSTER_RESOURCE_SET:=false},ClusterTopology=${CLUSTER_TOPOLOGY:=false}"
              ],
              "command": [
                "/manager"
              ],
              "image": std.join("", [target_registry, "k8s.gcr.io/cluster-api/cluster-api-controller:v0.4.4"]),
              "imagePullPolicy": "IfNotPresent",
              "livenessProbe": {
                "httpGet": {
                  "path": "/healthz",
                  "port": "healthz"
                }
              },
              "name": "manager",
              "ports": [
                {
                  "containerPort": 9443,
                  "name": "webhook-server",
                  "protocol": "TCP"
                },
                {
                  "containerPort": 9440,
                  "name": "healthz",
                  "protocol": "TCP"
                }
              ],
              "readinessProbe": {
                "httpGet": {
                  "path": "/readyz",
                  "port": "healthz"
                }
              },
              "volumeMounts": [
                {
                  "mountPath": "/tmp/k8s-webhook-server/serving-certs",
                  "name": "cert",
                  "readOnly": true
                },
                {
                  "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                  "name": "capi-manager-token",
                  "readOnly": true
                },
              ]
            }
          ],
          "serviceAccountName": "capi-manager",
          "terminationGracePeriodSeconds": 10,
          "tolerations": [
            {
              "effect": "NoSchedule",
              "key": "node-role.kubernetes.io/master"
            }
          ],
          "volumes": [
            {
              "name": "cert",
              "secret": {
                "secretName": "capi-webhook-service-cert"
              }
            },
            {
              "name": "capi-manager-token",
              "secret": {
                "defaultMode": 420,
                "secretName": "capi-manager-token"
              }
            },
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
        "cluster.x-k8s.io/provider": "bootstrap-kubeadm",
        "control-plane": "controller-manager"
      },
      "name": "capi-kubeadm-bootstrap-controller-manager",
      "namespace": "capi-kubeadm-bootstrap-system"
    },
    "spec": {
      "replicas": 1,
      "selector": {
        "matchLabels": {
          "cluster.x-k8s.io/provider": "bootstrap-kubeadm",
          "control-plane": "controller-manager"
        }
      },
      "template": {
        "metadata": {
          "labels": {
            "cluster.x-k8s.io/provider": "bootstrap-kubeadm",
            "control-plane": "controller-manager"
          }
        },
        "spec": {
          "containers": [
            {
              "args": [
                "--leader-elect",
                "--metrics-bind-addr=localhost:8080",
                "--feature-gates=MachinePool=${EXP_MACHINE_POOL:=false}"
              ],
              "command": [
                "/manager"
              ],
              "image": std.join("", [target_registry, "k8s.gcr.io/cluster-api/kubeadm-bootstrap-controller:v0.4.4"]),
              "imagePullPolicy": "IfNotPresent",
              "livenessProbe": {
                "httpGet": {
                  "path": "/healthz",
                  "port": "healthz"
                }
              },
              "name": "manager",
              "ports": [
                {
                  "containerPort": 9443,
                  "name": "webhook-server",
                  "protocol": "TCP"
                },
                {
                  "containerPort": 9440,
                  "name": "healthz",
                  "protocol": "TCP"
                }
              ],
              "readinessProbe": {
                "httpGet": {
                  "path": "/readyz",
                  "port": "healthz"
                }
              },
              "volumeMounts": [
                {
                  "mountPath": "/tmp/k8s-webhook-server/serving-certs",
                  "name": "cert",
                  "readOnly": true
                },
                {
                  "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                  "name": "capi-kubeadm-bootstrap-manager-token",
                  "readOnly": true
                }
              ]
            }
          ],
          "serviceAccountName": "capi-kubeadm-bootstrap-manager",
          "terminationGracePeriodSeconds": 10,
          "tolerations": [
            {
              "effect": "NoSchedule",
              "key": "node-role.kubernetes.io/master"
            }
          ],
          "volumes": [
            {
              "name": "cert",
              "secret": {
                "secretName": "capi-kubeadm-bootstrap-webhook-service-cert"
              }
            },
            {
              "name": "capi-kubeadm-bootstrap-manager-token",
              "secret": {
                "defaultMode": 420,
                "secretName": "capi-kubeadm-bootstrap-manager-token"
              }
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
        "cluster.x-k8s.io/provider": "control-plane-kubeadm",
        "control-plane": "controller-manager"
      },
      "name": "capi-kubeadm-control-plane-controller-manager",
      "namespace": "capi-kubeadm-control-plane-system"
    },
    "spec": {
      "replicas": 1,
      "selector": {
        "matchLabels": {
          "cluster.x-k8s.io/provider": "control-plane-kubeadm",
          "control-plane": "controller-manager"
        }
      },
      "template": {
        "metadata": {
          "labels": {
            "cluster.x-k8s.io/provider": "control-plane-kubeadm",
            "control-plane": "controller-manager"
          }
        },
        "spec": {
          "containers": [
            {
              "args": [
                "--leader-elect",
                "--metrics-bind-addr=localhost:8080",
                "--feature-gates=ClusterTopology=${CLUSTER_TOPOLOGY:=false}"
              ],
              "command": [
                "/manager"
              ],
              "image": std.join("", [target_registry, "k8s.gcr.io/cluster-api/kubeadm-control-plane-controller:v0.4.4"]),
              "imagePullPolicy": "IfNotPresent",
              "livenessProbe": {
                "httpGet": {
                  "path": "/healthz",
                  "port": "healthz"
                }
              },
              "name": "manager",
              "ports": [
                {
                  "containerPort": 9443,
                  "name": "webhook-server",
                  "protocol": "TCP"
                },
                {
                  "containerPort": 9440,
                  "name": "healthz",
                  "protocol": "TCP"
                }
              ],
              "readinessProbe": {
                "httpGet": {
                  "path": "/readyz",
                  "port": "healthz"
                }
              },
              "volumeMounts": [
                {
                  "mountPath": "/tmp/k8s-webhook-server/serving-certs",
                  "name": "cert",
                  "readOnly": true
                },
                {
                  "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                  "name": "capi-kubeadm-control-plane-manager-token",
                  "readOnly": true
                }
              ]
            }
          ],
          "serviceAccountName": "capi-kubeadm-control-plane-manager",
          "terminationGracePeriodSeconds": 10,
          "tolerations": [
            {
              "effect": "NoSchedule",
              "key": "node-role.kubernetes.io/master"
            }
          ],
          "volumes": [
            {
              "name": "cert",
              "secret": {
                "secretName": "capi-kubeadm-control-plane-webhook-service-cert"
              }
            },
            {
              "name": "capi-kubeadm-control-plane-manager-token",
              "secret": {
                "defaultMode": 420,
                "secretName": "capi-kubeadm-control-plane-manager-token"
              }
            }
          ]
        }
      }
    }
  }
]