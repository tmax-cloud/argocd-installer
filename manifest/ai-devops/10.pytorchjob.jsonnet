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
        "annotations": {
        "argocd.argoproj.io/sync-options": "Replace=true"
        },        
        "name": "pytorchjobs.kubeflow.org"
    },
    "spec": {
        "additionalPrinterColumns": [
        {
            "JSONPath": ".status.conditions[-1:].type",
            "name": "State",
            "type": "string"
        },
        {
            "JSONPath": ".metadata.creationTimestamp",
            "name": "Age",
            "type": "date"
        }
        ],
        "group": "kubeflow.org",
        "names": {
        "kind": "PyTorchJob",
        "plural": "pytorchjobs",
        "singular": "pytorchjob"
        },
        "scope": "Namespaced",
        "subresources": {
        "status": {}
        },
        "validation": {
        "openAPIV3Schema": {
            "type": "object",
            "properties": {
            "spec": {
                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec",
                "type": "object",
                "properties": {
                "activeDeadlineSeconds": {
                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.activeDeadlineSeconds",
                    "type": "integer",
                    "format": "int64"
                },
                "backoffLimit": {
                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.backoffLimit",
                    "type": "integer",
                    "format": "int32"
                },
                "cleanPodPolicy": {
                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.cleanPodPolicy",
                    "type": "string"
                },
                "ttlSecondsAfterFinished": {
                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.ttlSecondsAfterFinished",
                    "type": "integer",
                    "format": "int32"
                },
                "pytorchReplicaSpecs": {
                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs",
                    "type": "object",
                    "properties": {
                    "Master": {
                        "type": "object",
                        "properties": {
                        "replicas": {
                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.replicas",
                            "maximum": 1,
                            "minimum": 1,
                            "type": "integer"
                        },
                        "restartPolicy": {
                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.restartPolicy",
                            "type": "string"
                        },
                        "template": {
                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template",
                            "type": "object",
                            "properties": {
                            "metadata": {
                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.metadata",
                                "type": "object",
                                "properties": {
                                "annotations": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.metadata.properties.annotations",
                                    "type": "object",
                                    "additionalProperties": {
                                    "type": "string"
                                    }
                                },
                                "clusterName": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.metadata.properties.clusterName",
                                    "type": "string"
                                },
                                "creationTimestamp": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.metadata.properties.creationTimestamp",
                                    "type": "string",
                                    "format": "date-time"
                                },
                                "deletionGracePeriodSeconds": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.metadata.properties.deletionGracePeriodSeconds",
                                    "type": "integer"
                                },
                                "deletionTimestamp": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.metadata.properties.deletionTimestamp",
                                    "type": "string",
                                    "format": "date-time"
                                },
                                "finalizers": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.metadata.properties.finalizers",
                                    "type": "array",
                                    "items": {
                                    "type": "string"
                                    }
                                },
                                "generateName": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.metadata.properties.generateName",
                                    "type": "string"
                                },
                                "generation": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.metadata.properties.generation",
                                    "type": "integer"
                                },
                                "labels": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.metadata.properties.labels",
                                    "type": "object",
                                    "additionalProperties": {
                                    "type": "string"
                                    }
                                },
                                "managedFields": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.metadata.properties.managedFields",
                                    "type": "array",
                                    "items": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.metadata.properties.managedFields.items",
                                    "type": "object",
                                    "properties": {
                                        "apiVersion": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.metadata.properties.managedFields.items.properties.apiVersion",
                                        "type": "string"
                                        },
                                        "fieldsType": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.metadata.properties.managedFields.items.properties.fieldsType",
                                        "type": "string"
                                        },
                                        "fieldsV1": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.metadata.properties.managedFields.items.properties.fieldsV1",
                                        "type": "object"
                                        },
                                        "manager": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.metadata.properties.managedFields.items.properties.manager",
                                        "type": "string"
                                        },
                                        "operation": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.metadata.properties.managedFields.items.properties.operation",
                                        "type": "string"
                                        },
                                        "time": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.metadata.properties.managedFields.items.properties.time",
                                        "type": "string",
                                        "format": "date-time"
                                        }
                                    }
                                    }
                                },
                                "name": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.metadata.properties.name",
                                    "type": "string"
                                },
                                "namespace": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.metadata.properties.namespace",
                                    "type": "string"
                                },
                                "ownerReferences": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.metadata.properties.ownerReferences",
                                    "type": "array",
                                    "items": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.metadata.properties.ownerReferences.items",
                                    "type": "object",
                                    "required": [
                                        "apiVersion",
                                        "kind",
                                        "name",
                                        "uid"
                                    ],
                                    "properties": {
                                        "apiVersion": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.metadata.properties.ownerReferences.items.properties.apiVersion",
                                        "type": "string"
                                        },
                                        "blockOwnerDeletion": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.metadata.properties.ownerReferences.items.properties.blockOwnerDeletion",
                                        "type": "boolean"
                                        },
                                        "controller": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.metadata.properties.ownerReferences.items.properties.controller",
                                        "type": "boolean"
                                        },
                                        "kind": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.metadata.properties.ownerReferences.items.properties.kind",
                                        "type": "string"
                                        },
                                        "name": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.metadata.properties.ownerReferences.items.properties.name",
                                        "type": "string"
                                        },
                                        "uid": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.metadata.properties.ownerReferences.items.properties.uid",
                                        "type": "string"
                                        }
                                    }
                                    }
                                },
                                "resourceVersion": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.metadata.properties.resourceVersion",
                                    "type": "string"
                                },
                                "selfLink": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.metadata.properties.selfLink",
                                    "type": "string"
                                },
                                "uid": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.metadata.properties.uid",
                                    "type": "string"
                                }
                                }
                            },
                            "spec": {
                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec",
                                "type": "object",
                                "required": [
                                "containers"
                                ],
                                "properties": {
                                "activeDeadlineSeconds": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.activeDeadlineSeconds",
                                    "type": "integer",
                                    "format": "int64"
                                },
                                "affinity": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity",
                                    "type": "object",
                                    "properties": {
                                    "nodeAffinity": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.nodeAffinity",
                                        "type": "object",
                                        "properties": {
                                        "preferredDuringSchedulingIgnoredDuringExecution": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution",
                                            "type": "array",
                                            "items": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items",
                                            "type": "object",
                                            "required": [
                                                "weight",
                                                "preference"
                                            ],
                                            "properties": {
                                                "preference": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.preference",
                                                "type": "object",
                                                "properties": {
                                                    "matchExpressions": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.preference.properties.matchExpressions",
                                                    "type": "array",
                                                    "items": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.preference.properties.matchExpressions.items",
                                                        "type": "object",
                                                        "required": [
                                                        "key",
                                                        "operator"
                                                        ],
                                                        "properties": {
                                                        "key": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.preference.properties.matchExpressions.items.properties.key",
                                                            "type": "string"
                                                        },
                                                        "operator": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.preference.properties.matchExpressions.items.properties.operator",
                                                            "type": "string"
                                                        },
                                                        "values": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.preference.properties.matchExpressions.items.properties.values",
                                                            "type": "array",
                                                            "items": {
                                                            "type": "string"
                                                            }
                                                        }
                                                        }
                                                    }
                                                    },
                                                    "matchFields": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.preference.properties.matchFields",
                                                    "type": "array",
                                                    "items": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.preference.properties.matchFields.items",
                                                        "type": "object",
                                                        "required": [
                                                        "key",
                                                        "operator"
                                                        ],
                                                        "properties": {
                                                        "key": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.preference.properties.matchFields.items.properties.key",
                                                            "type": "string"
                                                        },
                                                        "operator": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.preference.properties.matchFields.items.properties.operator",
                                                            "type": "string"
                                                        },
                                                        "values": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.preference.properties.matchFields.items.properties.values",
                                                            "type": "array",
                                                            "items": {
                                                            "type": "string"
                                                            }
                                                        }
                                                        }
                                                    }
                                                    }
                                                }
                                                },
                                                "weight": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.weight",
                                                "type": "integer"
                                                }
                                            }
                                            }
                                        },
                                        "requiredDuringSchedulingIgnoredDuringExecution": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution",
                                            "type": "object",
                                            "required": [
                                            "nodeSelectorTerms"
                                            ],
                                            "properties": {
                                            "nodeSelectorTerms": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms",
                                                "type": "array",
                                                "items": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms.items",
                                                "type": "object",
                                                "properties": {
                                                    "matchExpressions": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms.items.properties.matchExpressions",
                                                    "type": "array",
                                                    "items": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms.items.properties.matchExpressions.items",
                                                        "type": "object",
                                                        "required": [
                                                        "key",
                                                        "operator"
                                                        ],
                                                        "properties": {
                                                        "key": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms.items.properties.matchExpressions.items.properties.key",
                                                            "type": "string"
                                                        },
                                                        "operator": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms.items.properties.matchExpressions.items.properties.operator",
                                                            "type": "string"
                                                        },
                                                        "values": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms.items.properties.matchExpressions.items.properties.values",
                                                            "type": "array",
                                                            "items": {
                                                            "type": "string"
                                                            }
                                                        }
                                                        }
                                                    }
                                                    },
                                                    "matchFields": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms.items.properties.matchFields",
                                                    "type": "array",
                                                    "items": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms.items.properties.matchFields.items",
                                                        "type": "object",
                                                        "required": [
                                                        "key",
                                                        "operator"
                                                        ],
                                                        "properties": {
                                                        "key": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms.items.properties.matchFields.items.properties.key",
                                                            "type": "string"
                                                        },
                                                        "operator": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms.items.properties.matchFields.items.properties.operator",
                                                            "type": "string"
                                                        },
                                                        "values": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms.items.properties.matchFields.items.properties.values",
                                                            "type": "array",
                                                            "items": {
                                                            "type": "string"
                                                            }
                                                        }
                                                        }
                                                    }
                                                    }
                                                }
                                                }
                                            }
                                            }
                                        }
                                        }
                                    },
                                    "podAffinity": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAffinity",
                                        "type": "object",
                                        "properties": {
                                        "preferredDuringSchedulingIgnoredDuringExecution": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution",
                                            "type": "array",
                                            "items": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items",
                                            "type": "object",
                                            "required": [
                                                "weight",
                                                "podAffinityTerm"
                                            ],
                                            "properties": {
                                                "podAffinityTerm": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm",
                                                "type": "object",
                                                "required": [
                                                    "topologyKey"
                                                ],
                                                "properties": {
                                                    "labelSelector": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector",
                                                    "type": "object",
                                                    "properties": {
                                                        "matchExpressions": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchExpressions",
                                                        "type": "array",
                                                        "items": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchExpressions.items",
                                                            "type": "object",
                                                            "required": [
                                                            "key",
                                                            "operator"
                                                            ],
                                                            "properties": {
                                                            "key": {
                                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchExpressions.items.properties.key",
                                                                "type": "string"
                                                            },
                                                            "operator": {
                                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchExpressions.items.properties.operator",
                                                                "type": "string"
                                                            },
                                                            "values": {
                                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchExpressions.items.properties.values",
                                                                "type": "array",
                                                                "items": {
                                                                "type": "string"
                                                                }
                                                            }
                                                            }
                                                        }
                                                        },
                                                        "matchLabels": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchLabels",
                                                        "type": "object",
                                                        "additionalProperties": {
                                                            "type": "string"
                                                        }
                                                        }
                                                    }
                                                    },
                                                    "namespaces": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.namespaces",
                                                    "type": "array",
                                                    "items": {
                                                        "type": "string"
                                                    }
                                                    },
                                                    "topologyKey": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.topologyKey",
                                                    "type": "string"
                                                    }
                                                }
                                                },
                                                "weight": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.weight",
                                                "type": "integer"
                                                }
                                            }
                                            }
                                        },
                                        "requiredDuringSchedulingIgnoredDuringExecution": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution",
                                            "type": "array",
                                            "items": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items",
                                            "type": "object",
                                            "required": [
                                                "topologyKey"
                                            ],
                                            "properties": {
                                                "labelSelector": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector",
                                                "type": "object",
                                                "properties": {
                                                    "matchExpressions": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchExpressions",
                                                    "type": "array",
                                                    "items": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchExpressions.items",
                                                        "type": "object",
                                                        "required": [
                                                        "key",
                                                        "operator"
                                                        ],
                                                        "properties": {
                                                        "key": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchExpressions.items.properties.key",
                                                            "type": "string"
                                                        },
                                                        "operator": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchExpressions.items.properties.operator",
                                                            "type": "string"
                                                        },
                                                        "values": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchExpressions.items.properties.values",
                                                            "type": "array",
                                                            "items": {
                                                            "type": "string"
                                                            }
                                                        }
                                                        }
                                                    }
                                                    },
                                                    "matchLabels": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchLabels",
                                                    "type": "object",
                                                    "additionalProperties": {
                                                        "type": "string"
                                                    }
                                                    }
                                                }
                                                },
                                                "namespaces": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.namespaces",
                                                "type": "array",
                                                "items": {
                                                    "type": "string"
                                                }
                                                },
                                                "topologyKey": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.topologyKey",
                                                "type": "string"
                                                }
                                            }
                                            }
                                        }
                                        }
                                    },
                                    "podAntiAffinity": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity",
                                        "type": "object",
                                        "properties": {
                                        "preferredDuringSchedulingIgnoredDuringExecution": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution",
                                            "type": "array",
                                            "items": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items",
                                            "type": "object",
                                            "required": [
                                                "weight",
                                                "podAffinityTerm"
                                            ],
                                            "properties": {
                                                "podAffinityTerm": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm",
                                                "type": "object",
                                                "required": [
                                                    "topologyKey"
                                                ],
                                                "properties": {
                                                    "labelSelector": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector",
                                                    "type": "object",
                                                    "properties": {
                                                        "matchExpressions": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchExpressions",
                                                        "type": "array",
                                                        "items": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchExpressions.items",
                                                            "type": "object",
                                                            "required": [
                                                            "key",
                                                            "operator"
                                                            ],
                                                            "properties": {
                                                            "key": {
                                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchExpressions.items.properties.key",
                                                                "type": "string"
                                                            },
                                                            "operator": {
                                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchExpressions.items.properties.operator",
                                                                "type": "string"
                                                            },
                                                            "values": {
                                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchExpressions.items.properties.values",
                                                                "type": "array",
                                                                "items": {
                                                                "type": "string"
                                                                }
                                                            }
                                                            }
                                                        }
                                                        },
                                                        "matchLabels": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchLabels",
                                                        "type": "object",
                                                        "additionalProperties": {
                                                            "type": "string"
                                                        }
                                                        }
                                                    }
                                                    },
                                                    "namespaces": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.namespaces",
                                                    "type": "array",
                                                    "items": {
                                                        "type": "string"
                                                    }
                                                    },
                                                    "topologyKey": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.topologyKey",
                                                    "type": "string"
                                                    }
                                                }
                                                },
                                                "weight": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.weight",
                                                "type": "integer"
                                                }
                                            }
                                            }
                                        },
                                        "requiredDuringSchedulingIgnoredDuringExecution": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution",
                                            "type": "array",
                                            "items": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items",
                                            "type": "object",
                                            "required": [
                                                "topologyKey"
                                            ],
                                            "properties": {
                                                "labelSelector": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector",
                                                "type": "object",
                                                "properties": {
                                                    "matchExpressions": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchExpressions",
                                                    "type": "array",
                                                    "items": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchExpressions.items",
                                                        "type": "object",
                                                        "required": [
                                                        "key",
                                                        "operator"
                                                        ],
                                                        "properties": {
                                                        "key": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchExpressions.items.properties.key",
                                                            "type": "string"
                                                        },
                                                        "operator": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchExpressions.items.properties.operator",
                                                            "type": "string"
                                                        },
                                                        "values": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchExpressions.items.properties.values",
                                                            "type": "array",
                                                            "items": {
                                                            "type": "string"
                                                            }
                                                        }
                                                        }
                                                    }
                                                    },
                                                    "matchLabels": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchLabels",
                                                    "type": "object",
                                                    "additionalProperties": {
                                                        "type": "string"
                                                    }
                                                    }
                                                }
                                                },
                                                "namespaces": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.namespaces",
                                                "type": "array",
                                                "items": {
                                                    "type": "string"
                                                }
                                                },
                                                "topologyKey": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.topologyKey",
                                                "type": "string"
                                                }
                                            }
                                            }
                                        }
                                        }
                                    }
                                    }
                                },
                                "automountServiceAccountToken": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.automountServiceAccountToken",
                                    "type": "boolean"
                                },
                                "containers": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers",
                                    "type": "array",
                                    "items": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items",
                                    "type": "object",
                                    "required": [
                                        "name",
                                        "image"
                                    ],
                                    "properties": {
                                        "args": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.args",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                        },
                                        "command": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.command",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                        },
                                        "env": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.env",
                                        "type": "array",
                                        "items": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.env.items",
                                            "type": "object",
                                            "required": [
                                            "name"
                                            ],
                                            "properties": {
                                            "name": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.name",
                                                "type": "string"
                                            },
                                            "value": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.value",
                                                "type": "string"
                                            },
                                            "valueFrom": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom",
                                                "type": "object",
                                                "properties": {
                                                "configMapKeyRef": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.configMapKeyRef",
                                                    "type": "object",
                                                    "required": [
                                                    "key"
                                                    ],
                                                    "properties": {
                                                    "key": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.configMapKeyRef.properties.key",
                                                        "type": "string"
                                                    },
                                                    "name": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.configMapKeyRef.properties.name",
                                                        "type": "string"
                                                    },
                                                    "optional": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.configMapKeyRef.properties.optional",
                                                        "type": "boolean"
                                                    }
                                                    }
                                                },
                                                "fieldRef": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.fieldRef",
                                                    "type": "object",
                                                    "required": [
                                                    "fieldPath"
                                                    ],
                                                    "properties": {
                                                    "apiVersion": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.fieldRef.properties.apiVersion",
                                                        "type": "string"
                                                    },
                                                    "fieldPath": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.fieldRef.properties.fieldPath",
                                                        "type": "string"
                                                    }
                                                    }
                                                },
                                                "resourceFieldRef": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.resourceFieldRef",
                                                    "type": "object",
                                                    "required": [
                                                    "resource"
                                                    ],
                                                    "properties": {
                                                    "containerName": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.resourceFieldRef.properties.containerName",
                                                        "type": "string"
                                                    },
                                                    "divisor": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.resourceFieldRef.properties.divisor",
                                                        "type": "string"
                                                    },
                                                    "resource": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.resourceFieldRef.properties.resource",
                                                        "type": "string"
                                                    }
                                                    }
                                                },
                                                "secretKeyRef": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.secretKeyRef",
                                                    "type": "object",
                                                    "required": [
                                                    "key"
                                                    ],
                                                    "properties": {
                                                    "key": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.secretKeyRef.properties.key",
                                                        "type": "string"
                                                    },
                                                    "name": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.secretKeyRef.properties.name",
                                                        "type": "string"
                                                    },
                                                    "optional": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.secretKeyRef.properties.optional",
                                                        "type": "boolean"
                                                    }
                                                    }
                                                }
                                                }
                                            }
                                            }
                                        }
                                        },
                                        "envFrom": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.envFrom",
                                        "type": "array",
                                        "items": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.envFrom.items",
                                            "type": "object",
                                            "properties": {
                                            "configMapRef": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.envFrom.items.properties.configMapRef",
                                                "type": "object",
                                                "properties": {
                                                "name": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.envFrom.items.properties.configMapRef.properties.name",
                                                    "type": "string"
                                                },
                                                "optional": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.envFrom.items.properties.configMapRef.properties.optional",
                                                    "type": "boolean"
                                                }
                                                }
                                            },
                                            "prefix": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.envFrom.items.properties.prefix",
                                                "type": "string"
                                            },
                                            "secretRef": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.envFrom.items.properties.secretRef",
                                                "type": "object",
                                                "properties": {
                                                "name": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.envFrom.items.properties.secretRef.properties.name",
                                                    "type": "string"
                                                },
                                                "optional": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.envFrom.items.properties.secretRef.properties.optional",
                                                    "type": "boolean"
                                                }
                                                }
                                            }
                                            }
                                        }
                                        },
                                        "image": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.image",
                                        "type": "string"
                                        },
                                        "imagePullPolicy": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.imagePullPolicy",
                                        "type": "string"
                                        },
                                        "lifecycle": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.lifecycle",
                                        "type": "object",
                                        "properties": {
                                            "postStart": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart",
                                            "type": "object",
                                            "properties": {
                                                "exec": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.exec",
                                                "type": "object",
                                                "properties": {
                                                    "command": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.exec.properties.command",
                                                    "type": "array",
                                                    "items": {
                                                        "type": "string"
                                                    }
                                                    }
                                                }
                                                },
                                                "httpGet": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.httpGet",
                                                "type": "object",
                                                "required": [
                                                    "port"
                                                ],
                                                "properties": {
                                                    "host": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.host",
                                                    "type": "string"
                                                    },
                                                    "httpHeaders": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.httpHeaders",
                                                    "type": "array",
                                                    "items": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.httpHeaders.items",
                                                        "type": "object",
                                                        "required": [
                                                        "name",
                                                        "value"
                                                        ],
                                                        "properties": {
                                                        "name": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.httpHeaders.items.properties.name",
                                                            "type": "string"
                                                        },
                                                        "value": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.httpHeaders.items.properties.value",
                                                            "type": "string"
                                                        }
                                                        }
                                                    }
                                                    },
                                                    "path": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.path",
                                                    "type": "string"
                                                    },
                                                    "port": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.port",
                                                    "type": "string"
                                                    },
                                                    "scheme": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.scheme",
                                                    "type": "string"
                                                    }
                                                }
                                                },
                                                "tcpSocket": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.tcpSocket",
                                                "type": "object",
                                                "required": [
                                                    "port"
                                                ],
                                                "properties": {
                                                    "host": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.tcpSocket.properties.host",
                                                    "type": "string"
                                                    },
                                                    "port": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.tcpSocket.properties.port",
                                                    "type": "string"
                                                    }
                                                }
                                                }
                                            }
                                            },
                                            "preStop": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop",
                                            "type": "object",
                                            "properties": {
                                                "exec": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.exec",
                                                "type": "object",
                                                "properties": {
                                                    "command": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.exec.properties.command",
                                                    "type": "array",
                                                    "items": {
                                                        "type": "string"
                                                    }
                                                    }
                                                }
                                                },
                                                "httpGet": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.httpGet",
                                                "type": "object",
                                                "required": [
                                                    "port"
                                                ],
                                                "properties": {
                                                    "host": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.host",
                                                    "type": "string"
                                                    },
                                                    "httpHeaders": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.httpHeaders",
                                                    "type": "array",
                                                    "items": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.httpHeaders.items",
                                                        "type": "object",
                                                        "required": [
                                                        "name",
                                                        "value"
                                                        ],
                                                        "properties": {
                                                        "name": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.httpHeaders.items.properties.name",
                                                            "type": "string"
                                                        },
                                                        "value": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.httpHeaders.items.properties.value",
                                                            "type": "string"
                                                        }
                                                        }
                                                    }
                                                    },
                                                    "path": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.path",
                                                    "type": "string"
                                                    },
                                                    "port": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.port",
                                                    "type": "string"
                                                    },
                                                    "scheme": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.scheme",
                                                    "type": "string"
                                                    }
                                                }
                                                },
                                                "tcpSocket": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.tcpSocket",
                                                "type": "object",
                                                "required": [
                                                    "port"
                                                ],
                                                "properties": {
                                                    "host": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.tcpSocket.properties.host",
                                                    "type": "string"
                                                    },
                                                    "port": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.tcpSocket.properties.port",
                                                    "type": "string"
                                                    }
                                                }
                                                }
                                            }
                                            }
                                        }
                                        },
                                        "livenessProbe": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.livenessProbe",
                                        "type": "object",
                                        "properties": {
                                            "exec": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.exec",
                                            "type": "object",
                                            "properties": {
                                                "command": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.exec.properties.command",
                                                "type": "array",
                                                "items": {
                                                    "type": "string"
                                                }
                                                }
                                            }
                                            },
                                            "failureThreshold": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.failureThreshold",
                                            "type": "integer"
                                            },
                                            "httpGet": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.httpGet",
                                            "type": "object",
                                            "required": [
                                                "port"
                                            ],
                                            "properties": {
                                                "host": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.httpGet.properties.host",
                                                "type": "string"
                                                },
                                                "httpHeaders": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.httpGet.properties.httpHeaders",
                                                "type": "array",
                                                "items": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.httpGet.properties.httpHeaders.items",
                                                    "type": "object",
                                                    "required": [
                                                    "name",
                                                    "value"
                                                    ],
                                                    "properties": {
                                                    "name": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.httpGet.properties.httpHeaders.items.properties.name",
                                                        "type": "string"
                                                    },
                                                    "value": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.httpGet.properties.httpHeaders.items.properties.value",
                                                        "type": "string"
                                                    }
                                                    }
                                                }
                                                },
                                                "path": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.httpGet.properties.path",
                                                "type": "string"
                                                },
                                                "port": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.httpGet.properties.port",
                                                "type": "string"
                                                },
                                                "scheme": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.httpGet.properties.scheme",
                                                "type": "string"
                                                }
                                            }
                                            },
                                            "initialDelaySeconds": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.initialDelaySeconds",
                                            "type": "integer"
                                            },
                                            "periodSeconds": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.periodSeconds",
                                            "type": "integer"
                                            },
                                            "successThreshold": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.successThreshold",
                                            "type": "integer"
                                            },
                                            "tcpSocket": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.tcpSocket",
                                            "type": "object",
                                            "required": [
                                                "port"
                                            ],
                                            "properties": {
                                                "host": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.tcpSocket.properties.host",
                                                "type": "string"
                                                },
                                                "port": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.tcpSocket.properties.port",
                                                "type": "string"
                                                }
                                            }
                                            },
                                            "timeoutSeconds": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.timeoutSeconds",
                                            "type": "integer"
                                            }
                                        }
                                        },
                                        "name": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.name",
                                        "type": "string"
                                        },
                                        "ports": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.ports",
                                        "type": "array",
                                        "items": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.ports.items",
                                            "type": "object",
                                            "required": [
                                            "containerPort"
                                            ],
                                            "properties": {
                                            "containerPort": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.ports.items.properties.containerPort",
                                                "type": "integer"
                                            },
                                            "hostIP": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.ports.items.properties.hostIP",
                                                "type": "string"
                                            },
                                            "hostPort": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.ports.items.properties.hostPort",
                                                "type": "integer"
                                            },
                                            "name": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.ports.items.properties.name",
                                                "type": "string"
                                            },
                                            "protocol": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.ports.items.properties.protocol",
                                                "type": "string"
                                            }
                                            }
                                        }
                                        },
                                        "readinessProbe": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.readinessProbe",
                                        "type": "object",
                                        "properties": {
                                            "exec": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.exec",
                                            "type": "object",
                                            "properties": {
                                                "command": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.exec.properties.command",
                                                "type": "array",
                                                "items": {
                                                    "type": "string"
                                                }
                                                }
                                            }
                                            },
                                            "failureThreshold": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.failureThreshold",
                                            "type": "integer"
                                            },
                                            "httpGet": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.httpGet",
                                            "type": "object",
                                            "required": [
                                                "port"
                                            ],
                                            "properties": {
                                                "host": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.httpGet.properties.host",
                                                "type": "string"
                                                },
                                                "httpHeaders": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.httpGet.properties.httpHeaders",
                                                "type": "array",
                                                "items": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.httpGet.properties.httpHeaders.items",
                                                    "type": "object",
                                                    "required": [
                                                    "name",
                                                    "value"
                                                    ],
                                                    "properties": {
                                                    "name": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.httpGet.properties.httpHeaders.items.properties.name",
                                                        "type": "string"
                                                    },
                                                    "value": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.httpGet.properties.httpHeaders.items.properties.value",
                                                        "type": "string"
                                                    }
                                                    }
                                                }
                                                },
                                                "path": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.httpGet.properties.path",
                                                "type": "string"
                                                },
                                                "port": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.httpGet.properties.port",
                                                "type": "string"
                                                },
                                                "scheme": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.httpGet.properties.scheme",
                                                "type": "string"
                                                }
                                            }
                                            },
                                            "initialDelaySeconds": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.initialDelaySeconds",
                                            "type": "integer"
                                            },
                                            "periodSeconds": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.periodSeconds",
                                            "type": "integer"
                                            },
                                            "successThreshold": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.successThreshold",
                                            "type": "integer"
                                            },
                                            "tcpSocket": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.tcpSocket",
                                            "type": "object",
                                            "required": [
                                                "port"
                                            ],
                                            "properties": {
                                                "host": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.tcpSocket.properties.host",
                                                "type": "string"
                                                },
                                                "port": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.tcpSocket.properties.port",
                                                "type": "string"
                                                }
                                            }
                                            },
                                            "timeoutSeconds": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.timeoutSeconds",
                                            "type": "integer"
                                            }
                                        }
                                        },
                                        "resources": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.resources",
                                        "type": "object",
                                        "properties": {
                                            "limits": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.resources.properties.limits",
                                            "type": "object",
                                            "additionalProperties": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.resources.properties.limits.additionalProperties",
                                                "type": "string"
                                            }
                                            },
                                            "requests": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.resources.properties.requests",
                                            "type": "object",
                                            "additionalProperties": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.resources.properties.requests.additionalProperties",
                                                "type": "string"
                                            }
                                            }
                                        }
                                        },
                                        "securityContext": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.securityContext",
                                        "type": "object",
                                        "properties": {
                                            "allowPrivilegeEscalation": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.allowPrivilegeEscalation",
                                            "type": "boolean"
                                            },
                                            "capabilities": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.capabilities",
                                            "type": "object",
                                            "properties": {
                                                "add": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.capabilities.properties.add",
                                                "type": "array",
                                                "items": {
                                                    "type": "string"
                                                }
                                                },
                                                "drop": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.capabilities.properties.drop",
                                                "type": "array",
                                                "items": {
                                                    "type": "string"
                                                }
                                                }
                                            }
                                            },
                                            "privileged": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.privileged",
                                            "type": "boolean"
                                            },
                                            "procMount": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.procMount",
                                            "type": "string"
                                            },
                                            "readOnlyRootFilesystem": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.readOnlyRootFilesystem",
                                            "type": "boolean"
                                            },
                                            "runAsGroup": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.runAsGroup",
                                            "type": "integer"
                                            },
                                            "runAsNonRoot": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.runAsNonRoot",
                                            "type": "boolean"
                                            },
                                            "runAsUser": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.runAsUser",
                                            "type": "integer"
                                            },
                                            "seLinuxOptions": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.seLinuxOptions",
                                            "type": "object",
                                            "properties": {
                                                "level": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.seLinuxOptions.properties.level",
                                                "type": "string"
                                                },
                                                "role": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.seLinuxOptions.properties.role",
                                                "type": "string"
                                                },
                                                "type": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.seLinuxOptions.properties.type",
                                                "type": "string"
                                                },
                                                "user": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.seLinuxOptions.properties.user",
                                                "type": "string"
                                                }
                                            }
                                            },
                                            "windowsOptions": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.windowsOptions",
                                            "type": "object",
                                            "properties": {
                                                "gmsaCredentialSpec": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.windowsOptions.properties.gmsaCredentialSpec",
                                                "type": "string"
                                                },
                                                "gmsaCredentialSpecName": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.windowsOptions.properties.gmsaCredentialSpecName",
                                                "type": "string"
                                                },
                                                "runAsUserName": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.windowsOptions.properties.runAsUserName",
                                                "type": "string"
                                                }
                                            }
                                            }
                                        }
                                        },
                                        "stdin": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.stdin",
                                        "type": "boolean"
                                        },
                                        "stdinOnce": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.stdinOnce",
                                        "type": "boolean"
                                        },
                                        "terminationMessagePath": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.terminationMessagePath",
                                        "type": "string"
                                        },
                                        "terminationMessagePolicy": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.terminationMessagePolicy",
                                        "type": "string"
                                        },
                                        "tty": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.tty",
                                        "type": "boolean"
                                        },
                                        "volumeMounts": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.volumeMounts",
                                        "type": "array",
                                        "items": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.volumeMounts.items",
                                            "type": "object",
                                            "required": [
                                            "name",
                                            "mountPath"
                                            ],
                                            "properties": {
                                            "mountPath": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.volumeMounts.items.properties.mountPath",
                                                "type": "string"
                                            },
                                            "mountPropagation": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.volumeMounts.items.properties.mountPropagation",
                                                "type": "string"
                                            },
                                            "name": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.volumeMounts.items.properties.name",
                                                "type": "string"
                                            },
                                            "readOnly": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.volumeMounts.items.properties.readOnly",
                                                "type": "boolean"
                                            },
                                            "subPath": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.volumeMounts.items.properties.subPath",
                                                "type": "string"
                                            },
                                            "subPathExpr": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.volumeMounts.items.properties.subPathExpr",
                                                "type": "string"
                                            }
                                            }
                                        }
                                        },
                                        "workingDir": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.containers.items.properties.workingDir",
                                        "type": "string"
                                        }
                                    }
                                    }
                                },
                                "dnsPolicy": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.dnsPolicy",
                                    "type": "string"
                                },
                                "hostAliases": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.hostAliases",
                                    "type": "array",
                                    "items": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.hostAliases.items",
                                    "type": "object",
                                    "properties": {
                                        "hostnames": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.hostAliases.items.properties.hostnames",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                        },
                                        "ip": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.hostAliases.items.properties.ip",
                                        "type": "string"
                                        }
                                    }
                                    }
                                },
                                "hostIPC": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.hostIPC",
                                    "type": "boolean"
                                },
                                "hostNetwork": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.hostNetwork",
                                    "type": "boolean"
                                },
                                "hostPID": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.hostPID",
                                    "type": "boolean"
                                },
                                "hostname": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.hostname",
                                    "type": "string"
                                },
                                "imagePullSecrets": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.imagePullSecrets",
                                    "type": "array",
                                    "items": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.imagePullSecrets.items",
                                    "type": "object",
                                    "properties": {
                                        "name": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.imagePullSecrets.items.properties.name",
                                        "type": "string"
                                        }
                                    }
                                    }
                                },
                                "initContainers": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers",
                                    "type": "array",
                                    "items": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items",
                                    "type": "object",
                                    "required": [
                                        "name",
                                        "image"
                                    ],
                                    "properties": {
                                        "args": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.args",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                        },
                                        "command": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.command",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                        },
                                        "env": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.env",
                                        "type": "array",
                                        "items": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.env.items",
                                            "type": "object",
                                            "required": [
                                            "name"
                                            ],
                                            "properties": {
                                            "name": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.name",
                                                "type": "string"
                                            },
                                            "value": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.value",
                                                "type": "string"
                                            },
                                            "valueFrom": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom",
                                                "type": "object",
                                                "properties": {
                                                "configMapKeyRef": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.configMapKeyRef",
                                                    "type": "object",
                                                    "required": [
                                                    "key"
                                                    ],
                                                    "properties": {
                                                    "key": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.configMapKeyRef.properties.key",
                                                        "type": "string"
                                                    },
                                                    "name": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.configMapKeyRef.properties.name",
                                                        "type": "string"
                                                    },
                                                    "optional": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.configMapKeyRef.properties.optional",
                                                        "type": "boolean"
                                                    }
                                                    }
                                                },
                                                "fieldRef": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.fieldRef",
                                                    "type": "object",
                                                    "required": [
                                                    "fieldPath"
                                                    ],
                                                    "properties": {
                                                    "apiVersion": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.fieldRef.properties.apiVersion",
                                                        "type": "string"
                                                    },
                                                    "fieldPath": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.fieldRef.properties.fieldPath",
                                                        "type": "string"
                                                    }
                                                    }
                                                },
                                                "resourceFieldRef": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.resourceFieldRef",
                                                    "type": "object",
                                                    "required": [
                                                    "resource"
                                                    ],
                                                    "properties": {
                                                    "containerName": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.resourceFieldRef.properties.containerName",
                                                        "type": "string"
                                                    },
                                                    "divisor": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.resourceFieldRef.properties.divisor",
                                                        "type": "string"
                                                    },
                                                    "resource": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.resourceFieldRef.properties.resource",
                                                        "type": "string"
                                                    }
                                                    }
                                                },
                                                "secretKeyRef": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.secretKeyRef",
                                                    "type": "object",
                                                    "required": [
                                                    "key"
                                                    ],
                                                    "properties": {
                                                    "key": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.secretKeyRef.properties.key",
                                                        "type": "string"
                                                    },
                                                    "name": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.secretKeyRef.properties.name",
                                                        "type": "string"
                                                    },
                                                    "optional": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.secretKeyRef.properties.optional",
                                                        "type": "boolean"
                                                    }
                                                    }
                                                }
                                                }
                                            }
                                            }
                                        }
                                        },
                                        "envFrom": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.envFrom",
                                        "type": "array",
                                        "items": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.envFrom.items",
                                            "type": "object",
                                            "properties": {
                                            "configMapRef": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.envFrom.items.properties.configMapRef",
                                                "type": "object",
                                                "properties": {
                                                "name": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.envFrom.items.properties.configMapRef.properties.name",
                                                    "type": "string"
                                                },
                                                "optional": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.envFrom.items.properties.configMapRef.properties.optional",
                                                    "type": "boolean"
                                                }
                                                }
                                            },
                                            "prefix": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.envFrom.items.properties.prefix",
                                                "type": "string"
                                            },
                                            "secretRef": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.envFrom.items.properties.secretRef",
                                                "type": "object",
                                                "properties": {
                                                "name": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.envFrom.items.properties.secretRef.properties.name",
                                                    "type": "string"
                                                },
                                                "optional": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.envFrom.items.properties.secretRef.properties.optional",
                                                    "type": "boolean"
                                                }
                                                }
                                            }
                                            }
                                        }
                                        },
                                        "image": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.image",
                                        "type": "string"
                                        },
                                        "imagePullPolicy": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.imagePullPolicy",
                                        "type": "string"
                                        },
                                        "lifecycle": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle",
                                        "type": "object",
                                        "properties": {
                                            "postStart": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart",
                                            "type": "object",
                                            "properties": {
                                                "exec": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.exec",
                                                "type": "object",
                                                "properties": {
                                                    "command": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.exec.properties.command",
                                                    "type": "array",
                                                    "items": {
                                                        "type": "string"
                                                    }
                                                    }
                                                }
                                                },
                                                "httpGet": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.httpGet",
                                                "type": "object",
                                                "required": [
                                                    "port"
                                                ],
                                                "properties": {
                                                    "host": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.host",
                                                    "type": "string"
                                                    },
                                                    "httpHeaders": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.httpHeaders",
                                                    "type": "array",
                                                    "items": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.httpHeaders.items",
                                                        "type": "object",
                                                        "required": [
                                                        "name",
                                                        "value"
                                                        ],
                                                        "properties": {
                                                        "name": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.httpHeaders.items.properties.name",
                                                            "type": "string"
                                                        },
                                                        "value": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.httpHeaders.items.properties.value",
                                                            "type": "string"
                                                        }
                                                        }
                                                    }
                                                    },
                                                    "path": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.path",
                                                    "type": "string"
                                                    },
                                                    "port": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.port",
                                                    "type": "string"
                                                    },
                                                    "scheme": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.scheme",
                                                    "type": "string"
                                                    }
                                                }
                                                },
                                                "tcpSocket": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.tcpSocket",
                                                "type": "object",
                                                "required": [
                                                    "port"
                                                ],
                                                "properties": {
                                                    "host": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.tcpSocket.properties.host",
                                                    "type": "string"
                                                    },
                                                    "port": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.tcpSocket.properties.port",
                                                    "type": "string"
                                                    }
                                                }
                                                }
                                            }
                                            },
                                            "preStop": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop",
                                            "type": "object",
                                            "properties": {
                                                "exec": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.exec",
                                                "type": "object",
                                                "properties": {
                                                    "command": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.exec.properties.command",
                                                    "type": "array",
                                                    "items": {
                                                        "type": "string"
                                                    }
                                                    }
                                                }
                                                },
                                                "httpGet": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.httpGet",
                                                "type": "object",
                                                "required": [
                                                    "port"
                                                ],
                                                "properties": {
                                                    "host": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.host",
                                                    "type": "string"
                                                    },
                                                    "httpHeaders": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.httpHeaders",
                                                    "type": "array",
                                                    "items": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.httpHeaders.items",
                                                        "type": "object",
                                                        "required": [
                                                        "name",
                                                        "value"
                                                        ],
                                                        "properties": {
                                                        "name": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.httpHeaders.items.properties.name",
                                                            "type": "string"
                                                        },
                                                        "value": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.httpHeaders.items.properties.value",
                                                            "type": "string"
                                                        }
                                                        }
                                                    }
                                                    },
                                                    "path": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.path",
                                                    "type": "string"
                                                    },
                                                    "port": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.port",
                                                    "type": "string"
                                                    },
                                                    "scheme": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.scheme",
                                                    "type": "string"
                                                    }
                                                }
                                                },
                                                "tcpSocket": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.tcpSocket",
                                                "type": "object",
                                                "required": [
                                                    "port"
                                                ],
                                                "properties": {
                                                    "host": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.tcpSocket.properties.host",
                                                    "type": "string"
                                                    },
                                                    "port": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.tcpSocket.properties.port",
                                                    "type": "string"
                                                    }
                                                }
                                                }
                                            }
                                            }
                                        }
                                        },
                                        "livenessProbe": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe",
                                        "type": "object",
                                        "properties": {
                                            "exec": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.exec",
                                            "type": "object",
                                            "properties": {
                                                "command": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.exec.properties.command",
                                                "type": "array",
                                                "items": {
                                                    "type": "string"
                                                }
                                                }
                                            }
                                            },
                                            "failureThreshold": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.failureThreshold",
                                            "type": "integer"
                                            },
                                            "httpGet": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.httpGet",
                                            "type": "object",
                                            "required": [
                                                "port"
                                            ],
                                            "properties": {
                                                "host": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.httpGet.properties.host",
                                                "type": "string"
                                                },
                                                "httpHeaders": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.httpGet.properties.httpHeaders",
                                                "type": "array",
                                                "items": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.httpGet.properties.httpHeaders.items",
                                                    "type": "object",
                                                    "required": [
                                                    "name",
                                                    "value"
                                                    ],
                                                    "properties": {
                                                    "name": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.httpGet.properties.httpHeaders.items.properties.name",
                                                        "type": "string"
                                                    },
                                                    "value": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.httpGet.properties.httpHeaders.items.properties.value",
                                                        "type": "string"
                                                    }
                                                    }
                                                }
                                                },
                                                "path": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.httpGet.properties.path",
                                                "type": "string"
                                                },
                                                "port": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.httpGet.properties.port",
                                                "type": "string"
                                                },
                                                "scheme": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.httpGet.properties.scheme",
                                                "type": "string"
                                                }
                                            }
                                            },
                                            "initialDelaySeconds": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.initialDelaySeconds",
                                            "type": "integer"
                                            },
                                            "periodSeconds": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.periodSeconds",
                                            "type": "integer"
                                            },
                                            "successThreshold": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.successThreshold",
                                            "type": "integer"
                                            },
                                            "tcpSocket": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.tcpSocket",
                                            "type": "object",
                                            "required": [
                                                "port"
                                            ],
                                            "properties": {
                                                "host": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.tcpSocket.properties.host",
                                                "type": "string"
                                                },
                                                "port": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.tcpSocket.properties.port",
                                                "type": "string"
                                                }
                                            }
                                            },
                                            "timeoutSeconds": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.timeoutSeconds",
                                            "type": "integer"
                                            }
                                        }
                                        },
                                        "name": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.name",
                                        "type": "string"
                                        },
                                        "ports": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.ports",
                                        "type": "array",
                                        "items": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.ports.items",
                                            "type": "object",
                                            "required": [
                                            "containerPort"
                                            ],
                                            "properties": {
                                            "containerPort": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.ports.items.properties.containerPort",
                                                "type": "integer"
                                            },
                                            "hostIP": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.ports.items.properties.hostIP",
                                                "type": "string"
                                            },
                                            "hostPort": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.ports.items.properties.hostPort",
                                                "type": "integer"
                                            },
                                            "name": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.ports.items.properties.name",
                                                "type": "string"
                                            },
                                            "protocol": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.ports.items.properties.protocol",
                                                "type": "string"
                                            }
                                            }
                                        }
                                        },
                                        "readinessProbe": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe",
                                        "type": "object",
                                        "properties": {
                                            "exec": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.exec",
                                            "type": "object",
                                            "properties": {
                                                "command": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.exec.properties.command",
                                                "type": "array",
                                                "items": {
                                                    "type": "string"
                                                }
                                                }
                                            }
                                            },
                                            "failureThreshold": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.failureThreshold",
                                            "type": "integer"
                                            },
                                            "httpGet": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.httpGet",
                                            "type": "object",
                                            "required": [
                                                "port"
                                            ],
                                            "properties": {
                                                "host": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.httpGet.properties.host",
                                                "type": "string"
                                                },
                                                "httpHeaders": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.httpGet.properties.httpHeaders",
                                                "type": "array",
                                                "items": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.httpGet.properties.httpHeaders.items",
                                                    "type": "object",
                                                    "required": [
                                                    "name",
                                                    "value"
                                                    ],
                                                    "properties": {
                                                    "name": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.httpGet.properties.httpHeaders.items.properties.name",
                                                        "type": "string"
                                                    },
                                                    "value": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.httpGet.properties.httpHeaders.items.properties.value",
                                                        "type": "string"
                                                    }
                                                    }
                                                }
                                                },
                                                "path": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.httpGet.properties.path",
                                                "type": "string"
                                                },
                                                "port": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.httpGet.properties.port",
                                                "type": "string"
                                                },
                                                "scheme": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.httpGet.properties.scheme",
                                                "type": "string"
                                                }
                                            }
                                            },
                                            "initialDelaySeconds": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.initialDelaySeconds",
                                            "type": "integer"
                                            },
                                            "periodSeconds": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.periodSeconds",
                                            "type": "integer"
                                            },
                                            "successThreshold": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.successThreshold",
                                            "type": "integer"
                                            },
                                            "tcpSocket": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.tcpSocket",
                                            "type": "object",
                                            "required": [
                                                "port"
                                            ],
                                            "properties": {
                                                "host": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.tcpSocket.properties.host",
                                                "type": "string"
                                                },
                                                "port": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.tcpSocket.properties.port",
                                                "type": "string"
                                                }
                                            }
                                            },
                                            "timeoutSeconds": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.timeoutSeconds",
                                            "type": "integer"
                                            }
                                        }
                                        },
                                        "resources": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.resources",
                                        "type": "object",
                                        "properties": {
                                            "limits": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.resources.properties.limits",
                                            "type": "object",
                                            "additionalProperties": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.resources.properties.limits.additionalProperties",
                                                "type": "string"
                                            }
                                            },
                                            "requests": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.resources.properties.requests",
                                            "type": "object",
                                            "additionalProperties": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.resources.properties.requests.additionalProperties",
                                                "type": "string"
                                            }
                                            }
                                        }
                                        },
                                        "securityContext": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.securityContext",
                                        "type": "object",
                                        "properties": {
                                            "allowPrivilegeEscalation": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.allowPrivilegeEscalation",
                                            "type": "boolean"
                                            },
                                            "capabilities": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.capabilities",
                                            "type": "object",
                                            "properties": {
                                                "add": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.capabilities.properties.add",
                                                "type": "array",
                                                "items": {
                                                    "type": "string"
                                                }
                                                },
                                                "drop": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.capabilities.properties.drop",
                                                "type": "array",
                                                "items": {
                                                    "type": "string"
                                                }
                                                }
                                            }
                                            },
                                            "privileged": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.privileged",
                                            "type": "boolean"
                                            },
                                            "procMount": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.procMount",
                                            "type": "string"
                                            },
                                            "readOnlyRootFilesystem": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.readOnlyRootFilesystem",
                                            "type": "boolean"
                                            },
                                            "runAsGroup": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.runAsGroup",
                                            "type": "integer"
                                            },
                                            "runAsNonRoot": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.runAsNonRoot",
                                            "type": "boolean"
                                            },
                                            "runAsUser": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.runAsUser",
                                            "type": "integer"
                                            },
                                            "seLinuxOptions": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.seLinuxOptions",
                                            "type": "object",
                                            "properties": {
                                                "level": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.seLinuxOptions.properties.level",
                                                "type": "string"
                                                },
                                                "role": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.seLinuxOptions.properties.role",
                                                "type": "string"
                                                },
                                                "type": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.seLinuxOptions.properties.type",
                                                "type": "string"
                                                },
                                                "user": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.seLinuxOptions.properties.user",
                                                "type": "string"
                                                }
                                            }
                                            },
                                            "windowsOptions": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.windowsOptions",
                                            "type": "object",
                                            "properties": {
                                                "gmsaCredentialSpec": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.windowsOptions.properties.gmsaCredentialSpec",
                                                "type": "string"
                                                },
                                                "gmsaCredentialSpecName": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.windowsOptions.properties.gmsaCredentialSpecName",
                                                "type": "string"
                                                },
                                                "runAsUserName": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.windowsOptions.properties.runAsUserName",
                                                "type": "string"
                                                }
                                            }
                                            }
                                        }
                                        },
                                        "stdin": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.stdin",
                                        "type": "boolean"
                                        },
                                        "stdinOnce": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.stdinOnce",
                                        "type": "boolean"
                                        },
                                        "terminationMessagePath": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.terminationMessagePath",
                                        "type": "string"
                                        },
                                        "terminationMessagePolicy": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.terminationMessagePolicy",
                                        "type": "string"
                                        },
                                        "tty": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.tty",
                                        "type": "boolean"
                                        },
                                        "volumeMounts": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.volumeMounts",
                                        "type": "array",
                                        "items": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.volumeMounts.items",
                                            "type": "object",
                                            "required": [
                                            "name",
                                            "mountPath"
                                            ],
                                            "properties": {
                                            "mountPath": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.volumeMounts.items.properties.mountPath",
                                                "type": "string"
                                            },
                                            "mountPropagation": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.volumeMounts.items.properties.mountPropagation",
                                                "type": "string"
                                            },
                                            "name": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.volumeMounts.items.properties.name",
                                                "type": "string"
                                            },
                                            "readOnly": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.volumeMounts.items.properties.readOnly",
                                                "type": "boolean"
                                            },
                                            "subPath": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.volumeMounts.items.properties.subPath",
                                                "type": "string"
                                            },
                                            "subPathExpr": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.volumeMounts.items.properties.subPathExpr",
                                                "type": "string"
                                            }
                                            }
                                        }
                                        },
                                        "workingDir": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.initContainers.items.properties.workingDir",
                                        "type": "string"
                                        }
                                    }
                                    }
                                },
                                "nodeName": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.nodeName",
                                    "type": "string"
                                },
                                "nodeSelector": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.nodeSelector",
                                    "type": "object",
                                    "additionalProperties": {
                                    "type": "string"
                                    }
                                },
                                "restartPolicy": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.restartPolicy",
                                    "type": "string"
                                },
                                "schedulerName": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.schedulerName",
                                    "type": "string"
                                },
                                "securityContext": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.securityContext",
                                    "type": "object",
                                    "properties": {
                                    "fsGroup": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.securityContext.properties.fsGroup",
                                        "type": "integer",
                                        "format": "int64"
                                    },
                                    "runAsNonRoot": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.securityContext.properties.runAsNonRoot",
                                        "type": "boolean"
                                    },
                                    "runAsUser": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.securityContext.properties.runAsUser",
                                        "type": "integer",
                                        "format": "int64"
                                    },
                                    "seLinuxOptions": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.securityContext.properties.seLinuxOptions",
                                        "type": "object",
                                        "properties": {
                                        "level": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.securityContext.properties.seLinuxOptions.properties.level",
                                            "type": "string"
                                        },
                                        "role": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.securityContext.properties.seLinuxOptions.properties.role",
                                            "type": "string"
                                        },
                                        "type": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.securityContext.properties.seLinuxOptions.properties.type",
                                            "type": "string"
                                        },
                                        "user": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.securityContext.properties.seLinuxOptions.properties.user",
                                            "type": "string"
                                        }
                                        }
                                    },
                                    "supplementalGroups": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.securityContext.properties.supplementalGroups",
                                        "type": "array",
                                        "items": {
                                        "type": "integer",
                                        "format": "int64"
                                        }
                                    }
                                    }
                                },
                                "serviceAccount": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.serviceAccount",
                                    "type": "string"
                                },
                                "serviceAccountName": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.serviceAccountName",
                                    "type": "string"
                                },
                                "subdomain": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.subdomain",
                                    "type": "string"
                                },
                                "terminationGracePeriodSeconds": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.terminationGracePeriodSeconds",
                                    "type": "integer",
                                    "format": "int64"
                                },
                                "tolerations": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.tolerations",
                                    "type": "array",
                                    "items": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.tolerations.items",
                                    "type": "object",
                                    "properties": {
                                        "effect": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.tolerations.items.properties.effect",
                                        "type": "string"
                                        },
                                        "key": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.tolerations.items.properties.key",
                                        "type": "string"
                                        },
                                        "operator": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.tolerations.items.properties.operator",
                                        "type": "string"
                                        },
                                        "tolerationSeconds": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.tolerations.items.properties.tolerationSeconds",
                                        "type": "integer",
                                        "format": "int64"
                                        },
                                        "value": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.tolerations.items.properties.value",
                                        "type": "string"
                                        }
                                    }
                                    }
                                },
                                "volumes": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes",
                                    "type": "array",
                                    "items": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items",
                                    "type": "object",
                                    "required": [
                                        "name"
                                    ],
                                    "properties": {
                                        "awsElasticBlockStore": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.awsElasticBlockStore",
                                        "type": "object",
                                        "required": [
                                            "volumeID"
                                        ],
                                        "properties": {
                                            "fsType": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.awsElasticBlockStore.properties.fsType",
                                            "type": "string"
                                            },
                                            "partition": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.awsElasticBlockStore.properties.partition",
                                            "type": "integer"
                                            },
                                            "readOnly": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.awsElasticBlockStore.properties.readOnly",
                                            "type": "boolean"
                                            },
                                            "volumeID": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.awsElasticBlockStore.properties.volumeID",
                                            "type": "string"
                                            }
                                        }
                                        },
                                        "azureDisk": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.azureDisk",
                                        "type": "object",
                                        "required": [
                                            "diskName",
                                            "diskURI"
                                        ],
                                        "properties": {
                                            "cachingMode": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.azureDisk.properties.cachingMode",
                                            "type": "string"
                                            },
                                            "diskName": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.azureDisk.properties.diskName",
                                            "type": "string"
                                            },
                                            "diskURI": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.azureDisk.properties.diskURI",
                                            "type": "string"
                                            },
                                            "fsType": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.azureDisk.properties.fsType",
                                            "type": "string"
                                            },
                                            "kind": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.azureDisk.properties.kind",
                                            "type": "string"
                                            },
                                            "readOnly": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.azureDisk.properties.readOnly",
                                            "type": "boolean"
                                            }
                                        }
                                        },
                                        "azureFile": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.azureFile",
                                        "type": "object",
                                        "required": [
                                            "secretName",
                                            "shareName"
                                        ],
                                        "properties": {
                                            "readOnly": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.azureFile.properties.readOnly",
                                            "type": "boolean"
                                            },
                                            "secretName": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.azureFile.properties.secretName",
                                            "type": "string"
                                            },
                                            "shareName": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.azureFile.properties.shareName",
                                            "type": "string"
                                            }
                                        }
                                        },
                                        "cephfs": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.cephfs",
                                        "type": "object",
                                        "required": [
                                            "monitors"
                                        ],
                                        "properties": {
                                            "monitors": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.cephfs.properties.monitors",
                                            "type": "array",
                                            "items": {
                                                "type": "string"
                                            }
                                            },
                                            "path": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.cephfs.properties.path",
                                            "type": "string"
                                            },
                                            "readOnly": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.cephfs.properties.readOnly",
                                            "type": "boolean"
                                            },
                                            "secretFile": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.cephfs.properties.secretFile",
                                            "type": "string"
                                            },
                                            "secretRef": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.cephfs.properties.secretRef",
                                            "type": "object",
                                            "properties": {
                                                "name": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.cephfs.properties.secretRef.properties.name",
                                                "type": "string"
                                                }
                                            }
                                            },
                                            "user": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.cephfs.properties.user",
                                            "type": "string"
                                            }
                                        }
                                        },
                                        "cinder": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.cinder",
                                        "type": "object",
                                        "required": [
                                            "volumeID"
                                        ],
                                        "properties": {
                                            "fsType": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.cinder.properties.fsType",
                                            "type": "string"
                                            },
                                            "readOnly": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.cinder.properties.readOnly",
                                            "type": "boolean"
                                            },
                                            "secretRef": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.cinder.properties.secretRef",
                                            "type": "object",
                                            "properties": {
                                                "name": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.cinder.properties.secretRef.properties.name",
                                                "type": "string"
                                                }
                                            }
                                            },
                                            "volumeID": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.cinder.properties.volumeID",
                                            "type": "string"
                                            }
                                        }
                                        },
                                        "configMap": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.configMap",
                                        "type": "object",
                                        "properties": {
                                            "defaultMode": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.configMap.properties.defaultMode",
                                            "type": "integer"
                                            },
                                            "items": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.configMap.properties.items",
                                            "type": "array",
                                            "items": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.configMap.properties.items.items",
                                                "type": "object",
                                                "required": [
                                                "key",
                                                "path"
                                                ],
                                                "properties": {
                                                "key": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.configMap.properties.items.items.properties.key",
                                                    "type": "string"
                                                },
                                                "mode": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.configMap.properties.items.items.properties.mode",
                                                    "type": "integer"
                                                },
                                                "path": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.configMap.properties.items.items.properties.path",
                                                    "type": "string"
                                                }
                                                }
                                            }
                                            },
                                            "name": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.configMap.properties.name",
                                            "type": "string"
                                            },
                                            "optional": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.configMap.properties.optional",
                                            "type": "boolean"
                                            }
                                        }
                                        },
                                        "downwardAPI": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI",
                                        "type": "object",
                                        "properties": {
                                            "defaultMode": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.defaultMode",
                                            "type": "integer"
                                            },
                                            "items": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.items",
                                            "type": "array",
                                            "items": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.items.items",
                                                "type": "object",
                                                "required": [
                                                "path"
                                                ],
                                                "properties": {
                                                "fieldRef": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.items.items.properties.fieldRef",
                                                    "type": "object",
                                                    "required": [
                                                    "fieldPath"
                                                    ],
                                                    "properties": {
                                                    "apiVersion": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.items.items.properties.fieldRef.properties.apiVersion",
                                                        "type": "string"
                                                    },
                                                    "fieldPath": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.items.items.properties.fieldRef.properties.fieldPath",
                                                        "type": "string"
                                                    }
                                                    }
                                                },
                                                "mode": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.items.items.properties.mode",
                                                    "type": "integer"
                                                },
                                                "path": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.items.items.properties.path",
                                                    "type": "string"
                                                },
                                                "resourceFieldRef": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.items.items.properties.resourceFieldRef",
                                                    "type": "object",
                                                    "required": [
                                                    "resource"
                                                    ],
                                                    "properties": {
                                                    "containerName": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.items.items.properties.resourceFieldRef.properties.containerName",
                                                        "type": "string"
                                                    },
                                                    "divisor": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.items.items.properties.resourceFieldRef.properties.divisor",
                                                        "type": "string"
                                                    },
                                                    "resource": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.items.items.properties.resourceFieldRef.properties.resource",
                                                        "type": "string"
                                                    }
                                                    }
                                                }
                                                }
                                            }
                                            }
                                        }
                                        },
                                        "emptyDir": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.emptyDir",
                                        "type": "object",
                                        "properties": {
                                            "medium": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.emptyDir.properties.medium",
                                            "type": "string"
                                            },
                                            "sizeLimit": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.emptyDir.properties.sizeLimit",
                                            "type": "string"
                                            }
                                        }
                                        },
                                        "fc": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.fc",
                                        "type": "object",
                                        "properties": {
                                            "fsType": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.fc.properties.fsType",
                                            "type": "string"
                                            },
                                            "lun": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.fc.properties.lun",
                                            "type": "integer"
                                            },
                                            "readOnly": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.fc.properties.readOnly",
                                            "type": "boolean"
                                            },
                                            "targetWWNs": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.fc.properties.targetWWNs",
                                            "type": "array",
                                            "items": {
                                                "type": "string"
                                            }
                                            },
                                            "wwids": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.fc.properties.wwids",
                                            "type": "array",
                                            "items": {
                                                "type": "string"
                                            }
                                            }
                                        }
                                        },
                                        "flexVolume": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.flexVolume",
                                        "type": "object",
                                        "required": [
                                            "driver"
                                        ],
                                        "properties": {
                                            "driver": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.flexVolume.properties.driver",
                                            "type": "string"
                                            },
                                            "fsType": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.flexVolume.properties.fsType",
                                            "type": "string"
                                            },
                                            "options": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.flexVolume.properties.options",
                                            "type": "object",
                                            "additionalProperties": {
                                                "type": "string"
                                            }
                                            },
                                            "readOnly": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.flexVolume.properties.readOnly",
                                            "type": "boolean"
                                            },
                                            "secretRef": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.flexVolume.properties.secretRef",
                                            "type": "object",
                                            "properties": {
                                                "name": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.flexVolume.properties.secretRef.properties.name",
                                                "type": "string"
                                                }
                                            }
                                            }
                                        }
                                        },
                                        "flocker": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.flocker",
                                        "type": "object",
                                        "properties": {
                                            "datasetName": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.flocker.properties.datasetName",
                                            "type": "string"
                                            },
                                            "datasetUUID": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.flocker.properties.datasetUUID",
                                            "type": "string"
                                            }
                                        }
                                        },
                                        "gcePersistentDisk": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.gcePersistentDisk",
                                        "type": "object",
                                        "required": [
                                            "pdName"
                                        ],
                                        "properties": {
                                            "fsType": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.gcePersistentDisk.properties.fsType",
                                            "type": "string"
                                            },
                                            "partition": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.gcePersistentDisk.properties.partition",
                                            "type": "integer"
                                            },
                                            "pdName": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.gcePersistentDisk.properties.pdName",
                                            "type": "string"
                                            },
                                            "readOnly": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.gcePersistentDisk.properties.readOnly",
                                            "type": "boolean"
                                            }
                                        }
                                        },
                                        "gitRepo": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.gitRepo",
                                        "type": "object",
                                        "required": [
                                            "repository"
                                        ],
                                        "properties": {
                                            "directory": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.gitRepo.properties.directory",
                                            "type": "string"
                                            },
                                            "repository": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.gitRepo.properties.repository",
                                            "type": "string"
                                            },
                                            "revision": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.gitRepo.properties.revision",
                                            "type": "string"
                                            }
                                        }
                                        },
                                        "glusterfs": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.glusterfs",
                                        "type": "object",
                                        "required": [
                                            "endpoints",
                                            "path"
                                        ],
                                        "properties": {
                                            "endpoints": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.glusterfs.properties.endpoints",
                                            "type": "string"
                                            },
                                            "path": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.glusterfs.properties.path",
                                            "type": "string"
                                            },
                                            "readOnly": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.glusterfs.properties.readOnly",
                                            "type": "boolean"
                                            }
                                        }
                                        },
                                        "hostPath": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.hostPath",
                                        "type": "object",
                                        "required": [
                                            "path"
                                        ],
                                        "properties": {
                                            "path": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.hostPath.properties.path",
                                            "type": "string"
                                            },
                                            "type": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.hostPath.properties.type",
                                            "type": "string"
                                            }
                                        }
                                        },
                                        "iscsi": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.iscsi",
                                        "type": "object",
                                        "required": [
                                            "targetPortal",
                                            "iqn",
                                            "lun"
                                        ],
                                        "properties": {
                                            "chapAuthDiscovery": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.chapAuthDiscovery",
                                            "type": "boolean"
                                            },
                                            "chapAuthSession": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.chapAuthSession",
                                            "type": "boolean"
                                            },
                                            "fsType": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.fsType",
                                            "type": "string"
                                            },
                                            "initiatorName": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.initiatorName",
                                            "type": "string"
                                            },
                                            "iqn": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.iqn",
                                            "type": "string"
                                            },
                                            "iscsiInterface": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.iscsiInterface",
                                            "type": "string"
                                            },
                                            "lun": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.lun",
                                            "type": "integer"
                                            },
                                            "portals": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.portals",
                                            "type": "array",
                                            "items": {
                                                "type": "string"
                                            }
                                            },
                                            "readOnly": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.readOnly",
                                            "type": "boolean"
                                            },
                                            "secretRef": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.secretRef",
                                            "type": "object",
                                            "properties": {
                                                "name": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.secretRef.properties.name",
                                                "type": "string"
                                                }
                                            }
                                            },
                                            "targetPortal": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.targetPortal",
                                            "type": "string"
                                            }
                                        }
                                        },
                                        "name": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.name",
                                        "type": "string"
                                        },
                                        "nfs": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.nfs",
                                        "type": "object",
                                        "required": [
                                            "server",
                                            "path"
                                        ],
                                        "properties": {
                                            "path": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.nfs.properties.path",
                                            "type": "string"
                                            },
                                            "readOnly": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.nfs.properties.readOnly",
                                            "type": "boolean"
                                            },
                                            "server": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.nfs.properties.server",
                                            "type": "string"
                                            }
                                        }
                                        },
                                        "persistentVolumeClaim": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.persistentVolumeClaim",
                                        "type": "object",
                                        "required": [
                                            "claimName"
                                        ],
                                        "properties": {
                                            "claimName": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.persistentVolumeClaim.properties.claimName",
                                            "type": "string"
                                            },
                                            "readOnly": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.persistentVolumeClaim.properties.readOnly",
                                            "type": "boolean"
                                            }
                                        }
                                        },
                                        "photonPersistentDisk": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.photonPersistentDisk",
                                        "type": "object",
                                        "required": [
                                            "pdID"
                                        ],
                                        "properties": {
                                            "fsType": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.photonPersistentDisk.properties.fsType",
                                            "type": "string"
                                            },
                                            "pdID": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.photonPersistentDisk.properties.pdID",
                                            "type": "string"
                                            }
                                        }
                                        },
                                        "portworxVolume": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.portworxVolume",
                                        "type": "object",
                                        "required": [
                                            "volumeID"
                                        ],
                                        "properties": {
                                            "fsType": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.portworxVolume.properties.fsType",
                                            "type": "string"
                                            },
                                            "readOnly": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.portworxVolume.properties.readOnly",
                                            "type": "boolean"
                                            },
                                            "volumeID": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.portworxVolume.properties.volumeID",
                                            "type": "string"
                                            }
                                        }
                                        },
                                        "projected": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected",
                                        "type": "object",
                                        "required": [
                                            "sources"
                                        ],
                                        "properties": {
                                            "defaultMode": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.defaultMode",
                                            "type": "integer"
                                            },
                                            "sources": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources",
                                            "type": "array",
                                            "items": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items",
                                                "type": "object",
                                                "properties": {
                                                "configMap": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.configMap",
                                                    "type": "object",
                                                    "properties": {
                                                    "items": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.configMap.properties.items",
                                                        "type": "array",
                                                        "items": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.configMap.properties.items.items",
                                                        "type": "object",
                                                        "required": [
                                                            "key",
                                                            "path"
                                                        ],
                                                        "properties": {
                                                            "key": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.configMap.properties.items.items.properties.key",
                                                            "type": "string"
                                                            },
                                                            "mode": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.configMap.properties.items.items.properties.mode",
                                                            "type": "integer"
                                                            },
                                                            "path": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.configMap.properties.items.items.properties.path",
                                                            "type": "string"
                                                            }
                                                        }
                                                        }
                                                    },
                                                    "name": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.configMap.properties.name",
                                                        "type": "string"
                                                    },
                                                    "optional": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.configMap.properties.optional",
                                                        "type": "boolean"
                                                    }
                                                    }
                                                },
                                                "downwardAPI": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI",
                                                    "type": "object",
                                                    "properties": {
                                                    "items": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI.properties.items",
                                                        "type": "array",
                                                        "items": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI.properties.items.items",
                                                        "type": "object",
                                                        "required": [
                                                            "path"
                                                        ],
                                                        "properties": {
                                                            "fieldRef": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI.properties.items.items.properties.fieldRef",
                                                            "type": "object",
                                                            "required": [
                                                                "fieldPath"
                                                            ],
                                                            "properties": {
                                                                "apiVersion": {
                                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI.properties.items.items.properties.fieldRef.properties.apiVersion",
                                                                "type": "string"
                                                                },
                                                                "fieldPath": {
                                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI.properties.items.items.properties.fieldRef.properties.fieldPath",
                                                                "type": "string"
                                                                }
                                                            }
                                                            },
                                                            "mode": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI.properties.items.items.properties.mode",
                                                            "type": "integer"
                                                            },
                                                            "path": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI.properties.items.items.properties.path",
                                                            "type": "string"
                                                            },
                                                            "resourceFieldRef": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI.properties.items.items.properties.resourceFieldRef",
                                                            "type": "object",
                                                            "required": [
                                                                "resource"
                                                            ],
                                                            "properties": {
                                                                "containerName": {
                                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI.properties.items.items.properties.resourceFieldRef.properties.containerName",
                                                                "type": "string"
                                                                },
                                                                "divisor": {
                                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI.properties.items.items.properties.resourceFieldRef.properties.divisor",
                                                                "type": "string"
                                                                },
                                                                "resource": {
                                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI.properties.items.items.properties.resourceFieldRef.properties.resource",
                                                                "type": "string"
                                                                }
                                                            }
                                                            }
                                                        }
                                                        }
                                                    }
                                                    }
                                                },
                                                "secret": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.secret",
                                                    "type": "object",
                                                    "properties": {
                                                    "items": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.secret.properties.items",
                                                        "type": "array",
                                                        "items": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.secret.properties.items.items",
                                                        "type": "object",
                                                        "required": [
                                                            "key",
                                                            "path"
                                                        ],
                                                        "properties": {
                                                            "key": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.secret.properties.items.items.properties.key",
                                                            "type": "string"
                                                            },
                                                            "mode": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.secret.properties.items.items.properties.mode",
                                                            "type": "integer"
                                                            },
                                                            "path": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.secret.properties.items.items.properties.path",
                                                            "type": "string"
                                                            }
                                                        }
                                                        }
                                                    },
                                                    "name": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.secret.properties.name",
                                                        "type": "string"
                                                    },
                                                    "optional": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.secret.properties.optional",
                                                        "type": "boolean"
                                                    }
                                                    }
                                                },
                                                "serviceAccountToken": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.serviceAccountToken",
                                                    "type": "object",
                                                    "required": [
                                                    "path"
                                                    ],
                                                    "properties": {
                                                    "audience": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.serviceAccountToken.properties.audience",
                                                        "type": "string"
                                                    },
                                                    "expirationSeconds": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.serviceAccountToken.properties.expirationSeconds",
                                                        "type": "integer"
                                                    },
                                                    "path": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.serviceAccountToken.properties.path",
                                                        "type": "string"
                                                    }
                                                    }
                                                }
                                                }
                                            }
                                            }
                                        }
                                        },
                                        "quobyte": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.quobyte",
                                        "type": "object",
                                        "required": [
                                            "registry",
                                            "volume"
                                        ],
                                        "properties": {
                                            "group": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.quobyte.properties.group",
                                            "type": "string"
                                            },
                                            "readOnly": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.quobyte.properties.readOnly",
                                            "type": "boolean"
                                            },
                                            "registry": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.quobyte.properties.registry",
                                            "type": "string"
                                            },
                                            "tenant": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.quobyte.properties.tenant",
                                            "type": "string"
                                            },
                                            "user": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.quobyte.properties.user",
                                            "type": "string"
                                            },
                                            "volume": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.quobyte.properties.volume",
                                            "type": "string"
                                            }
                                        }
                                        },
                                        "rbd": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.rbd",
                                        "type": "object",
                                        "required": [
                                            "monitors",
                                            "image"
                                        ],
                                        "properties": {
                                            "fsType": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.rbd.properties.fsType",
                                            "type": "string"
                                            },
                                            "image": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.rbd.properties.image",
                                            "type": "string"
                                            },
                                            "keyring": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.rbd.properties.keyring",
                                            "type": "string"
                                            },
                                            "monitors": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.rbd.properties.monitors",
                                            "type": "array",
                                            "items": {
                                                "type": "string"
                                            }
                                            },
                                            "pool": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.rbd.properties.pool",
                                            "type": "string"
                                            },
                                            "readOnly": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.rbd.properties.readOnly",
                                            "type": "boolean"
                                            },
                                            "secretRef": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.rbd.properties.secretRef",
                                            "type": "object",
                                            "properties": {
                                                "name": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.rbd.properties.secretRef.properties.name",
                                                "type": "string"
                                                }
                                            }
                                            },
                                            "user": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.rbd.properties.user",
                                            "type": "string"
                                            }
                                        }
                                        },
                                        "scaleIO": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.scaleIO",
                                        "type": "object",
                                        "required": [
                                            "gateway",
                                            "system",
                                            "secretRef"
                                        ],
                                        "properties": {
                                            "fsType": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.scaleIO.properties.fsType",
                                            "type": "string"
                                            },
                                            "gateway": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.scaleIO.properties.gateway",
                                            "type": "string"
                                            },
                                            "protectionDomain": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.scaleIO.properties.protectionDomain",
                                            "type": "string"
                                            },
                                            "readOnly": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.scaleIO.properties.readOnly",
                                            "type": "boolean"
                                            },
                                            "secretRef": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.scaleIO.properties.secretRef",
                                            "type": "object",
                                            "properties": {
                                                "name": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.scaleIO.properties.secretRef.properties.name",
                                                "type": "string"
                                                }
                                            }
                                            },
                                            "sslEnabled": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.scaleIO.properties.sslEnabled",
                                            "type": "boolean"
                                            },
                                            "storageMode": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.scaleIO.properties.storageMode",
                                            "type": "string"
                                            },
                                            "storagePool": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.scaleIO.properties.storagePool",
                                            "type": "string"
                                            },
                                            "system": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.scaleIO.properties.system",
                                            "type": "string"
                                            },
                                            "volumeName": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.scaleIO.properties.volumeName",
                                            "type": "string"
                                            }
                                        }
                                        },
                                        "secret": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.secret",
                                        "type": "object",
                                        "properties": {
                                            "defaultMode": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.secret.properties.defaultMode",
                                            "type": "integer"
                                            },
                                            "items": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.secret.properties.items",
                                            "type": "array",
                                            "items": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.secret.properties.items.items",
                                                "type": "object",
                                                "required": [
                                                "key",
                                                "path"
                                                ],
                                                "properties": {
                                                "key": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.secret.properties.items.items.properties.key",
                                                    "type": "string"
                                                },
                                                "mode": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.secret.properties.items.items.properties.mode",
                                                    "type": "integer"
                                                },
                                                "path": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.secret.properties.items.items.properties.path",
                                                    "type": "string"
                                                }
                                                }
                                            }
                                            },
                                            "optional": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.secret.properties.optional",
                                            "type": "boolean"
                                            },
                                            "secretName": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.secret.properties.secretName",
                                            "type": "string"
                                            }
                                        }
                                        },
                                        "storageos": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.storageos",
                                        "type": "object",
                                        "properties": {
                                            "fsType": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.storageos.properties.fsType",
                                            "type": "string"
                                            },
                                            "readOnly": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.storageos.properties.readOnly",
                                            "type": "boolean"
                                            },
                                            "secretRef": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.storageos.properties.secretRef",
                                            "type": "object",
                                            "properties": {
                                                "name": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.storageos.properties.secretRef.properties.name",
                                                "type": "string"
                                                }
                                            }
                                            },
                                            "volumeName": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.storageos.properties.volumeName",
                                            "type": "string"
                                            },
                                            "volumeNamespace": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.storageos.properties.volumeNamespace",
                                            "type": "string"
                                            }
                                        }
                                        },
                                        "vsphereVolume": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.vsphereVolume",
                                        "type": "object",
                                        "required": [
                                            "volumePath"
                                        ],
                                        "properties": {
                                            "fsType": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.vsphereVolume.properties.fsType",
                                            "type": "string"
                                            },
                                            "storagePolicyID": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.vsphereVolume.properties.storagePolicyID",
                                            "type": "string"
                                            },
                                            "storagePolicyName": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.vsphereVolume.properties.storagePolicyName",
                                            "type": "string"
                                            },
                                            "volumePath": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Master.properties.template.properties.spec.properties.volumes.items.properties.vsphereVolume.properties.volumePath",
                                            "type": "string"
                                            }
                                        }
                                        }
                                    }
                                    }
                                }
                                }
                            }
                            }
                        }
                        }
                    },
                    "Worker": {
                        "type": "object",
                        "properties": {
                        "replicas": {
                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.replicas",
                            "minimum": 1,
                            "type": "integer"
                        },
                        "restartPolicy": {
                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.restartPolicy",
                            "type": "string"
                        },
                        "template": {
                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template",
                            "type": "object",
                            "properties": {
                            "metadata": {
                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.metadata",
                                "type": "object",
                                "properties": {
                                "annotations": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.metadata.properties.annotations",
                                    "type": "object",
                                    "additionalProperties": {
                                    "type": "string"
                                    }
                                },
                                "clusterName": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.metadata.properties.clusterName",
                                    "type": "string"
                                },
                                "creationTimestamp": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.metadata.properties.creationTimestamp",
                                    "type": "string",
                                    "format": "date-time"
                                },
                                "deletionGracePeriodSeconds": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.metadata.properties.deletionGracePeriodSeconds",
                                    "type": "integer"
                                },
                                "deletionTimestamp": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.metadata.properties.deletionTimestamp",
                                    "type": "string",
                                    "format": "date-time"
                                },
                                "finalizers": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.metadata.properties.finalizers",
                                    "type": "array",
                                    "items": {
                                    "type": "string"
                                    }
                                },
                                "generateName": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.metadata.properties.generateName",
                                    "type": "string"
                                },
                                "generation": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.metadata.properties.generation",
                                    "type": "integer"
                                },
                                "labels": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.metadata.properties.labels",
                                    "type": "object",
                                    "additionalProperties": {
                                    "type": "string"
                                    }
                                },
                                "managedFields": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.metadata.properties.managedFields",
                                    "type": "array",
                                    "items": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.metadata.properties.managedFields.items",
                                    "type": "object",
                                    "properties": {
                                        "apiVersion": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.metadata.properties.managedFields.items.properties.apiVersion",
                                        "type": "string"
                                        },
                                        "fieldsType": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.metadata.properties.managedFields.items.properties.fieldsType",
                                        "type": "string"
                                        },
                                        "fieldsV1": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.metadata.properties.managedFields.items.properties.fieldsV1",
                                        "type": "object"
                                        },
                                        "manager": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.metadata.properties.managedFields.items.properties.manager",
                                        "type": "string"
                                        },
                                        "operation": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.metadata.properties.managedFields.items.properties.operation",
                                        "type": "string"
                                        },
                                        "time": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.metadata.properties.managedFields.items.properties.time",
                                        "type": "string",
                                        "format": "date-time"
                                        }
                                    }
                                    }
                                },
                                "name": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.metadata.properties.name",
                                    "type": "string"
                                },
                                "namespace": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.metadata.properties.namespace",
                                    "type": "string"
                                },
                                "ownerReferences": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.metadata.properties.ownerReferences",
                                    "type": "array",
                                    "items": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.metadata.properties.ownerReferences.items",
                                    "type": "object",
                                    "required": [
                                        "apiVersion",
                                        "kind",
                                        "name",
                                        "uid"
                                    ],
                                    "properties": {
                                        "apiVersion": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.metadata.properties.ownerReferences.items.properties.apiVersion",
                                        "type": "string"
                                        },
                                        "blockOwnerDeletion": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.metadata.properties.ownerReferences.items.properties.blockOwnerDeletion",
                                        "type": "boolean"
                                        },
                                        "controller": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.metadata.properties.ownerReferences.items.properties.controller",
                                        "type": "boolean"
                                        },
                                        "kind": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.metadata.properties.ownerReferences.items.properties.kind",
                                        "type": "string"
                                        },
                                        "name": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.metadata.properties.ownerReferences.items.properties.name",
                                        "type": "string"
                                        },
                                        "uid": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.metadata.properties.ownerReferences.items.properties.uid",
                                        "type": "string"
                                        }
                                    }
                                    }
                                },
                                "resourceVersion": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.metadata.properties.resourceVersion",
                                    "type": "string"
                                },
                                "selfLink": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.metadata.properties.selfLink",
                                    "type": "string"
                                },
                                "uid": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.metadata.properties.uid",
                                    "type": "string"
                                }
                                }
                            },
                            "spec": {
                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec",
                                "type": "object",
                                "required": [
                                "containers"
                                ],
                                "properties": {
                                "activeDeadlineSeconds": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.activeDeadlineSeconds",
                                    "type": "integer",
                                    "format": "int64"
                                },
                                "affinity": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity",
                                    "type": "object",
                                    "properties": {
                                    "nodeAffinity": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.nodeAffinity",
                                        "type": "object",
                                        "properties": {
                                        "preferredDuringSchedulingIgnoredDuringExecution": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution",
                                            "type": "array",
                                            "items": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items",
                                            "type": "object",
                                            "required": [
                                                "weight",
                                                "preference"
                                            ],
                                            "properties": {
                                                "preference": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.preference",
                                                "type": "object",
                                                "properties": {
                                                    "matchExpressions": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.preference.properties.matchExpressions",
                                                    "type": "array",
                                                    "items": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.preference.properties.matchExpressions.items",
                                                        "type": "object",
                                                        "required": [
                                                        "key",
                                                        "operator"
                                                        ],
                                                        "properties": {
                                                        "key": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.preference.properties.matchExpressions.items.properties.key",
                                                            "type": "string"
                                                        },
                                                        "operator": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.preference.properties.matchExpressions.items.properties.operator",
                                                            "type": "string"
                                                        },
                                                        "values": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.preference.properties.matchExpressions.items.properties.values",
                                                            "type": "array",
                                                            "items": {
                                                            "type": "string"
                                                            }
                                                        }
                                                        }
                                                    }
                                                    },
                                                    "matchFields": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.preference.properties.matchFields",
                                                    "type": "array",
                                                    "items": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.preference.properties.matchFields.items",
                                                        "type": "object",
                                                        "required": [
                                                        "key",
                                                        "operator"
                                                        ],
                                                        "properties": {
                                                        "key": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.preference.properties.matchFields.items.properties.key",
                                                            "type": "string"
                                                        },
                                                        "operator": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.preference.properties.matchFields.items.properties.operator",
                                                            "type": "string"
                                                        },
                                                        "values": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.preference.properties.matchFields.items.properties.values",
                                                            "type": "array",
                                                            "items": {
                                                            "type": "string"
                                                            }
                                                        }
                                                        }
                                                    }
                                                    }
                                                }
                                                },
                                                "weight": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.weight",
                                                "type": "integer"
                                                }
                                            }
                                            }
                                        },
                                        "requiredDuringSchedulingIgnoredDuringExecution": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution",
                                            "type": "object",
                                            "required": [
                                            "nodeSelectorTerms"
                                            ],
                                            "properties": {
                                            "nodeSelectorTerms": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms",
                                                "type": "array",
                                                "items": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms.items",
                                                "type": "object",
                                                "properties": {
                                                    "matchExpressions": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms.items.properties.matchExpressions",
                                                    "type": "array",
                                                    "items": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms.items.properties.matchExpressions.items",
                                                        "type": "object",
                                                        "required": [
                                                        "key",
                                                        "operator"
                                                        ],
                                                        "properties": {
                                                        "key": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms.items.properties.matchExpressions.items.properties.key",
                                                            "type": "string"
                                                        },
                                                        "operator": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms.items.properties.matchExpressions.items.properties.operator",
                                                            "type": "string"
                                                        },
                                                        "values": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms.items.properties.matchExpressions.items.properties.values",
                                                            "type": "array",
                                                            "items": {
                                                            "type": "string"
                                                            }
                                                        }
                                                        }
                                                    }
                                                    },
                                                    "matchFields": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms.items.properties.matchFields",
                                                    "type": "array",
                                                    "items": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms.items.properties.matchFields.items",
                                                        "type": "object",
                                                        "required": [
                                                        "key",
                                                        "operator"
                                                        ],
                                                        "properties": {
                                                        "key": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms.items.properties.matchFields.items.properties.key",
                                                            "type": "string"
                                                        },
                                                        "operator": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms.items.properties.matchFields.items.properties.operator",
                                                            "type": "string"
                                                        },
                                                        "values": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms.items.properties.matchFields.items.properties.values",
                                                            "type": "array",
                                                            "items": {
                                                            "type": "string"
                                                            }
                                                        }
                                                        }
                                                    }
                                                    }
                                                }
                                                }
                                            }
                                            }
                                        }
                                        }
                                    },
                                    "podAffinity": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAffinity",
                                        "type": "object",
                                        "properties": {
                                        "preferredDuringSchedulingIgnoredDuringExecution": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution",
                                            "type": "array",
                                            "items": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items",
                                            "type": "object",
                                            "required": [
                                                "weight",
                                                "podAffinityTerm"
                                            ],
                                            "properties": {
                                                "podAffinityTerm": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm",
                                                "type": "object",
                                                "required": [
                                                    "topologyKey"
                                                ],
                                                "properties": {
                                                    "labelSelector": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector",
                                                    "type": "object",
                                                    "properties": {
                                                        "matchExpressions": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchExpressions",
                                                        "type": "array",
                                                        "items": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchExpressions.items",
                                                            "type": "object",
                                                            "required": [
                                                            "key",
                                                            "operator"
                                                            ],
                                                            "properties": {
                                                            "key": {
                                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchExpressions.items.properties.key",
                                                                "type": "string"
                                                            },
                                                            "operator": {
                                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchExpressions.items.properties.operator",
                                                                "type": "string"
                                                            },
                                                            "values": {
                                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchExpressions.items.properties.values",
                                                                "type": "array",
                                                                "items": {
                                                                "type": "string"
                                                                }
                                                            }
                                                            }
                                                        }
                                                        },
                                                        "matchLabels": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchLabels",
                                                        "type": "object",
                                                        "additionalProperties": {
                                                            "type": "string"
                                                        }
                                                        }
                                                    }
                                                    },
                                                    "namespaces": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.namespaces",
                                                    "type": "array",
                                                    "items": {
                                                        "type": "string"
                                                    }
                                                    },
                                                    "topologyKey": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.topologyKey",
                                                    "type": "string"
                                                    }
                                                }
                                                },
                                                "weight": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.weight",
                                                "type": "integer"
                                                }
                                            }
                                            }
                                        },
                                        "requiredDuringSchedulingIgnoredDuringExecution": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution",
                                            "type": "array",
                                            "items": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items",
                                            "type": "object",
                                            "required": [
                                                "topologyKey"
                                            ],
                                            "properties": {
                                                "labelSelector": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector",
                                                "type": "object",
                                                "properties": {
                                                    "matchExpressions": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchExpressions",
                                                    "type": "array",
                                                    "items": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchExpressions.items",
                                                        "type": "object",
                                                        "required": [
                                                        "key",
                                                        "operator"
                                                        ],
                                                        "properties": {
                                                        "key": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchExpressions.items.properties.key",
                                                            "type": "string"
                                                        },
                                                        "operator": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchExpressions.items.properties.operator",
                                                            "type": "string"
                                                        },
                                                        "values": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchExpressions.items.properties.values",
                                                            "type": "array",
                                                            "items": {
                                                            "type": "string"
                                                            }
                                                        }
                                                        }
                                                    }
                                                    },
                                                    "matchLabels": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchLabels",
                                                    "type": "object",
                                                    "additionalProperties": {
                                                        "type": "string"
                                                    }
                                                    }
                                                }
                                                },
                                                "namespaces": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.namespaces",
                                                "type": "array",
                                                "items": {
                                                    "type": "string"
                                                }
                                                },
                                                "topologyKey": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.topologyKey",
                                                "type": "string"
                                                }
                                            }
                                            }
                                        }
                                        }
                                    },
                                    "podAntiAffinity": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity",
                                        "type": "object",
                                        "properties": {
                                        "preferredDuringSchedulingIgnoredDuringExecution": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution",
                                            "type": "array",
                                            "items": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items",
                                            "type": "object",
                                            "required": [
                                                "weight",
                                                "podAffinityTerm"
                                            ],
                                            "properties": {
                                                "podAffinityTerm": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm",
                                                "type": "object",
                                                "required": [
                                                    "topologyKey"
                                                ],
                                                "properties": {
                                                    "labelSelector": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector",
                                                    "type": "object",
                                                    "properties": {
                                                        "matchExpressions": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchExpressions",
                                                        "type": "array",
                                                        "items": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchExpressions.items",
                                                            "type": "object",
                                                            "required": [
                                                            "key",
                                                            "operator"
                                                            ],
                                                            "properties": {
                                                            "key": {
                                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchExpressions.items.properties.key",
                                                                "type": "string"
                                                            },
                                                            "operator": {
                                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchExpressions.items.properties.operator",
                                                                "type": "string"
                                                            },
                                                            "values": {
                                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchExpressions.items.properties.values",
                                                                "type": "array",
                                                                "items": {
                                                                "type": "string"
                                                                }
                                                            }
                                                            }
                                                        }
                                                        },
                                                        "matchLabels": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchLabels",
                                                        "type": "object",
                                                        "additionalProperties": {
                                                            "type": "string"
                                                        }
                                                        }
                                                    }
                                                    },
                                                    "namespaces": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.namespaces",
                                                    "type": "array",
                                                    "items": {
                                                        "type": "string"
                                                    }
                                                    },
                                                    "topologyKey": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.topologyKey",
                                                    "type": "string"
                                                    }
                                                }
                                                },
                                                "weight": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.weight",
                                                "type": "integer"
                                                }
                                            }
                                            }
                                        },
                                        "requiredDuringSchedulingIgnoredDuringExecution": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution",
                                            "type": "array",
                                            "items": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items",
                                            "type": "object",
                                            "required": [
                                                "topologyKey"
                                            ],
                                            "properties": {
                                                "labelSelector": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector",
                                                "type": "object",
                                                "properties": {
                                                    "matchExpressions": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchExpressions",
                                                    "type": "array",
                                                    "items": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchExpressions.items",
                                                        "type": "object",
                                                        "required": [
                                                        "key",
                                                        "operator"
                                                        ],
                                                        "properties": {
                                                        "key": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchExpressions.items.properties.key",
                                                            "type": "string"
                                                        },
                                                        "operator": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchExpressions.items.properties.operator",
                                                            "type": "string"
                                                        },
                                                        "values": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchExpressions.items.properties.values",
                                                            "type": "array",
                                                            "items": {
                                                            "type": "string"
                                                            }
                                                        }
                                                        }
                                                    }
                                                    },
                                                    "matchLabels": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchLabels",
                                                    "type": "object",
                                                    "additionalProperties": {
                                                        "type": "string"
                                                    }
                                                    }
                                                }
                                                },
                                                "namespaces": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.namespaces",
                                                "type": "array",
                                                "items": {
                                                    "type": "string"
                                                }
                                                },
                                                "topologyKey": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.topologyKey",
                                                "type": "string"
                                                }
                                            }
                                            }
                                        }
                                        }
                                    }
                                    }
                                },
                                "automountServiceAccountToken": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.automountServiceAccountToken",
                                    "type": "boolean"
                                },
                                "containers": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers",
                                    "type": "array",
                                    "items": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items",
                                    "type": "object",
                                    "required": [
                                        "name",
                                        "image"
                                    ],
                                    "properties": {
                                        "args": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.args",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                        },
                                        "command": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.command",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                        },
                                        "env": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.env",
                                        "type": "array",
                                        "items": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.env.items",
                                            "type": "object",
                                            "required": [
                                            "name"
                                            ],
                                            "properties": {
                                            "name": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.name",
                                                "type": "string"
                                            },
                                            "value": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.value",
                                                "type": "string"
                                            },
                                            "valueFrom": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom",
                                                "type": "object",
                                                "properties": {
                                                "configMapKeyRef": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.configMapKeyRef",
                                                    "type": "object",
                                                    "required": [
                                                    "key"
                                                    ],
                                                    "properties": {
                                                    "key": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.configMapKeyRef.properties.key",
                                                        "type": "string"
                                                    },
                                                    "name": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.configMapKeyRef.properties.name",
                                                        "type": "string"
                                                    },
                                                    "optional": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.configMapKeyRef.properties.optional",
                                                        "type": "boolean"
                                                    }
                                                    }
                                                },
                                                "fieldRef": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.fieldRef",
                                                    "type": "object",
                                                    "required": [
                                                    "fieldPath"
                                                    ],
                                                    "properties": {
                                                    "apiVersion": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.fieldRef.properties.apiVersion",
                                                        "type": "string"
                                                    },
                                                    "fieldPath": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.fieldRef.properties.fieldPath",
                                                        "type": "string"
                                                    }
                                                    }
                                                },
                                                "resourceFieldRef": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.resourceFieldRef",
                                                    "type": "object",
                                                    "required": [
                                                    "resource"
                                                    ],
                                                    "properties": {
                                                    "containerName": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.resourceFieldRef.properties.containerName",
                                                        "type": "string"
                                                    },
                                                    "divisor": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.resourceFieldRef.properties.divisor",
                                                        "type": "string"
                                                    },
                                                    "resource": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.resourceFieldRef.properties.resource",
                                                        "type": "string"
                                                    }
                                                    }
                                                },
                                                "secretKeyRef": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.secretKeyRef",
                                                    "type": "object",
                                                    "required": [
                                                    "key"
                                                    ],
                                                    "properties": {
                                                    "key": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.secretKeyRef.properties.key",
                                                        "type": "string"
                                                    },
                                                    "name": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.secretKeyRef.properties.name",
                                                        "type": "string"
                                                    },
                                                    "optional": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.secretKeyRef.properties.optional",
                                                        "type": "boolean"
                                                    }
                                                    }
                                                }
                                                }
                                            }
                                            }
                                        }
                                        },
                                        "envFrom": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.envFrom",
                                        "type": "array",
                                        "items": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.envFrom.items",
                                            "type": "object",
                                            "properties": {
                                            "configMapRef": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.envFrom.items.properties.configMapRef",
                                                "type": "object",
                                                "properties": {
                                                "name": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.envFrom.items.properties.configMapRef.properties.name",
                                                    "type": "string"
                                                },
                                                "optional": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.envFrom.items.properties.configMapRef.properties.optional",
                                                    "type": "boolean"
                                                }
                                                }
                                            },
                                            "prefix": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.envFrom.items.properties.prefix",
                                                "type": "string"
                                            },
                                            "secretRef": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.envFrom.items.properties.secretRef",
                                                "type": "object",
                                                "properties": {
                                                "name": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.envFrom.items.properties.secretRef.properties.name",
                                                    "type": "string"
                                                },
                                                "optional": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.envFrom.items.properties.secretRef.properties.optional",
                                                    "type": "boolean"
                                                }
                                                }
                                            }
                                            }
                                        }
                                        },
                                        "image": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.image",
                                        "type": "string"
                                        },
                                        "imagePullPolicy": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.imagePullPolicy",
                                        "type": "string"
                                        },
                                        "lifecycle": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.lifecycle",
                                        "type": "object",
                                        "properties": {
                                            "postStart": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart",
                                            "type": "object",
                                            "properties": {
                                                "exec": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.exec",
                                                "type": "object",
                                                "properties": {
                                                    "command": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.exec.properties.command",
                                                    "type": "array",
                                                    "items": {
                                                        "type": "string"
                                                    }
                                                    }
                                                }
                                                },
                                                "httpGet": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.httpGet",
                                                "type": "object",
                                                "required": [
                                                    "port"
                                                ],
                                                "properties": {
                                                    "host": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.host",
                                                    "type": "string"
                                                    },
                                                    "httpHeaders": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.httpHeaders",
                                                    "type": "array",
                                                    "items": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.httpHeaders.items",
                                                        "type": "object",
                                                        "required": [
                                                        "name",
                                                        "value"
                                                        ],
                                                        "properties": {
                                                        "name": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.httpHeaders.items.properties.name",
                                                            "type": "string"
                                                        },
                                                        "value": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.httpHeaders.items.properties.value",
                                                            "type": "string"
                                                        }
                                                        }
                                                    }
                                                    },
                                                    "path": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.path",
                                                    "type": "string"
                                                    },
                                                    "port": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.port",
                                                    "type": "string"
                                                    },
                                                    "scheme": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.scheme",
                                                    "type": "string"
                                                    }
                                                }
                                                },
                                                "tcpSocket": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.tcpSocket",
                                                "type": "object",
                                                "required": [
                                                    "port"
                                                ],
                                                "properties": {
                                                    "host": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.tcpSocket.properties.host",
                                                    "type": "string"
                                                    },
                                                    "port": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.tcpSocket.properties.port",
                                                    "type": "string"
                                                    }
                                                }
                                                }
                                            }
                                            },
                                            "preStop": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop",
                                            "type": "object",
                                            "properties": {
                                                "exec": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.exec",
                                                "type": "object",
                                                "properties": {
                                                    "command": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.exec.properties.command",
                                                    "type": "array",
                                                    "items": {
                                                        "type": "string"
                                                    }
                                                    }
                                                }
                                                },
                                                "httpGet": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.httpGet",
                                                "type": "object",
                                                "required": [
                                                    "port"
                                                ],
                                                "properties": {
                                                    "host": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.host",
                                                    "type": "string"
                                                    },
                                                    "httpHeaders": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.httpHeaders",
                                                    "type": "array",
                                                    "items": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.httpHeaders.items",
                                                        "type": "object",
                                                        "required": [
                                                        "name",
                                                        "value"
                                                        ],
                                                        "properties": {
                                                        "name": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.httpHeaders.items.properties.name",
                                                            "type": "string"
                                                        },
                                                        "value": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.httpHeaders.items.properties.value",
                                                            "type": "string"
                                                        }
                                                        }
                                                    }
                                                    },
                                                    "path": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.path",
                                                    "type": "string"
                                                    },
                                                    "port": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.port",
                                                    "type": "string"
                                                    },
                                                    "scheme": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.scheme",
                                                    "type": "string"
                                                    }
                                                }
                                                },
                                                "tcpSocket": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.tcpSocket",
                                                "type": "object",
                                                "required": [
                                                    "port"
                                                ],
                                                "properties": {
                                                    "host": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.tcpSocket.properties.host",
                                                    "type": "string"
                                                    },
                                                    "port": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.tcpSocket.properties.port",
                                                    "type": "string"
                                                    }
                                                }
                                                }
                                            }
                                            }
                                        }
                                        },
                                        "livenessProbe": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.livenessProbe",
                                        "type": "object",
                                        "properties": {
                                            "exec": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.exec",
                                            "type": "object",
                                            "properties": {
                                                "command": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.exec.properties.command",
                                                "type": "array",
                                                "items": {
                                                    "type": "string"
                                                }
                                                }
                                            }
                                            },
                                            "failureThreshold": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.failureThreshold",
                                            "type": "integer"
                                            },
                                            "httpGet": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.httpGet",
                                            "type": "object",
                                            "required": [
                                                "port"
                                            ],
                                            "properties": {
                                                "host": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.httpGet.properties.host",
                                                "type": "string"
                                                },
                                                "httpHeaders": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.httpGet.properties.httpHeaders",
                                                "type": "array",
                                                "items": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.httpGet.properties.httpHeaders.items",
                                                    "type": "object",
                                                    "required": [
                                                    "name",
                                                    "value"
                                                    ],
                                                    "properties": {
                                                    "name": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.httpGet.properties.httpHeaders.items.properties.name",
                                                        "type": "string"
                                                    },
                                                    "value": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.httpGet.properties.httpHeaders.items.properties.value",
                                                        "type": "string"
                                                    }
                                                    }
                                                }
                                                },
                                                "path": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.httpGet.properties.path",
                                                "type": "string"
                                                },
                                                "port": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.httpGet.properties.port",
                                                "type": "string"
                                                },
                                                "scheme": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.httpGet.properties.scheme",
                                                "type": "string"
                                                }
                                            }
                                            },
                                            "initialDelaySeconds": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.initialDelaySeconds",
                                            "type": "integer"
                                            },
                                            "periodSeconds": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.periodSeconds",
                                            "type": "integer"
                                            },
                                            "successThreshold": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.successThreshold",
                                            "type": "integer"
                                            },
                                            "tcpSocket": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.tcpSocket",
                                            "type": "object",
                                            "required": [
                                                "port"
                                            ],
                                            "properties": {
                                                "host": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.tcpSocket.properties.host",
                                                "type": "string"
                                                },
                                                "port": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.tcpSocket.properties.port",
                                                "type": "string"
                                                }
                                            }
                                            },
                                            "timeoutSeconds": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.timeoutSeconds",
                                            "type": "integer"
                                            }
                                        }
                                        },
                                        "name": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.name",
                                        "type": "string"
                                        },
                                        "ports": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.ports",
                                        "type": "array",
                                        "items": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.ports.items",
                                            "type": "object",
                                            "required": [
                                            "containerPort"
                                            ],
                                            "properties": {
                                            "containerPort": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.ports.items.properties.containerPort",
                                                "type": "integer"
                                            },
                                            "hostIP": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.ports.items.properties.hostIP",
                                                "type": "string"
                                            },
                                            "hostPort": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.ports.items.properties.hostPort",
                                                "type": "integer"
                                            },
                                            "name": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.ports.items.properties.name",
                                                "type": "string"
                                            },
                                            "protocol": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.ports.items.properties.protocol",
                                                "type": "string"
                                            }
                                            }
                                        }
                                        },
                                        "readinessProbe": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.readinessProbe",
                                        "type": "object",
                                        "properties": {
                                            "exec": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.exec",
                                            "type": "object",
                                            "properties": {
                                                "command": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.exec.properties.command",
                                                "type": "array",
                                                "items": {
                                                    "type": "string"
                                                }
                                                }
                                            }
                                            },
                                            "failureThreshold": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.failureThreshold",
                                            "type": "integer"
                                            },
                                            "httpGet": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.httpGet",
                                            "type": "object",
                                            "required": [
                                                "port"
                                            ],
                                            "properties": {
                                                "host": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.httpGet.properties.host",
                                                "type": "string"
                                                },
                                                "httpHeaders": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.httpGet.properties.httpHeaders",
                                                "type": "array",
                                                "items": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.httpGet.properties.httpHeaders.items",
                                                    "type": "object",
                                                    "required": [
                                                    "name",
                                                    "value"
                                                    ],
                                                    "properties": {
                                                    "name": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.httpGet.properties.httpHeaders.items.properties.name",
                                                        "type": "string"
                                                    },
                                                    "value": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.httpGet.properties.httpHeaders.items.properties.value",
                                                        "type": "string"
                                                    }
                                                    }
                                                }
                                                },
                                                "path": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.httpGet.properties.path",
                                                "type": "string"
                                                },
                                                "port": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.httpGet.properties.port",
                                                "type": "string"
                                                },
                                                "scheme": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.httpGet.properties.scheme",
                                                "type": "string"
                                                }
                                            }
                                            },
                                            "initialDelaySeconds": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.initialDelaySeconds",
                                            "type": "integer"
                                            },
                                            "periodSeconds": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.periodSeconds",
                                            "type": "integer"
                                            },
                                            "successThreshold": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.successThreshold",
                                            "type": "integer"
                                            },
                                            "tcpSocket": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.tcpSocket",
                                            "type": "object",
                                            "required": [
                                                "port"
                                            ],
                                            "properties": {
                                                "host": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.tcpSocket.properties.host",
                                                "type": "string"
                                                },
                                                "port": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.tcpSocket.properties.port",
                                                "type": "string"
                                                }
                                            }
                                            },
                                            "timeoutSeconds": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.timeoutSeconds",
                                            "type": "integer"
                                            }
                                        }
                                        },
                                        "resources": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.resources",
                                        "type": "object",
                                        "properties": {
                                            "limits": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.resources.properties.limits",
                                            "type": "object",
                                            "additionalProperties": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.resources.properties.limits.additionalProperties",
                                                "type": "string"
                                            }
                                            },
                                            "requests": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.resources.properties.requests",
                                            "type": "object",
                                            "additionalProperties": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.resources.properties.requests.additionalProperties",
                                                "type": "string"
                                            }
                                            }
                                        }
                                        },
                                        "securityContext": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.securityContext",
                                        "type": "object",
                                        "properties": {
                                            "allowPrivilegeEscalation": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.allowPrivilegeEscalation",
                                            "type": "boolean"
                                            },
                                            "capabilities": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.capabilities",
                                            "type": "object",
                                            "properties": {
                                                "add": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.capabilities.properties.add",
                                                "type": "array",
                                                "items": {
                                                    "type": "string"
                                                }
                                                },
                                                "drop": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.capabilities.properties.drop",
                                                "type": "array",
                                                "items": {
                                                    "type": "string"
                                                }
                                                }
                                            }
                                            },
                                            "privileged": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.privileged",
                                            "type": "boolean"
                                            },
                                            "procMount": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.procMount",
                                            "type": "string"
                                            },
                                            "readOnlyRootFilesystem": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.readOnlyRootFilesystem",
                                            "type": "boolean"
                                            },
                                            "runAsGroup": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.runAsGroup",
                                            "type": "integer"
                                            },
                                            "runAsNonRoot": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.runAsNonRoot",
                                            "type": "boolean"
                                            },
                                            "runAsUser": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.runAsUser",
                                            "type": "integer"
                                            },
                                            "seLinuxOptions": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.seLinuxOptions",
                                            "type": "object",
                                            "properties": {
                                                "level": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.seLinuxOptions.properties.level",
                                                "type": "string"
                                                },
                                                "role": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.seLinuxOptions.properties.role",
                                                "type": "string"
                                                },
                                                "type": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.seLinuxOptions.properties.type",
                                                "type": "string"
                                                },
                                                "user": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.seLinuxOptions.properties.user",
                                                "type": "string"
                                                }
                                            }
                                            },
                                            "windowsOptions": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.windowsOptions",
                                            "type": "object",
                                            "properties": {
                                                "gmsaCredentialSpec": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.windowsOptions.properties.gmsaCredentialSpec",
                                                "type": "string"
                                                },
                                                "gmsaCredentialSpecName": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.windowsOptions.properties.gmsaCredentialSpecName",
                                                "type": "string"
                                                },
                                                "runAsUserName": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.windowsOptions.properties.runAsUserName",
                                                "type": "string"
                                                }
                                            }
                                            }
                                        }
                                        },
                                        "stdin": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.stdin",
                                        "type": "boolean"
                                        },
                                        "stdinOnce": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.stdinOnce",
                                        "type": "boolean"
                                        },
                                        "terminationMessagePath": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.terminationMessagePath",
                                        "type": "string"
                                        },
                                        "terminationMessagePolicy": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.terminationMessagePolicy",
                                        "type": "string"
                                        },
                                        "tty": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.tty",
                                        "type": "boolean"
                                        },
                                        "volumeMounts": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.volumeMounts",
                                        "type": "array",
                                        "items": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.volumeMounts.items",
                                            "type": "object",
                                            "required": [
                                            "name",
                                            "mountPath"
                                            ],
                                            "properties": {
                                            "mountPath": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.volumeMounts.items.properties.mountPath",
                                                "type": "string"
                                            },
                                            "mountPropagation": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.volumeMounts.items.properties.mountPropagation",
                                                "type": "string"
                                            },
                                            "name": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.volumeMounts.items.properties.name",
                                                "type": "string"
                                            },
                                            "readOnly": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.volumeMounts.items.properties.readOnly",
                                                "type": "boolean"
                                            },
                                            "subPath": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.volumeMounts.items.properties.subPath",
                                                "type": "string"
                                            },
                                            "subPathExpr": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.volumeMounts.items.properties.subPathExpr",
                                                "type": "string"
                                            }
                                            }
                                        }
                                        },
                                        "workingDir": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.containers.items.properties.workingDir",
                                        "type": "string"
                                        }
                                    }
                                    }
                                },
                                "dnsPolicy": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.dnsPolicy",
                                    "type": "string"
                                },
                                "hostAliases": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.hostAliases",
                                    "type": "array",
                                    "items": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.hostAliases.items",
                                    "type": "object",
                                    "properties": {
                                        "hostnames": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.hostAliases.items.properties.hostnames",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                        },
                                        "ip": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.hostAliases.items.properties.ip",
                                        "type": "string"
                                        }
                                    }
                                    }
                                },
                                "hostIPC": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.hostIPC",
                                    "type": "boolean"
                                },
                                "hostNetwork": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.hostNetwork",
                                    "type": "boolean"
                                },
                                "hostPID": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.hostPID",
                                    "type": "boolean"
                                },
                                "hostname": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.hostname",
                                    "type": "string"
                                },
                                "imagePullSecrets": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.imagePullSecrets",
                                    "type": "array",
                                    "items": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.imagePullSecrets.items",
                                    "type": "object",
                                    "properties": {
                                        "name": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.imagePullSecrets.items.properties.name",
                                        "type": "string"
                                        }
                                    }
                                    }
                                },
                                "initContainers": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers",
                                    "type": "array",
                                    "items": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items",
                                    "type": "object",
                                    "required": [
                                        "name",
                                        "image"
                                    ],
                                    "properties": {
                                        "args": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.args",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                        },
                                        "command": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.command",
                                        "type": "array",
                                        "items": {
                                            "type": "string"
                                        }
                                        },
                                        "env": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.env",
                                        "type": "array",
                                        "items": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.env.items",
                                            "type": "object",
                                            "required": [
                                            "name"
                                            ],
                                            "properties": {
                                            "name": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.name",
                                                "type": "string"
                                            },
                                            "value": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.value",
                                                "type": "string"
                                            },
                                            "valueFrom": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom",
                                                "type": "object",
                                                "properties": {
                                                "configMapKeyRef": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.configMapKeyRef",
                                                    "type": "object",
                                                    "required": [
                                                    "key"
                                                    ],
                                                    "properties": {
                                                    "key": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.configMapKeyRef.properties.key",
                                                        "type": "string"
                                                    },
                                                    "name": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.configMapKeyRef.properties.name",
                                                        "type": "string"
                                                    },
                                                    "optional": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.configMapKeyRef.properties.optional",
                                                        "type": "boolean"
                                                    }
                                                    }
                                                },
                                                "fieldRef": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.fieldRef",
                                                    "type": "object",
                                                    "required": [
                                                    "fieldPath"
                                                    ],
                                                    "properties": {
                                                    "apiVersion": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.fieldRef.properties.apiVersion",
                                                        "type": "string"
                                                    },
                                                    "fieldPath": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.fieldRef.properties.fieldPath",
                                                        "type": "string"
                                                    }
                                                    }
                                                },
                                                "resourceFieldRef": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.resourceFieldRef",
                                                    "type": "object",
                                                    "required": [
                                                    "resource"
                                                    ],
                                                    "properties": {
                                                    "containerName": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.resourceFieldRef.properties.containerName",
                                                        "type": "string"
                                                    },
                                                    "divisor": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.resourceFieldRef.properties.divisor",
                                                        "type": "string"
                                                    },
                                                    "resource": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.resourceFieldRef.properties.resource",
                                                        "type": "string"
                                                    }
                                                    }
                                                },
                                                "secretKeyRef": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.secretKeyRef",
                                                    "type": "object",
                                                    "required": [
                                                    "key"
                                                    ],
                                                    "properties": {
                                                    "key": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.secretKeyRef.properties.key",
                                                        "type": "string"
                                                    },
                                                    "name": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.secretKeyRef.properties.name",
                                                        "type": "string"
                                                    },
                                                    "optional": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.secretKeyRef.properties.optional",
                                                        "type": "boolean"
                                                    }
                                                    }
                                                }
                                                }
                                            }
                                            }
                                        }
                                        },
                                        "envFrom": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.envFrom",
                                        "type": "array",
                                        "items": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.envFrom.items",
                                            "type": "object",
                                            "properties": {
                                            "configMapRef": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.envFrom.items.properties.configMapRef",
                                                "type": "object",
                                                "properties": {
                                                "name": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.envFrom.items.properties.configMapRef.properties.name",
                                                    "type": "string"
                                                },
                                                "optional": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.envFrom.items.properties.configMapRef.properties.optional",
                                                    "type": "boolean"
                                                }
                                                }
                                            },
                                            "prefix": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.envFrom.items.properties.prefix",
                                                "type": "string"
                                            },
                                            "secretRef": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.envFrom.items.properties.secretRef",
                                                "type": "object",
                                                "properties": {
                                                "name": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.envFrom.items.properties.secretRef.properties.name",
                                                    "type": "string"
                                                },
                                                "optional": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.envFrom.items.properties.secretRef.properties.optional",
                                                    "type": "boolean"
                                                }
                                                }
                                            }
                                            }
                                        }
                                        },
                                        "image": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.image",
                                        "type": "string"
                                        },
                                        "imagePullPolicy": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.imagePullPolicy",
                                        "type": "string"
                                        },
                                        "lifecycle": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle",
                                        "type": "object",
                                        "properties": {
                                            "postStart": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart",
                                            "type": "object",
                                            "properties": {
                                                "exec": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.exec",
                                                "type": "object",
                                                "properties": {
                                                    "command": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.exec.properties.command",
                                                    "type": "array",
                                                    "items": {
                                                        "type": "string"
                                                    }
                                                    }
                                                }
                                                },
                                                "httpGet": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.httpGet",
                                                "type": "object",
                                                "required": [
                                                    "port"
                                                ],
                                                "properties": {
                                                    "host": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.host",
                                                    "type": "string"
                                                    },
                                                    "httpHeaders": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.httpHeaders",
                                                    "type": "array",
                                                    "items": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.httpHeaders.items",
                                                        "type": "object",
                                                        "required": [
                                                        "name",
                                                        "value"
                                                        ],
                                                        "properties": {
                                                        "name": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.httpHeaders.items.properties.name",
                                                            "type": "string"
                                                        },
                                                        "value": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.httpHeaders.items.properties.value",
                                                            "type": "string"
                                                        }
                                                        }
                                                    }
                                                    },
                                                    "path": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.path",
                                                    "type": "string"
                                                    },
                                                    "port": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.port",
                                                    "type": "string"
                                                    },
                                                    "scheme": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.scheme",
                                                    "type": "string"
                                                    }
                                                }
                                                },
                                                "tcpSocket": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.tcpSocket",
                                                "type": "object",
                                                "required": [
                                                    "port"
                                                ],
                                                "properties": {
                                                    "host": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.tcpSocket.properties.host",
                                                    "type": "string"
                                                    },
                                                    "port": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.tcpSocket.properties.port",
                                                    "type": "string"
                                                    }
                                                }
                                                }
                                            }
                                            },
                                            "preStop": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop",
                                            "type": "object",
                                            "properties": {
                                                "exec": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.exec",
                                                "type": "object",
                                                "properties": {
                                                    "command": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.exec.properties.command",
                                                    "type": "array",
                                                    "items": {
                                                        "type": "string"
                                                    }
                                                    }
                                                }
                                                },
                                                "httpGet": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.httpGet",
                                                "type": "object",
                                                "required": [
                                                    "port"
                                                ],
                                                "properties": {
                                                    "host": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.host",
                                                    "type": "string"
                                                    },
                                                    "httpHeaders": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.httpHeaders",
                                                    "type": "array",
                                                    "items": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.httpHeaders.items",
                                                        "type": "object",
                                                        "required": [
                                                        "name",
                                                        "value"
                                                        ],
                                                        "properties": {
                                                        "name": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.httpHeaders.items.properties.name",
                                                            "type": "string"
                                                        },
                                                        "value": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.httpHeaders.items.properties.value",
                                                            "type": "string"
                                                        }
                                                        }
                                                    }
                                                    },
                                                    "path": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.path",
                                                    "type": "string"
                                                    },
                                                    "port": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.port",
                                                    "type": "string"
                                                    },
                                                    "scheme": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.scheme",
                                                    "type": "string"
                                                    }
                                                }
                                                },
                                                "tcpSocket": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.tcpSocket",
                                                "type": "object",
                                                "required": [
                                                    "port"
                                                ],
                                                "properties": {
                                                    "host": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.tcpSocket.properties.host",
                                                    "type": "string"
                                                    },
                                                    "port": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.tcpSocket.properties.port",
                                                    "type": "string"
                                                    }
                                                }
                                                }
                                            }
                                            }
                                        }
                                        },
                                        "livenessProbe": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe",
                                        "type": "object",
                                        "properties": {
                                            "exec": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.exec",
                                            "type": "object",
                                            "properties": {
                                                "command": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.exec.properties.command",
                                                "type": "array",
                                                "items": {
                                                    "type": "string"
                                                }
                                                }
                                            }
                                            },
                                            "failureThreshold": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.failureThreshold",
                                            "type": "integer"
                                            },
                                            "httpGet": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.httpGet",
                                            "type": "object",
                                            "required": [
                                                "port"
                                            ],
                                            "properties": {
                                                "host": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.httpGet.properties.host",
                                                "type": "string"
                                                },
                                                "httpHeaders": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.httpGet.properties.httpHeaders",
                                                "type": "array",
                                                "items": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.httpGet.properties.httpHeaders.items",
                                                    "type": "object",
                                                    "required": [
                                                    "name",
                                                    "value"
                                                    ],
                                                    "properties": {
                                                    "name": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.httpGet.properties.httpHeaders.items.properties.name",
                                                        "type": "string"
                                                    },
                                                    "value": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.httpGet.properties.httpHeaders.items.properties.value",
                                                        "type": "string"
                                                    }
                                                    }
                                                }
                                                },
                                                "path": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.httpGet.properties.path",
                                                "type": "string"
                                                },
                                                "port": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.httpGet.properties.port",
                                                "type": "string"
                                                },
                                                "scheme": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.httpGet.properties.scheme",
                                                "type": "string"
                                                }
                                            }
                                            },
                                            "initialDelaySeconds": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.initialDelaySeconds",
                                            "type": "integer"
                                            },
                                            "periodSeconds": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.periodSeconds",
                                            "type": "integer"
                                            },
                                            "successThreshold": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.successThreshold",
                                            "type": "integer"
                                            },
                                            "tcpSocket": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.tcpSocket",
                                            "type": "object",
                                            "required": [
                                                "port"
                                            ],
                                            "properties": {
                                                "host": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.tcpSocket.properties.host",
                                                "type": "string"
                                                },
                                                "port": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.tcpSocket.properties.port",
                                                "type": "string"
                                                }
                                            }
                                            },
                                            "timeoutSeconds": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.timeoutSeconds",
                                            "type": "integer"
                                            }
                                        }
                                        },
                                        "name": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.name",
                                        "type": "string"
                                        },
                                        "ports": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.ports",
                                        "type": "array",
                                        "items": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.ports.items",
                                            "type": "object",
                                            "required": [
                                            "containerPort"
                                            ],
                                            "properties": {
                                            "containerPort": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.ports.items.properties.containerPort",
                                                "type": "integer"
                                            },
                                            "hostIP": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.ports.items.properties.hostIP",
                                                "type": "string"
                                            },
                                            "hostPort": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.ports.items.properties.hostPort",
                                                "type": "integer"
                                            },
                                            "name": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.ports.items.properties.name",
                                                "type": "string"
                                            },
                                            "protocol": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.ports.items.properties.protocol",
                                                "type": "string"
                                            }
                                            }
                                        }
                                        },
                                        "readinessProbe": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe",
                                        "type": "object",
                                        "properties": {
                                            "exec": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.exec",
                                            "type": "object",
                                            "properties": {
                                                "command": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.exec.properties.command",
                                                "type": "array",
                                                "items": {
                                                    "type": "string"
                                                }
                                                }
                                            }
                                            },
                                            "failureThreshold": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.failureThreshold",
                                            "type": "integer"
                                            },
                                            "httpGet": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.httpGet",
                                            "type": "object",
                                            "required": [
                                                "port"
                                            ],
                                            "properties": {
                                                "host": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.httpGet.properties.host",
                                                "type": "string"
                                                },
                                                "httpHeaders": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.httpGet.properties.httpHeaders",
                                                "type": "array",
                                                "items": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.httpGet.properties.httpHeaders.items",
                                                    "type": "object",
                                                    "required": [
                                                    "name",
                                                    "value"
                                                    ],
                                                    "properties": {
                                                    "name": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.httpGet.properties.httpHeaders.items.properties.name",
                                                        "type": "string"
                                                    },
                                                    "value": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.httpGet.properties.httpHeaders.items.properties.value",
                                                        "type": "string"
                                                    }
                                                    }
                                                }
                                                },
                                                "path": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.httpGet.properties.path",
                                                "type": "string"
                                                },
                                                "port": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.httpGet.properties.port",
                                                "type": "string"
                                                },
                                                "scheme": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.httpGet.properties.scheme",
                                                "type": "string"
                                                }
                                            }
                                            },
                                            "initialDelaySeconds": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.initialDelaySeconds",
                                            "type": "integer"
                                            },
                                            "periodSeconds": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.periodSeconds",
                                            "type": "integer"
                                            },
                                            "successThreshold": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.successThreshold",
                                            "type": "integer"
                                            },
                                            "tcpSocket": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.tcpSocket",
                                            "type": "object",
                                            "required": [
                                                "port"
                                            ],
                                            "properties": {
                                                "host": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.tcpSocket.properties.host",
                                                "type": "string"
                                                },
                                                "port": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.tcpSocket.properties.port",
                                                "type": "string"
                                                }
                                            }
                                            },
                                            "timeoutSeconds": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.timeoutSeconds",
                                            "type": "integer"
                                            }
                                        }
                                        },
                                        "resources": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.resources",
                                        "type": "object",
                                        "properties": {
                                            "limits": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.resources.properties.limits",
                                            "type": "object",
                                            "additionalProperties": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.resources.properties.limits.additionalProperties",
                                                "type": "string"
                                            }
                                            },
                                            "requests": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.resources.properties.requests",
                                            "type": "object",
                                            "additionalProperties": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.resources.properties.requests.additionalProperties",
                                                "type": "string"
                                            }
                                            }
                                        }
                                        },
                                        "securityContext": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.securityContext",
                                        "type": "object",
                                        "properties": {
                                            "allowPrivilegeEscalation": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.allowPrivilegeEscalation",
                                            "type": "boolean"
                                            },
                                            "capabilities": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.capabilities",
                                            "type": "object",
                                            "properties": {
                                                "add": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.capabilities.properties.add",
                                                "type": "array",
                                                "items": {
                                                    "type": "string"
                                                }
                                                },
                                                "drop": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.capabilities.properties.drop",
                                                "type": "array",
                                                "items": {
                                                    "type": "string"
                                                }
                                                }
                                            }
                                            },
                                            "privileged": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.privileged",
                                            "type": "boolean"
                                            },
                                            "procMount": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.procMount",
                                            "type": "string"
                                            },
                                            "readOnlyRootFilesystem": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.readOnlyRootFilesystem",
                                            "type": "boolean"
                                            },
                                            "runAsGroup": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.runAsGroup",
                                            "type": "integer"
                                            },
                                            "runAsNonRoot": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.runAsNonRoot",
                                            "type": "boolean"
                                            },
                                            "runAsUser": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.runAsUser",
                                            "type": "integer"
                                            },
                                            "seLinuxOptions": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.seLinuxOptions",
                                            "type": "object",
                                            "properties": {
                                                "level": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.seLinuxOptions.properties.level",
                                                "type": "string"
                                                },
                                                "role": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.seLinuxOptions.properties.role",
                                                "type": "string"
                                                },
                                                "type": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.seLinuxOptions.properties.type",
                                                "type": "string"
                                                },
                                                "user": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.seLinuxOptions.properties.user",
                                                "type": "string"
                                                }
                                            }
                                            },
                                            "windowsOptions": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.windowsOptions",
                                            "type": "object",
                                            "properties": {
                                                "gmsaCredentialSpec": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.windowsOptions.properties.gmsaCredentialSpec",
                                                "type": "string"
                                                },
                                                "gmsaCredentialSpecName": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.windowsOptions.properties.gmsaCredentialSpecName",
                                                "type": "string"
                                                },
                                                "runAsUserName": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.windowsOptions.properties.runAsUserName",
                                                "type": "string"
                                                }
                                            }
                                            }
                                        }
                                        },
                                        "stdin": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.stdin",
                                        "type": "boolean"
                                        },
                                        "stdinOnce": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.stdinOnce",
                                        "type": "boolean"
                                        },
                                        "terminationMessagePath": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.terminationMessagePath",
                                        "type": "string"
                                        },
                                        "terminationMessagePolicy": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.terminationMessagePolicy",
                                        "type": "string"
                                        },
                                        "tty": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.tty",
                                        "type": "boolean"
                                        },
                                        "volumeMounts": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.volumeMounts",
                                        "type": "array",
                                        "items": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.volumeMounts.items",
                                            "type": "object",
                                            "required": [
                                            "name",
                                            "mountPath"
                                            ],
                                            "properties": {
                                            "mountPath": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.volumeMounts.items.properties.mountPath",
                                                "type": "string"
                                            },
                                            "mountPropagation": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.volumeMounts.items.properties.mountPropagation",
                                                "type": "string"
                                            },
                                            "name": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.volumeMounts.items.properties.name",
                                                "type": "string"
                                            },
                                            "readOnly": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.volumeMounts.items.properties.readOnly",
                                                "type": "boolean"
                                            },
                                            "subPath": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.volumeMounts.items.properties.subPath",
                                                "type": "string"
                                            },
                                            "subPathExpr": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.volumeMounts.items.properties.subPathExpr",
                                                "type": "string"
                                            }
                                            }
                                        }
                                        },
                                        "workingDir": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.initContainers.items.properties.workingDir",
                                        "type": "string"
                                        }
                                    }
                                    }
                                },
                                "nodeName": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.nodeName",
                                    "type": "string"
                                },
                                "nodeSelector": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.nodeSelector",
                                    "type": "object",
                                    "additionalProperties": {
                                    "type": "string"
                                    }
                                },
                                "restartPolicy": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.restartPolicy",
                                    "type": "string"
                                },
                                "schedulerName": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.schedulerName",
                                    "type": "string"
                                },
                                "securityContext": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.securityContext",
                                    "type": "object",
                                    "properties": {
                                    "fsGroup": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.securityContext.properties.fsGroup",
                                        "type": "integer",
                                        "format": "int64"
                                    },
                                    "runAsNonRoot": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.securityContext.properties.runAsNonRoot",
                                        "type": "boolean"
                                    },
                                    "runAsUser": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.securityContext.properties.runAsUser",
                                        "type": "integer",
                                        "format": "int64"
                                    },
                                    "seLinuxOptions": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.securityContext.properties.seLinuxOptions",
                                        "type": "object",
                                        "properties": {
                                        "level": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.securityContext.properties.seLinuxOptions.properties.level",
                                            "type": "string"
                                        },
                                        "role": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.securityContext.properties.seLinuxOptions.properties.role",
                                            "type": "string"
                                        },
                                        "type": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.securityContext.properties.seLinuxOptions.properties.type",
                                            "type": "string"
                                        },
                                        "user": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.securityContext.properties.seLinuxOptions.properties.user",
                                            "type": "string"
                                        }
                                        }
                                    },
                                    "supplementalGroups": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.securityContext.properties.supplementalGroups",
                                        "type": "array",
                                        "items": {
                                        "type": "integer",
                                        "format": "int64"
                                        }
                                    }
                                    }
                                },
                                "serviceAccount": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.serviceAccount",
                                    "type": "string"
                                },
                                "serviceAccountName": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.serviceAccountName",
                                    "type": "string"
                                },
                                "subdomain": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.subdomain",
                                    "type": "string"
                                },
                                "terminationGracePeriodSeconds": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.terminationGracePeriodSeconds",
                                    "type": "integer",
                                    "format": "int64"
                                },
                                "tolerations": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.tolerations",
                                    "type": "array",
                                    "items": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.tolerations.items",
                                    "type": "object",
                                    "properties": {
                                        "effect": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.tolerations.items.properties.effect",
                                        "type": "string"
                                        },
                                        "key": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.tolerations.items.properties.key",
                                        "type": "string"
                                        },
                                        "operator": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.tolerations.items.properties.operator",
                                        "type": "string"
                                        },
                                        "tolerationSeconds": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.tolerations.items.properties.tolerationSeconds",
                                        "type": "integer",
                                        "format": "int64"
                                        },
                                        "value": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.tolerations.items.properties.value",
                                        "type": "string"
                                        }
                                    }
                                    }
                                },
                                "volumes": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes",
                                    "type": "array",
                                    "items": {
                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items",
                                    "type": "object",
                                    "required": [
                                        "name"
                                    ],
                                    "properties": {
                                        "awsElasticBlockStore": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.awsElasticBlockStore",
                                        "type": "object",
                                        "required": [
                                            "volumeID"
                                        ],
                                        "properties": {
                                            "fsType": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.awsElasticBlockStore.properties.fsType",
                                            "type": "string"
                                            },
                                            "partition": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.awsElasticBlockStore.properties.partition",
                                            "type": "integer"
                                            },
                                            "readOnly": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.awsElasticBlockStore.properties.readOnly",
                                            "type": "boolean"
                                            },
                                            "volumeID": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.awsElasticBlockStore.properties.volumeID",
                                            "type": "string"
                                            }
                                        }
                                        },
                                        "azureDisk": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.azureDisk",
                                        "type": "object",
                                        "required": [
                                            "diskName",
                                            "diskURI"
                                        ],
                                        "properties": {
                                            "cachingMode": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.azureDisk.properties.cachingMode",
                                            "type": "string"
                                            },
                                            "diskName": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.azureDisk.properties.diskName",
                                            "type": "string"
                                            },
                                            "diskURI": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.azureDisk.properties.diskURI",
                                            "type": "string"
                                            },
                                            "fsType": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.azureDisk.properties.fsType",
                                            "type": "string"
                                            },
                                            "kind": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.azureDisk.properties.kind",
                                            "type": "string"
                                            },
                                            "readOnly": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.azureDisk.properties.readOnly",
                                            "type": "boolean"
                                            }
                                        }
                                        },
                                        "azureFile": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.azureFile",
                                        "type": "object",
                                        "required": [
                                            "secretName",
                                            "shareName"
                                        ],
                                        "properties": {
                                            "readOnly": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.azureFile.properties.readOnly",
                                            "type": "boolean"
                                            },
                                            "secretName": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.azureFile.properties.secretName",
                                            "type": "string"
                                            },
                                            "shareName": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.azureFile.properties.shareName",
                                            "type": "string"
                                            }
                                        }
                                        },
                                        "cephfs": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.cephfs",
                                        "type": "object",
                                        "required": [
                                            "monitors"
                                        ],
                                        "properties": {
                                            "monitors": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.cephfs.properties.monitors",
                                            "type": "array",
                                            "items": {
                                                "type": "string"
                                            }
                                            },
                                            "path": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.cephfs.properties.path",
                                            "type": "string"
                                            },
                                            "readOnly": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.cephfs.properties.readOnly",
                                            "type": "boolean"
                                            },
                                            "secretFile": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.cephfs.properties.secretFile",
                                            "type": "string"
                                            },
                                            "secretRef": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.cephfs.properties.secretRef",
                                            "type": "object",
                                            "properties": {
                                                "name": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.cephfs.properties.secretRef.properties.name",
                                                "type": "string"
                                                }
                                            }
                                            },
                                            "user": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.cephfs.properties.user",
                                            "type": "string"
                                            }
                                        }
                                        },
                                        "cinder": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.cinder",
                                        "type": "object",
                                        "required": [
                                            "volumeID"
                                        ],
                                        "properties": {
                                            "fsType": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.cinder.properties.fsType",
                                            "type": "string"
                                            },
                                            "readOnly": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.cinder.properties.readOnly",
                                            "type": "boolean"
                                            },
                                            "secretRef": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.cinder.properties.secretRef",
                                            "type": "object",
                                            "properties": {
                                                "name": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.cinder.properties.secretRef.properties.name",
                                                "type": "string"
                                                }
                                            }
                                            },
                                            "volumeID": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.cinder.properties.volumeID",
                                            "type": "string"
                                            }
                                        }
                                        },
                                        "configMap": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.configMap",
                                        "type": "object",
                                        "properties": {
                                            "defaultMode": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.configMap.properties.defaultMode",
                                            "type": "integer"
                                            },
                                            "items": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.configMap.properties.items",
                                            "type": "array",
                                            "items": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.configMap.properties.items.items",
                                                "type": "object",
                                                "required": [
                                                "key",
                                                "path"
                                                ],
                                                "properties": {
                                                "key": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.configMap.properties.items.items.properties.key",
                                                    "type": "string"
                                                },
                                                "mode": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.configMap.properties.items.items.properties.mode",
                                                    "type": "integer"
                                                },
                                                "path": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.configMap.properties.items.items.properties.path",
                                                    "type": "string"
                                                }
                                                }
                                            }
                                            },
                                            "name": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.configMap.properties.name",
                                            "type": "string"
                                            },
                                            "optional": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.configMap.properties.optional",
                                            "type": "boolean"
                                            }
                                        }
                                        },
                                        "downwardAPI": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI",
                                        "type": "object",
                                        "properties": {
                                            "defaultMode": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.defaultMode",
                                            "type": "integer"
                                            },
                                            "items": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.items",
                                            "type": "array",
                                            "items": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.items.items",
                                                "type": "object",
                                                "required": [
                                                "path"
                                                ],
                                                "properties": {
                                                "fieldRef": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.items.items.properties.fieldRef",
                                                    "type": "object",
                                                    "required": [
                                                    "fieldPath"
                                                    ],
                                                    "properties": {
                                                    "apiVersion": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.items.items.properties.fieldRef.properties.apiVersion",
                                                        "type": "string"
                                                    },
                                                    "fieldPath": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.items.items.properties.fieldRef.properties.fieldPath",
                                                        "type": "string"
                                                    }
                                                    }
                                                },
                                                "mode": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.items.items.properties.mode",
                                                    "type": "integer"
                                                },
                                                "path": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.items.items.properties.path",
                                                    "type": "string"
                                                },
                                                "resourceFieldRef": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.items.items.properties.resourceFieldRef",
                                                    "type": "object",
                                                    "required": [
                                                    "resource"
                                                    ],
                                                    "properties": {
                                                    "containerName": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.items.items.properties.resourceFieldRef.properties.containerName",
                                                        "type": "string"
                                                    },
                                                    "divisor": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.items.items.properties.resourceFieldRef.properties.divisor",
                                                        "type": "string"
                                                    },
                                                    "resource": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.items.items.properties.resourceFieldRef.properties.resource",
                                                        "type": "string"
                                                    }
                                                    }
                                                }
                                                }
                                            }
                                            }
                                        }
                                        },
                                        "emptyDir": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.emptyDir",
                                        "type": "object",
                                        "properties": {
                                            "medium": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.emptyDir.properties.medium",
                                            "type": "string"
                                            },
                                            "sizeLimit": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.emptyDir.properties.sizeLimit",
                                            "type": "string"
                                            }
                                        }
                                        },
                                        "fc": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.fc",
                                        "type": "object",
                                        "properties": {
                                            "fsType": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.fc.properties.fsType",
                                            "type": "string"
                                            },
                                            "lun": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.fc.properties.lun",
                                            "type": "integer"
                                            },
                                            "readOnly": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.fc.properties.readOnly",
                                            "type": "boolean"
                                            },
                                            "targetWWNs": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.fc.properties.targetWWNs",
                                            "type": "array",
                                            "items": {
                                                "type": "string"
                                            }
                                            },
                                            "wwids": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.fc.properties.wwids",
                                            "type": "array",
                                            "items": {
                                                "type": "string"
                                            }
                                            }
                                        }
                                        },
                                        "flexVolume": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.flexVolume",
                                        "type": "object",
                                        "required": [
                                            "driver"
                                        ],
                                        "properties": {
                                            "driver": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.flexVolume.properties.driver",
                                            "type": "string"
                                            },
                                            "fsType": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.flexVolume.properties.fsType",
                                            "type": "string"
                                            },
                                            "options": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.flexVolume.properties.options",
                                            "type": "object",
                                            "additionalProperties": {
                                                "type": "string"
                                            }
                                            },
                                            "readOnly": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.flexVolume.properties.readOnly",
                                            "type": "boolean"
                                            },
                                            "secretRef": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.flexVolume.properties.secretRef",
                                            "type": "object",
                                            "properties": {
                                                "name": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.flexVolume.properties.secretRef.properties.name",
                                                "type": "string"
                                                }
                                            }
                                            }
                                        }
                                        },
                                        "flocker": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.flocker",
                                        "type": "object",
                                        "properties": {
                                            "datasetName": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.flocker.properties.datasetName",
                                            "type": "string"
                                            },
                                            "datasetUUID": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.flocker.properties.datasetUUID",
                                            "type": "string"
                                            }
                                        }
                                        },
                                        "gcePersistentDisk": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.gcePersistentDisk",
                                        "type": "object",
                                        "required": [
                                            "pdName"
                                        ],
                                        "properties": {
                                            "fsType": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.gcePersistentDisk.properties.fsType",
                                            "type": "string"
                                            },
                                            "partition": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.gcePersistentDisk.properties.partition",
                                            "type": "integer"
                                            },
                                            "pdName": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.gcePersistentDisk.properties.pdName",
                                            "type": "string"
                                            },
                                            "readOnly": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.gcePersistentDisk.properties.readOnly",
                                            "type": "boolean"
                                            }
                                        }
                                        },
                                        "gitRepo": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.gitRepo",
                                        "type": "object",
                                        "required": [
                                            "repository"
                                        ],
                                        "properties": {
                                            "directory": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.gitRepo.properties.directory",
                                            "type": "string"
                                            },
                                            "repository": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.gitRepo.properties.repository",
                                            "type": "string"
                                            },
                                            "revision": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.gitRepo.properties.revision",
                                            "type": "string"
                                            }
                                        }
                                        },
                                        "glusterfs": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.glusterfs",
                                        "type": "object",
                                        "required": [
                                            "endpoints",
                                            "path"
                                        ],
                                        "properties": {
                                            "endpoints": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.glusterfs.properties.endpoints",
                                            "type": "string"
                                            },
                                            "path": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.glusterfs.properties.path",
                                            "type": "string"
                                            },
                                            "readOnly": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.glusterfs.properties.readOnly",
                                            "type": "boolean"
                                            }
                                        }
                                        },
                                        "hostPath": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.hostPath",
                                        "type": "object",
                                        "required": [
                                            "path"
                                        ],
                                        "properties": {
                                            "path": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.hostPath.properties.path",
                                            "type": "string"
                                            },
                                            "type": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.hostPath.properties.type",
                                            "type": "string"
                                            }
                                        }
                                        },
                                        "iscsi": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.iscsi",
                                        "type": "object",
                                        "required": [
                                            "targetPortal",
                                            "iqn",
                                            "lun"
                                        ],
                                        "properties": {
                                            "chapAuthDiscovery": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.chapAuthDiscovery",
                                            "type": "boolean"
                                            },
                                            "chapAuthSession": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.chapAuthSession",
                                            "type": "boolean"
                                            },
                                            "fsType": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.fsType",
                                            "type": "string"
                                            },
                                            "initiatorName": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.initiatorName",
                                            "type": "string"
                                            },
                                            "iqn": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.iqn",
                                            "type": "string"
                                            },
                                            "iscsiInterface": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.iscsiInterface",
                                            "type": "string"
                                            },
                                            "lun": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.lun",
                                            "type": "integer"
                                            },
                                            "portals": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.portals",
                                            "type": "array",
                                            "items": {
                                                "type": "string"
                                            }
                                            },
                                            "readOnly": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.readOnly",
                                            "type": "boolean"
                                            },
                                            "secretRef": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.secretRef",
                                            "type": "object",
                                            "properties": {
                                                "name": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.secretRef.properties.name",
                                                "type": "string"
                                                }
                                            }
                                            },
                                            "targetPortal": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.targetPortal",
                                            "type": "string"
                                            }
                                        }
                                        },
                                        "name": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.name",
                                        "type": "string"
                                        },
                                        "nfs": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.nfs",
                                        "type": "object",
                                        "required": [
                                            "server",
                                            "path"
                                        ],
                                        "properties": {
                                            "path": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.nfs.properties.path",
                                            "type": "string"
                                            },
                                            "readOnly": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.nfs.properties.readOnly",
                                            "type": "boolean"
                                            },
                                            "server": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.nfs.properties.server",
                                            "type": "string"
                                            }
                                        }
                                        },
                                        "persistentVolumeClaim": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.persistentVolumeClaim",
                                        "type": "object",
                                        "required": [
                                            "claimName"
                                        ],
                                        "properties": {
                                            "claimName": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.persistentVolumeClaim.properties.claimName",
                                            "type": "string"
                                            },
                                            "readOnly": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.persistentVolumeClaim.properties.readOnly",
                                            "type": "boolean"
                                            }
                                        }
                                        },
                                        "photonPersistentDisk": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.photonPersistentDisk",
                                        "type": "object",
                                        "required": [
                                            "pdID"
                                        ],
                                        "properties": {
                                            "fsType": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.photonPersistentDisk.properties.fsType",
                                            "type": "string"
                                            },
                                            "pdID": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.photonPersistentDisk.properties.pdID",
                                            "type": "string"
                                            }
                                        }
                                        },
                                        "portworxVolume": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.portworxVolume",
                                        "type": "object",
                                        "required": [
                                            "volumeID"
                                        ],
                                        "properties": {
                                            "fsType": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.portworxVolume.properties.fsType",
                                            "type": "string"
                                            },
                                            "readOnly": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.portworxVolume.properties.readOnly",
                                            "type": "boolean"
                                            },
                                            "volumeID": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.portworxVolume.properties.volumeID",
                                            "type": "string"
                                            }
                                        }
                                        },
                                        "projected": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected",
                                        "type": "object",
                                        "required": [
                                            "sources"
                                        ],
                                        "properties": {
                                            "defaultMode": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.defaultMode",
                                            "type": "integer"
                                            },
                                            "sources": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources",
                                            "type": "array",
                                            "items": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items",
                                                "type": "object",
                                                "properties": {
                                                "configMap": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.configMap",
                                                    "type": "object",
                                                    "properties": {
                                                    "items": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.configMap.properties.items",
                                                        "type": "array",
                                                        "items": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.configMap.properties.items.items",
                                                        "type": "object",
                                                        "required": [
                                                            "key",
                                                            "path"
                                                        ],
                                                        "properties": {
                                                            "key": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.configMap.properties.items.items.properties.key",
                                                            "type": "string"
                                                            },
                                                            "mode": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.configMap.properties.items.items.properties.mode",
                                                            "type": "integer"
                                                            },
                                                            "path": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.configMap.properties.items.items.properties.path",
                                                            "type": "string"
                                                            }
                                                        }
                                                        }
                                                    },
                                                    "name": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.configMap.properties.name",
                                                        "type": "string"
                                                    },
                                                    "optional": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.configMap.properties.optional",
                                                        "type": "boolean"
                                                    }
                                                    }
                                                },
                                                "downwardAPI": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI",
                                                    "type": "object",
                                                    "properties": {
                                                    "items": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI.properties.items",
                                                        "type": "array",
                                                        "items": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI.properties.items.items",
                                                        "type": "object",
                                                        "required": [
                                                            "path"
                                                        ],
                                                        "properties": {
                                                            "fieldRef": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI.properties.items.items.properties.fieldRef",
                                                            "type": "object",
                                                            "required": [
                                                                "fieldPath"
                                                            ],
                                                            "properties": {
                                                                "apiVersion": {
                                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI.properties.items.items.properties.fieldRef.properties.apiVersion",
                                                                "type": "string"
                                                                },
                                                                "fieldPath": {
                                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI.properties.items.items.properties.fieldRef.properties.fieldPath",
                                                                "type": "string"
                                                                }
                                                            }
                                                            },
                                                            "mode": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI.properties.items.items.properties.mode",
                                                            "type": "integer"
                                                            },
                                                            "path": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI.properties.items.items.properties.path",
                                                            "type": "string"
                                                            },
                                                            "resourceFieldRef": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI.properties.items.items.properties.resourceFieldRef",
                                                            "type": "object",
                                                            "required": [
                                                                "resource"
                                                            ],
                                                            "properties": {
                                                                "containerName": {
                                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI.properties.items.items.properties.resourceFieldRef.properties.containerName",
                                                                "type": "string"
                                                                },
                                                                "divisor": {
                                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI.properties.items.items.properties.resourceFieldRef.properties.divisor",
                                                                "type": "string"
                                                                },
                                                                "resource": {
                                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI.properties.items.items.properties.resourceFieldRef.properties.resource",
                                                                "type": "string"
                                                                }
                                                            }
                                                            }
                                                        }
                                                        }
                                                    }
                                                    }
                                                },
                                                "secret": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.secret",
                                                    "type": "object",
                                                    "properties": {
                                                    "items": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.secret.properties.items",
                                                        "type": "array",
                                                        "items": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.secret.properties.items.items",
                                                        "type": "object",
                                                        "required": [
                                                            "key",
                                                            "path"
                                                        ],
                                                        "properties": {
                                                            "key": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.secret.properties.items.items.properties.key",
                                                            "type": "string"
                                                            },
                                                            "mode": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.secret.properties.items.items.properties.mode",
                                                            "type": "integer"
                                                            },
                                                            "path": {
                                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.secret.properties.items.items.properties.path",
                                                            "type": "string"
                                                            }
                                                        }
                                                        }
                                                    },
                                                    "name": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.secret.properties.name",
                                                        "type": "string"
                                                    },
                                                    "optional": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.secret.properties.optional",
                                                        "type": "boolean"
                                                    }
                                                    }
                                                },
                                                "serviceAccountToken": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.serviceAccountToken",
                                                    "type": "object",
                                                    "required": [
                                                    "path"
                                                    ],
                                                    "properties": {
                                                    "audience": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.serviceAccountToken.properties.audience",
                                                        "type": "string"
                                                    },
                                                    "expirationSeconds": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.serviceAccountToken.properties.expirationSeconds",
                                                        "type": "integer"
                                                    },
                                                    "path": {
                                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.serviceAccountToken.properties.path",
                                                        "type": "string"
                                                    }
                                                    }
                                                }
                                                }
                                            }
                                            }
                                        }
                                        },
                                        "quobyte": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.quobyte",
                                        "type": "object",
                                        "required": [
                                            "registry",
                                            "volume"
                                        ],
                                        "properties": {
                                            "group": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.quobyte.properties.group",
                                            "type": "string"
                                            },
                                            "readOnly": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.quobyte.properties.readOnly",
                                            "type": "boolean"
                                            },
                                            "registry": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.quobyte.properties.registry",
                                            "type": "string"
                                            },
                                            "tenant": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.quobyte.properties.tenant",
                                            "type": "string"
                                            },
                                            "user": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.quobyte.properties.user",
                                            "type": "string"
                                            },
                                            "volume": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.quobyte.properties.volume",
                                            "type": "string"
                                            }
                                        }
                                        },
                                        "rbd": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.rbd",
                                        "type": "object",
                                        "required": [
                                            "monitors",
                                            "image"
                                        ],
                                        "properties": {
                                            "fsType": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.rbd.properties.fsType",
                                            "type": "string"
                                            },
                                            "image": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.rbd.properties.image",
                                            "type": "string"
                                            },
                                            "keyring": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.rbd.properties.keyring",
                                            "type": "string"
                                            },
                                            "monitors": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.rbd.properties.monitors",
                                            "type": "array",
                                            "items": {
                                                "type": "string"
                                            }
                                            },
                                            "pool": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.rbd.properties.pool",
                                            "type": "string"
                                            },
                                            "readOnly": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.rbd.properties.readOnly",
                                            "type": "boolean"
                                            },
                                            "secretRef": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.rbd.properties.secretRef",
                                            "type": "object",
                                            "properties": {
                                                "name": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.rbd.properties.secretRef.properties.name",
                                                "type": "string"
                                                }
                                            }
                                            },
                                            "user": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.rbd.properties.user",
                                            "type": "string"
                                            }
                                        }
                                        },
                                        "scaleIO": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.scaleIO",
                                        "type": "object",
                                        "required": [
                                            "gateway",
                                            "system",
                                            "secretRef"
                                        ],
                                        "properties": {
                                            "fsType": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.scaleIO.properties.fsType",
                                            "type": "string"
                                            },
                                            "gateway": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.scaleIO.properties.gateway",
                                            "type": "string"
                                            },
                                            "protectionDomain": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.scaleIO.properties.protectionDomain",
                                            "type": "string"
                                            },
                                            "readOnly": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.scaleIO.properties.readOnly",
                                            "type": "boolean"
                                            },
                                            "secretRef": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.scaleIO.properties.secretRef",
                                            "type": "object",
                                            "properties": {
                                                "name": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.scaleIO.properties.secretRef.properties.name",
                                                "type": "string"
                                                }
                                            }
                                            },
                                            "sslEnabled": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.scaleIO.properties.sslEnabled",
                                            "type": "boolean"
                                            },
                                            "storageMode": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.scaleIO.properties.storageMode",
                                            "type": "string"
                                            },
                                            "storagePool": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.scaleIO.properties.storagePool",
                                            "type": "string"
                                            },
                                            "system": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.scaleIO.properties.system",
                                            "type": "string"
                                            },
                                            "volumeName": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.scaleIO.properties.volumeName",
                                            "type": "string"
                                            }
                                        }
                                        },
                                        "secret": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.secret",
                                        "type": "object",
                                        "properties": {
                                            "defaultMode": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.secret.properties.defaultMode",
                                            "type": "integer"
                                            },
                                            "items": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.secret.properties.items",
                                            "type": "array",
                                            "items": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.secret.properties.items.items",
                                                "type": "object",
                                                "required": [
                                                "key",
                                                "path"
                                                ],
                                                "properties": {
                                                "key": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.secret.properties.items.items.properties.key",
                                                    "type": "string"
                                                },
                                                "mode": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.secret.properties.items.items.properties.mode",
                                                    "type": "integer"
                                                },
                                                "path": {
                                                    "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.secret.properties.items.items.properties.path",
                                                    "type": "string"
                                                }
                                                }
                                            }
                                            },
                                            "optional": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.secret.properties.optional",
                                            "type": "boolean"
                                            },
                                            "secretName": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.secret.properties.secretName",
                                            "type": "string"
                                            }
                                        }
                                        },
                                        "storageos": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.storageos",
                                        "type": "object",
                                        "properties": {
                                            "fsType": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.storageos.properties.fsType",
                                            "type": "string"
                                            },
                                            "readOnly": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.storageos.properties.readOnly",
                                            "type": "boolean"
                                            },
                                            "secretRef": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.storageos.properties.secretRef",
                                            "type": "object",
                                            "properties": {
                                                "name": {
                                                "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.storageos.properties.secretRef.properties.name",
                                                "type": "string"
                                                }
                                            }
                                            },
                                            "volumeName": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.storageos.properties.volumeName",
                                            "type": "string"
                                            },
                                            "volumeNamespace": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.storageos.properties.volumeNamespace",
                                            "type": "string"
                                            }
                                        }
                                        },
                                        "vsphereVolume": {
                                        "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.vsphereVolume",
                                        "type": "object",
                                        "required": [
                                            "volumePath"
                                        ],
                                        "properties": {
                                            "fsType": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.vsphereVolume.properties.fsType",
                                            "type": "string"
                                            },
                                            "storagePolicyID": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.vsphereVolume.properties.storagePolicyID",
                                            "type": "string"
                                            },
                                            "storagePolicyName": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.vsphereVolume.properties.storagePolicyName",
                                            "type": "string"
                                            },
                                            "volumePath": {
                                            "description": "%pytorchjob_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.pytorchReplicaSpecs.properties.Worker.properties.template.properties.spec.properties.volumes.items.properties.vsphereVolume.properties.volumePath",
                                            "type": "string"
                                            }
                                        }
                                        }
                                    }
                                    }
                                }
                                }
                            }
                            }
                        }
                        }
                    }
                    }
                }
                }
            }
            }
        }
        },
        "versions": [
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
        "app": "pytorch-operator",
        "app.kubernetes.io/component": "pytorch",
        "app.kubernetes.io/name": "pytorch-operator",
        "kustomize.component": "pytorch-operator"
        },
        "name": "pytorch-operator",
        "namespace": ai_devops_namespace
    }
    },
    {
    "aggregationRule": {
        "clusterRoleSelectors": [
        {
            "matchLabels": {
            "rbac.authorization.kubeflow.org/aggregate-to-kubeflow-pytorchjobs-admin": "true"
            }
        }
        ]
    },
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRole",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "pytorch",
        "app.kubernetes.io/name": "pytorch-operator",
        "kustomize.component": "pytorch-operator",
        "rbac.authorization.kubeflow.org/aggregate-to-kubeflow-admin": "true"
        },
        "name": "kubeflow-pytorchjobs-admin"
    },
    "rules": []
    },
    {
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRole",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "pytorch",
        "app.kubernetes.io/name": "pytorch-operator",
        "kustomize.component": "pytorch-operator",
        "rbac.authorization.kubeflow.org/aggregate-to-kubeflow-edit": "true",
        "rbac.authorization.kubeflow.org/aggregate-to-kubeflow-pytorchjobs-admin": "true"
        },
        "name": "kubeflow-pytorchjobs-edit"
    },
    "rules": [
        {
        "apiGroups": [
            "kubeflow.org"
        ],
        "resources": [
            "pytorchjobs",
            "pytorchjobs/status",
            "pytorchjobs/finalizers"
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
        "app.kubernetes.io/component": "pytorch",
        "app.kubernetes.io/name": "pytorch-operator",
        "kustomize.component": "pytorch-operator",
        "rbac.authorization.kubeflow.org/aggregate-to-kubeflow-view": "true"
        },
        "name": "kubeflow-pytorchjobs-view"
    },
    "rules": [
        {
        "apiGroups": [
            "kubeflow.org"
        ],
        "resources": [
            "pytorchjobs",
            "pytorchjobs/status",
            "pytorchjobs/finalizers"
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
    "apiVersion": "rbac.authorization.k8s.io/v1beta1",
    "kind": "ClusterRole",
    "metadata": {
        "labels": {
        "app": "pytorch-operator",
        "app.kubernetes.io/component": "pytorch",
        "app.kubernetes.io/name": "pytorch-operator",
        "kustomize.component": "pytorch-operator"
        },
        "name": "pytorch-operator"
    },
    "rules": [
        {
        "apiGroups": [
            "kubeflow.org"
        ],
        "resources": [
            "pytorchjobs",
            "pytorchjobs/status",
            "pytorchjobs/finalizers"
        ],
        "verbs": [
            "*"
        ]
        },
        {
        "apiGroups": [
            "apiextensions.k8s.io"
        ],
        "resources": [
            "customresourcedefinitions"
        ],
        "verbs": [
            "*"
        ]
        },
        {
        "apiGroups": [
            ""
        ],
        "resources": [
            "pods",
            "services",
            "endpoints",
            "events"
        ],
        "verbs": [
            "*"
        ]
        }
    ]
    },
    {
    "apiVersion": "rbac.authorization.k8s.io/v1beta1",
    "kind": "ClusterRoleBinding",
    "metadata": {
        "labels": {
        "app": "pytorch-operator",
        "app.kubernetes.io/component": "pytorch",
        "app.kubernetes.io/name": "pytorch-operator",
        "kustomize.component": "pytorch-operator"
        },
        "name": "pytorch-operator"
    },
    "roleRef": {
        "apiGroup": "rbac.authorization.k8s.io",
        "kind": "ClusterRole",
        "name": "pytorch-operator"
    },
    "subjects": [
        {
        "kind": "ServiceAccount",
        "name": "pytorch-operator",
        "namespace": ai_devops_namespace
        }
    ]
    },
    {
    "apiVersion": "v1",
    "data": {
        "cluster-name": "",
        "clusterDomain": "cluster.local",
        "istio-namespace": istio_namespace,
        "userid-header": "kubeflow-userid",
        "userid-prefix": ""
    },
    "kind": "ConfigMap",
    "metadata": {
        "name": "kubeflow-config-mb6ktt4hf9",
        "namespace": ai_devops_namespace
    }
    },
    {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
        "annotations": {
        "prometheus.io/path": "/metrics",
        "prometheus.io/port": "8443",
        "prometheus.io/scrape": "true"
        },
        "labels": {
        "app": "pytorch-operator",
        "app.kubernetes.io/component": "pytorch",
        "app.kubernetes.io/name": "pytorch-operator",
        "kustomize.component": "pytorch-operator"
        },
        "name": "pytorch-operator",
        "namespace": ai_devops_namespace
    },
    "spec": {
        "ports": [
        {
            "name": "monitoring-port",
            "port": 8443,
            "targetPort": 8443
        }
        ],
        "selector": {
        "app.kubernetes.io/component": "pytorch",
        "app.kubernetes.io/name": "pytorch-operator",
        "kustomize.component": "pytorch-operator",
        "name": "pytorch-operator"
        },
        "type": "ClusterIP"
    }
    },
    {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "pytorch",
        "app.kubernetes.io/name": "pytorch-operator",
        "kustomize.component": "pytorch-operator"
        },
        "name": "pytorch-operator",
        "namespace": ai_devops_namespace
    },
    "spec": {
        "replicas": 1,
        "selector": {
        "matchLabels": {
            "app.kubernetes.io/component": "pytorch",
            "app.kubernetes.io/name": "pytorch-operator",
            "kustomize.component": "pytorch-operator",
            "name": "pytorch-operator"
        }
        },
        "template": {
        "metadata": {
            "annotations": {
            "sidecar.istio.io/inject": "false"
            },
            "labels": {
            "app.kubernetes.io/component": "pytorch",
            "app.kubernetes.io/name": "pytorch-operator",
            "kustomize.component": "pytorch-operator",
            "name": "pytorch-operator"
            }
        },
        "spec": {
            "containers": [
            {
                "command": [
                "/pytorch-operator.v1",
                "--alsologtostderr",
                "-v=1",
                "--monitoring-port=8443"
                ],
                "env": [
                {
                    "name": "MY_POD_NAMESPACE",
                    "valueFrom": {
                    "fieldRef": {
                        "fieldPath": "metadata.namespace"
                    }
                    }
                },
                {
                    "name": "MY_POD_NAME",
                    "valueFrom": {
                    "fieldRef": {
                        "fieldPath": "metadata.name"
                    }
                    }
                }
                ],
                "image": std.join("", [target_registry, "gcr.io/kubeflow-images-public/pytorch-operator:vmaster-g518f9c76"]),
                "name": "pytorch-operator",
                "volumeMounts": [
                    {
                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                        "name": "pytorch-operator-token",
                        "readOnly": true
                    }
                ]
            }
            ],
            "volumes": [
                {
                    "name": "pytorch-operator-token",
                    "secret": {
                        "defaultMode": 420,
                        "secretName": "pytorch-operator-token"
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
        "app.kubernetes.io/component": "pytorch",
        "app.kubernetes.io/name": "pytorch-job-crds"
        },
        "name": "pytorch-job-crds",
        "namespace": ai_devops_namespace
    },
    "spec": {
        "addOwnerRef": true,
        "componentKinds": [
        {
            "group": "core",
            "kind": "Service"
        },
        {
            "group": "apps",
            "kind": "Deployment"
        },
        {
            "group": "core",
            "kind": "ServiceAccount"
        },
        {
            "group": "kubeflow.org",
            "kind": "PyTorchJob"
        }
        ],
        "descriptor": {
        "description": "Pytorch-job-crds contains the \"PyTorchJob\" custom resource definition.",
        "keywords": [
            "pytorchjob",
            "pytorch-operator",
            "pytorch-training"
        ],
        "links": [
            {
            "description": "About",
            "url": "https://github.com/kubeflow/pytorch-operator"
            },
            {
            "description": "Docs",
            "url": "https://www.kubeflow.org/docs/reference/pytorchjob/v1/pytorch/"
            }
        ],
        "maintainers": [
            {
            "email": "johnugeo@cisco.com",
            "name": "Johnu George"
            }
        ],
        "owners": [
            {
            "email": "johnugeo@cisco.com",
            "name": "Johnu George"
            }
        ],
        "type": "pytorch-job-crds",
        "version": "v1"
        },
        "selector": {
        "matchLabels": {
            "app.kubernetes.io/component": "pytorch",
            "app.kubernetes.io/instance": "pytorch-job-crds-v0.7.0",
            "app.kubernetes.io/managed-by": "kfctl",
            "app.kubernetes.io/name": "pytorch-job-crds",
            "app.kubernetes.io/part-of": "kubeflow",
            "app.kubernetes.io/version": "v0.7.0"
        }
        }
    }
    },
    {
    "apiVersion": "app.k8s.io/v1beta1",
    "kind": "Application",
    "metadata": {
        "labels": {
        "app.kubernetes.io/component": "pytorch",
        "app.kubernetes.io/name": "pytorch-operator"
        },
        "name": "pytorch-operator",
        "namespace": ai_devops_namespace
    },
    "spec": {
        "addOwnerRef": true,
        "componentKinds": [
        {
            "group": "core",
            "kind": "Service"
        },
        {
            "group": "apps",
            "kind": "Deployment"
        },
        {
            "group": "core",
            "kind": "ConfigMap"
        },
        {
            "group": "core",
            "kind": "ServiceAccount"
        },
        {
            "group": "kubeflow.org",
            "kind": "PyTorchJob"
        }
        ],
        "descriptor": {
        "description": "Pytorch-operator allows users to create and manage the \"PyTorchJob\" custom resource.",
        "keywords": [
            "pytorchjob",
            "pytorch-operator",
            "pytorch-training"
        ],
        "links": [
            {
            "description": "About",
            "url": "https://github.com/kubeflow/pytorch-operator"
            },
            {
            "description": "Docs",
            "url": "https://www.kubeflow.org/docs/reference/pytorchjob/v1/pytorch/"
            }
        ],
        "maintainers": [
            {
            "email": "johnugeo@cisco.com",
            "name": "Johnu George"
            }
        ],
        "owners": [
            {
            "email": "johnugeo@cisco.com",
            "name": "Johnu George"
            }
        ],
        "type": "pytorch-operator",
        "version": "v1"
        },
        "selector": {
        "matchLabels": {
            "app.kubernetes.io/component": "pytorch",
            "app.kubernetes.io/instance": "pytorch-operator-v0.7.0",
            "app.kubernetes.io/managed-by": "kfctl",
            "app.kubernetes.io/name": "pytorch-operator",
            "app.kubernetes.io/part-of": "kubeflow",
            "app.kubernetes.io/version": "v0.7.0"
        }
        }
    }
    },
    {
    "apiVersion": "v1",
    "kind": "Secret",
    "metadata": {
        "name": "pytorch-operator-token",
        "namespace": ai_devops_namespace,
        "annotations": {
        "kubernetes.io/service-account.name": "pytorch-operator"
        }
    },
    "type": "kubernetes.io/service-account-token"
    }
]    