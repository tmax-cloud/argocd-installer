function (
  is_offline="false",
  private_registry="172.22.6.2:5000",
  credentials="VGhpcyBpcyBhbiBhd3MgY3JlZGVudGlhbAo=",
  time_zone="UTC"
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";

[
  {
    "apiVersion": "v1",
    "data": {
      "credentials": credentials,
    },
    "kind": "Secret",
    "metadata": {
      "labels": [
        {
          "cluster.x-k8s.io/provider": "infrastructure-aws",
        },
      ],
      "name": "capa-manager-bootstrap-credentials",
      "namespace" : "capa-system",
    },
    "type": "Opaque",
  },
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "labels": {
        "cluster.x-k8s.io/provider": "infrastructure-aws",
        "control-plane": "capa-controller-manager"
      },
      "name": "capa-controller-manager",
      "namespace": "capa-system"
    },
    "spec": {
      "replicas": 1,
      "selector": {
        "matchLabels": {
          "cluster.x-k8s.io/provider": "infrastructure-aws",
          "control-plane": "capa-controller-manager"
        }
      },
      "template": {
        "metadata": {
          "labels": {
            "cluster.x-k8s.io/provider": "infrastructure-aws",
            "control-plane": "capa-controller-manager"
          }
        },
        "spec": {
          "containers": [
            {
              "args": [
                "--metrics-addr=127.0.0.1:8080",
                "--enable-leader-election",
                "--feature-gates=EKS=false,EKSEnableIAM=false,MachinePool=false,EventBridgeInstanceState=false,AutoControllerIdentityCreator=true"
              ],
              "env": [
                {
                  "name": "AWS_SHARED_CREDENTIALS_FILE",
                  "value": "/home/.aws/credentials"
                }
              ],
              "image": std.join("", [target_registry, "gcr.io/k8s-staging-cluster-api-aws/cluster-api-aws-controller:v0.6.5"]),
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
                  "mountPath": "/home/.aws",
                  "name": "credentials"
                },
                {
                  "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                  "name": "capa-controller-manager-token",
                  "readOnly": true
                }
              ]
            },
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
                  "name": "capa-controller-manager-token",
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
          "securityContext": {
            "fsGroup": 1000
          },
          "serviceAccountName": "capa-controller-manager",
          "terminationGracePeriodSeconds": 10,
          "tolerations": [
            {
              "effect": "NoSchedule",
              "key": "node-role.kubernetes.io/master"
            }
          ],
          "volumes": [
            {
              "name": "credentials",
              "secret": {
                "secretName": "capa-manager-bootstrap-credentials"
              }
            },
            {
              "name": "capa-controller-manager-token",
              "secret": {
                "defaultMode": 420,
                "secretName": "capa-controller-manager-token"
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
        "cluster.x-k8s.io/provider": "infrastructure-aws",
        "control-plane": "capa-controller-manager"
      },
      "name": "capa-controller-manager",
      "namespace": "capi-webhook-system"
    },
    "spec": {
      "replicas": 1,
      "selector": {
        "matchLabels": {
          "cluster.x-k8s.io/provider": "infrastructure-aws",
          "control-plane": "capa-controller-manager"
        }
      },
      "template": {
        "metadata": {
          "labels": {
            "cluster.x-k8s.io/provider": "infrastructure-aws",
            "control-plane": "capa-controller-manager"
          }
        },
        "spec": {
          "containers": [
            {
              "args": [
                "--metrics-addr=127.0.0.1:8080",
                "--webhook-port=9443",
                "--feature-gates=EKS=false,EKSEnableIAM=false,MachinePool=false,EventBridgeInstanceState=false,AutoControllerIdentityCreator=true"
              ],
              "image": std.join("", [target_registry, "gcr.io/k8s-staging-cluster-api-aws/cluster-api-aws-controller:v0.6.5"]),
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
                  "name": "capa-controller-manager-token",
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
            },
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
                  "name": "capa-controller-manager-token",
                  "readOnly": true
                }
              ]
            }
          ],
          "serviceAccountName": "capa-controller-manager",
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
                "secretName": "capa-webhook-service-cert"
              }
            },
            {
              "name": "capa-controller-manager-token",
              "secret": {
                "defaultMode": 420,
                "secretName": "capa-controller-manager-token"
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