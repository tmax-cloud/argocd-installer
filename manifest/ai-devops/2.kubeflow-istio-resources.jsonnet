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
    "aggregationRule": {
        "clusterRoleSelectors": [
        {
            "matchLabels": {
            "rbac.authorization.kubeflow.org/aggregate-to-kubeflow-istio-admin": "true"
            }
        }
        ]
    },
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRole",
    "metadata": {
        "labels": {
        "rbac.authorization.kubeflow.org/aggregate-to-kubeflow-admin": "true"
        },
        "name": "kubeflow-istio-admin"
    },
    "rules": []
    },
    {
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRole",
    "metadata": {
        "labels": {
        "rbac.authorization.kubeflow.org/aggregate-to-kubeflow-edit": "true",
        "rbac.authorization.kubeflow.org/aggregate-to-kubeflow-istio-admin": "true"
        },
        "name": "kubeflow-istio-edit"
    },
    "rules": [
        {
        "apiGroups": [
            "istio.io",
            "networking.istio.io"
        ],
        "resources": [
            "*"
        ],
        "verbs": [
            "get",
            "list",
            "watch",
            "create",
            "delete",
            "deletecollection",
            "patch",
            "update"
        ]
        }
    ]
    },
    {
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRole",
    "metadata": {
        "labels": {
        "rbac.authorization.kubeflow.org/aggregate-to-kubeflow-view": "true"
        },
        "name": "kubeflow-istio-view"
    },
    "rules": [
        {
        "apiGroups": [
            "istio.io",
            "networking.istio.io"
        ],
        "resources": [
            "*"
        ],
        "verbs": [
            "get",
            "list",
            "watch"
        ]
        }
    ]
    },
    {
    "apiVersion": "v1",
    "data": {
        "clusterRbacConfig": "ON_WITH_EXCLUSION",
        "gatewaySelector": gatewaySelector
    },
    "kind": "ConfigMap",
    "metadata": {
        "name": "istio-config",
        "namespace": ai_devops_namespace
    }
    },
    {
    "apiVersion": "networking.istio.io/v1alpha3",
    "kind": "Gateway",
    "metadata": {
        "name": "kubeflow-gateway",
        "namespace": ai_devops_namespace
    },
    "spec": {
        "selector": {
        "istio": "ingressgateway"
        },
        "servers": [
        {
            "hosts": [
            "*"
            ],
            "port": {
            "name": "http",
            "number": 80,
            "protocol": "HTTP"
            }
        }
        ]
    }
    },
    {
    "apiVersion": "networking.istio.io/v1alpha3",
    "kind": "ServiceEntry",
    "metadata": {
        "name": "google-api-entry",
        "namespace": ai_devops_namespace
    },
    "spec": {
        "hosts": [
        "www.googleapis.com"
        ],
        "location": "MESH_EXTERNAL",
        "ports": [
        {
            "name": "https",
            "number": 443,
            "protocol": "HTTPS"
        }
        ],
        "resolution": "DNS"
    }
    },
    {
    "apiVersion": "networking.istio.io/v1alpha3",
    "kind": "ServiceEntry",
    "metadata": {
        "name": "google-storage-api-entry",
        "namespace": ai_devops_namespace
    },
    "spec": {
        "hosts": [
        "storage.googleapis.com"
        ],
        "location": "MESH_EXTERNAL",
        "ports": [
        {
            "name": "https",
            "number": 443,
            "protocol": "HTTPS"
        }
        ],
        "resolution": "DNS"
    }
    },
    {
    "apiVersion": "networking.istio.io/v1alpha3",
    "kind": "VirtualService",
    "metadata": {
        "name": "google-api-vs",
        "namespace": ai_devops_namespace
    },
    "spec": {
        "hosts": [
        "www.googleapis.com"
        ],
        "tls": [
        {
            "match": [
            {
                "port": 443,
                "sni_hosts": [
                "www.googleapis.com"
                ]
            }
            ],
            "route": [
            {
                "destination": {
                "host": "www.googleapis.com",
                "port": {
                    "number": 443
                }
                },
                "weight": 100
            }
            ]
        }
        ]
    }
    },
    {
    "apiVersion": "networking.istio.io/v1alpha3",
    "kind": "VirtualService",
    "metadata": {
        "name": "google-storage-api-vs",
        "namespace": ai_devops_namespace
    },
    "spec": {
        "hosts": [
        "storage.googleapis.com"
        ],
        "tls": [
        {
            "match": [
            {
                "port": 443,
                "sni_hosts": [
                "storage.googleapis.com"
                ]
            }
            ],
            "route": [
            {
                "destination": {
                "host": "storage.googleapis.com",
                "port": {
                    "number": 443
                }
                },
                "weight": 100
            }
            ]
        }
        ]
    }
    },
    {
    "apiVersion": "rbac.istio.io/v1alpha1",
    "kind": "ClusterRbacConfig",
    "metadata": {
        "name": "default"
    },
    "spec": {
        "exclusion": {
        "namespaces": [
            "istio-system"
        ]
        },
        "mode": "OFF"
    }
    }
]    