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

[
    {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "creationTimestamp": null,
        "labels": {
        "app.kubernetes.io/component": "kubeflow",
        "app.kubernetes.io/name": "kubeflow"
        },
        "name": "applications.app.k8s.io"
    },
    "spec": {
        "group": "app.k8s.io",
        "names": {
        "kind": "Application",
        "plural": "applications"
        },
        "scope": "Namespaced",
        "validation": {
        "openAPIV3Schema": {
            "properties": {
            "apiVersion": {
                "type": "string"
            },
            "kind": {
                "type": "string"
            },
            "metadata": {
                "type": "object"
            },
            "spec": {
                "properties": {
                "addOwnerRef": {
                    "type": "boolean"
                },
                "assemblyPhase": {
                    "type": "string"
                },
                "componentKinds": {
                    "items": {
                    "type": "object"
                    },
                    "type": "array"
                },
                "descriptor": {
                    "properties": {
                    "description": {
                        "type": "string"
                    },
                    "icons": {
                        "items": {
                        "properties": {
                            "size": {
                            "type": "string"
                            },
                            "src": {
                            "type": "string"
                            },
                            "type": {
                            "type": "string"
                            }
                        },
                        "required": [
                            "src"
                        ],
                        "type": "object"
                        },
                        "type": "array"
                    },
                    "keywords": {
                        "items": {
                        "type": "string"
                        },
                        "type": "array"
                    },
                    "links": {
                        "items": {
                        "properties": {
                            "description": {
                            "type": "string"
                            },
                            "url": {
                            "type": "string"
                            }
                        },
                        "type": "object"
                        },
                        "type": "array"
                    },
                    "maintainers": {
                        "items": {
                        "properties": {
                            "email": {
                            "type": "string"
                            },
                            "name": {
                            "type": "string"
                            },
                            "url": {
                            "type": "string"
                            }
                        },
                        "type": "object"
                        },
                        "type": "array"
                    },
                    "notes": {
                        "type": "string"
                    },
                    "owners": {
                        "items": {
                        "properties": {
                            "email": {
                            "type": "string"
                            },
                            "name": {
                            "type": "string"
                            },
                            "url": {
                            "type": "string"
                            }
                        },
                        "type": "object"
                        },
                        "type": "array"
                    },
                    "type": {
                        "type": "string"
                    },
                    "version": {
                        "type": "string"
                    }
                    },
                    "type": "object"
                },
                "info": {
                    "items": {
                    "properties": {
                        "name": {
                        "type": "string"
                        },
                        "type": {
                        "type": "string"
                        },
                        "value": {
                        "type": "string"
                        },
                        "valueFrom": {
                        "properties": {
                            "configMapKeyRef": {
                            "properties": {
                                "apiVersion": {
                                "type": "string"
                                },
                                "fieldPath": {
                                "type": "string"
                                },
                                "key": {
                                "type": "string"
                                },
                                "kind": {
                                "type": "string"
                                },
                                "name": {
                                "type": "string"
                                },
                                "namespace": {
                                "type": "string"
                                },
                                "resourceVersion": {
                                "type": "string"
                                },
                                "uid": {
                                "type": "string"
                                }
                            },
                            "type": "object"
                            },
                            "ingressRef": {
                            "properties": {
                                "apiVersion": {
                                "type": "string"
                                },
                                "fieldPath": {
                                "type": "string"
                                },
                                "host": {
                                "type": "string"
                                },
                                "kind": {
                                "type": "string"
                                },
                                "name": {
                                "type": "string"
                                },
                                "namespace": {
                                "type": "string"
                                },
                                "path": {
                                "type": "string"
                                },
                                "resourceVersion": {
                                "type": "string"
                                },
                                "uid": {
                                "type": "string"
                                }
                            },
                            "type": "object"
                            },
                            "secretKeyRef": {
                            "properties": {
                                "apiVersion": {
                                "type": "string"
                                },
                                "fieldPath": {
                                "type": "string"
                                },
                                "key": {
                                "type": "string"
                                },
                                "kind": {
                                "type": "string"
                                },
                                "name": {
                                "type": "string"
                                },
                                "namespace": {
                                "type": "string"
                                },
                                "resourceVersion": {
                                "type": "string"
                                },
                                "uid": {
                                "type": "string"
                                }
                            },
                            "type": "object"
                            },
                            "serviceRef": {
                            "properties": {
                                "apiVersion": {
                                "type": "string"
                                },
                                "fieldPath": {
                                "type": "string"
                                },
                                "kind": {
                                "type": "string"
                                },
                                "name": {
                                "type": "string"
                                },
                                "namespace": {
                                "type": "string"
                                },
                                "path": {
                                "type": "string"
                                },
                                "port": {
                                "format": "int32",
                                "type": "integer"
                                },
                                "resourceVersion": {
                                "type": "string"
                                },
                                "uid": {
                                "type": "string"
                                }
                            },
                            "type": "object"
                            },
                            "type": {
                            "type": "string"
                            }
                        },
                        "type": "object"
                        }
                    },
                    "type": "object"
                    },
                    "type": "array"
                },
                "selector": {
                    "type": "object"
                }
                },
                "type": "object"
            },
            "status": {
                "properties": {
                "components": {
                    "items": {
                    "properties": {
                        "group": {
                        "type": "string"
                        },
                        "kind": {
                        "type": "string"
                        },
                        "link": {
                        "type": "string"
                        },
                        "name": {
                        "type": "string"
                        },
                        "status": {
                        "type": "string"
                        }
                    },
                    "type": "object"
                    },
                    "type": "array"
                },
                "conditions": {
                    "items": {
                    "properties": {
                        "lastTransitionTime": {
                        "format": "date-time",
                        "type": "string"
                        },
                        "lastUpdateTime": {
                        "format": "date-time",
                        "type": "string"
                        },
                        "message": {
                        "type": "string"
                        },
                        "reason": {
                        "type": "string"
                        },
                        "status": {
                        "type": "string"
                        },
                        "type": {
                        "type": "string"
                        }
                    },
                    "required": [
                        "type",
                        "status"
                    ],
                    "type": "object"
                    },
                    "type": "array"
                },
                "observedGeneration": {
                    "format": "int64",
                    "type": "integer"
                }
                },
                "type": "object"
            }
            }
        }
        },
        "version": "v1beta1"
    }
    },
    {
    "apiVersion": "v1",
    "kind": "ServiceAccount",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "kubeflow",
        "app.kubernetes.io/name": "kubeflow"
        },
        "name": "application-controller-service-account",
        "namespace": ai_devops_namespace
    }
    },
    {
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRole",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "kubeflow",
        "app.kubernetes.io/name": "kubeflow"
        },
        "name": "application-controller-cluster-role"
    },
    "rules": [
        {
        "apiGroups": [
            "*"
        ],
        "resources": [
            "*"
        ],
        "verbs": [
            "get",
            "list",
            "update",
            "patch",
            "watch"
        ]
        },
        {
        "apiGroups": [
            "app.k8s.io"
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
    "kind": "ClusterRoleBinding",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "kubeflow",
        "app.kubernetes.io/name": "kubeflow"
        },
        "name": "application-controller-cluster-role-binding"
    },
    "roleRef": {
        "apiGroup": "rbac.authorization.k8s.io",
        "kind": "ClusterRole",
        "name": "application-controller-cluster-role"
    },
    "subjects": [
        {
        "kind": "ServiceAccount",
        "name": "application-controller-service-account",
        "namespace": ai_devops_namespace
        }
    ]
    },
    {
    "apiVersion": "v1",
    "data": {
        "project": ""
    },
    "kind": "ConfigMap",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "kubeflow",
        "app.kubernetes.io/name": "kubeflow"
        },
        "name": "application-controller-parameters",
        "namespace": ai_devops_namespace
    }
    },
    {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "kubeflow",
        "app.kubernetes.io/name": "kubeflow"
        },
        "name": "application-controller-service",
        "namespace": ai_devops_namespace
    },
    "spec": {
        "ports": [
        {
            "port": 443
        }
        ],
        "selector": {
        "app.kubernetes.io/component": "kubeflow",
        "app.kubernetes.io/name": "kubeflow"
        }
    }
    },
    {
    "apiVersion": "apps/v1",
    "kind": "StatefulSet",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "kubeflow",
        "app.kubernetes.io/name": "kubeflow"
        },
        "name": "application-controller-stateful-set",
        "namespace": ai_devops_namespace
    },
    "spec": {
        "selector": {
        "matchLabels": {
            "app": "application-controller",
            "app.kubernetes.io/component": "kubeflow",
            "app.kubernetes.io/name": "kubeflow"
        }
        },
        "serviceName": "application-controller-service",
        "template": {
        "metadata": {
            "annotations": {
            "sidecar.istio.io/inject": "false"
            },
            "labels": {
            "app": "application-controller",
            "app.kubernetes.io/component": "kubeflow",
            "app.kubernetes.io/name": "kubeflow"
            }
        },
        "spec": {
            "containers": [
            {
                "command": [
                "/root/manager"
                ],
                "env": [
                {
                    "name": "project",
                    "value": ""
                }
                ],
                "image": std.join("", [target_registry, "gcr.io/kubeflow-images-public/kubernetes-sigs/application:1.0-beta"]),
                "imagePullPolicy": "Always",
                "name": "manager",
                "volumeMounts": [
                {
                    "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                    "name": "application-controller-service-account-token",
                    "readOnly": true
                }           
                ]
            }
            ],
            "volumes": [
            {
                "name": "application-controller-service-account-token",
                "secret": {
                "defaultMode": 420,
                "secretName": "application-controller-service-account-token"
                }
            }        
            ]
        }
        },
        "volumeClaimTemplates": []
    }
    },
    {
    "apiVersion": "v1",
    "kind": "Secret",
    "metadata": {
        "name": "application-controller-service-account-token",
        "namespace": ai_devops_namespace,
        "annotations": {
        "kubernetes.io/service-account.name": "application-controller-service-account"
        }
    },
    "type": "kubernetes.io/service-account-token"
    }
]