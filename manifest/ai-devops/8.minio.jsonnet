function (
    is_offline="false",
    private_registry="172.22.6.2:5000",
    ai_devops_namespace="kubeflow",
    istio_namespace="istio-system",
    knative_namespace="knative-serving",
    custom_domain_name="tmaxcloud.org",
    notebook_svc_type="Ingress"
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";
[
    {
    "apiVersion": "v1",
    "data": {
        "accesskey": "bWluaW8=",
        "secretkey": "bWluaW8xMjM="
    },
    "kind": "Secret",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "minio",
        "app.kubernetes.io/name": "minio"
        },
        "name": "mlpipeline-minio-artifact",
        "namespace": ai_devops_namespace
    },
    "type": "Opaque"
    },
    {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "minio",
        "app.kubernetes.io/name": "minio"
        },
        "name": "minio-service",
        "namespace": ai_devops_namespace
    },
    "spec": {
        "ports": [
        {
            "name": "http",
            "port": 9000,
            "protocol": "TCP",
            "targetPort": 9000
        }
        ],
        "selector": {
        "app": "minio",
        "app.kubernetes.io/component": "minio",
        "app.kubernetes.io/name": "minio"
        }
    }
    },
    {
    "apiVersion": "v1",
    "kind": "PersistentVolumeClaim",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "minio",
        "app.kubernetes.io/name": "minio"
        },
        "name": "minio-pvc",
        "namespace": ai_devops_namespace
    },
    "spec": {        
        "accessModes": [
        "ReadWriteOnce"
        ],
        "resources": {
        "requests": {
            "storage": "20Gi"
        }
        }
    }
    },
    {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
        "labels": {
        "app": "minio",
        "app.kubernetes.io/component": "minio",
        "app.kubernetes.io/name": "minio"
        },
        "name": "minio",
        "namespace": ai_devops_namespace
    },
    "spec": {
        "selector": {
        "matchLabels": {
            "app": "minio",
            "app.kubernetes.io/component": "minio",
            "app.kubernetes.io/name": "minio"
        }
        },
        "strategy": {
        "type": "Recreate"
        },
        "template": {
        "metadata": {
            "annotations": {
            "sidecar.istio.io/inject": "false"
            },
            "labels": {
            "app": "minio",
            "app.kubernetes.io/component": "minio",
            "app.kubernetes.io/name": "minio"
            }
        },
        "spec": {
            "containers": [
            {
                "args": [
                "server",
                "/data"
                ],
                "env": [
                {
                    "name": "MINIO_ACCESS_KEY",
                    "valueFrom": {
                    "secretKeyRef": {
                        "key": "accesskey",
                        "name": "mlpipeline-minio-artifact"
                    }
                    }
                },
                {
                    "name": "MINIO_SECRET_KEY",
                    "valueFrom": {
                    "secretKeyRef": {
                        "key": "secretkey",
                        "name": "mlpipeline-minio-artifact"
                    }
                    }
                }
                ],
                "image": std.join("", [target_registry, "gcr.io/ml-pipeline/minio:RELEASE.2019-08-14T20-37-41Z-license-compliance"]),
                "name": "minio",
                "ports": [
                {
                    "containerPort": 9000
                }
                ],
                "volumeMounts": [
                {
                    "mountPath": "/data",
                    "name": "data",
                    "subPath": "minio"
                }
                ]
            }
            ],
            "serviceAccountName": "kubeflow-service-account",
            "volumes": [
            {
                "name": "data",
                "persistentVolumeClaim": {
                "claimName": "minio-pvc"
                }
            }
            ]
        }
        }
    }
    },
    {
    "apiVersion": "app.k8s.io/v1beta1",
    "kind": "Application",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "minio",
        "app.kubernetes.io/name": "minio"
        },
        "name": "minio",
        "namespace": ai_devops_namespace
    },
    "spec": {
        "addOwnerRef": true,
        "componentKinds": [
        {
            "group": "core",
            "kind": "ConfigMap"
        },
        {
            "group": "apps",
            "kind": "Deployment"
        }
        ],
        "descriptor": {
        "description": "",
        "keywords": [
            "minio",
            "kubeflow"
        ],
        "links": [
            {
            "description": "About",
            "url": ""
            }
        ],
        "maintainers": [],
        "owners": [],
        "type": "minio",
        "version": "v1beta1"
        },
        "selector": {
        "matchLabels": {
            "app.kubernetes.io/component": "minio",
            "app.kubernetes.io/name": "minio"
        }
        }
    }
    }
]    