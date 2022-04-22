function (
    is_offline="false",
    private_registry="172.22.6.2:5000",
    ai_devops_namespace="kubeflow",
    istio_namespace="istio-system",
    knative_namespace="knative-serving",
    custom_domain_name="tmaxcloud.org",
    notebook_svc_type="Ingress",
    tmax_client_secret="tmax_client_secret",
    hyperauth_url="172.23.4.105",
    hyperauth_realm="tmax",
    console_subdomain="console"
)

local gatewaySelector = "ingressgateway";

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
    }
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