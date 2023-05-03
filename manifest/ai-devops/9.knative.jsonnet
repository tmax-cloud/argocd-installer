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
        "apiVersion": "v1",
        "data": {
            "progressDeadline": "600s",
            "queueSidecarImage": std.join("", [target_registry,"gcr.io/knative-releases/knative.dev/serving/cmd/queue:v1.2.5"])
        },
        "kind": "ConfigMap",
        "metadata": {
            "annotations": {
            "knative.dev/example-checksum": "dd7ee769"
            },
            "labels": {
            "app.kubernetes.io/component": "controller",
            "app.kubernetes.io/name": "knative-serving",
            "app.kubernetes.io/version": "1.2.5",
            "serving.knative.dev/release": "v1.2.5"
            },
            "name": "config-deployment",
            "namespace": "knative-serving"
        }
    },
    {
        "apiVersion": "apps/v1",
        "kind": "Deployment",
        "metadata": {
            "labels": {
            "app.kubernetes.io/component": "activator",
            "app.kubernetes.io/name": "knative-serving",
            "app.kubernetes.io/version": "1.2.5",
            "serving.knative.dev/release": "v1.2.5"
            },
            "name": "activator",
            "namespace": "knative-serving"
        },
        "spec": {
            "selector": {
            "matchLabels": {
                "app": "activator",
                "role": "activator"
            }
            },
            "template": {
            "metadata": {
                "annotations": {
                "cluster-autoscaler.kubernetes.io/safe-to-evict": "false",
                "sidecar.istio.io/inject": "true"
                },
                "labels": {
                "app": "activator",
                "app.kubernetes.io/component": "activator",
                "app.kubernetes.io/name": "knative-serving",
                "app.kubernetes.io/version": "1.2.5",
                "role": "activator",
                "serving.knative.dev/release": "v1.2.5"
                }
            },
            "spec": {
                "containers": [
                {
                    "env": [
                    {
                        "name": "GOGC",
                        "value": "500"
                    },
                    {
                        "name": "POD_NAME",
                        "valueFrom": {
                        "fieldRef": {
                            "fieldPath": "metadata.name"
                        }
                        }
                    },
                    {
                        "name": "POD_IP",
                        "valueFrom": {
                        "fieldRef": {
                            "fieldPath": "status.podIP"
                        }
                        }
                    },
                    {
                        "name": "SYSTEM_NAMESPACE",
                        "valueFrom": {
                        "fieldRef": {
                            "fieldPath": "metadata.namespace"
                        }
                        }
                    },
                    {
                        "name": "CONFIG_LOGGING_NAME",
                        "value": "config-logging"
                    },
                    {
                        "name": "CONFIG_OBSERVABILITY_NAME",
                        "value": "config-observability"
                    },
                    {
                        "name": "METRICS_DOMAIN",
                        "value": "knative.dev/internal/serving"
                    }
                    ],
                    "image": std.join("", [target_registry, "gcr.io/knative-releases/knative.dev/serving/cmd/activator:v1.2.5"]),
                    "livenessProbe": {
                    "failureThreshold": 12,
                    "httpGet": {
                        "httpHeaders": [
                        {
                            "name": "k-kubelet-probe",
                            "value": "activator"
                        }
                        ],
                        "port": 8012
                    },
                    "initialDelaySeconds": 15,
                    "periodSeconds": 10
                    },
                    "name": "activator",
                    "ports": [
                    {
                        "containerPort": 9090,
                        "name": "metrics"
                    },
                    {
                        "containerPort": 8008,
                        "name": "profiling"
                    },
                    {
                        "containerPort": 8012,
                        "name": "http1"
                    },
                    {
                        "containerPort": 8013,
                        "name": "h2c"
                    }
                    ],
                    "readinessProbe": {
                    "failureThreshold": 5,
                    "httpGet": {
                        "httpHeaders": [
                        {
                            "name": "k-kubelet-probe",
                            "value": "activator"
                        }
                        ],
                        "port": 8012
                    },
                    "periodSeconds": 5
                    },
                    "resources": {
                    "limits": {
                        "cpu": "1000m",
                        "memory": "600Mi"
                    },
                    "requests": {
                        "cpu": "300m",
                        "memory": "60Mi"
                    }
                    },
                    "securityContext": {
                    "allowPrivilegeEscalation": false,
                    "capabilities": {
                        "drop": [
                        "all"
                        ]
                    },
                    "readOnlyRootFilesystem": true,
                    "runAsNonRoot": true
                    },
                    "volumeMounts": [
                    {
                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                        "name": "controller-token",
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
                "terminationGracePeriodSeconds": 600,
                "volumes": [
                {
                    "name": "controller-token",
                    "secret": {
                    "defaultMode": 420,
                    "secretName": "controller-token"
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
            "app.kubernetes.io/component": "autoscaler",
            "app.kubernetes.io/name": "knative-serving",
            "app.kubernetes.io/version": "1.2.5",
            "serving.knative.dev/release": "v1.2.5"
            },
            "name": "autoscaler",
            "namespace": "knative-serving"
        },
        "spec": {
            "replicas": 1,
            "selector": {
            "matchLabels": {
                "app": "autoscaler"
            }
            },
            "strategy": {
            "rollingUpdate": {
                "maxUnavailable": 0
            },
            "type": "RollingUpdate"
            },
            "template": {
            "metadata": {
                "annotations": {
                "cluster-autoscaler.kubernetes.io/safe-to-evict": "false",
                "sidecar.istio.io/inject": "true"
                },
                "labels": {
                "app": "autoscaler",
                "app.kubernetes.io/component": "autoscaler",
                "app.kubernetes.io/name": "knative-serving",
                "app.kubernetes.io/version": "1.2.5",
                "serving.knative.dev/release": "v1.2.5"
                }
            },
            "spec": {
                "affinity": {
                "podAntiAffinity": {
                    "preferredDuringSchedulingIgnoredDuringExecution": [
                    {
                        "podAffinityTerm": {
                        "labelSelector": {
                            "matchLabels": {
                            "app": "autoscaler"
                            }
                        },
                        "topologyKey": "kubernetes.io/hostname"
                        },
                        "weight": 100
                    }
                    ]
                }
                },
                "containers": [
                {
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
                        "name": "POD_IP",
                        "valueFrom": {
                        "fieldRef": {
                            "fieldPath": "status.podIP"
                        }
                        }
                    },
                    {
                        "name": "SYSTEM_NAMESPACE",
                        "valueFrom": {
                        "fieldRef": {
                            "fieldPath": "metadata.namespace"
                        }
                        }
                    },
                    {
                        "name": "CONFIG_LOGGING_NAME",
                        "value": "config-logging"
                    },
                    {
                        "name": "CONFIG_OBSERVABILITY_NAME",
                        "value": "config-observability"
                    },
                    {
                        "name": "METRICS_DOMAIN",
                        "value": "knative.dev/serving"
                    }
                    ],
                    "image": std.join("", [target_registry, "gcr.io/knative-releases/knative.dev/serving/cmd/autoscaler:v1.2.5"]),
                    "livenessProbe": {
                    "failureThreshold": 6,
                    "httpGet": {
                        "httpHeaders": [
                        {
                            "name": "k-kubelet-probe",
                            "value": "autoscaler"
                        }
                        ],
                        "port": 8080
                    }
                    },
                    "name": "autoscaler",
                    "ports": [
                    {
                        "containerPort": 9090,
                        "name": "metrics"
                    },
                    {
                        "containerPort": 8008,
                        "name": "profiling"
                    },
                    {
                        "containerPort": 8080,
                        "name": "websocket"
                    }
                    ],
                    "readinessProbe": {
                    "httpGet": {
                        "httpHeaders": [
                        {
                            "name": "k-kubelet-probe",
                            "value": "autoscaler"
                        }
                        ],
                        "port": 8080
                    }
                    },
                    "resources": {
                    "limits": {
                        "cpu": "1000m",
                        "memory": "1000Mi"
                    },
                    "requests": {
                        "cpu": "100m",
                        "memory": "100Mi"
                    }
                    },
                    "securityContext": {
                    "allowPrivilegeEscalation": false,
                    "capabilities": {
                        "drop": [
                        "all"
                        ]
                    },
                    "readOnlyRootFilesystem": true,
                    "runAsNonRoot": true
                    },
                    "volumeMounts": [
                    {
                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                        "name": "controller-token",
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
                    "name": "controller-token",
                    "secret": {
                    "defaultMode": 420,
                    "secretName": "controller-token"
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
            "app.kubernetes.io/component": "controller",
            "app.kubernetes.io/name": "knative-serving",
            "app.kubernetes.io/version": "1.2.5",
            "serving.knative.dev/release": "v1.2.5"
            },
            "name": "controller",
            "namespace": "knative-serving"
        },
        "spec": {
            "selector": {
            "matchLabels": {
                "app": "controller"
            }
            },
            "template": {
            "metadata": {
                "annotations": {
                "cluster-autoscaler.kubernetes.io/safe-to-evict": "true",
                "sidecar.istio.io/inject": "true"
                },
                "labels": {
                "app": "controller",
                "app.kubernetes.io/component": "controller",
                "app.kubernetes.io/name": "knative-serving",
                "app.kubernetes.io/version": "1.2.5",
                "serving.knative.dev/release": "v1.2.5"
                }
            },
            "spec": {
                "affinity": {
                "podAntiAffinity": {
                    "preferredDuringSchedulingIgnoredDuringExecution": [
                    {
                        "podAffinityTerm": {
                        "labelSelector": {
                            "matchLabels": {
                            "app": "controller"
                            }
                        },
                        "topologyKey": "kubernetes.io/hostname"
                        },
                        "weight": 100
                    }
                    ]
                }
                },
                "containers": [
                {
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
                        "name": "SYSTEM_NAMESPACE",
                        "valueFrom": {
                        "fieldRef": {
                            "fieldPath": "metadata.namespace"
                        }
                        }
                    },
                    {
                        "name": "CONFIG_LOGGING_NAME",
                        "value": "config-logging"
                    },
                    {
                        "name": "CONFIG_OBSERVABILITY_NAME",
                        "value": "config-observability"
                    },
                    {
                        "name": "METRICS_DOMAIN",
                        "value": "knative.dev/internal/serving"
                    }
                    ],
                    "image": std.join("", [target_registry, "gcr.io/knative-releases/knative.dev/serving/cmd/controller:v1.2.5"]),
                    "name": "controller",
                    "ports": [
                    {
                        "containerPort": 9090,
                        "name": "metrics"
                    },
                    {
                        "containerPort": 8008,
                        "name": "profiling"
                    }
                    ],
                    "resources": {
                    "limits": {
                        "cpu": "1000m",
                        "memory": "1000Mi"
                    },
                    "requests": {
                        "cpu": "100m",
                        "memory": "100Mi"
                    }
                    },
                    "securityContext": {
                    "allowPrivilegeEscalation": false,
                    "capabilities": {
                        "drop": [
                        "all"
                        ]
                    },
                    "readOnlyRootFilesystem": true,
                    "runAsNonRoot": true
                    },
                    "volumeMounts": [
                    {
                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                        "name": "controller-token",
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
                    "name": "controller-token",
                    "secret": {
                    "defaultMode": 420,
                    "secretName": "controller-token"
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
            "app.kubernetes.io/component": "domain-mapping",
            "app.kubernetes.io/name": "knative-serving",
            "app.kubernetes.io/version": "1.2.5",
            "serving.knative.dev/release": "v1.2.5"
            },
            "name": "domain-mapping",
            "namespace": "knative-serving"
        },
        "spec": {
            "selector": {
            "matchLabels": {
                "app": "domain-mapping"
            }
            },
            "template": {
            "metadata": {
                "annotations": {
                "cluster-autoscaler.kubernetes.io/safe-to-evict": "true",
                "sidecar.istio.io/inject": "true"
                },
                "labels": {
                "app": "domain-mapping",
                "app.kubernetes.io/component": "domain-mapping",
                "app.kubernetes.io/name": "knative-serving",
                "app.kubernetes.io/version": "1.2.5",
                "serving.knative.dev/release": "v1.2.5"
                }
            },
            "spec": {
                "affinity": {
                "podAntiAffinity": {
                    "preferredDuringSchedulingIgnoredDuringExecution": [
                    {
                        "podAffinityTerm": {
                        "labelSelector": {
                            "matchLabels": {
                            "app": "domain-mapping"
                            }
                        },
                        "topologyKey": "kubernetes.io/hostname"
                        },
                        "weight": 100
                    }
                    ]
                }
                },
                "containers": [
                {
                    "env": [
                    {
                        "name": "SYSTEM_NAMESPACE",
                        "valueFrom": {
                        "fieldRef": {
                            "fieldPath": "metadata.namespace"
                        }
                        }
                    },
                    {
                        "name": "CONFIG_LOGGING_NAME",
                        "value": "config-logging"
                    },
                    {
                        "name": "CONFIG_OBSERVABILITY_NAME",
                        "value": "config-observability"
                    },
                    {
                        "name": "METRICS_DOMAIN",
                        "value": "knative.dev/serving"
                    }
                    ],
                    "image": std.join("", [target_registry, "gcr.io/knative-releases/knative.dev/serving/cmd/domain-mapping:v1.2.5"]),
                    "name": "domain-mapping",
                    "ports": [
                    {
                        "containerPort": 9090,
                        "name": "metrics"
                    },
                    {
                        "containerPort": 8008,
                        "name": "profiling"
                    }
                    ],
                    "resources": {
                    "limits": {
                        "cpu": "300m",
                        "memory": "400Mi"
                    },
                    "requests": {
                        "cpu": "30m",
                        "memory": "40Mi"
                    }
                    },
                    "securityContext": {
                    "allowPrivilegeEscalation": false,
                    "capabilities": {
                        "drop": [
                        "all"
                        ]
                    },
                    "readOnlyRootFilesystem": true,
                    "runAsNonRoot": true
                    },
                    "volumeMounts": [
                    {
                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                        "name": "controller-token",
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
                    "name": "controller-token",
                    "secret": {
                    "defaultMode": 420,
                    "secretName": "controller-token"
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
            "app.kubernetes.io/component": "domain-mapping",
            "app.kubernetes.io/name": "knative-serving",
            "app.kubernetes.io/version": "1.2.5",
            "serving.knative.dev/release": "v1.2.5"
            },
            "name": "domainmapping-webhook",
            "namespace": "knative-serving"
        },
        "spec": {
            "selector": {
            "matchLabels": {
                "app": "domainmapping-webhook",
                "role": "domainmapping-webhook"
            }
            },
            "template": {
            "metadata": {
                "annotations": {
                "cluster-autoscaler.kubernetes.io/safe-to-evict": "false",
                "sidecar.istio.io/inject": "true"
                },
                "labels": {
                "app": "domainmapping-webhook",
                "app.kubernetes.io/component": "domain-mapping",
                "app.kubernetes.io/name": "knative-serving",
                "app.kubernetes.io/version": "1.2.5",
                "role": "domainmapping-webhook",
                "serving.knative.dev/release": "v1.2.5"
                }
            },
            "spec": {
                "affinity": {
                "podAntiAffinity": {
                    "preferredDuringSchedulingIgnoredDuringExecution": [
                    {
                        "podAffinityTerm": {
                        "labelSelector": {
                            "matchLabels": {
                            "app": "domainmapping-webhook"
                            }
                        },
                        "topologyKey": "kubernetes.io/hostname"
                        },
                        "weight": 100
                    }
                    ]
                }
                },
                "containers": [
                {
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
                        "name": "SYSTEM_NAMESPACE",
                        "valueFrom": {
                        "fieldRef": {
                            "fieldPath": "metadata.namespace"
                        }
                        }
                    },
                    {
                        "name": "CONFIG_LOGGING_NAME",
                        "value": "config-logging"
                    },
                    {
                        "name": "CONFIG_OBSERVABILITY_NAME",
                        "value": "config-observability"
                    },
                    {
                        "name": "WEBHOOK_PORT",
                        "value": "8443"
                    },
                    {
                        "name": "METRICS_DOMAIN",
                        "value": "knative.dev/serving"
                    }
                    ],
                    "image": std.join("", [target_registry, "gcr.io/knative-releases/knative.dev/serving/cmd/domain-mapping-webhook:v1.2.5"]),
                    "livenessProbe": {
                    "failureThreshold": 6,
                    "httpGet": {
                        "httpHeaders": [
                        {
                            "name": "k-kubelet-probe",
                            "value": "webhook"
                        }
                        ],
                        "port": 8443,
                        "scheme": "HTTPS"
                    },
                    "initialDelaySeconds": 20,
                    "periodSeconds": 1
                    },
                    "name": "domainmapping-webhook",
                    "ports": [
                    {
                        "containerPort": 9090,
                        "name": "metrics"
                    },
                    {
                        "containerPort": 8008,
                        "name": "profiling"
                    },
                    {
                        "containerPort": 8443,
                        "name": "https-webhook"
                    }
                    ],
                    "readinessProbe": {
                    "httpGet": {
                        "httpHeaders": [
                        {
                            "name": "k-kubelet-probe",
                            "value": "webhook"
                        }
                        ],
                        "port": 8443,
                        "scheme": "HTTPS"
                    },
                    "periodSeconds": 1
                    },
                    "resources": {
                    "limits": {
                        "cpu": "500m",
                        "memory": "500Mi"
                    },
                    "requests": {
                        "cpu": "100m",
                        "memory": "100Mi"
                    }
                    },
                    "securityContext": {
                    "allowPrivilegeEscalation": false,
                    "capabilities": {
                        "drop": [
                        "all"
                        ]
                    },
                    "readOnlyRootFilesystem": true,
                    "runAsNonRoot": true
                    },
                    "volumeMounts": [
                    {
                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                        "name": "controller-token",
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
                "terminationGracePeriodSeconds": 300,
                "volumes": [
                {
                    "name": "controller-token",
                    "secret": {
                    "defaultMode": 420,
                    "secretName": "controller-token"
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
            "app.kubernetes.io/component": "net-istio",
            "app.kubernetes.io/name": "knative-serving",
            "app.kubernetes.io/version": "1.2.0",
            "networking.knative.dev/ingress-provider": "istio",
            "serving.knative.dev/release": "v1.2.0"
            },
            "name": "net-istio-controller",
            "namespace": "knative-serving"
        },
        "spec": {
            "selector": {
            "matchLabels": {
                "app": "net-istio-controller"
            }
            },
            "template": {
            "metadata": {
                "annotations": {
                "cluster-autoscaler.kubernetes.io/safe-to-evict": "true",
                "sidecar.istio.io/inject": "true"
                },
                "labels": {
                "app": "net-istio-controller",
                "app.kubernetes.io/component": "net-istio",
                "app.kubernetes.io/name": "knative-serving",
                "app.kubernetes.io/version": "1.2.0",
                "serving.knative.dev/release": "v1.2.0"
                }
            },
            "spec": {
                "containers": [
                {
                    "env": [
                    {
                        "name": "SYSTEM_NAMESPACE",
                        "valueFrom": {
                        "fieldRef": {
                            "fieldPath": "metadata.namespace"
                        }
                        }
                    },
                    {
                        "name": "CONFIG_LOGGING_NAME",
                        "value": "config-logging"
                    },
                    {
                        "name": "CONFIG_OBSERVABILITY_NAME",
                        "value": "config-observability"
                    },
                    {
                        "name": "METRICS_DOMAIN",
                        "value": "knative.dev/net-istio"
                    }
                    ],
                    "image": std.join("", [target_registry, "gcr.io/knative-releases/knative.dev/net-istio/cmd/controller:v1.2.0"]),
                    "name": "controller",
                    "ports": [
                    {
                        "containerPort": 9090,
                        "name": "metrics"
                    },
                    {
                        "containerPort": 8008,
                        "name": "profiling"
                    }
                    ],
                    "resources": {
                    "limits": {
                        "cpu": "300m",
                        "memory": "400Mi"
                    },
                    "requests": {
                        "cpu": "30m",
                        "memory": "40Mi"
                    }
                    },
                    "securityContext": {
                    "allowPrivilegeEscalation": false,
                    "capabilities": {
                        "drop": [
                        "all"
                        ]
                    },
                    "readOnlyRootFilesystem": true,
                    "runAsNonRoot": true
                    },
                    "volumeMounts": [
                    {
                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                        "name": "controller-token",
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
                    "name": "controller-token",
                    "secret": {
                    "defaultMode": 420,
                    "secretName": "controller-token"
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
            "app.kubernetes.io/component": "net-istio",
            "app.kubernetes.io/name": "knative-serving",
            "app.kubernetes.io/version": "1.2.0",
            "networking.knative.dev/ingress-provider": "istio",
            "serving.knative.dev/release": "v1.2.0"
            },
            "name": "net-istio-webhook",
            "namespace": "knative-serving"
        },
        "spec": {
            "selector": {
            "matchLabels": {
                "app": "net-istio-webhook",
                "role": "net-istio-webhook"
            }
            },
            "template": {
            "metadata": {
                "annotations": {
                "cluster-autoscaler.kubernetes.io/safe-to-evict": "false",
                "sidecar.istio.io/inject": "true"
                },
                "labels": {
                "app": "net-istio-webhook",
                "app.kubernetes.io/component": "net-istio",
                "app.kubernetes.io/name": "knative-serving",
                "app.kubernetes.io/version": "1.2.0",
                "role": "net-istio-webhook",
                "serving.knative.dev/release": "v1.2.0"
                }
            },
            "spec": {
                "containers": [
                {
                    "env": [
                    {
                        "name": "SYSTEM_NAMESPACE",
                        "valueFrom": {
                        "fieldRef": {
                            "fieldPath": "metadata.namespace"
                        }
                        }
                    },
                    {
                        "name": "CONFIG_LOGGING_NAME",
                        "value": "config-logging"
                    },
                    {
                        "name": "CONFIG_OBSERVABILITY_NAME",
                        "value": "config-observability"
                    },
                    {
                        "name": "METRICS_DOMAIN",
                        "value": "knative.dev/net-istio"
                    },
                    {
                        "name": "WEBHOOK_NAME",
                        "value": "net-istio-webhook"
                    }
                    ],
                    "image": std.join("", [target_registry, "gcr.io/knative-releases/knative.dev/net-istio/cmd/webhook:v1.2.0"]),
                    "name": "webhook",
                    "ports": [
                    {
                        "containerPort": 9090,
                        "name": "metrics"
                    },
                    {
                        "containerPort": 8008,
                        "name": "profiling"
                    },
                    {
                        "containerPort": 8443,
                        "name": "https-webhook"
                    }
                    ],
                    "resources": {
                    "limits": {
                        "cpu": "200m",
                        "memory": "200Mi"
                    },
                    "requests": {
                        "cpu": "20m",
                        "memory": "20Mi"
                    }
                    },
                    "securityContext": {
                    "allowPrivilegeEscalation": false
                    },
                    "volumeMounts": [
                    {
                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                        "name": "controller-token",
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
                    "name": "controller-token",
                    "secret": {
                    "defaultMode": 420,
                    "secretName": "controller-token"
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
            "app.kubernetes.io/component": "webhook",
            "app.kubernetes.io/name": "knative-serving",
            "app.kubernetes.io/version": "1.2.5",
            "serving.knative.dev/release": "v1.2.5"
            },
            "name": "webhook",
            "namespace": "knative-serving"
        },
        "spec": {
            "selector": {
            "matchLabels": {
                "app": "webhook",
                "role": "webhook"
            }
            },
            "template": {
            "metadata": {
                "annotations": {
                "cluster-autoscaler.kubernetes.io/safe-to-evict": "false",
                "sidecar.istio.io/inject": "true"
                },
                "labels": {
                "app": "webhook",
                "app.kubernetes.io/component": "webhook",
                "app.kubernetes.io/name": "knative-serving",
                "app.kubernetes.io/version": "1.2.5",
                "role": "webhook",
                "serving.knative.dev/release": "v1.2.5"
                }
            },
            "spec": {
                "affinity": {
                "podAntiAffinity": {
                    "preferredDuringSchedulingIgnoredDuringExecution": [
                    {
                        "podAffinityTerm": {
                        "labelSelector": {
                            "matchLabels": {
                            "app": "webhook"
                            }
                        },
                        "topologyKey": "kubernetes.io/hostname"
                        },
                        "weight": 100
                    }
                    ]
                }
                },
                "containers": [
                {
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
                        "name": "SYSTEM_NAMESPACE",
                        "valueFrom": {
                        "fieldRef": {
                            "fieldPath": "metadata.namespace"
                        }
                        }
                    },
                    {
                        "name": "CONFIG_LOGGING_NAME",
                        "value": "config-logging"
                    },
                    {
                        "name": "CONFIG_OBSERVABILITY_NAME",
                        "value": "config-observability"
                    },
                    {
                        "name": "WEBHOOK_NAME",
                        "value": "webhook"
                    },
                    {
                        "name": "WEBHOOK_PORT",
                        "value": "8443"
                    },
                    {
                        "name": "METRICS_DOMAIN",
                        "value": "knative.dev/internal/serving"
                    }
                    ],
                    "image": std.join("", [target_registry, "gcr.io/knative-releases/knative.dev/serving/cmd/webhook:v1.2.5"]),
                    "livenessProbe": {
                    "failureThreshold": 6,
                    "httpGet": {
                        "httpHeaders": [
                        {
                            "name": "k-kubelet-probe",
                            "value": "webhook"
                        }
                        ],
                        "port": 8443,
                        "scheme": "HTTPS"
                    },
                    "initialDelaySeconds": 20,
                    "periodSeconds": 1
                    },
                    "name": "webhook",
                    "ports": [
                    {
                        "containerPort": 9090,
                        "name": "metrics"
                    },
                    {
                        "containerPort": 8008,
                        "name": "profiling"
                    },
                    {
                        "containerPort": 8443,
                        "name": "https-webhook"
                    }
                    ],
                    "readinessProbe": {
                    "httpGet": {
                        "httpHeaders": [
                        {
                            "name": "k-kubelet-probe",
                            "value": "webhook"
                        }
                        ],
                        "port": 8443,
                        "scheme": "HTTPS"
                    },
                    "periodSeconds": 1
                    },
                    "resources": {
                    "limits": {
                        "cpu": "500m",
                        "memory": "500Mi"
                    },
                    "requests": {
                        "cpu": "100m",
                        "memory": "100Mi"
                    }
                    },
                    "securityContext": {
                    "allowPrivilegeEscalation": false,
                    "capabilities": {
                        "drop": [
                        "all"
                        ]
                    },
                    "readOnlyRootFilesystem": true,
                    "runAsNonRoot": true
                    },
                    "volumeMounts": [
                    {
                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                        "name": "controller-token",
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
                "terminationGracePeriodSeconds": 300,
                "volumes": [
                {
                    "name": "controller-token",
                    "secret": {
                    "defaultMode": 420,
                    "secretName": "controller-token"
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
  "apiVersion": "v1",
  "data": {
    "zap-logger-config": "{\n  \"level\": \"info\",\n  \"development\": false,\n  \"outputPaths\": [\"stdout\"],\n  \"errorOutputPaths\": [\"stderr\"],\n  \"encoding\": \"json\",\n  \"encoderConfig\": {\n    \"timeKey\": \"timestamp\",\n    \"levelKey\": \"severity\",\n    \"nameKey\": \"logger\",\n    \"callerKey\": \"caller\",\n    \"messageKey\": \"message\",\n    \"stacktraceKey\": \"stacktrace\",\n    \"lineEnding\": \"\",\n    \"levelEncoder\": \"\",\n    \"timeEncoder\": \"iso8601\",\n    \"durationEncoder\": \"\",\n    \"callerEncoder\": \"\"\n  }\n}    \n",
    "loglevel.controller": log_level,
    "loglevel.autoscaler": log_level,
    "loglevel.queueproxy": log_level,
    "loglevel.webhook": log_level,
    "loglevel.activator": log_level,
    "loglevel.hpaautoscaler": log_level,
    "loglevel.net-certmanager-controller": log_level,
    "loglevel.net-istio-controller": log_level
  },
  "kind": "ConfigMap",
  "metadata": {
    "annotations": {
      "knative.dev/example-checksum": "be93ff10"
    },
    "labels": {
      "app.kubernetes.io/name": "knative-serving",
      "app.kubernetes.io/version": "1.2.5",
      "serving.knative.dev/release": "v1.2.5"
    },
    "name": "config-logging",
    "namespace": "knative-serving"
  }
}
]