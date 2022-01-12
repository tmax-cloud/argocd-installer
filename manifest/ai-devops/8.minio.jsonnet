function (
    ai_devops_namespace="kubeflow",
    istio_namespace="istio-system",
    knative_namespace="knative-serving", 
    tmaxcloud_image_repo="docker.io/tmaxcloudck",
    istio_image_repo="docker.io/istio",
    gatewaySelector="ingressgateway",
    kubeflow_public_image_repo="gcr.io/kubeflow-images-public",
    katib_image_repo="docker.io/kubeflowkatib",
    katib_image_tag="v0.12.0",
    katib_object_image_tag="v0.11.0",
    mysql_deploy_image_repo="mysql",
    mysql_deploy_image_tag="8.0.27",
    argo_image_repo="docker.io/argoproj",
    argo_image_tag="v2.12.10",
    minio_image_repo="gcr.io/ml-pipeline/minio",
    minio_image_tag="RELEASE.2019-08-14T20-37-41Z-license-compliance",
    notebook_svc_type="Ingress",
    custom_domain_name="tmaxcloud.org",
    knative_serving_image_repo="gcr.io/knative-releases/knative.dev/serving/cmd",
    knative_istio_image_repo="gcr.io/knative-releases/knative.dev/net-istio/cmd",
    knative_serving_image_tag="v0.14.3",
    knative_istio_image_tag="v0.14.1",
    kfserving_image_tag="v0.5.1",
    kfserving_gcr_image_repo="gcr.io/kfserving",
    kfserving_docker_image_repo="docker.io/kfserving",
    kube_rbac_proxy_image_repo="gcr.io/kubebuilder/kube-rbac-proxy",
    kube_rbac_proxy_image_tag="v0.4.0"   
)
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
        "storageClassName": "nfs",
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
                "image": std.join("", [minio_image_repo, ":", minio_image_tag]),
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