function (
  is_offline = "false",
  private_registry = "registry.tmaxcloud.org",
  ingress_nginx_http_port = "30080",
  ingress_nginx_https_port = "30443",
  controller_version="v1.5.1",
  certgen_version="v20220916-gd32f8c343",
  service_type = "LoadBalancer",
  timezone="UTC",
  log_level="info"

)

local target_registry = if is_offline == "false" then "" else private_registry + "/";

[
  {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
      "labels": {
        "app.kubernetes.io/component": "controller",
        "app.kubernetes.io/instance": "ingress-nginx-system",
        "app.kubernetes.io/name": "ingress-nginx-system",
        "app.kubernetes.io/part-of": "ingress-nginx-system"
      },
      "name": "ingress-nginx-system-controller",
      "namespace": "ingress-nginx-system"
    },
    "spec": {
      "externalTrafficPolicy": "Local",
      "ipFamilies": [
        "IPv4"
      ],
      "ipFamilyPolicy": "SingleStack",
      "ports": [
        {
          "appProtocol": "http",
          "name": "http",
          "port": 80,
          "protocol": "TCP",
          "targetPort": "http",
          "nodePort": std.parseInt(ingress_nginx_http_port)
        },
        {
          "appProtocol": "https",
          "name": "https",
          "port": 443,
          "protocol": "TCP",
          "targetPort": "https",
          "nodePort": std.parseInt(ingress_nginx_https_port)
        },
        {
          "name": "kafka-1",
          "port": 9001,
          "protocol": "TCP"
        },
        {
          "name": "kafka-2",
          "port": 9002,
          "protocol": "TCP"
        },
        {
          "name": "kafka-3",
          "port": 9003,
          "protocol": "TCP"
        }
      ],
      "selector": {
        "app.kubernetes.io/component": "controller",
        "app.kubernetes.io/instance": "ingress-nginx-system",
        "app.kubernetes.io/name": "ingress-nginx-system"
      },
      "type": service_type
    }
  },
  {
    "apiVersion": "v1",
    "kind": "ConfigMap",
    "metadata": {
      "labels": {
        "app.kubernetes.io/component": "controller",
        "app.kubernetes.io/instance": "ingress-nginx-system",
        "app.kubernetes.io/name": "ingress-nginx-system",
        "app.kubernetes.io/part-of": "ingress-nginx-system"
      },
      "name": "ingress-nginx-system-controller",
      "namespace": "ingress-nginx-system"
    },
    "data": {
      "allow-snippet-annotations": "true",
      "error-log-level": log_level
    }
  },
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "labels": {
        "app.kubernetes.io/component": "controller",
        "app.kubernetes.io/instance": "ingress-nginx-system",
        "app.kubernetes.io/name": "ingress-nginx-system",
        "app.kubernetes.io/part-of": "ingress-nginx-system"
      },
      "name": "ingress-nginx-system-controller",
      "namespace": "ingress-nginx-system"
    },
    "spec": {
      "minReadySeconds": 0,
      "revisionHistoryLimit": 10,
      "selector": {
        "matchLabels": {
          "app.kubernetes.io/component": "controller",
          "app.kubernetes.io/instance": "ingress-nginx-system",
          "app.kubernetes.io/name": "ingress-nginx-system"
        }
      },
      "template": {
        "metadata": {
          "labels": {
            "app.kubernetes.io/component": "controller",
            "app.kubernetes.io/instance": "ingress-nginx-system",
            "app.kubernetes.io/name": "ingress-nginx-system"
          }
        },
        "spec": {
          "containers": [
            {
              "args": [
                "/nginx-ingress-controller",
                "--publish-service=ingress-nginx-system/ingress-nginx-system-controller",
                "--election-id=ingress-nginx-system-leader",
                "--controller-class=k8s.io/ingress-nginx-system",
                "--ingress-class=nginx-system",
                "--configmap=ingress-nginx-system/ingress-nginx-system-controller",
                "--validating-webhook=:8443",
                "--validating-webhook-certificate=/usr/local/certificates/cert",
                "--validating-webhook-key=/usr/local/certificates/key",
                "--default-ssl-certificate=ingress-nginx-system/ingress-tls"
              ],
              "env": [
                {
                  "name": "POD_NAME",
                  "valueFrom": {
                    "fieldRef": {
                      "fieldPath": "metadata.name"
                    }
                  }
                },
                {
                  "name": "POD_NAMESPACE",
                  "valueFrom": {
                    "fieldRef": {
                      "fieldPath": "metadata.namespace"
                    }
                  }
                },
                {
                  "name": "LD_PRELOAD",
                  "value": "/usr/local/lib/libmimalloc.so"
                }
              ],
              "image": std.join("", [target_registry, "registry.k8s.io/ingress-nginx/controller:", controller_version]),
              "imagePullPolicy": "IfNotPresent",
              "lifecycle": {
                "preStop": {
                  "exec": {
                    "command": [
                      "/wait-shutdown"
                    ]
                  }
                }
              },
              "livenessProbe": {
                "failureThreshold": 5,
                "httpGet": {
                  "path": "/healthz",
                  "port": 10254,
                  "scheme": "HTTP"
                },
                "initialDelaySeconds": 10,
                "periodSeconds": 10,
                "successThreshold": 1,
                "timeoutSeconds": 1
              },
              "name": "controller",
              "ports": [
                {
                  "containerPort": 80,
                  "name": "http",
                  "protocol": "TCP"
                },
                {
                  "containerPort": 443,
                  "name": "https",
                  "protocol": "TCP"
                },
                {
                  "containerPort": 8443,
                  "name": "webhook",
                  "protocol": "TCP"
                }
              ],
              "readinessProbe": {
                "failureThreshold": 3,
                "httpGet": {
                  "path": "/healthz",
                  "port": 10254,
                  "scheme": "HTTP"
                },
                "initialDelaySeconds": 10,
                "periodSeconds": 10,
                "successThreshold": 1,
                "timeoutSeconds": 1
              },
              "resources": {
                "requests": {
                  "cpu": "100m",
                  "memory": "90Mi"
                },
                "limits": {
                  "cpu": "200m",
                  "memory": "180Mi"
                }
              },
              "securityContext": {
                "allowPrivilegeEscalation": true,
                "capabilities": {
                  "add": [
                    "NET_BIND_SERVICE"
                  ],
                  "drop": [
                    "ALL"
                  ]
                },
                "runAsUser": 101
              },
              "volumeMounts": [
                {
                  "mountPath": "/usr/local/certificates/",
                  "name": "webhook-cert",
                  "readOnly": true
                }
              ] + if timezone != "UTC" then [
                {
                  "name": "timezone-config",
                  "mountPath": "/etc/localtime"
                }
              ] else []
            }
          ],
          "dnsPolicy": "ClusterFirst",
          "nodeSelector": {
            "kubernetes.io/os": "linux"
          },
          "serviceAccountName": "ingress-nginx-system",
          "terminationGracePeriodSeconds": 300,
          "volumes": [
            {
              "name": "webhook-cert",
              "secret": {
                "secretName": "ingress-nginx-system-admission"
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