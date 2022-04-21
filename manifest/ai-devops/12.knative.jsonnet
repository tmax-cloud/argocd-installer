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
    hyperauth_realm="tmax"
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";
local knative_serving_image_tag = "v0.14.3";
local knative_istio_image_tag = "v0.14.1";
[    
    {
    "apiVersion": "v1",
    "kind": "Namespace",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": knative_namespace
    }
    },
    {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "knative.dev/crd-install": "true",
        "kustomize.component": "knative"
        },
        "name": "images.caching.internal.knative.dev"
    },
    "spec": {
        "group": "caching.internal.knative.dev",
        "names": {
        "categories": [
            "knative-internal",
            "caching"
        ],
        "kind": "Image",
        "plural": "images",
        "shortNames": [
            "img"
        ],
        "singular": "image"
        },
        "scope": "Namespaced",
        "subresources": {
        "status": {}
        },
        "version": "v1alpha1"
    }
    },
    {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "knative.dev/crd-install": "true",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "certificates.networking.internal.knative.dev"
    },
    "spec": {
        "additionalPrinterColumns": [
        {
            "JSONPath": ".status.conditions[?(@.type==\"Ready\")].status",
            "name": "Ready",
            "type": "string"
        },
        {
            "JSONPath": ".status.conditions[?(@.type==\"Ready\")].reason",
            "name": "Reason",
            "type": "string"
        }
        ],
        "group": "networking.internal.knative.dev",
        "names": {
        "categories": [
            "knative-internal",
            "networking"
        ],
        "kind": "Certificate",
        "plural": "certificates",
        "shortNames": [
            "kcert"
        ],
        "singular": "certificate"
        },
        "scope": "Namespaced",
        "subresources": {
        "status": {}
        },
        "version": "v1alpha1"
    }
    },
    {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "duck.knative.dev/podspecable": "true",
        "knative.dev/crd-install": "true",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "configurations.serving.knative.dev"
    },
    "spec": {
        "additionalPrinterColumns": [
        {
            "JSONPath": ".status.latestCreatedRevisionName",
            "name": "LatestCreated",
            "type": "string"
        },
        {
            "JSONPath": ".status.latestReadyRevisionName",
            "name": "LatestReady",
            "type": "string"
        },
        {
            "JSONPath": ".status.conditions[?(@.type=='Ready')].status",
            "name": "Ready",
            "type": "string"
        },
        {
            "JSONPath": ".status.conditions[?(@.type=='Ready')].reason",
            "name": "Reason",
            "type": "string"
        }
        ],
        "conversion": {
        "strategy": "Webhook",
        "webhookClientConfig": {
            "service": {
            "name": "webhook",
            "namespace": knative_namespace
            }
        }
        },
        "group": "serving.knative.dev",
        "names": {
        "categories": [
            "all",
            "knative",
            "serving"
        ],
        "kind": "Configuration",
        "plural": "configurations",
        "shortNames": [
            "config",
            "cfg"
        ],
        "singular": "configuration"
        },
        "preserveUnknownFields": false,
        "scope": "Namespaced",
        "subresources": {
        "status": {}
        },
        "validation": {
        "openAPIV3Schema": {
            "type": "object",
            "x-kubernetes-preserve-unknown-fields": true
        }
        },
        "versions": [
        {
            "name": "v1alpha1",
            "served": true,
            "storage": false
        },
        {
            "name": "v1beta1",
            "served": true,
            "storage": false
        },
        {
            "name": "v1",
            "served": true,
            "storage": true
        }
        ]
    }
    },
    {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "knative.dev/crd-install": "true",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "ingresses.networking.internal.knative.dev"
    },
    "spec": {
        "additionalPrinterColumns": [
        {
            "JSONPath": ".status.conditions[?(@.type=='Ready')].status",
            "name": "Ready",
            "type": "string"
        },
        {
            "JSONPath": ".status.conditions[?(@.type=='Ready')].reason",
            "name": "Reason",
            "type": "string"
        }
        ],
        "group": "networking.internal.knative.dev",
        "names": {
        "categories": [
            "knative-internal",
            "networking"
        ],
        "kind": "Ingress",
        "plural": "ingresses",
        "shortNames": [
            "kingress",
            "king"
        ],
        "singular": "ingress"
        },
        "scope": "Namespaced",
        "subresources": {
        "status": {}
        },
        "versions": [
        {
            "name": "v1alpha1",
            "served": true,
            "storage": true
        }
        ]
    }
    },
    {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "knative.dev/crd-install": "true",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "metrics.autoscaling.internal.knative.dev"
    },
    "spec": {
        "additionalPrinterColumns": [
        {
            "JSONPath": ".status.conditions[?(@.type=='Ready')].status",
            "name": "Ready",
            "type": "string"
        },
        {
            "JSONPath": ".status.conditions[?(@.type=='Ready')].reason",
            "name": "Reason",
            "type": "string"
        }
        ],
        "group": "autoscaling.internal.knative.dev",
        "names": {
        "categories": [
            "knative-internal",
            "autoscaling"
        ],
        "kind": "Metric",
        "plural": "metrics",
        "singular": "metric"
        },
        "scope": "Namespaced",
        "subresources": {
        "status": {}
        },
        "version": "v1alpha1"
    }
    },
    {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "knative.dev/crd-install": "true",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "podautoscalers.autoscaling.internal.knative.dev"
    },
    "spec": {
        "additionalPrinterColumns": [
        {
            "JSONPath": ".status.desiredScale",
            "name": "DesiredScale",
            "type": "integer"
        },
        {
            "JSONPath": ".status.actualScale",
            "name": "ActualScale",
            "type": "integer"
        },
        {
            "JSONPath": ".status.conditions[?(@.type=='Ready')].status",
            "name": "Ready",
            "type": "string"
        },
        {
            "JSONPath": ".status.conditions[?(@.type=='Ready')].reason",
            "name": "Reason",
            "type": "string"
        }
        ],
        "group": "autoscaling.internal.knative.dev",
        "names": {
        "categories": [
            "knative-internal",
            "autoscaling"
        ],
        "kind": "PodAutoscaler",
        "plural": "podautoscalers",
        "shortNames": [
            "kpa",
            "pa"
        ],
        "singular": "podautoscaler"
        },
        "scope": "Namespaced",
        "subresources": {
        "status": {}
        },
        "versions": [
        {
            "name": "v1alpha1",
            "served": true,
            "storage": true
        }
        ]
    }
    },
    {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "knative.dev/crd-install": "true",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "revisions.serving.knative.dev"
    },
    "spec": {
        "additionalPrinterColumns": [
        {
            "JSONPath": ".metadata.labels['serving\\.knative\\.dev/configuration']",
            "name": "Config Name",
            "type": "string"
        },
        {
            "JSONPath": ".status.serviceName",
            "name": "K8s Service Name",
            "type": "string"
        },
        {
            "JSONPath": ".metadata.labels['serving\\.knative\\.dev/configurationGeneration']",
            "name": "Generation",
            "type": "string"
        },
        {
            "JSONPath": ".status.conditions[?(@.type=='Ready')].status",
            "name": "Ready",
            "type": "string"
        },
        {
            "JSONPath": ".status.conditions[?(@.type=='Ready')].reason",
            "name": "Reason",
            "type": "string"
        }
        ],
        "conversion": {
        "strategy": "Webhook",
        "webhookClientConfig": {
            "service": {
            "name": "webhook",
            "namespace": knative_namespace
            }
        }
        },
        "group": "serving.knative.dev",
        "names": {
        "categories": [
            "all",
            "knative",
            "serving"
        ],
        "kind": "Revision",
        "plural": "revisions",
        "shortNames": [
            "rev"
        ],
        "singular": "revision"
        },
        "preserveUnknownFields": false,
        "scope": "Namespaced",
        "subresources": {
        "status": {}
        },
        "validation": {
        "openAPIV3Schema": {
            "type": "object",
            "x-kubernetes-preserve-unknown-fields": true
        }
        },
        "versions": [
        {
            "name": "v1alpha1",
            "served": true,
            "storage": false
        },
        {
            "name": "v1beta1",
            "served": true,
            "storage": false
        },
        {
            "name": "v1",
            "served": true,
            "storage": true
        }
        ]
    }
    },
    {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "duck.knative.dev/addressable": "true",
        "knative.dev/crd-install": "true",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "routes.serving.knative.dev"
    },
    "spec": {
        "additionalPrinterColumns": [
        {
            "JSONPath": ".status.url",
            "name": "URL",
            "type": "string"
        },
        {
            "JSONPath": ".status.conditions[?(@.type=='Ready')].status",
            "name": "Ready",
            "type": "string"
        },
        {
            "JSONPath": ".status.conditions[?(@.type=='Ready')].reason",
            "name": "Reason",
            "type": "string"
        }
        ],
        "conversion": {
        "strategy": "Webhook",
        "webhookClientConfig": {
            "service": {
            "name": "webhook",
            "namespace": knative_namespace
            }
        }
        },
        "group": "serving.knative.dev",
        "names": {
        "categories": [
            "all",
            "knative",
            "serving"
        ],
        "kind": "Route",
        "plural": "routes",
        "shortNames": [
            "rt"
        ],
        "singular": "route"
        },
        "preserveUnknownFields": false,
        "scope": "Namespaced",
        "subresources": {
        "status": {}
        },
        "validation": {
        "openAPIV3Schema": {
            "type": "object",
            "x-kubernetes-preserve-unknown-fields": true
        }
        },
        "versions": [
        {
            "name": "v1alpha1",
            "served": true,
            "storage": false
        },
        {
            "name": "v1beta1",
            "served": true,
            "storage": false
        },
        {
            "name": "v1",
            "served": true,
            "storage": true
        }
        ]
    }
    },
    {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "knative.dev/crd-install": "true",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "serverlessservices.networking.internal.knative.dev"
    },
    "spec": {
        "additionalPrinterColumns": [
        {
            "JSONPath": ".spec.mode",
            "name": "Mode",
            "type": "string"
        },
        {
            "JSONPath": ".spec.numActivators",
            "name": "Activators",
            "type": "integer"
        },
        {
            "JSONPath": ".status.serviceName",
            "name": "ServiceName",
            "type": "string"
        },
        {
            "JSONPath": ".status.privateServiceName",
            "name": "PrivateServiceName",
            "type": "string"
        },
        {
            "JSONPath": ".status.conditions[?(@.type=='Ready')].status",
            "name": "Ready",
            "type": "string"
        },
        {
            "JSONPath": ".status.conditions[?(@.type=='Ready')].reason",
            "name": "Reason",
            "type": "string"
        }
        ],
        "group": "networking.internal.knative.dev",
        "names": {
        "categories": [
            "knative-internal",
            "networking"
        ],
        "kind": "ServerlessService",
        "plural": "serverlessservices",
        "shortNames": [
            "sks"
        ],
        "singular": "serverlessservice"
        },
        "scope": "Namespaced",
        "subresources": {
        "status": {}
        },
        "versions": [
        {
            "name": "v1alpha1",
            "served": true,
            "storage": true
        }
        ]
    }
    },
    {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "duck.knative.dev/addressable": "true",
        "duck.knative.dev/podspecable": "true",
        "knative.dev/crd-install": "true",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "services.serving.knative.dev"
    },
    "spec": {
        "additionalPrinterColumns": [
        {
            "JSONPath": ".status.url",
            "name": "URL",
            "type": "string"
        },
        {
            "JSONPath": ".status.latestCreatedRevisionName",
            "name": "LatestCreated",
            "type": "string"
        },
        {
            "JSONPath": ".status.latestReadyRevisionName",
            "name": "LatestReady",
            "type": "string"
        },
        {
            "JSONPath": ".status.conditions[?(@.type=='Ready')].status",
            "name": "Ready",
            "type": "string"
        },
        {
            "JSONPath": ".status.conditions[?(@.type=='Ready')].reason",
            "name": "Reason",
            "type": "string"
        }
        ],
        "conversion": {
        "strategy": "Webhook",
        "webhookClientConfig": {
            "service": {
            "name": "webhook",
            "namespace": knative_namespace
            }
        }
        },
        "group": "serving.knative.dev",
        "names": {
        "categories": [
            "all",
            "knative",
            "serving"
        ],
        "kind": "Service",
        "plural": "services",
        "shortNames": [
            "kservice",
            "ksvc"
        ],
        "singular": "service"
        },
        "preserveUnknownFields": false,
        "scope": "Namespaced",
        "subresources": {
        "status": {}
        },
        "validation": {
        "openAPIV3Schema": {
            "type": "object",
            "x-kubernetes-preserve-unknown-fields": true
        }
        },
        "versions": [
        {
            "name": "v1alpha1",
            "served": true,
            "storage": false
        },
        {
            "name": "v1beta1",
            "served": true,
            "storage": false
        },
        {
            "name": "v1",
            "served": true,
            "storage": true
        }
        ]
    }
    },
    {
    "apiVersion": "v1",
    "kind": "ServiceAccount",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "controller",
        "namespace": knative_namespace
    }
    },
    {
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRole",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "duck.knative.dev/addressable": "true",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "knative-serving-addressable-resolver"
    },
    "rules": [
        {
        "apiGroups": [
            "serving.knative.dev"
        ],
        "resources": [
            "routes",
            "routes/status",
            "services",
            "services/status"
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
    "aggregationRule": {
        "clusterRoleSelectors": [
        {
            "matchLabels": {
            "serving.knative.dev/controller": "true"
            }
        }
        ]
    },
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRole",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "knative-serving-admin"
    },
    "rules": []
    },
    {
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRole",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "serving.knative.dev/controller": "true",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "knative-serving-core"
    },
    "rules": [
        {
        "apiGroups": [
            ""
        ],
        "resources": [
            "pods",
            "namespaces",
            "secrets",
            "configmaps",
            "endpoints",
            "services",
            "events",
            "serviceaccounts"
        ],
        "verbs": [
            "get",
            "list",
            "create",
            "update",
            "delete",
            "patch",
            "watch"
        ]
        },
        {
        "apiGroups": [
            ""
        ],
        "resources": [
            "endpoints/restricted"
        ],
        "verbs": [
            "create"
        ]
        },
        {
        "apiGroups": [
            "apps"
        ],
        "resources": [
            "deployments",
            "deployments/finalizers"
        ],
        "verbs": [
            "get",
            "list",
            "create",
            "update",
            "delete",
            "patch",
            "watch"
        ]
        },
        {
        "apiGroups": [
            "admissionregistration.k8s.io"
        ],
        "resources": [
            "mutatingwebhookconfigurations",
            "validatingwebhookconfigurations"
        ],
        "verbs": [
            "get",
            "list",
            "create",
            "update",
            "delete",
            "patch",
            "watch"
        ]
        },
        {
        "apiGroups": [
            "apiextensions.k8s.io"
        ],
        "resources": [
            "customresourcedefinitions",
            "customresourcedefinitions/status"
        ],
        "verbs": [
            "get",
            "list",
            "create",
            "update",
            "delete",
            "patch",
            "watch"
        ]
        },
        {
        "apiGroups": [
            "autoscaling"
        ],
        "resources": [
            "horizontalpodautoscalers"
        ],
        "verbs": [
            "get",
            "list",
            "create",
            "update",
            "delete",
            "patch",
            "watch"
        ]
        },
        {
        "apiGroups": [
            "coordination.k8s.io"
        ],
        "resources": [
            "leases"
        ],
        "verbs": [
            "get",
            "list",
            "create",
            "update",
            "delete",
            "patch",
            "watch"
        ]
        },
        {
        "apiGroups": [
            "serving.knative.dev",
            "autoscaling.internal.knative.dev",
            "networking.internal.knative.dev"
        ],
        "resources": [
            "*",
            "*/status",
            "*/finalizers"
        ],
        "verbs": [
            "get",
            "list",
            "create",
            "update",
            "delete",
            "deletecollection",
            "patch",
            "watch"
        ]
        },
        {
        "apiGroups": [
            "caching.internal.knative.dev"
        ],
        "resources": [
            "images"
        ],
        "verbs": [
            "get",
            "list",
            "create",
            "update",
            "delete",
            "patch",
            "watch"
        ]
        }
    ]
    },
    {
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRole",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "networking.knative.dev/ingress-provider": "istio",
        "serving.knative.dev/controller": "true",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "knative-serving-istio"
    },
    "rules": [
        {
        "apiGroups": [
            "networking.istio.io"
        ],
        "resources": [
            "virtualservices",
            "gateways"
        ],
        "verbs": [
            "get",
            "list",
            "create",
            "update",
            "delete",
            "patch",
            "watch"
        ]
        }
    ]
    },
    {
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRole",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "rbac.authorization.k8s.io/aggregate-to-admin": "true",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "knative-serving-namespaced-admin"
    },
    "rules": [
        {
        "apiGroups": [
            "serving.knative.dev",
            "networking.internal.knative.dev",
            "autoscaling.internal.knative.dev",
            "caching.internal.knative.dev"
        ],
        "resources": [
            "*"
        ],
        "verbs": [
            "*"
        ]
        }
    ]
    },
    {
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRole",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "rbac.authorization.k8s.io/aggregate-to-edit": "true",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "knative-serving-namespaced-edit"
    },
    "rules": [
        {
        "apiGroups": [
            "serving.knative.dev",
            "networking.internal.knative.dev",
            "autoscaling.internal.knative.dev",
            "caching.internal.knative.dev"
        ],
        "resources": [
            "*"
        ],
        "verbs": [
            "create",
            "update",
            "patch",
            "delete"
        ]
        }
    ]
    },
    {
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRole",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "rbac.authorization.k8s.io/aggregate-to-view": "true",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "knative-serving-namespaced-view"
    },
    "rules": [
        {
        "apiGroups": [
            "serving.knative.dev",
            "networking.internal.knative.dev",
            "autoscaling.internal.knative.dev",
            "caching.internal.knative.dev"
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
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRole",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "duck.knative.dev/podspecable": "true",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "knative-serving-podspecable-binding"
    },
    "rules": [
        {
        "apiGroups": [
            "serving.knative.dev"
        ],
        "resources": [
            "configurations",
            "services"
        ],
        "verbs": [
            "list",
            "watch",
            "patch"
        ]
        }
    ]
    },
    {
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRoleBinding",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "knative-serving-controller-admin"
    },
    "roleRef": {
        "apiGroup": "rbac.authorization.k8s.io",
        "kind": "ClusterRole",
        "name": "knative-serving-admin"
    },
    "subjects": [
        {
        "kind": "ServiceAccount",
        "name": "controller",
        "namespace": knative_namespace
        }
    ]
    },
    {
    "apiVersion": "v1",
    "kind": "Secret",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knativels-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "istio-webhook-certs",
        "namespace": knative_namespace
    }
    },
    {
    "apiVersion": "v1",
    "kind": "Secret",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "webhook-certs",
        "namespace": knative_namespace
    }
    },
    {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
        "labels": {
        "app": "activator",
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "activator-service",
        "namespace": knative_namespace
    },
    "spec": {
        "ports": [
        {
            "name": "http",
            "port": 80,
            "targetPort": 8012
        },
        {
            "name": "http2",
            "port": 81,
            "targetPort": 8013
        },
        {
            "name": "http-profiling",
            "port": 8008,
            "targetPort": 8008
        },
        {
            "name": "http-metrics",
            "port": 9090,
            "targetPort": 9090
        }
        ],
        "selector": {
        "app": "activator",
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative"
        },
        "type": "ClusterIP"
    }
    },
    {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
        "labels": {
        "app": "autoscaler",
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "autoscaler",
        "namespace": knative_namespace
    },
    "spec": {
        "ports": [
        {
            "name": "http",
            "port": 8080,
            "targetPort": 8080
        },
        {
            "name": "http-profiling",
            "port": 8008,
            "targetPort": 8008
        },
        {
            "name": "http-metrics",
            "port": 9090,
            "targetPort": 9090
        },
        {
            "name": "https-custom-metrics",
            "port": 443,
            "targetPort": 8443
        }
        ],
        "selector": {
        "app": "autoscaler",
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative"
        }
    }
    },
    {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
        "labels": {
        "app": "controller",
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "controller",
        "namespace": knative_namespace
    },
    "spec": {
        "ports": [
        {
            "name": "http-profiling",
            "port": 8008,
            "targetPort": 8008
        },
        {
            "name": "http-metrics",
            "port": 9090,
            "targetPort": 9090
        }
        ],
        "selector": {
        "app": "controller",
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative"
        }
    }
    },
    {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "role": "istio-webhook",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "istio-webhook",
        "namespace": knative_namespace
    },
    "spec": {
        "ports": [
        {
            "name": "http-metrics",
            "port": 9090,
            "targetPort": 9090
        },
        {
            "name": "http-profiling",
            "port": 8008,
            "targetPort": 8008
        },
        {
            "name": "https-webhook",
            "port": 443,
            "targetPort": 8443
        }
        ],
        "selector": {
        "app": "istio-webhook",
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative"
        }
    }
    },
    {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "role": "webhook",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "webhook",
        "namespace": knative_namespace
    },
    "spec": {
        "ports": [
        {
            "name": "http-metrics",
            "port": 9090,
            "targetPort": 9090
        },
        {
            "name": "http-profiling",
            "port": 8008,
            "targetPort": 8008
        },
        {
            "name": "https-webhook",
            "port": 443,
            "targetPort": 8443
        }
        ],
        "selector": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "role": "webhook"
        }
    }
    },
    {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "activator",
        "namespace": knative_namespace
    },
    "spec": {
        "selector": {
        "matchLabels": {
            "app": "activator",
            "app.kubernetes.io/component": "knative-serving-install",
            "app.kubernetes.io/name": "knative-serving-install",
            "kustomize.component": "knative",
            "role": "activator"
        }
        },
        "template": {
        "metadata": {
            "annotations": {
            "cluster-autoscaler.kubernetes.io/safe-to-evict": "false"
            },
            "labels": {
            "app": "activator",
            "app.kubernetes.io/component": "knative-serving-install",
            "app.kubernetes.io/name": "knative-serving-install",
            "kustomize.component": "knative",
            "role": "activator",
            "serving.knative.dev/release": "v0.14.3"
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
                "image": std.join("", [target_registry, "gcr.io/knative-releases/knative.dev/serving/cmd/activator:", knative_serving_image_tag]),
                "livenessProbe": {
                "httpGet": {
                    "httpHeaders": [
                    {
                        "name": "k-kubelet-probe",
                        "value": "activator"
                    }
                    ],
                    "port": 8012
                }
                },
                "name": "activator",
                "ports": [
                {
                    "containerPort": 8012,
                    "name": "http1"
                },
                {
                    "containerPort": 8013,
                    "name": "h2c"
                },
                {
                    "containerPort": 9090,
                    "name": "metrics"
                },
                {
                    "containerPort": 8008,
                    "name": "profiling"
                }
                ],
                "readinessProbe": {
                "httpGet": {
                    "httpHeaders": [
                    {
                        "name": "k-kubelet-probe",
                        "value": "activator"
                    }
                    ],
                    "port": 8012
                }
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
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "autoscaler",
        "namespace": knative_namespace
    },
    "spec": {
        "replicas": 1,
        "selector": {
        "matchLabels": {
            "app": "autoscaler",
            "app.kubernetes.io/component": "knative-serving-install",
            "app.kubernetes.io/name": "knative-serving-install",
            "kustomize.component": "knative"
        }
        },
        "template": {
        "metadata": {
            "annotations": {
            "cluster-autoscaler.kubernetes.io/safe-to-evict": "false"
            },
            "labels": {
            "app": "autoscaler",
            "app.kubernetes.io/component": "knative-serving-install",
            "app.kubernetes.io/name": "knative-serving-install",
            "kustomize.component": "knative",
            "serving.knative.dev/release": "v0.14.3"
            }
        },
        "spec": {
            "containers": [
            {
                "args": [
                "--secure-port=8443",
                "--cert-dir=/tmp"
                ],
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
                "image": std.join("", [target_registry, "gcr.io/knative-releases/knative.dev/serving/cmd/autoscaler:", knative_serving_image_tag]),
                "livenessProbe": {
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
                    "containerPort": 8080,
                    "name": "websocket"
                },
                {
                    "containerPort": 9090,
                    "name": "metrics"
                },
                {
                    "containerPort": 8443,
                    "name": "custom-metrics"
                },
                {
                    "containerPort": 8008,
                    "name": "profiling"
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
                    "cpu": "300m",
                    "memory": "400Mi"
                },
                "requests": {
                    "cpu": "30m",
                    "memory": "40Mi"
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
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "controller",
        "namespace": knative_namespace
    },
    "spec": {
        "selector": {
        "matchLabels": {
            "app": "controller",
            "app.kubernetes.io/component": "knative-serving-install",
            "app.kubernetes.io/name": "knative-serving-install",
            "kustomize.component": "knative"
        }
        },
        "template": {
        "metadata": {
            "annotations": {
            "cluster-autoscaler.kubernetes.io/safe-to-evict": "true"
            },
            "labels": {
            "app": "controller",
            "app.kubernetes.io/component": "knative-serving-install",
            "app.kubernetes.io/name": "knative-serving-install",
            "kustomize.component": "knative",
            "serving.knative.dev/release": "v0.14.3"
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
                    "value": "knative.dev/internal/serving"
                }
                ],
                "image": std.join("", [target_registry, "gcr.io/knative-releases/knative.dev/serving/cmd/controller:", knative_serving_image_tag]),
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
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "istio-webhook",
        "namespace": knative_namespace
    },
    "spec": {
        "selector": {
        "matchLabels": {
            "app": "istio-webhook",
            "app.kubernetes.io/component": "knative-serving-install",
            "app.kubernetes.io/name": "knative-serving-install",
            "kustomize.component": "knative",
            "role": "istio-webhook"
        }
        },
        "template": {
        "metadata": {
            "annotations": {
            "cluster-autoscaler.kubernetes.io/safe-to-evict": "false"
            },
            "labels": {
            "app": "istio-webhook",
            "app.kubernetes.io/component": "knative-serving-install",
            "app.kubernetes.io/name": "knative-serving-install",
            "kustomize.component": "knative",
            "role": "istio-webhook",
            "serving.knative.dev/release": "v0.14.3"
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
                    "value": "istio-webhook"
                }
                ],
                "image": std.join("", [target_registry, "gcr.io/knative-releases/knative.dev/net-istio/cmd/webhook:", knative_istio_image_tag]),
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
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "networking.knative.dev/ingress-provider": "istio",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "networking-istio",
        "namespace": knative_namespace
    },
    "spec": {
        "selector": {
        "matchLabels": {
            "app": "networking-istio",
            "app.kubernetes.io/component": "knative-serving-install",
            "app.kubernetes.io/name": "knative-serving-install",
            "kustomize.component": "knative"
        }
        },
        "template": {
        "metadata": {
            "annotations": {
            "cluster-autoscaler.kubernetes.io/safe-to-evict": "true",
            "sidecar.istio.io/inject": "false"
            },
            "labels": {
            "app": "networking-istio",
            "app.kubernetes.io/component": "knative-serving-install",
            "app.kubernetes.io/name": "knative-serving-install",
            "kustomize.component": "knative",
            "serving.knative.dev/release": "v0.14.3"
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
                "image": std.join("", [target_registry, "gcr.io/knative-releases/knative.dev/net-istio/cmd/controller:", knative_istio_image_tag]),
                "name": "networking-istio",
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
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "webhook",
        "namespace": knative_namespace
    },
    "spec": {
        "selector": {
        "matchLabels": {
            "app": "webhook",
            "app.kubernetes.io/component": "knative-serving-install",
            "app.kubernetes.io/name": "knative-serving-install",
            "kustomize.component": "knative",
            "role": "webhook"
        }
        },
        "template": {
        "metadata": {
            "annotations": {
            "cluster-autoscaler.kubernetes.io/safe-to-evict": "false"
            },
            "labels": {
            "app": "webhook",
            "app.kubernetes.io/component": "knative-serving-install",
            "app.kubernetes.io/name": "knative-serving-install",
            "kustomize.component": "knative",
            "role": "webhook",
            "serving.knative.dev/release": "v0.14.3"
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
                    "value": "knative.dev/serving"
                }
                ],
                "image": std.join("", [target_registry, "gcr.io/knative-releases/knative.dev/serving/cmd/webhook:", knative_serving_image_tag]),
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
    "apiVersion": "app.k8s.io/v1beta1",
    "kind": "Application",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative"
        },
        "name": "knative-serving-crds",
        "namespace": knative_namespace
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
            "knative-serving-crds",
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
        "type": "knative-serving-crds",
        "version": "v1beta1"
        },
        "selector": {
        "matchLabels": {
            "app.kubernetes.io/component": "knative-serving-crds",
            "app.kubernetes.io/name": "knative-serving-crds"
        }
        }
    }
    },
    {
    "apiVersion": "app.k8s.io/v1beta1",
    "kind": "Application",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative"
        },
        "name": "knative-serving-install",
        "namespace": knative_namespace
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
            "knative-serving-install",
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
        "type": "knative-serving-install",
        "version": "v1beta1"
        },
        "selector": {
        "matchLabels": {
            "app.kubernetes.io/component": "knative-serving-install",
            "app.kubernetes.io/name": "knative-serving-install"
        }
        }
    }
    },
    {
    "apiVersion": "autoscaling/v2beta1",
    "kind": "HorizontalPodAutoscaler",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "activator",
        "namespace": knative_namespace
    },
    "spec": {
        "maxReplicas": 20,
        "metrics": [
        {
            "resource": {
            "name": "cpu",
            "targetAverageUtilization": 100
            },
            "type": "Resource"
        }
        ],
        "minReplicas": 1,
        "scaleTargetRef": {
        "apiVersion": "apps/v1",
        "kind": "Deployment",
        "name": "activator"
        }
    }
    },
    {
    "apiVersion": "networking.istio.io/v1alpha3",
    "kind": "Gateway",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "networking.knative.dev/ingress-provider": "istio",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "cluster-local-gateway",
        "namespace": knative_namespace
    },
    "spec": {
        "selector": {
        "istio": "cluster-local-gateway"
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
    "apiVersion": "rbac.istio.io/v1alpha1",
    "kind": "ServiceRole",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative"
        },
        "name": "istio-service-role",
        "namespace": knative_namespace
    },
    "spec": {
        "rules": [
        {
            "methods": [
            "*"
            ],
            "services": [
            "*"
            ]
        }
        ]
    }
    },
    {
    "apiVersion": "rbac.istio.io/v1alpha1",
    "kind": "ServiceRoleBinding",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative"
        },
        "name": "istio-service-role-binding",
        "namespace": knative_namespace
    },
    "spec": {
        "roleRef": {
        "kind": "ServiceRole",
        "name": "istio-service-role"
        },
        "subjects": [
        {
            "user": "*"
        }
        ]
    }
    },
    {
    "apiVersion": "admissionregistration.k8s.io/v1beta1",
    "kind": "MutatingWebhookConfiguration",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "webhook.istio.networking.internal.knative.dev"
    },
    "webhooks": [
        {
        "admissionReviewVersions": [
            "v1beta1"
        ],
        "clientConfig": {
            "service": {
            "name": "istio-webhook",
            "namespace": knative_namespace
            }
        },
        "failurePolicy": "Fail",
        "name": "webhook.istio.networking.internal.knative.dev",
        "objectSelector": {
            "matchExpressions": [
            {
                "key": "serving.knative.dev/configuration",
                "operator": "Exists"
            }
            ]
        },
        "sideEffects": "None"
        }
    ]
    },
    {
    "apiVersion": "admissionregistration.k8s.io/v1beta1",
    "kind": "MutatingWebhookConfiguration",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "webhook.serving.knative.dev"
    },
    "webhooks": [
        {
        "admissionReviewVersions": [
            "v1beta1"
        ],
        "clientConfig": {
            "service": {
            "name": "webhook",
            "namespace": knative_namespace
            }
        },
        "failurePolicy": "Fail",
        "name": "webhook.serving.knative.dev",
        "sideEffects": "None"
        }
    ]
    },
    {
    "apiVersion": "admissionregistration.k8s.io/v1beta1",
    "kind": "ValidatingWebhookConfiguration",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "config.webhook.istio.networking.internal.knative.dev"
    },
    "webhooks": [
        {
        "admissionReviewVersions": [
            "v1beta1"
        ],
        "clientConfig": {
            "service": {
            "name": "istio-webhook",
            "namespace": knative_namespace
            }
        },
        "failurePolicy": "Fail",
        "name": "config.webhook.istio.networking.internal.knative.dev",
        "namespaceSelector": {
            "matchExpressions": [
            {
                "key": "serving.knative.dev/release",
                "operator": "Exists"
            }
            ]
        },
        "sideEffects": "None"
        }
    ]
    },
    {
    "apiVersion": "admissionregistration.k8s.io/v1beta1",
    "kind": "ValidatingWebhookConfiguration",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "config.webhook.serving.knative.dev"
    },
    "webhooks": [
        {
        "admissionReviewVersions": [
            "v1beta1"
        ],
        "clientConfig": {
            "service": {
            "name": "webhook",
            "namespace": knative_namespace
            }
        },
        "failurePolicy": "Fail",
        "name": "config.webhook.serving.knative.dev",
        "namespaceSelector": {
            "matchExpressions": [
            {
                "key": "serving.knative.dev/release",
                "operator": "Exists"
            }
            ]
        },
        "sideEffects": "None"
        }
    ]
    },
    {
    "apiVersion": "admissionregistration.k8s.io/v1beta1",
    "kind": "ValidatingWebhookConfiguration",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "validation.webhook.serving.knative.dev"
    },
    "webhooks": [
        {
        "admissionReviewVersions": [
            "v1beta1"
        ],
        "clientConfig": {
            "service": {
            "name": "webhook",
            "namespace": knative_namespace
            }
        },
        "failurePolicy": "Fail",
        "name": "validation.webhook.serving.knative.dev",
        "sideEffects": "None"
        }
    ]
    },
    {
    "apiVersion": "v1",
    "data": null,
    "kind": "ConfigMap",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "config-autoscaler",
        "namespace": knative_namespace
    }
    },
    {
    "apiVersion": "v1",
    "data": null,
    "kind": "ConfigMap",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "config-defaults",
        "namespace": knative_namespace
    }
    },
    {
    "apiVersion": "v1",
    "data": {
        "queueSidecarImage": std.join("", [target_registry, "gcr.io/knative-releases/knative.dev/serving/cmd/queue:", knative_serving_image_tag])
    },
    "kind": "ConfigMap",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "config-deployment",
        "namespace": knative_namespace
    }
    },
    {
    "apiVersion": "v1",
    "data": null,
    "kind": "ConfigMap",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "config-domain",
        "namespace": knative_namespace
    }
    },
    {
    "apiVersion": "v1",
    "data": {
        "progressDeadline": "600s",
        "registriesSkippingTagResolving": "nvcr.io"
    },
    "kind": "ConfigMap",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "config-gc",
        "namespace": knative_namespace
    }
    },
    {
    "apiVersion": "v1",
    "data": {
        "gateway.kubeflow.kubeflow-gateway": "istio-ingressgateway.istio-system.svc.cluster.local",
        "local-gateway.knative-serving.cluster-local-gateway": "cluster-local-gateway.istio-system.svc.cluster.local",
        "local-gateway.mesh": "mesh"
    },
    "kind": "ConfigMap",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "networking.knative.dev/ingress-provider": "istio",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "config-istio",
        "namespace": knative_namespace
    }
    },
    {
    "apiVersion": "v1",
    "data": {
        "leaseDuration": "15s",
        "renewDeadline": "10s",
        "resourceLock": "leases",
        "retryPeriod": "2s"
    },
    "kind": "ConfigMap",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "config-leader-election",
        "namespace": knative_namespace
    }
    },
    {
    "apiVersion": "v1",
    "data": null,
    "kind": "ConfigMap",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "config-logging",
        "namespace": knative_namespace
    }
    },
    {
    "apiVersion": "v1",
    "data": null,
    "kind": "ConfigMap",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "config-network",
        "namespace": knative_namespace
    }
    },
    {
    "apiVersion": "v1",
    "data": null,
    "kind": "ConfigMap",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "config-observability",
        "namespace": knative_namespace
    }
    },
    {
    "apiVersion": "v1",
    "data": null,
    "kind": "ConfigMap",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "config-tracing",
        "namespace": knative_namespace
    }
    },
    {
    "apiVersion": "caching.internal.knative.dev/v1alpha1",
    "kind": "Image",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "knative-serving-install",
        "app.kubernetes.io/name": "knative-serving-install",
        "kustomize.component": "knative",
        "serving.knative.dev/release": "v0.14.3"
        },
        "name": "queue-proxy",
        "namespace": knative_namespace
    },
    "spec": {
        "image": std.join("", [target_registry, "gcr.io/knative-releases/knative.dev/serving/cmd/queue:", knative_serving_image_tag])
    }
    },
    {
    "apiVersion": "v1",
    "kind": "Secret",
    "metadata": {
        "name": "controller-token",
        "namespace": knative_namespace,
        "annotations": {
        "kubernetes.io/service-account.name": "controller"
        }
    },
    "type": "kubernetes.io/service-account-token"
    }
]    