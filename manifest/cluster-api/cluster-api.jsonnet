function (
  is_offline="false",
  private_registry="172.22.6.2:5000",
  time_zone="UTC"
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
                "--secure-listen-address=0.0.0.0:8443",
                "--upstream=http://127.0.0.1:8080/",
                "--logtostderr=true",
                "--v=10"
              ],
              "image": std.join("", [target_registry, "gcr.io/kubebuilder/kube-rbac-proxy:v0.4.1"]),
              "name": "kube-rbac-proxy",
              "ports": [
                {
                  "containerPort": 8443,
                  "name": "https"
                }
              ],
              "volumeMounts": [
                {
                  "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                  "name": "capi-controller-manager-token",
                  "readOnly": true
                }
              ]
            },
            {
              "args": [
                "--metrics-addr=127.0.0.1:8080",
                "--enable-leader-election",
                "--feature-gates=MachinePool=true,ClusterResourceSet=true"
              ],
              "command": [
                "/manager"
              ],
              "image": std.join("", [target_registry, "us.gcr.io/k8s-artifacts-prod/cluster-api/cluster-api-controller:v0.3.16"]),
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
                  "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                  "name": "capi-controller-manager-token",
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
          "serviceAccountName": "capi-controller-manager",
          "terminationGracePeriodSeconds": 10,
          "tolerations": [
            {
              "effect": "NoSchedule",
              "key": "node-role.kubernetes.io/master"
            }
          ],
          "volumes": [
            {
              "name": "capi-controller-manager-token",
              "secret": {
                "defaultMode": 420,
                "secretName": "capi-controller-manager-token"
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
          )
        }
      }
    }
  },
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "labels": {
        "cluster.x-k8s.io/provider": "cluster-api",
        "control-plane": "controller-manager"
      },
      "name": "capi-controller-manager",
      "namespace": "capi-webhook-system"
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
            "--secure-listen-address=0.0.0.0:8443",
            "--upstream=http://127.0.0.1:8080/",
            "--logtostderr=true",
            "--v=10"
            ],
            "image": std.join("", [target_registry, "gcr.io/kubebuilder/kube-rbac-proxy:v0.4.1"]),
            "name": "kube-rbac-proxy",
            "ports": [
            {
              "containerPort": 8443,
              "name": "https"
            }
            ],
            "volumeMounts": [
            {
              "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
              "name": "capi-controller-manager-token",
              "readOnly": true
            }
            ]
          },
          {
            "args": [
              "--metrics-addr=127.0.0.1:8080",
              "--webhook-port=9443",
              "--feature-gates=MachinePool=true,ClusterResourceSet=true"
            ],
            "command": [
              "/manager"
            ],
            "image": std.join("", [target_registry, "us.gcr.io/k8s-artifacts-prod/cluster-api/cluster-api-controller:v0.3.16"]),
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
                "name": "capi-controller-manager-token",
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
          "serviceAccountName": "capi-controller-manager",
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
              "defaultMode": 420,
                "secretName": "capi-webhook-service-cert"
              }
            },
            {
              "name": "capi-controller-manager-token",
              "secret": {
                "defaultMode": 420,
                "secretName": "capi-controller-manager-token"
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
          )
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
                "--secure-listen-address=0.0.0.0:8443",
                "--upstream=http://127.0.0.1:8080/",
                "--logtostderr=true",
                "--v=10"
              ],
              "image": std.join("", [target_registry, "gcr.io/kubebuilder/kube-rbac-proxy:v0.4.1"]),
              "name": "kube-rbac-proxy",
              "ports": [
                {
                  "containerPort": 8443,
                  "name": "https"
                }
              ],
              "volumeMounts": [
                {
                  "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                  "name": "capi-kubeadm-bootstrap-controller-manager-token",
                  "readOnly": true
                }
              ]
            },
            {
              "args": [
                "--metrics-addr=127.0.0.1:8080",
                "--enable-leader-election",
                "--feature-gates=MachinePool=true"
              ],
              "command": [
                "/manager"
              ],
              "image": std.join("", [target_registry, "us.gcr.io/k8s-artifacts-prod/cluster-api/kubeadm-bootstrap-controller:v0.3.16"]),
              "imagePullPolicy": "IfNotPresent",
              "name": "manager",
              "volumeMounts": [
                {
                  "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                  "name": "capi-kubeadm-bootstrap-controller-manager-token",
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
          "serviceAccountName": "capi-kubeadm-bootstrap-controller-manager",
          "terminationGracePeriodSeconds": 10,
          "tolerations": [
            {
              "effect": "NoSchedule",
              "key": "node-role.kubernetes.io/master"
            }
          ],
          "volumes": [
            {
              "name": "capi-kubeadm-bootstrap-controller-manager-token",
              "secret": {
                "defaultMode": 420,
                "secretName": "capi-kubeadm-bootstrap-controller-manager-token"
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
          )
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
      "namespace": "capi-webhook-system"
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
                "--secure-listen-address=0.0.0.0:8443",
                "--upstream=http://127.0.0.1:8080/",
                "--logtostderr=true",
                "--v=10"
              ],
              "image": std.join("", [target_registry, "gcr.io/kubebuilder/kube-rbac-proxy:v0.4.1"]),
              "name": "kube-rbac-proxy",
              "ports": [
                {
                  "containerPort": 8443,
                  "name": "https"
                }
              ],
              "volumeMounts": [
                {
                  "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                  "name": "capi-kubeadm-bootstrap-controller-manager-token",
                  "readOnly": true
                }
              ]
            },
            {
              "args": [
                "--metrics-addr=127.0.0.1:8080",
                "--webhook-port=9443",
                "--feature-gates=MachinePool=true"
              ],
              "command": [
                "/manager"
              ],
              "image": std.join("", [target_registry, "us.gcr.io/k8s-artifacts-prod/cluster-api/kubeadm-bootstrap-controller:v0.3.16"]),
              "imagePullPolicy": "IfNotPresent",
              "name": "manager",
              "ports": [
                {
                  "containerPort": 9443,
                  "name": "webhook-server",
                  "protocol": "TCP"
                }
              ],
              "volumeMounts": [
                {
                  "mountPath": "/tmp/k8s-webhook-server/serving-certs",
                  "name": "cert",
                  "readOnly": true
                },
                {
                  "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                  "name": "capi-kubeadm-bootstrap-controller-manager-token",
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
          "serviceAccountName": "capi-kubeadm-bootstrap-controller-manager",
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
                "defaultMode": 420,
                "secretName": "capi-kubeadm-bootstrap-webhook-service-cert"
              }
            },
            {
              "name": "capi-kubeadm-bootstrap-controller-manager-token",
              "secret": {
                "defaultMode": 420,
                "secretName": "capi-kubeadm-bootstrap-controller-manager-token"
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
          )
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
              "--secure-listen-address=0.0.0.0:8443",
              "--upstream=http://127.0.0.1:8080/",
              "--logtostderr=true",
              "--v=10"
            ],
            "image": std.join("", [target_registry, "gcr.io/kubebuilder/kube-rbac-proxy:v0.4.1"]),
            "name": "kube-rbac-proxy",
            "ports": [
              {
                "containerPort": 8443,
                "name": "https"
              }
            ],
            "volumeMounts": [
              {
                "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                "name": "capi-kubeadm-control-plane-controller-manager-token",
                "readOnly": true
              }
            ]
          },
          {
            "args": [
              "--metrics-addr=127.0.0.1:8080",
              "--enable-leader-election"
            ],
            "command": [
              "/manager"
            ],
            "image": std.join("", [target_registry, "us.gcr.io/k8s-artifacts-prod/cluster-api/kubeadm-control-plane-controller:v0.3.16"]),
            "imagePullPolicy": "IfNotPresent",
            "name": "manager",
            "volumeMounts": [
              {
                "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                "name": "capi-kubeadm-control-plane-controller-manager-token",
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
          "serviceAccountName": "capi-kubeadm-control-plane-controller-manager",
          "terminationGracePeriodSeconds": 10,
          "tolerations": [
            {
              "effect": "NoSchedule",
              "key": "node-role.kubernetes.io/master"
            }
          ],
          "volumes": [
            {
              "name": "capi-kubeadm-control-plane-controller-manager-token",
              "secret": {
                "defaultMode": 420,
                "secretName": "capi-kubeadm-control-plane-controller-manager-token"
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
          )
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
      "namespace": "capi-webhook-system"
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
                "--secure-listen-address=0.0.0.0:8443",
                "--upstream=http://127.0.0.1:8080/",
                "--logtostderr=true",
                "--v=10"
              ],
              "image": std.join("", [target_registry, "gcr.io/kubebuilder/kube-rbac-proxy:v0.4.1"]),
              "name": "kube-rbac-proxy",
              "ports": [
                {
                  "containerPort": 8443,
                  "name": "https"
                }
              ],
              "volumeMounts": [
                {
                  "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                  "name": "capi-kubeadm-control-plane-controller-manager-token",
                  "readOnly": true
                }
              ]
            },
            {
              "args": [
                "--metrics-addr=127.0.0.1:8080",
                "--webhook-port=9443"
              ],
              "command": [
                "/manager"
              ],
              "image": std.join("", [target_registry, "us.gcr.io/k8s-artifacts-prod/cluster-api/kubeadm-control-plane-controller:v0.3.16"]),
              "imagePullPolicy": "IfNotPresent",
              "name": "manager",
              "ports": [
                {
                  "containerPort": 9443,
                  "name": "webhook-server",
                  "protocol": "TCP"
                }
              ],
              "volumeMounts": [
                {
                  "mountPath": "/tmp/k8s-webhook-server/serving-certs",
                  "name": "cert",
                  "readOnly": true
                },
                {
                  "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                  "name": "capi-kubeadm-control-plane-controller-manager-token",
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
          "serviceAccountName": "capi-kubeadm-control-plane-controller-manager",
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
                "defaultMode": 420,
                "secretName": "capi-kubeadm-control-plane-webhook-service-cert"
              }
            },
            {
              "name": "capi-kubeadm-control-plane-controller-manager-token",
              "secret": {
                "defaultMode": 420,
                "secretName": "capi-kubeadm-control-plane-controller-manager-token"
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
          )
        }
      }
    }
  }
]