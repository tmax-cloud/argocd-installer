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
local serverstransport = "insecure@file";
[
    {
        "apiVersion": "v1",
        "data": {
            "CLIENT_SECRET": tmax_client_secret,
            "DISCOVERY_URL": std.join("", ["https://", hyperauth_url, "/auth/realms/", hyperauth_realm]),
            "CUSTOM_DOMAIN": custom_domain_name,
            "GATEKEEPER_VERSION": gatekeeper_version,
            "LOG_LEVEL": gatekeeper_log_level,
            "IS_CLOSED": is_offline,
            "REGISTRY_NAME": target_registry,
            "SERVERSTRANSPORT": serverstransport
        },
        "kind": "ConfigMap",
        "metadata": {
            "labels": {
            "app": "notebook-controller",
            "app.kubernetes.io/component": "notebook-controller",
            "app.kubernetes.io/name": "notebook-controller",
            "kustomize.component": "notebook-controller"
            },
            "name": "notebook-controller-config",
            "namespace": "kubeflow"
        }
    },
    {
        "apiVersion": "apps/v1",
        "kind": "Deployment",
        "metadata": {
            "labels": {
            "app": "notebook-controller",
            "app.kubernetes.io/component": "notebook-controller",
            "app.kubernetes.io/name": "notebook-controller",
            "kustomize.component": "notebook-controller",
            "name": "notebook-controller-deployment",
            "notebook": "controller"
            },
            "name": "notebook-controller-deployment",
            "namespace": "kubeflow"
        },
        "spec": {
            "replicas": 1,
            "selector": {
            "matchLabels": {
                "app": "notebook-controller",
                "app.kubernetes.io/component": "notebook-controller",
                "app.kubernetes.io/name": "notebook-controller",
                "kustomize.component": "notebook-controller",
                "notebook": "controller"
            }
            },
            "strategy": {
            "type": "Recreate"
            },
            "template": {
            "metadata": {
                "labels": {
                "app": "notebook-controller",
                "app.kubernetes.io/component": "notebook-controller",
                "app.kubernetes.io/name": "notebook-controller",
                "kustomize.component": "notebook-controller",
                "notebook": "controller"
                },
                "name": "notebook-controller"
            },
            "spec": {
                "containers": [
                {
                    "args": [
                        std.join("", ["--zap-log-level=", log_level])
                    ],
                    "env": [
                    {
                        "name": "CLIENT_SECRET",
                        "valueFrom": {
                        "configMapKeyRef": {
                            "key": "CLIENT_SECRET",
                            "name": "notebook-controller-config"
                        }
                        }
                    },
                    {
                        "name": "DISCOVERY_URL",
                        "valueFrom": {
                        "configMapKeyRef": {
                            "key": "DISCOVERY_URL",
                            "name": "notebook-controller-config"
                        }
                        }
                    },
                    {
                        "name": "CUSTOM_DOMAIN",
                        "valueFrom": {
                        "configMapKeyRef": {
                            "key": "CUSTOM_DOMAIN",
                            "name": "notebook-controller-config"
                        }
                        }
                    },
                    {
                        "name": "GATEKEEPER_VERSION",
                        "valueFrom": {
                        "configMapKeyRef": {
                            "key": "GATEKEEPER_VERSION",
                            "name": "notebook-controller-config"
                        }
                        }
                    },
                    {
                        "name": "LOG_LEVEL",
                        "valueFrom": {
                        "configMapKeyRef": {
                            "key": "LOG_LEVEL",
                            "name": "notebook-controller-config"
                        }
                        }
                    },
                    {
                        "name": "IS_CLOSED",
                        "valueFrom": {
                        "configMapKeyRef": {
                            "key": "IS_CLOSED",
                            "name": "notebook-controller-config"
                        }
                        }
                    },
                    {
                        "name": "REGISTRY_NAME",
                        "valueFrom": {
                        "configMapKeyRef": {
                            "key": "REGISTRY_NAME",
                            "name": "notebook-controller-config"
                        }
                        }
                    },
                    {
                        "name": "SERVERSTRANSPORT",
                        "valueFrom": {
                        "configMapKeyRef": {
                            "key": "SERVERSTRANSPORT",
                            "name": "notebook-controller-config"
                        }
                        }
                    }
                    ],
                    "image": std.join("", [target_registry, "docker.io/tmaxcloudck/notebook-controller-go:b0.2.10"]),
                    "imagePullPolicy": "Always",
                    "name": "notebook-controller",
                    "resources": {
                        "limits": {
                            "cpu": "1",
                            "memory": "3Gi"
                        },
                        "requests": {
                            "cpu": "20m",
                            "memory": "300Mi"
                        }
                    },
                    "volumeMounts": [
                    {
                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                        "name": "notebook-controller-service-account-token",
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
                "volumes": [
                {
                    "name": "notebook-controller-service-account-token",
                    "secret": {
                    "defaultMode": 420,
                    "secretName": "notebook-controller-service-account-token"
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