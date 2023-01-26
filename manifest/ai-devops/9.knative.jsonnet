function (    
    is_offline="false",
    private_registry="172.22.6.2:5000",    
    custom_domain_name="tmaxcloud.org",    
    tmax_client_secret="tmax_client_secret",
    hyperauth_url="172.23.4.105",
    hyperauth_realm="tmax",
    console_subdomain="console",    
    gatekeeper_log_level="info",    
    gatekeeper_version="v1.0.2"
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";
[
    {
        "apiVersion": "v1",
        "data": {
            "progressDeadline": "600s",
            "queueSidecarImage": std.join("", [target_registry,"gcr.io/knative-releases/knative.dev/serving/cmd/queue@sha256:14415b204ea8d0567235143a6c3377f49cbd35f18dc84dfa4baa7695c2a9b53d"])
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
                    "image": std.join("", [target_registry, "gcr.io/knative-releases/knative.dev/serving/cmd/activator@sha256:93ff6e69357785ff97806945b284cbd1d37e50402b876a320645be8877c0d7b7"]),
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
                    ]
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
                    "image": std.join("", [target_registry, "gcr.io/knative-releases/knative.dev/serving/cmd/autoscaler@sha256:007820fdb75b60e6fd5a25e65fd6ad9744082a6bf195d72795561c91b425d016"]),
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
                    ]
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
                    "image": std.join("", [target_registry, "gcr.io/knative-releases/knative.dev/serving/cmd/controller@sha256:75cfdcfa050af9522e798e820ba5483b9093de1ce520207a3fedf112d73a4686"]),
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
                    ]
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
                    "image": std.join("", [target_registry, "gcr.io/knative-releases/knative.dev/serving/cmd/domain-mapping@sha256:23baa19322320f25a462568eded1276601ef67194883db9211e1ea24f21a0beb"]),
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
                    ]
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
                    "image": std.join("", [target_registry, "gcr.io/knative-releases/knative.dev/serving/cmd/domain-mapping-webhook@sha256:847bb97e38440c71cb4bcc3e430743e18b328ad1e168b6fca35b10353b9a2c22"]),
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
                    ]
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
                    "image": std.join("", [target_registry, "gcr.io/knative-releases/knative.dev/net-istio/cmd/controller@sha256:f253b82941c2220181cee80d7488fe1cefce9d49ab30bdb54bcb8c76515f7a26"]),
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
                    ]
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
                    "image": std.join("", [target_registry, "gcr.io/knative-releases/knative.dev/net-istio/cmd/webhook@sha256:a705c1ea8e9e556f860314fe055082fbe3cde6a924c29291955f98d979f8185e"]),
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
                    ]
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
                    "image": std.join("", [target_registry, "gcr.io/knative-releases/knative.dev/serving/cmd/webhook@sha256:9084ea8498eae3c6c4364a397d66516a25e48488f4a9871ef765fa554ba483f0"]),
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
                    ]
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
                ]
            }
            }
        }
    }
]