function (
  is_offline="false",
  private_registry="172.22.6.2:5000",
  username="username",
  password="password",
  time_zone="UTC"
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";

[
  {
    "apiVersion": "v1",
    "kind": "Secret",
    "metadata": {
      "labels": [
        {
          "cluster.x-k8s.io/provider": "infrastructure-vsphere",
        },
      ],
      "name": "capv-manager-bootstrap-credentials",
      "namespace": "capv-system",
    },
    "stringData": {
      "credentials.yaml": std.join("", ["username: ", username, "\npassword: ", password]),
    },
    "type": "Opaque",
  },
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "labels": {
        "cluster.x-k8s.io/provider": "infrastructure-vsphere",
        "control-plane": "controller-manager"
      },
      "name": "capv-controller-manager",
      "namespace": "capi-webhook-system"
    },
    "spec": {
      "replicas": 1,
      "selector": {
          "matchLabels": {
              "cluster.x-k8s.io/provider": "infrastructure-vsphere",
              "control-plane": "controller-manager"
          }
      },
      "template": {
        "metadata": {
          "labels": {
            "cluster.x-k8s.io/provider": "infrastructure-vsphere",
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
              "image": std.join("", [target_registry, "gcr.io/kubebuilder/kube-rbac-proxy:v0.8.0"]),
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
                  "name": "capv-controller-manager-token",
                  "readOnly": true
                }
              ]
            },
            {
              "args": [
                "--metrics-addr=127.0.0.1:8080",
                "--webhook-port=9443",
                "--enable-leader-election=false"
              ],
              "image": std.join("", [target_registry, "gcr.io/cluster-api-provider-vsphere/release/manager:v0.7.6"]),
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
                  "name": "capv-controller-manager-token",
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
          "serviceAccountName": "capv-controller-manager",
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
                "secretName": "capv-webhook-service-cert"
              }
            },
            {
              "name": "capv-controller-manager-token",
              "secret": {
                "defaultMode": 420,
                "secretName": "capv-controller-manager-token"
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
        "cluster.x-k8s.io/provider": "infrastructure-vsphere",
        "control-plane": "controller-manager"
      },
      "name": "capv-controller-manager",
      "namespace": "capv-system"
    },
    "spec": {
      "replicas": 1,
      "selector": {
        "matchLabels": {
          "cluster.x-k8s.io/provider": "infrastructure-vsphere",
          "control-plane": "controller-manager"
        }
      },
      "template": {
        "metadata": {
          "labels": {
            "cluster.x-k8s.io/provider": "infrastructure-vsphere",
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
              "image": std.join("", [target_registry, "gcr.io/kubebuilder/kube-rbac-proxy:v0.8.0"]),
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
                  "name": "capv-controller-manager-token",
                  "readOnly": true
                }
              ]
            },
            {
              "args": [
                "--metrics-addr=127.0.0.1:8080"
              ],
              "image": std.join("", [target_registry, "gcr.io/cluster-api-provider-vsphere/release/manager:v0.7.6"]),
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
                  "mountPath": "/etc/capv",
                  "name": "manager-bootstrap-credentials",
                  "readOnly": true
                },
                {
                  "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                  "name": "capv-controller-manager-token",
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
          "serviceAccountName": "capv-controller-manager",
          "terminationGracePeriodSeconds": 10,
          "tolerations": [
            {
              "effect": "NoSchedule",
              "key": "node-role.kubernetes.io/master"
            }
          ],
          "volumes": [
            {
              "name": "manager-bootstrap-credentials",
              "secret": {
                "secretName": "capv-manager-bootstrap-credentials"
              }
            },
            {
              "name": "capv-controller-manager-token",
              "secret": {
                "defaultMode": 420,
                "secretName": "capv-controller-manager-token"
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