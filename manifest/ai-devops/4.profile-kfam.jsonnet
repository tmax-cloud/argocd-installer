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
local kfam_log_level = if log_level == "error" then "ERROR" else if log_level == "debug" then "DEBUG" else if log_level == "fatal" then "FATAL" else "INFO";
[
    {
        "apiVersion": "apps/v1",
        "kind": "Deployment",
        "metadata": {
            "labels": {
            "kustomize.component": "profiles"
            },
            "name": "profiles-deployment",
            "namespace": "kubeflow"
        },
        "spec": {
            "replicas": 1,
            "selector": {
            "matchLabels": {
                "kustomize.component": "profiles"
            }
            },
            "template": {
            "metadata": {
                "annotations": {
                "sidecar.istio.io/inject": "true"
                },
                "labels": {
                "kustomize.component": "profiles"
                }
            },
            "spec": {
                "containers": [
                {
                    "command": [
                    "/access-management",
                    std.join("", ["-log-level=", kfam_log_level]),
                    "-cluster-admin",
                    "$(ADMIN)",
                    "-userid-header",
                    "$(USERID_HEADER)",
                    "-userid-prefix",
                    "$(USERID_PREFIX)"
                    ],
                    "envFrom": [
                    {
                        "configMapRef": {
                        "name": "profiles-config-46c7tgh6fd"
                        }
                    }
                    ],
                    "image": std.join("", [target_registry, "docker.io/tmaxcloudck/kfam:v1.6.1-lls"]),
                    "imagePullPolicy": "Always",
                    "livenessProbe": {
                    "httpGet": {
                        "path": "/metrics",
                        "port": 8081
                    },
                    "initialDelaySeconds": 30,
                    "periodSeconds": 30
                    },
                    "name": "kfam",
                    "resources": {
                    "limits": {
                        "cpu": "1",
                        "memory": "2.5Gi"
                    },
                    "requests": {
                        "cpu": "20m",
                        "memory": "250Mi"
                    }
                    },
                    "ports": [
                    {
                        "containerPort": 8081,
                        "name": "kfam-http",
                        "protocol": "TCP"
                    }
                    ]
                },
                {
                    "args": [
                      std.join("", ["--zap-log-level=", log_level])
                    ],
                    "command": [
                    "/manager",
                    "-userid-header",
                    "$(USERID_HEADER)",
                    "-userid-prefix",
                    "$(USERID_PREFIX)",
                    "-workload-identity",
                    "$(WORKLOAD_IDENTITY)"
                    ],
                    "envFrom": [
                    {
                        "configMapRef": {
                        "name": "profiles-config-46c7tgh6fd"
                        }
                    }
                    ],
                    "image": std.join("", [target_registry, "docker.io/tmaxcloudck/profiles-controller:v1.6.1-lls"]),
                    "imagePullPolicy": "Always",
                    "livenessProbe": {
                    "httpGet": {
                        "path": "/healthz",
                        "port": 9876
                    },
                    "initialDelaySeconds": 15,
                    "periodSeconds": 20
                    },
                    "name": "manager",
                    "ports": [
                    {
                        "containerPort": 9876
                    }
                    ],
                    "readinessProbe": {
                    "httpGet": {
                        "path": "/readyz",
                        "port": 9876
                    },
                    "initialDelaySeconds": 5,
                    "periodSeconds": 10
                    },
                    "resources": {
                    "limits": {
                        "cpu": "1",
                        "memory": "2.5Gi"
                    },
                    "requests": {
                        "cpu": "20m",
                        "memory": "250Mi"
                    }
                    },
                    "volumeMounts": [
                    {
                        "mountPath": "/etc/profile-controller",
                        "name": "namespace-labels",
                        "readOnly": true
                    },                    
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
                "serviceAccountName": "profiles-controller-service-account",
                "volumes": [                
                {
                    "configMap": {
                    "name": "namespace-labels-data-4df5t8mdgf"
                    },
                    "name": "namespace-labels"
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