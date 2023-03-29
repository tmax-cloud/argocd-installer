function (    
    is_offline="false",
    private_registry="172.22.6.2:5000",    
    custom_domain_name="tmaxcloud.org",    
    tmax_client_secret="tmax_client_secret",
    hyperauth_url="172.23.4.105",
    hyperauth_realm="tmax",
    console_subdomain="console",    
    gatekeeper_log_level="info",    
    gatekeeper_version="v1.0.2",
    log_level="info",
    time_zone="UTC"
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";
[
    {
        "apiVersion": "apps/v1",
        "kind": "Deployment",
        "metadata": {
            "labels": {
            "control-plane": "kubeflow-training-operator"
            },
            "name": "training-operator",
            "namespace": "kubeflow"
        },
        "spec": {
            "replicas": 1,
            "selector": {
            "matchLabels": {
                "control-plane": "kubeflow-training-operator"
            }
            },
            "template": {
            "metadata": {
                "annotations": {
                "sidecar.istio.io/inject": "false"
                },
                "labels": {
                "control-plane": "kubeflow-training-operator"
                }
            },
            "spec": {
                "containers": [
                {
                    "command": [
                    "/manager"
                    ],
                    "args": [
                      std.join("", ["--zap-log-level=", log_level])
                    ],
                    "env": [
                    {
                        "name": "MY_POD_NAMESPACE",
                        "valueFrom": {
                        "fieldRef": {
                            "fieldPath": "metadata.namespace"
                        }
                        }
                    },
                    {
                        "name": "MY_POD_NAME",
                        "valueFrom": {
                        "fieldRef": {
                            "fieldPath": "metadata.name"
                        }
                        }
                    }
                    ],
                    "image": std.join("", [target_registry, "docker.io/tmaxcloudck/training-operator:v1.5-lls"]),
                    "livenessProbe": {
                    "httpGet": {
                        "path": "/healthz",
                        "port": 8081
                    },
                    "initialDelaySeconds": 15,
                    "periodSeconds": 20,
                    "timeoutSeconds": 3
                    },
                    "name": "training-operator",
                    "ports": [
                    {
                        "containerPort": 8080
                    }
                    ],
                    "readinessProbe": {
                    "httpGet": {
                        "path": "/readyz",
                        "port": 8081
                    },
                    "initialDelaySeconds": 10,
                    "periodSeconds": 15,
                    "timeoutSeconds": 3
                    },
                    "resources": {
                    "limits": {
                        "cpu": "100m",
                        "memory": "300Mi"
                    },
                    "requests": {
                        "cpu": "100m",
                        "memory": "200Mi"
                    }
                    },
                    "securityContext": {
                    "allowPrivilegeEscalation": false
                    },
                    "volumeMounts": [
                    {
                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                        "name": "training-operator-token",
                        "readOnly": true
                    }
                    ] + (
                    if time_zone != "UTC" then [
                    {
                        "name": "timezone-config",
                        "mountPath": "/etc/localtime"
                    },
                    ] else []
                )
                }
                ],
                "terminationGracePeriodSeconds": 10,
                "volumes": [
                {
                    "name": "training-operator-token",
                    "secret": {
                    "defaultMode": 420,
                    "secretName": "training-operator-token"
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