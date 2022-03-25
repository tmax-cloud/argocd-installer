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
    "apiVersion": "apiextensions.k8s.io/v1",
    "kind": "CustomResourceDefinition",
    "metadata": {
        "annotations": {
        "controller-gen.kubebuilder.io/version": "v0.4.1"
        },
        "creationTimestamp": null,
        "name": "notebooks.kubeflow.tmax.io"
    },
    "spec": {
        "group": "kubeflow.tmax.io",
        "names": {
        "kind": "Notebook",
        "listKind": "NotebookList",
        "plural": "notebooks",
        "singular": "notebook"
        },
        "scope": "Namespaced",
        "versions": [
        {
            "name": "v1",
            "schema": {
            "openAPIV3Schema": {
                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema",
                "properties": {
                "apiVersion": {
                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.apiVersion",
                    "type": "string"
                },
                "kind": {
                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.kind",
                    "type": "string"
                },
                "metadata": {
                    "type": "object"
                },
                "spec": {
                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec",
                    "properties": {
                    "template": {
                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template",
                        "properties": {
                        "spec": {
                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec",
                            "properties": {
                            "activeDeadlineSeconds": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.activeDeadlineSeconds",
                                "format": "int64",
                                "type": "integer"
                            },
                            "affinity": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity",
                                "properties": {
                                "nodeAffinity": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.nodeAffinity",
                                    "properties": {
                                    "preferredDuringSchedulingIgnoredDuringExecution": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution",
                                        "items": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items",
                                        "properties": {
                                            "preference": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.preference",
                                            "properties": {
                                                "matchExpressions": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.preference.properties.matchExpressions",
                                                "items": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.preference.properties.matchExpressions.items",
                                                    "properties": {
                                                    "key": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.preference.properties.matchExpressions.items.properties.key",
                                                        "type": "string"
                                                    },
                                                    "operator": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.preference.properties.matchExpressions.items.properties.operator",
                                                        "type": "string"
                                                    },
                                                    "values": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.preference.properties.matchExpressions.items.properties.values",
                                                        "items": {
                                                        "type": "string"
                                                        },
                                                        "type": "array"
                                                    }
                                                    },
                                                    "required": [
                                                    "key",
                                                    "operator"
                                                    ],
                                                    "type": "object"
                                                },
                                                "type": "array"
                                                },
                                                "matchFields": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.preference.properties.matchFields",
                                                "items": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.preference.properties.matchFields.items",
                                                    "properties": {
                                                    "key": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.preference.properties.matchFields.items.properties.key",
                                                        "type": "string"
                                                    },
                                                    "operator": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.preference.properties.matchFields.items.properties.operator",
                                                        "type": "string"
                                                    },
                                                    "values": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.preference.properties.matchFields.items.properties.values",
                                                        "items": {
                                                        "type": "string"
                                                        },
                                                        "type": "array"
                                                    }
                                                    },
                                                    "required": [
                                                    "key",
                                                    "operator"
                                                    ],
                                                    "type": "object"
                                                },
                                                "type": "array"
                                                }
                                            },
                                            "type": "object"
                                            },
                                            "weight": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.weight",
                                            "format": "int32",
                                            "type": "integer"
                                            }
                                        },
                                        "required": [
                                            "preference",
                                            "weight"
                                        ],
                                        "type": "object"
                                        },
                                        "type": "array"
                                    },
                                    "requiredDuringSchedulingIgnoredDuringExecution": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution",
                                        "properties": {
                                        "nodeSelectorTerms": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms",
                                            "items": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms.items",
                                            "properties": {
                                                "matchExpressions": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms.items.properties.matchExpressions",
                                                "items": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms.items.properties.matchExpressions.items",
                                                    "properties": {
                                                    "key": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms.items.properties.matchExpressions.items.properties.key",
                                                        "type": "string"
                                                    },
                                                    "operator": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms.items.properties.matchExpressions.items.properties.operator",
                                                        "type": "string"
                                                    },
                                                    "values": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms.items.properties.matchExpressions.items.properties.values",
                                                        "items": {
                                                        "type": "string"
                                                        },
                                                        "type": "array"
                                                    }
                                                    },
                                                    "required": [
                                                    "key",
                                                    "operator"
                                                    ],
                                                    "type": "object"
                                                },
                                                "type": "array"
                                                },
                                                "matchFields": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms.items.properties.matchFields",
                                                "items": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms.items.properties.matchFields.items",
                                                    "properties": {
                                                    "key": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms.items.properties.matchFields.items.properties.key",
                                                        "type": "string"
                                                    },
                                                    "operator": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms.items.properties.matchFields.items.properties.operator",
                                                        "type": "string"
                                                    },
                                                    "values": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.nodeAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.properties.nodeSelectorTerms.items.properties.matchFields.items.properties.values",
                                                        "items": {
                                                        "type": "string"
                                                        },
                                                        "type": "array"
                                                    }
                                                    },
                                                    "required": [
                                                    "key",
                                                    "operator"
                                                    ],
                                                    "type": "object"
                                                },
                                                "type": "array"
                                                }
                                            },
                                            "type": "object"
                                            },
                                            "type": "array"
                                        }
                                        },
                                        "required": [
                                        "nodeSelectorTerms"
                                        ],
                                        "type": "object"
                                    }
                                    },
                                    "type": "object"
                                },
                                "podAffinity": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAffinity",
                                    "properties": {
                                    "preferredDuringSchedulingIgnoredDuringExecution": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution",
                                        "items": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items",
                                        "properties": {
                                            "podAffinityTerm": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm",
                                            "properties": {
                                                "labelSelector": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector",
                                                "properties": {
                                                    "matchExpressions": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchExpressions",
                                                    "items": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchExpressions.items",
                                                        "properties": {
                                                        "key": {
                                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchExpressions.items.properties.key",
                                                            "type": "string"
                                                        },
                                                        "operator": {
                                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchExpressions.items.properties.operator",
                                                            "type": "string"
                                                        },
                                                        "values": {
                                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchExpressions.items.properties.values",
                                                            "items": {
                                                            "type": "string"
                                                            },
                                                            "type": "array"
                                                        }
                                                        },
                                                        "required": [
                                                        "key",
                                                        "operator"
                                                        ],
                                                        "type": "object"
                                                    },
                                                    "type": "array"
                                                    },
                                                    "matchLabels": {
                                                    "additionalProperties": {
                                                        "type": "string"
                                                    },
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchLabels",
                                                    "type": "object"
                                                    }
                                                },
                                                "type": "object"
                                                },
                                                "namespaces": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.namespaces",
                                                "items": {
                                                    "type": "string"
                                                },
                                                "type": "array"
                                                },
                                                "topologyKey": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.topologyKey",
                                                "type": "string"
                                                }
                                            },
                                            "required": [
                                                "topologyKey"
                                            ],
                                            "type": "object"
                                            },
                                            "weight": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.weight",
                                            "format": "int32",
                                            "type": "integer"
                                            }
                                        },
                                        "required": [
                                            "podAffinityTerm",
                                            "weight"
                                        ],
                                        "type": "object"
                                        },
                                        "type": "array"
                                    },
                                    "requiredDuringSchedulingIgnoredDuringExecution": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution",
                                        "items": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items",
                                        "properties": {
                                            "labelSelector": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector",
                                            "properties": {
                                                "matchExpressions": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchExpressions",
                                                "items": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchExpressions.items",
                                                    "properties": {
                                                    "key": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchExpressions.items.properties.key",
                                                        "type": "string"
                                                    },
                                                    "operator": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchExpressions.items.properties.operator",
                                                        "type": "string"
                                                    },
                                                    "values": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchExpressions.items.properties.values",
                                                        "items": {
                                                        "type": "string"
                                                        },
                                                        "type": "array"
                                                    }
                                                    },
                                                    "required": [
                                                    "key",
                                                    "operator"
                                                    ],
                                                    "type": "object"
                                                },
                                                "type": "array"
                                                },
                                                "matchLabels": {
                                                "additionalProperties": {
                                                    "type": "string"
                                                },
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchLabels",
                                                "type": "object"
                                                }
                                            },
                                            "type": "object"
                                            },
                                            "namespaces": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.namespaces",
                                            "items": {
                                                "type": "string"
                                            },
                                            "type": "array"
                                            },
                                            "topologyKey": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.topologyKey",
                                            "type": "string"
                                            }
                                        },
                                        "required": [
                                            "topologyKey"
                                        ],
                                        "type": "object"
                                        },
                                        "type": "array"
                                    }
                                    },
                                    "type": "object"
                                },
                                "podAntiAffinity": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity",
                                    "properties": {
                                    "preferredDuringSchedulingIgnoredDuringExecution": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution",
                                        "items": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items",
                                        "properties": {
                                            "podAffinityTerm": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm",
                                            "properties": {
                                                "labelSelector": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector",
                                                "properties": {
                                                    "matchExpressions": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchExpressions",
                                                    "items": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchExpressions.items",
                                                        "properties": {
                                                        "key": {
                                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchExpressions.items.properties.key",
                                                            "type": "string"
                                                        },
                                                        "operator": {
                                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchExpressions.items.properties.operator",
                                                            "type": "string"
                                                        },
                                                        "values": {
                                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchExpressions.items.properties.values",
                                                            "items": {
                                                            "type": "string"
                                                            },
                                                            "type": "array"
                                                        }
                                                        },
                                                        "required": [
                                                        "key",
                                                        "operator"
                                                        ],
                                                        "type": "object"
                                                    },
                                                    "type": "array"
                                                    },
                                                    "matchLabels": {
                                                    "additionalProperties": {
                                                        "type": "string"
                                                    },
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.labelSelector.properties.matchLabels",
                                                    "type": "object"
                                                    }
                                                },
                                                "type": "object"
                                                },
                                                "namespaces": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.namespaces",
                                                "items": {
                                                    "type": "string"
                                                },
                                                "type": "array"
                                                },
                                                "topologyKey": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.podAffinityTerm.properties.topologyKey",
                                                "type": "string"
                                                }
                                            },
                                            "required": [
                                                "topologyKey"
                                            ],
                                            "type": "object"
                                            },
                                            "weight": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.preferredDuringSchedulingIgnoredDuringExecution.items.properties.weight",
                                            "format": "int32",
                                            "type": "integer"
                                            }
                                        },
                                        "required": [
                                            "podAffinityTerm",
                                            "weight"
                                        ],
                                        "type": "object"
                                        },
                                        "type": "array"
                                    },
                                    "requiredDuringSchedulingIgnoredDuringExecution": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution",
                                        "items": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items",
                                        "properties": {
                                            "labelSelector": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector",
                                            "properties": {
                                                "matchExpressions": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchExpressions",
                                                "items": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchExpressions.items",
                                                    "properties": {
                                                    "key": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchExpressions.items.properties.key",
                                                        "type": "string"
                                                    },
                                                    "operator": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchExpressions.items.properties.operator",
                                                        "type": "string"
                                                    },
                                                    "values": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchExpressions.items.properties.values",
                                                        "items": {
                                                        "type": "string"
                                                        },
                                                        "type": "array"
                                                    }
                                                    },
                                                    "required": [
                                                    "key",
                                                    "operator"
                                                    ],
                                                    "type": "object"
                                                },
                                                "type": "array"
                                                },
                                                "matchLabels": {
                                                "additionalProperties": {
                                                    "type": "string"
                                                },
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.labelSelector.properties.matchLabels",
                                                "type": "object"
                                                }
                                            },
                                            "type": "object"
                                            },
                                            "namespaces": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.namespaces",
                                            "items": {
                                                "type": "string"
                                            },
                                            "type": "array"
                                            },
                                            "topologyKey": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.affinity.properties.podAntiAffinity.properties.requiredDuringSchedulingIgnoredDuringExecution.items.properties.topologyKey",
                                            "type": "string"
                                            }
                                        },
                                        "required": [
                                            "topologyKey"
                                        ],
                                        "type": "object"
                                        },
                                        "type": "array"
                                    }
                                    },
                                    "type": "object"
                                }
                                },
                                "type": "object"
                            },
                            "automountServiceAccountToken": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.automountServiceAccountToken",
                                "type": "boolean"
                            },
                            "containers": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers",
                                "items": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items",
                                "properties": {
                                    "args": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.args",
                                    "items": {
                                        "type": "string"
                                    },
                                    "type": "array"
                                    },
                                    "command": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.command",
                                    "items": {
                                        "type": "string"
                                    },
                                    "type": "array"
                                    },
                                    "env": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.env",
                                    "items": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.env.items",
                                        "properties": {
                                        "name": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.name",
                                            "type": "string"
                                        },
                                        "value": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.value",
                                            "type": "string"
                                        },
                                        "valueFrom": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom",
                                            "properties": {
                                            "configMapKeyRef": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.configMapKeyRef",
                                                "properties": {
                                                "key": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.configMapKeyRef.properties.key",
                                                    "type": "string"
                                                },
                                                "name": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.configMapKeyRef.properties.name",
                                                    "type": "string"
                                                },
                                                "optional": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.configMapKeyRef.properties.optional",
                                                    "type": "boolean"
                                                }
                                                },
                                                "required": [
                                                "key"
                                                ],
                                                "type": "object"
                                            },
                                            "fieldRef": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.fieldRef",
                                                "properties": {
                                                "apiVersion": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.fieldRef.properties.apiVersion",
                                                    "type": "string"
                                                },
                                                "fieldPath": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.fieldRef.properties.fieldPath",
                                                    "type": "string"
                                                }
                                                },
                                                "required": [
                                                "fieldPath"
                                                ],
                                                "type": "object"
                                            },
                                            "resourceFieldRef": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.resourceFieldRef",
                                                "properties": {
                                                "containerName": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.resourceFieldRef.properties.containerName",
                                                    "type": "string"
                                                },
                                                "divisor": {
                                                    "anyOf": [
                                                    {
                                                        "type": "integer"
                                                    },
                                                    {
                                                        "type": "string"
                                                    }
                                                    ],
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.resourceFieldRef.properties.divisor",
                                                    "pattern": "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$",
                                                    "x-kubernetes-int-or-string": true
                                                },
                                                "resource": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.resourceFieldRef.properties.resource",
                                                    "type": "string"
                                                }
                                                },
                                                "required": [
                                                "resource"
                                                ],
                                                "type": "object"
                                            },
                                            "secretKeyRef": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.secretKeyRef",
                                                "properties": {
                                                "key": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.secretKeyRef.properties.key",
                                                    "type": "string"
                                                },
                                                "name": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.secretKeyRef.properties.name",
                                                    "type": "string"
                                                },
                                                "optional": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.env.items.properties.valueFrom.properties.secretKeyRef.properties.optional",
                                                    "type": "boolean"
                                                }
                                                },
                                                "required": [
                                                "key"
                                                ],
                                                "type": "object"
                                            }
                                            },
                                            "type": "object"
                                        }
                                        },
                                        "required": [
                                        "name"
                                        ],
                                        "type": "object"
                                    },
                                    "type": "array"
                                    },
                                    "envFrom": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.envFrom",
                                    "items": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.envFrom.items",
                                        "properties": {
                                        "configMapRef": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.envFrom.items.properties.configMapRef",
                                            "properties": {
                                            "name": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.envFrom.items.properties.configMapRef.properties.name",
                                                "type": "string"
                                            },
                                            "optional": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.envFrom.items.properties.configMapRef.properties.optional",
                                                "type": "boolean"
                                            }
                                            },
                                            "type": "object"
                                        },
                                        "prefix": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.envFrom.items.properties.prefix",
                                            "type": "string"
                                        },
                                        "secretRef": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.envFrom.items.properties.secretRef",
                                            "properties": {
                                            "name": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.envFrom.items.properties.secretRef.properties.name",
                                                "type": "string"
                                            },
                                            "optional": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.envFrom.items.properties.secretRef.properties.optional",
                                                "type": "boolean"
                                            }
                                            },
                                            "type": "object"
                                        }
                                        },
                                        "type": "object"
                                    },
                                    "type": "array"
                                    },
                                    "image": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.image",
                                    "type": "string"
                                    },
                                    "imagePullPolicy": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.imagePullPolicy",
                                    "type": "string"
                                    },
                                    "lifecycle": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.lifecycle",
                                    "properties": {
                                        "postStart": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart",
                                        "properties": {
                                            "exec": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.exec",
                                            "properties": {
                                                "command": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.exec.properties.command",
                                                "items": {
                                                    "type": "string"
                                                },
                                                "type": "array"
                                                }
                                            },
                                            "type": "object"
                                            },
                                            "httpGet": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.httpGet",
                                            "properties": {
                                                "host": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.host",
                                                "type": "string"
                                                },
                                                "httpHeaders": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.httpHeaders",
                                                "items": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.httpHeaders.items",
                                                    "properties": {
                                                    "name": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.httpHeaders.items.properties.name",
                                                        "type": "string"
                                                    },
                                                    "value": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.httpHeaders.items.properties.value",
                                                        "type": "string"
                                                    }
                                                    },
                                                    "required": [
                                                    "name",
                                                    "value"
                                                    ],
                                                    "type": "object"
                                                },
                                                "type": "array"
                                                },
                                                "path": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.path",
                                                "type": "string"
                                                },
                                                "port": {
                                                "anyOf": [
                                                    {
                                                    "type": "integer"
                                                    },
                                                    {
                                                    "type": "string"
                                                    }
                                                ],
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.port",
                                                "x-kubernetes-int-or-string": true
                                                },
                                                "scheme": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.scheme",
                                                "type": "string"
                                                }
                                            },
                                            "required": [
                                                "port"
                                            ],
                                            "type": "object"
                                            },
                                            "tcpSocket": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.tcpSocket",
                                            "properties": {
                                                "host": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.tcpSocket.properties.host",
                                                "type": "string"
                                                },
                                                "port": {
                                                "anyOf": [
                                                    {
                                                    "type": "integer"
                                                    },
                                                    {
                                                    "type": "string"
                                                    }
                                                ],
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.postStart.properties.tcpSocket.properties.port",
                                                "x-kubernetes-int-or-string": true
                                                }
                                            },
                                            "required": [
                                                "port"
                                            ],
                                            "type": "object"
                                            }
                                        },
                                        "type": "object"
                                        },
                                        "preStop": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop",
                                        "properties": {
                                            "exec": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.exec",
                                            "properties": {
                                                "command": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.exec.properties.command",
                                                "items": {
                                                    "type": "string"
                                                },
                                                "type": "array"
                                                }
                                            },
                                            "type": "object"
                                            },
                                            "httpGet": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.httpGet",
                                            "properties": {
                                                "host": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.host",
                                                "type": "string"
                                                },
                                                "httpHeaders": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.httpHeaders",
                                                "items": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.httpHeaders.items",
                                                    "properties": {
                                                    "name": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.httpHeaders.items.properties.name",
                                                        "type": "string"
                                                    },
                                                    "value": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.httpHeaders.items.properties.value",
                                                        "type": "string"
                                                    }
                                                    },
                                                    "required": [
                                                    "name",
                                                    "value"
                                                    ],
                                                    "type": "object"
                                                },
                                                "type": "array"
                                                },
                                                "path": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.path",
                                                "type": "string"
                                                },
                                                "port": {
                                                "anyOf": [
                                                    {
                                                    "type": "integer"
                                                    },
                                                    {
                                                    "type": "string"
                                                    }
                                                ],
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.port",
                                                "x-kubernetes-int-or-string": true
                                                },
                                                "scheme": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.scheme",
                                                "type": "string"
                                                }
                                            },
                                            "required": [
                                                "port"
                                            ],
                                            "type": "object"
                                            },
                                            "tcpSocket": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.tcpSocket",
                                            "properties": {
                                                "host": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.tcpSocket.properties.host",
                                                "type": "string"
                                                },
                                                "port": {
                                                "anyOf": [
                                                    {
                                                    "type": "integer"
                                                    },
                                                    {
                                                    "type": "string"
                                                    }
                                                ],
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.lifecycle.properties.preStop.properties.tcpSocket.properties.port",
                                                "x-kubernetes-int-or-string": true
                                                }
                                            },
                                            "required": [
                                                "port"
                                            ],
                                            "type": "object"
                                            }
                                        },
                                        "type": "object"
                                        }
                                    },
                                    "type": "object"
                                    },
                                    "livenessProbe": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.livenessProbe",
                                    "properties": {
                                        "exec": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.exec",
                                        "properties": {
                                            "command": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.exec.properties.command",
                                            "items": {
                                                "type": "string"
                                            },
                                            "type": "array"
                                            }
                                        },
                                        "type": "object"
                                        },
                                        "failureThreshold": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.failureThreshold",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "httpGet": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.httpGet",
                                        "properties": {
                                            "host": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.httpGet.properties.host",
                                            "type": "string"
                                            },
                                            "httpHeaders": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.httpGet.properties.httpHeaders",
                                            "items": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.httpGet.properties.httpHeaders.items",
                                                "properties": {
                                                "name": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.httpGet.properties.httpHeaders.items.properties.name",
                                                    "type": "string"
                                                },
                                                "value": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.httpGet.properties.httpHeaders.items.properties.value",
                                                    "type": "string"
                                                }
                                                },
                                                "required": [
                                                "name",
                                                "value"
                                                ],
                                                "type": "object"
                                            },
                                            "type": "array"
                                            },
                                            "path": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.httpGet.properties.path",
                                            "type": "string"
                                            },
                                            "port": {
                                            "anyOf": [
                                                {
                                                "type": "integer"
                                                },
                                                {
                                                "type": "string"
                                                }
                                            ],
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.httpGet.properties.port",
                                            "x-kubernetes-int-or-string": true
                                            },
                                            "scheme": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.httpGet.properties.scheme",
                                            "type": "string"
                                            }
                                        },
                                        "required": [
                                            "port"
                                        ],
                                        "type": "object"
                                        },
                                        "initialDelaySeconds": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.initialDelaySeconds",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "periodSeconds": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.periodSeconds",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "successThreshold": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.successThreshold",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "tcpSocket": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.tcpSocket",
                                        "properties": {
                                            "host": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.tcpSocket.properties.host",
                                            "type": "string"
                                            },
                                            "port": {
                                            "anyOf": [
                                                {
                                                "type": "integer"
                                                },
                                                {
                                                "type": "string"
                                                }
                                            ],
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.tcpSocket.properties.port",
                                            "x-kubernetes-int-or-string": true
                                            }
                                        },
                                        "required": [
                                            "port"
                                        ],
                                        "type": "object"
                                        },
                                        "timeoutSeconds": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.livenessProbe.properties.timeoutSeconds",
                                        "format": "int32",
                                        "type": "integer"
                                        }
                                    },
                                    "type": "object"
                                    },
                                    "name": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.name",
                                    "type": "string"
                                    },
                                    "ports": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.ports",
                                    "items": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.ports.items",
                                        "properties": {
                                        "containerPort": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.ports.items.properties.containerPort",
                                            "format": "int32",
                                            "type": "integer"
                                        },
                                        "hostIP": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.ports.items.properties.hostIP",
                                            "type": "string"
                                        },
                                        "hostPort": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.ports.items.properties.hostPort",
                                            "format": "int32",
                                            "type": "integer"
                                        },
                                        "name": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.ports.items.properties.name",
                                            "type": "string"
                                        },
                                        "protocol": {
                                            "default": "TCP",
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.ports.items.properties.protocol",
                                            "type": "string"
                                        }
                                        },
                                        "required": [
                                        "containerPort"
                                        ],
                                        "type": "object"
                                    },
                                    "type": "array",
                                    "x-kubernetes-list-map-keys": [
                                        "containerPort",
                                        "protocol"
                                    ],
                                    "x-kubernetes-list-type": "map"
                                    },
                                    "readinessProbe": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.readinessProbe",
                                    "properties": {
                                        "exec": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.exec",
                                        "properties": {
                                            "command": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.exec.properties.command",
                                            "items": {
                                                "type": "string"
                                            },
                                            "type": "array"
                                            }
                                        },
                                        "type": "object"
                                        },
                                        "failureThreshold": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.failureThreshold",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "httpGet": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.httpGet",
                                        "properties": {
                                            "host": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.httpGet.properties.host",
                                            "type": "string"
                                            },
                                            "httpHeaders": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.httpGet.properties.httpHeaders",
                                            "items": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.httpGet.properties.httpHeaders.items",
                                                "properties": {
                                                "name": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.httpGet.properties.httpHeaders.items.properties.name",
                                                    "type": "string"
                                                },
                                                "value": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.httpGet.properties.httpHeaders.items.properties.value",
                                                    "type": "string"
                                                }
                                                },
                                                "required": [
                                                "name",
                                                "value"
                                                ],
                                                "type": "object"
                                            },
                                            "type": "array"
                                            },
                                            "path": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.httpGet.properties.path",
                                            "type": "string"
                                            },
                                            "port": {
                                            "anyOf": [
                                                {
                                                "type": "integer"
                                                },
                                                {
                                                "type": "string"
                                                }
                                            ],
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.httpGet.properties.port",
                                            "x-kubernetes-int-or-string": true
                                            },
                                            "scheme": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.httpGet.properties.scheme",
                                            "type": "string"
                                            }
                                        },
                                        "required": [
                                            "port"
                                        ],
                                        "type": "object"
                                        },
                                        "initialDelaySeconds": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.initialDelaySeconds",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "periodSeconds": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.periodSeconds",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "successThreshold": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.successThreshold",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "tcpSocket": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.tcpSocket",
                                        "properties": {
                                            "host": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.tcpSocket.properties.host",
                                            "type": "string"
                                            },
                                            "port": {
                                            "anyOf": [
                                                {
                                                "type": "integer"
                                                },
                                                {
                                                "type": "string"
                                                }
                                            ],
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.tcpSocket.properties.port",
                                            "x-kubernetes-int-or-string": true
                                            }
                                        },
                                        "required": [
                                            "port"
                                        ],
                                        "type": "object"
                                        },
                                        "timeoutSeconds": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.readinessProbe.properties.timeoutSeconds",
                                        "format": "int32",
                                        "type": "integer"
                                        }
                                    },
                                    "type": "object"
                                    },
                                    "resources": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.resources",
                                    "properties": {
                                        "limits": {
                                        "additionalProperties": {
                                            "anyOf": [
                                            {
                                                "type": "integer"
                                            },
                                            {
                                                "type": "string"
                                            }
                                            ],
                                            "pattern": "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$",
                                            "x-kubernetes-int-or-string": true
                                        },
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.resources.properties.limits",
                                        "type": "object"
                                        },
                                        "requests": {
                                        "additionalProperties": {
                                            "anyOf": [
                                            {
                                                "type": "integer"
                                            },
                                            {
                                                "type": "string"
                                            }
                                            ],
                                            "pattern": "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$",
                                            "x-kubernetes-int-or-string": true
                                        },
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.resources.properties.requests",
                                        "type": "object"
                                        }
                                    },
                                    "type": "object"
                                    },
                                    "securityContext": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.securityContext",
                                    "properties": {
                                        "allowPrivilegeEscalation": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.allowPrivilegeEscalation",
                                        "type": "boolean"
                                        },
                                        "capabilities": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.capabilities",
                                        "properties": {
                                            "add": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.capabilities.properties.add",
                                            "items": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.capabilities.properties.add.items",
                                                "type": "string"
                                            },
                                            "type": "array"
                                            },
                                            "drop": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.capabilities.properties.drop",
                                            "items": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.capabilities.properties.drop.items",
                                                "type": "string"
                                            },
                                            "type": "array"
                                            }
                                        },
                                        "type": "object"
                                        },
                                        "privileged": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.privileged",
                                        "type": "boolean"
                                        },
                                        "procMount": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.procMount",
                                        "type": "string"
                                        },
                                        "readOnlyRootFilesystem": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.readOnlyRootFilesystem",
                                        "type": "boolean"
                                        },
                                        "runAsGroup": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.runAsGroup",
                                        "format": "int64",
                                        "type": "integer"
                                        },
                                        "runAsNonRoot": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.runAsNonRoot",
                                        "type": "boolean"
                                        },
                                        "runAsUser": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.runAsUser",
                                        "format": "int64",
                                        "type": "integer"
                                        },
                                        "seLinuxOptions": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.seLinuxOptions",
                                        "properties": {
                                            "level": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.seLinuxOptions.properties.level",
                                            "type": "string"
                                            },
                                            "role": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.seLinuxOptions.properties.role",
                                            "type": "string"
                                            },
                                            "type": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.seLinuxOptions.properties.type",
                                            "type": "string"
                                            },
                                            "user": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.seLinuxOptions.properties.user",
                                            "type": "string"
                                            }
                                        },
                                        "type": "object"
                                        },
                                        "windowsOptions": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.windowsOptions",
                                        "properties": {
                                            "gmsaCredentialSpec": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.windowsOptions.properties.gmsaCredentialSpec",
                                            "type": "string"
                                            },
                                            "gmsaCredentialSpecName": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.windowsOptions.properties.gmsaCredentialSpecName",
                                            "type": "string"
                                            },
                                            "runAsUserName": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.securityContext.properties.windowsOptions.properties.runAsUserName",
                                            "type": "string"
                                            }
                                        },
                                        "type": "object"
                                        }
                                    },
                                    "type": "object"
                                    },
                                    "startupProbe": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.startupProbe",
                                    "properties": {
                                        "exec": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.startupProbe.properties.exec",
                                        "properties": {
                                            "command": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.startupProbe.properties.exec.properties.command",
                                            "items": {
                                                "type": "string"
                                            },
                                            "type": "array"
                                            }
                                        },
                                        "type": "object"
                                        },
                                        "failureThreshold": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.startupProbe.properties.failureThreshold",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "httpGet": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.startupProbe.properties.httpGet",
                                        "properties": {
                                            "host": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.startupProbe.properties.httpGet.properties.host",
                                            "type": "string"
                                            },
                                            "httpHeaders": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.startupProbe.properties.httpGet.properties.httpHeaders",
                                            "items": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.startupProbe.properties.httpGet.properties.httpHeaders.items",
                                                "properties": {
                                                "name": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.startupProbe.properties.httpGet.properties.httpHeaders.items.properties.name",
                                                    "type": "string"
                                                },
                                                "value": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.startupProbe.properties.httpGet.properties.httpHeaders.items.properties.value",
                                                    "type": "string"
                                                }
                                                },
                                                "required": [
                                                "name",
                                                "value"
                                                ],
                                                "type": "object"
                                            },
                                            "type": "array"
                                            },
                                            "path": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.startupProbe.properties.httpGet.properties.path",
                                            "type": "string"
                                            },
                                            "port": {
                                            "anyOf": [
                                                {
                                                "type": "integer"
                                                },
                                                {
                                                "type": "string"
                                                }
                                            ],
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.startupProbe.properties.httpGet.properties.port",
                                            "x-kubernetes-int-or-string": true
                                            },
                                            "scheme": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.startupProbe.properties.httpGet.properties.scheme",
                                            "type": "string"
                                            }
                                        },
                                        "required": [
                                            "port"
                                        ],
                                        "type": "object"
                                        },
                                        "initialDelaySeconds": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.startupProbe.properties.initialDelaySeconds",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "periodSeconds": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.startupProbe.properties.periodSeconds",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "successThreshold": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.startupProbe.properties.successThreshold",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "tcpSocket": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.startupProbe.properties.tcpSocket",
                                        "properties": {
                                            "host": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.startupProbe.properties.tcpSocket.properties.host",
                                            "type": "string"
                                            },
                                            "port": {
                                            "anyOf": [
                                                {
                                                "type": "integer"
                                                },
                                                {
                                                "type": "string"
                                                }
                                            ],
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.startupProbe.properties.tcpSocket.properties.port",
                                            "x-kubernetes-int-or-string": true
                                            }
                                        },
                                        "required": [
                                            "port"
                                        ],
                                        "type": "object"
                                        },
                                        "timeoutSeconds": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.startupProbe.properties.timeoutSeconds",
                                        "format": "int32",
                                        "type": "integer"
                                        }
                                    },
                                    "type": "object"
                                    },
                                    "stdin": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.stdin",
                                    "type": "boolean"
                                    },
                                    "stdinOnce": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.stdinOnce",
                                    "type": "boolean"
                                    },
                                    "terminationMessagePath": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.terminationMessagePath",
                                    "type": "string"
                                    },
                                    "terminationMessagePolicy": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.terminationMessagePolicy",
                                    "type": "string"
                                    },
                                    "tty": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.tty",
                                    "type": "boolean"
                                    },
                                    "volumeDevices": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.volumeDevices",
                                    "items": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.volumeDevices.items",
                                        "properties": {
                                        "devicePath": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.volumeDevices.items.properties.devicePath",
                                            "type": "string"
                                        },
                                        "name": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.volumeDevices.items.properties.name",
                                            "type": "string"
                                        }
                                        },
                                        "required": [
                                        "devicePath",
                                        "name"
                                        ],
                                        "type": "object"
                                    },
                                    "type": "array"
                                    },
                                    "volumeMounts": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.volumeMounts",
                                    "items": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.volumeMounts.items",
                                        "properties": {
                                        "mountPath": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.volumeMounts.items.properties.mountPath",
                                            "type": "string"
                                        },
                                        "mountPropagation": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.volumeMounts.items.properties.mountPropagation",
                                            "type": "string"
                                        },
                                        "name": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.volumeMounts.items.properties.name",
                                            "type": "string"
                                        },
                                        "readOnly": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.volumeMounts.items.properties.readOnly",
                                            "type": "boolean"
                                        },
                                        "subPath": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.volumeMounts.items.properties.subPath",
                                            "type": "string"
                                        },
                                        "subPathExpr": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.volumeMounts.items.properties.subPathExpr",
                                            "type": "string"
                                        }
                                        },
                                        "required": [
                                        "mountPath",
                                        "name"
                                        ],
                                        "type": "object"
                                    },
                                    "type": "array"
                                    },
                                    "workingDir": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.containers.items.properties.workingDir",
                                    "type": "string"
                                    }
                                },
                                "required": [
                                    "name"
                                ],
                                "type": "object"
                                },
                                "type": "array"
                            },
                            "dnsConfig": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.dnsConfig",
                                "properties": {
                                "nameservers": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.dnsConfig.properties.nameservers",
                                    "items": {
                                    "type": "string"
                                    },
                                    "type": "array"
                                },
                                "options": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.dnsConfig.properties.options",
                                    "items": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.dnsConfig.properties.options.items",
                                    "properties": {
                                        "name": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.dnsConfig.properties.options.items.properties.name",
                                        "type": "string"
                                        },
                                        "value": {
                                        "type": "string"
                                        }
                                    },
                                    "type": "object"
                                    },
                                    "type": "array"
                                },
                                "searches": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.dnsConfig.properties.searches",
                                    "items": {
                                    "type": "string"
                                    },
                                    "type": "array"
                                }
                                },
                                "type": "object"
                            },
                            "dnsPolicy": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.dnsPolicy",
                                "type": "string"
                            },
                            "enableServiceLinks": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.enableServiceLinks",
                                "type": "boolean"
                            },
                            "ephemeralContainers": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers",
                                "items": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items",
                                "properties": {
                                    "args": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.args",
                                    "items": {
                                        "type": "string"
                                    },
                                    "type": "array"
                                    },
                                    "command": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.command",
                                    "items": {
                                        "type": "string"
                                    },
                                    "type": "array"
                                    },
                                    "env": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.env",
                                    "items": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.env.items",
                                        "properties": {
                                        "name": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.env.items.properties.name",
                                            "type": "string"
                                        },
                                        "value": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.env.items.properties.value",
                                            "type": "string"
                                        },
                                        "valueFrom": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.env.items.properties.valueFrom",
                                            "properties": {
                                            "configMapKeyRef": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.env.items.properties.valueFrom.properties.configMapKeyRef",
                                                "properties": {
                                                "key": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.env.items.properties.valueFrom.properties.configMapKeyRef.properties.key",
                                                    "type": "string"
                                                },
                                                "name": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.env.items.properties.valueFrom.properties.configMapKeyRef.properties.name",
                                                    "type": "string"
                                                },
                                                "optional": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.env.items.properties.valueFrom.properties.configMapKeyRef.properties.optional",
                                                    "type": "boolean"
                                                }
                                                },
                                                "required": [
                                                "key"
                                                ],
                                                "type": "object"
                                            },
                                            "fieldRef": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.env.items.properties.valueFrom.properties.fieldRef",
                                                "properties": {
                                                "apiVersion": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.env.items.properties.valueFrom.properties.fieldRef.properties.apiVersion",
                                                    "type": "string"
                                                },
                                                "fieldPath": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.env.items.properties.valueFrom.properties.fieldRef.properties.fieldPath",
                                                    "type": "string"
                                                }
                                                },
                                                "required": [
                                                "fieldPath"
                                                ],
                                                "type": "object"
                                            },
                                            "resourceFieldRef": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.env.items.properties.valueFrom.properties.resourceFieldRef",
                                                "properties": {
                                                "containerName": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.env.items.properties.valueFrom.properties.resourceFieldRef.properties.containerName",
                                                    "type": "string"
                                                },
                                                "divisor": {
                                                    "anyOf": [
                                                    {
                                                        "type": "integer"
                                                    },
                                                    {
                                                        "type": "string"
                                                    }
                                                    ],
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.env.items.properties.valueFrom.properties.resourceFieldRef.properties.divisor",
                                                    "pattern": "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$",
                                                    "x-kubernetes-int-or-string": true
                                                },
                                                "resource": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.env.items.properties.valueFrom.properties.resourceFieldRef.properties.resource",
                                                    "type": "string"
                                                }
                                                },
                                                "required": [
                                                "resource"
                                                ],
                                                "type": "object"
                                            },
                                            "secretKeyRef": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.env.items.properties.valueFrom.properties.secretKeyRef",
                                                "properties": {
                                                "key": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.env.items.properties.valueFrom.properties.secretKeyRef.properties.key",
                                                    "type": "string"
                                                },
                                                "name": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.env.items.properties.valueFrom.properties.secretKeyRef.properties.name",
                                                    "type": "string"
                                                },
                                                "optional": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.env.items.properties.valueFrom.properties.secretKeyRef.properties.optional",
                                                    "type": "boolean"
                                                }
                                                },
                                                "required": [
                                                "key"
                                                ],
                                                "type": "object"
                                            }
                                            },
                                            "type": "object"
                                        }
                                        },
                                        "required": [
                                        "name"
                                        ],
                                        "type": "object"
                                    },
                                    "type": "array"
                                    },
                                    "envFrom": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.envFrom",
                                    "items": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.envFrom.items",
                                        "properties": {
                                        "configMapRef": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.envFrom.items.properties.configMapRef",
                                            "properties": {
                                            "name": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.envFrom.items.properties.configMapRef.properties.name",
                                                "type": "string"
                                            },
                                            "optional": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.envFrom.items.properties.configMapRef.properties.optional",
                                                "type": "boolean"
                                            }
                                            },
                                            "type": "object"
                                        },
                                        "prefix": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.envFrom.items.properties.prefix",
                                            "type": "string"
                                        },
                                        "secretRef": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.envFrom.items.properties.secretRef",
                                            "properties": {
                                            "name": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.envFrom.items.properties.secretRef.properties.name",
                                                "type": "string"
                                            },
                                            "optional": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.envFrom.items.properties.secretRef.properties.optional",
                                                "type": "boolean"
                                            }
                                            },
                                            "type": "object"
                                        }
                                        },
                                        "type": "object"
                                    },
                                    "type": "array"
                                    },
                                    "image": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.image",
                                    "type": "string"
                                    },
                                    "imagePullPolicy": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.imagePullPolicy",
                                    "type": "string"
                                    },
                                    "lifecycle": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.lifecycle",
                                    "properties": {
                                        "postStart": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.lifecycle.properties.postStart",
                                        "properties": {
                                            "exec": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.lifecycle.properties.postStart.properties.exec",
                                            "properties": {
                                                "command": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.lifecycle.properties.postStart.properties.exec.properties.command",
                                                "items": {
                                                    "type": "string"
                                                },
                                                "type": "array"
                                                }
                                            },
                                            "type": "object"
                                            },
                                            "httpGet": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.lifecycle.properties.postStart.properties.httpGet",
                                            "properties": {
                                                "host": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.host",
                                                "type": "string"
                                                },
                                                "httpHeaders": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.httpHeaders",
                                                "items": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.httpHeaders.items",
                                                    "properties": {
                                                    "name": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.httpHeaders.items.properties.name",
                                                        "type": "string"
                                                    },
                                                    "value": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.httpHeaders.items.properties.value",
                                                        "type": "string"
                                                    }
                                                    },
                                                    "required": [
                                                    "name",
                                                    "value"
                                                    ],
                                                    "type": "object"
                                                },
                                                "type": "array"
                                                },
                                                "path": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.path",
                                                "type": "string"
                                                },
                                                "port": {
                                                "anyOf": [
                                                    {
                                                    "type": "integer"
                                                    },
                                                    {
                                                    "type": "string"
                                                    }
                                                ],
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.port",
                                                "x-kubernetes-int-or-string": true
                                                },
                                                "scheme": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.scheme",
                                                "type": "string"
                                                }
                                            },
                                            "required": [
                                                "port"
                                            ],
                                            "type": "object"
                                            },
                                            "tcpSocket": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.lifecycle.properties.postStart.properties.tcpSocket",
                                            "properties": {
                                                "host": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.lifecycle.properties.postStart.properties.tcpSocket.properties.host",
                                                "type": "string"
                                                },
                                                "port": {
                                                "anyOf": [
                                                    {
                                                    "type": "integer"
                                                    },
                                                    {
                                                    "type": "string"
                                                    }
                                                ],
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.lifecycle.properties.postStart.properties.tcpSocket.properties.port",
                                                "x-kubernetes-int-or-string": true
                                                }
                                            },
                                            "required": [
                                                "port"
                                            ],
                                            "type": "object"
                                            }
                                        },
                                        "type": "object"
                                        },
                                        "preStop": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.lifecycle.properties.preStop",
                                        "properties": {
                                            "exec": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.lifecycle.properties.preStop.properties.exec",
                                            "properties": {
                                                "command": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.lifecycle.properties.preStop.properties.exec.properties.command",
                                                "items": {
                                                    "type": "string"
                                                },
                                                "type": "array"
                                                }
                                            },
                                            "type": "object"
                                            },
                                            "httpGet": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.lifecycle.properties.preStop.properties.httpGet",
                                            "properties": {
                                                "host": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.host",
                                                "type": "string"
                                                },
                                                "httpHeaders": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.httpHeaders",
                                                "items": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.httpHeaders.items",
                                                    "properties": {
                                                    "name": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.httpHeaders.items.properties.name",
                                                        "type": "string"
                                                    },
                                                    "value": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.httpHeaders.items.properties.value",
                                                        "type": "string"
                                                    }
                                                    },
                                                    "required": [
                                                    "name",
                                                    "value"
                                                    ],
                                                    "type": "object"
                                                },
                                                "type": "array"
                                                },
                                                "path": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.path",
                                                "type": "string"
                                                },
                                                "port": {
                                                "anyOf": [
                                                    {
                                                    "type": "integer"
                                                    },
                                                    {
                                                    "type": "string"
                                                    }
                                                ],
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.port",
                                                "x-kubernetes-int-or-string": true
                                                },
                                                "scheme": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.scheme",
                                                "type": "string"
                                                }
                                            },
                                            "required": [
                                                "port"
                                            ],
                                            "type": "object"
                                            },
                                            "tcpSocket": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.lifecycle.properties.preStop.properties.tcpSocket",
                                            "properties": {
                                                "host": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.lifecycle.properties.preStop.properties.tcpSocket.properties.host",
                                                "type": "string"
                                                },
                                                "port": {
                                                "anyOf": [
                                                    {
                                                    "type": "integer"
                                                    },
                                                    {
                                                    "type": "string"
                                                    }
                                                ],
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.lifecycle.properties.preStop.properties.tcpSocket.properties.port",
                                                "x-kubernetes-int-or-string": true
                                                }
                                            },
                                            "required": [
                                                "port"
                                            ],
                                            "type": "object"
                                            }
                                        },
                                        "type": "object"
                                        }
                                    },
                                    "type": "object"
                                    },
                                    "livenessProbe": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.livenessProbe",
                                    "properties": {
                                        "exec": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.livenessProbe.properties.exec",
                                        "properties": {
                                            "command": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.livenessProbe.properties.exec.properties.command",
                                            "items": {
                                                "type": "string"
                                            },
                                            "type": "array"
                                            }
                                        },
                                        "type": "object"
                                        },
                                        "failureThreshold": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.livenessProbe.properties.failureThreshold",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "httpGet": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.livenessProbe.properties.httpGet",
                                        "properties": {
                                            "host": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.livenessProbe.properties.httpGet.properties.host",
                                            "type": "string"
                                            },
                                            "httpHeaders": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.livenessProbe.properties.httpGet.properties.httpHeaders",
                                            "items": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.livenessProbe.properties.httpGet.properties.httpHeaders.items",
                                                "properties": {
                                                "name": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.livenessProbe.properties.httpGet.properties.httpHeaders.items.properties.name",
                                                    "type": "string"
                                                },
                                                "value": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.livenessProbe.properties.httpGet.properties.httpHeaders.items.properties.value",
                                                    "type": "string"
                                                }
                                                },
                                                "required": [
                                                "name",
                                                "value"
                                                ],
                                                "type": "object"
                                            },
                                            "type": "array"
                                            },
                                            "path": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.livenessProbe.properties.httpGet.properties.path",
                                            "type": "string"
                                            },
                                            "port": {
                                            "anyOf": [
                                                {
                                                "type": "integer"
                                                },
                                                {
                                                "type": "string"
                                                }
                                            ],
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.livenessProbe.properties.httpGet.properties.port",
                                            "x-kubernetes-int-or-string": true
                                            },
                                            "scheme": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.livenessProbe.properties.httpGet.properties.scheme",
                                            "type": "string"
                                            }
                                        },
                                        "required": [
                                            "port"
                                        ],
                                        "type": "object"
                                        },
                                        "initialDelaySeconds": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.livenessProbe.properties.initialDelaySeconds",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "periodSeconds": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.livenessProbe.properties.periodSeconds",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "successThreshold": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.livenessProbe.properties.successThreshold",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "tcpSocket": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.livenessProbe.properties.tcpSocket",
                                        "properties": {
                                            "host": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.livenessProbe.properties.tcpSocket.properties.host",
                                            "type": "string"
                                            },
                                            "port": {
                                            "anyOf": [
                                                {
                                                "type": "integer"
                                                },
                                                {
                                                "type": "string"
                                                }
                                            ],
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.livenessProbe.properties.tcpSocket.properties.port",
                                            "x-kubernetes-int-or-string": true
                                            }
                                        },
                                        "required": [
                                            "port"
                                        ],
                                        "type": "object"
                                        },
                                        "timeoutSeconds": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.livenessProbe.properties.timeoutSeconds",
                                        "format": "int32",
                                        "type": "integer"
                                        }
                                    },
                                    "type": "object"
                                    },
                                    "name": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.name",
                                    "type": "string"
                                    },
                                    "ports": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.ports",
                                    "items": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.ports.items",
                                        "properties": {
                                        "containerPort": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.ports.items.properties.containerPort",
                                            "format": "int32",
                                            "type": "integer"
                                        },
                                        "hostIP": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.ports.items.properties.hostIP",
                                            "type": "string"
                                        },
                                        "hostPort": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.ports.items.properties.hostPort",
                                            "format": "int32",
                                            "type": "integer"
                                        },
                                        "name": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.ports.items.properties.name",
                                            "type": "string"
                                        },
                                        "protocol": {
                                            "default": "TCP",
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.ports.items.properties.protocol",
                                            "type": "string"
                                        }
                                        },
                                        "required": [
                                        "containerPort"
                                        ],
                                        "type": "object"
                                    },
                                    "type": "array"
                                    },
                                    "readinessProbe": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.readinessProbe",
                                    "properties": {
                                        "exec": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.readinessProbe.properties.exec",
                                        "properties": {
                                            "command": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.readinessProbe.properties.exec.properties.command",
                                            "items": {
                                                "type": "string"
                                            },
                                            "type": "array"
                                            }
                                        },
                                        "type": "object"
                                        },
                                        "failureThreshold": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.readinessProbe.properties.failureThreshold",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "httpGet": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.readinessProbe.properties.httpGet",
                                        "properties": {
                                            "host": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.readinessProbe.properties.httpGet.properties.host",
                                            "type": "string"
                                            },
                                            "httpHeaders": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.readinessProbe.properties.httpGet.properties.httpHeaders",
                                            "items": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.readinessProbe.properties.httpGet.properties.httpHeaders.items",
                                                "properties": {
                                                "name": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.readinessProbe.properties.httpGet.properties.httpHeaders.items.properties.name",
                                                    "type": "string"
                                                },
                                                "value": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.readinessProbe.properties.httpGet.properties.httpHeaders.items.properties.value",
                                                    "type": "string"
                                                }
                                                },
                                                "required": [
                                                "name",
                                                "value"
                                                ],
                                                "type": "object"
                                            },
                                            "type": "array"
                                            },
                                            "path": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.readinessProbe.properties.httpGet.properties.path",
                                            "type": "string"
                                            },
                                            "port": {
                                            "anyOf": [
                                                {
                                                "type": "integer"
                                                },
                                                {
                                                "type": "string"
                                                }
                                            ],
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.readinessProbe.properties.httpGet.properties.port",
                                            "x-kubernetes-int-or-string": true
                                            },
                                            "scheme": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.readinessProbe.properties.httpGet.properties.scheme",
                                            "type": "string"
                                            }
                                        },
                                        "required": [
                                            "port"
                                        ],
                                        "type": "object"
                                        },
                                        "initialDelaySeconds": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.readinessProbe.properties.initialDelaySeconds",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "periodSeconds": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.readinessProbe.properties.periodSeconds",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "successThreshold": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.readinessProbe.properties.successThreshold",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "tcpSocket": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.readinessProbe.properties.tcpSocket",
                                        "properties": {
                                            "host": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.readinessProbe.properties.tcpSocket.properties.host",
                                            "type": "string"
                                            },
                                            "port": {
                                            "anyOf": [
                                                {
                                                "type": "integer"
                                                },
                                                {
                                                "type": "string"
                                                }
                                            ],
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.readinessProbe.properties.tcpSocket.properties.port",
                                            "x-kubernetes-int-or-string": true
                                            }
                                        },
                                        "required": [
                                            "port"
                                        ],
                                        "type": "object"
                                        },
                                        "timeoutSeconds": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.readinessProbe.properties.timeoutSeconds",
                                        "format": "int32",
                                        "type": "integer"
                                        }
                                    },
                                    "type": "object"
                                    },
                                    "resources": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.resources",
                                    "properties": {
                                        "limits": {
                                        "additionalProperties": {
                                            "anyOf": [
                                            {
                                                "type": "integer"
                                            },
                                            {
                                                "type": "string"
                                            }
                                            ],
                                            "pattern": "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$",
                                            "x-kubernetes-int-or-string": true
                                        },
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.resources.properties.limits",
                                        "type": "object"
                                        },
                                        "requests": {
                                        "additionalProperties": {
                                            "anyOf": [
                                            {
                                                "type": "integer"
                                            },
                                            {
                                                "type": "string"
                                            }
                                            ],
                                            "pattern": "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$",
                                            "x-kubernetes-int-or-string": true
                                        },
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.resources.properties.requests",
                                        "type": "object"
                                        }
                                    },
                                    "type": "object"
                                    },
                                    "securityContext": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.securityContext",
                                    "properties": {
                                        "allowPrivilegeEscalation": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.securityContext.properties.allowPrivilegeEscalation",
                                        "type": "boolean"
                                        },
                                        "capabilities": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.securityContext.properties.capabilities",
                                        "properties": {
                                            "add": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.securityContext.properties.capabilities.properties.add",
                                            "items": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.securityContext.properties.capabilities.properties.add.items",
                                                "type": "string"
                                            },
                                            "type": "array"
                                            },
                                            "drop": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.securityContext.properties.capabilities.properties.drop",
                                            "items": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.securityContext.properties.capabilities.properties.drop.items",
                                                "type": "string"
                                            },
                                            "type": "array"
                                            }
                                        },
                                        "type": "object"
                                        },
                                        "privileged": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.securityContext.properties.privileged",
                                        "type": "boolean"
                                        },
                                        "procMount": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.securityContext.properties.procMount",
                                        "type": "string"
                                        },
                                        "readOnlyRootFilesystem": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.securityContext.properties.readOnlyRootFilesystem",
                                        "type": "boolean"
                                        },
                                        "runAsGroup": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.securityContext.properties.runAsGroup",
                                        "format": "int64",
                                        "type": "integer"
                                        },
                                        "runAsNonRoot": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.securityContext.properties.runAsNonRoot",
                                        "type": "boolean"
                                        },
                                        "runAsUser": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.securityContext.properties.runAsUser",
                                        "format": "int64",
                                        "type": "integer"
                                        },
                                        "seLinuxOptions": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.securityContext.properties.seLinuxOptions",
                                        "properties": {
                                            "level": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.securityContext.properties.seLinuxOptions.properties.level",
                                            "type": "string"
                                            },
                                            "role": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.securityContext.properties.seLinuxOptions.properties.role",
                                            "type": "string"
                                            },
                                            "type": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.securityContext.properties.seLinuxOptions.properties.type",
                                            "type": "string"
                                            },
                                            "user": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.securityContext.properties.seLinuxOptions.properties.user",
                                            "type": "string"
                                            }
                                        },
                                        "type": "object"
                                        },
                                        "windowsOptions": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.securityContext.properties.windowsOptions",
                                        "properties": {
                                            "gmsaCredentialSpec": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.securityContext.properties.windowsOptions.properties.gmsaCredentialSpec",
                                            "type": "string"
                                            },
                                            "gmsaCredentialSpecName": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.securityContext.properties.windowsOptions.properties.gmsaCredentialSpecName",
                                            "type": "string"
                                            },
                                            "runAsUserName": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.securityContext.properties.windowsOptions.properties.runAsUserName",
                                            "type": "string"
                                            }
                                        },
                                        "type": "object"
                                        }
                                    },
                                    "type": "object"
                                    },
                                    "startupProbe": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.startupProbe",
                                    "properties": {
                                        "exec": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.startupProbe.properties.exec",
                                        "properties": {
                                            "command": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.startupProbe.properties.exec.properties.command",
                                            "items": {
                                                "type": "string"
                                            },
                                            "type": "array"
                                            }
                                        },
                                        "type": "object"
                                        },
                                        "failureThreshold": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.startupProbe.properties.failureThreshold",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "httpGet": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.startupProbe.properties.httpGet",
                                        "properties": {
                                            "host": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.startupProbe.properties.httpGet.properties.host",
                                            "type": "string"
                                            },
                                            "httpHeaders": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.startupProbe.properties.httpGet.properties.httpHeaders",
                                            "items": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.startupProbe.properties.httpGet.properties.httpHeaders.items",
                                                "properties": {
                                                "name": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.startupProbe.properties.httpGet.properties.httpHeaders.items.properties.name",
                                                    "type": "string"
                                                },
                                                "value": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.startupProbe.properties.httpGet.properties.httpHeaders.items.properties.value",
                                                    "type": "string"
                                                }
                                                },
                                                "required": [
                                                "name",
                                                "value"
                                                ],
                                                "type": "object"
                                            },
                                            "type": "array"
                                            },
                                            "path": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.startupProbe.properties.httpGet.properties.path",
                                            "type": "string"
                                            },
                                            "port": {
                                            "anyOf": [
                                                {
                                                "type": "integer"
                                                },
                                                {
                                                "type": "string"
                                                }
                                            ],
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.startupProbe.properties.httpGet.properties.port",
                                            "x-kubernetes-int-or-string": true
                                            },
                                            "scheme": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.startupProbe.properties.httpGet.properties.scheme",
                                            "type": "string"
                                            }
                                        },
                                        "required": [
                                            "port"
                                        ],
                                        "type": "object"
                                        },
                                        "initialDelaySeconds": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.startupProbe.properties.initialDelaySeconds",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "periodSeconds": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.startupProbe.properties.periodSeconds",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "successThreshold": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.startupProbe.properties.successThreshold",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "tcpSocket": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.startupProbe.properties.tcpSocket",
                                        "properties": {
                                            "host": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.startupProbe.properties.tcpSocket.properties.host",
                                            "type": "string"
                                            },
                                            "port": {
                                            "anyOf": [
                                                {
                                                "type": "integer"
                                                },
                                                {
                                                "type": "string"
                                                }
                                            ],
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.startupProbe.properties.tcpSocket.properties.port",
                                            "x-kubernetes-int-or-string": true
                                            }
                                        },
                                        "required": [
                                            "port"
                                        ],
                                        "type": "object"
                                        },
                                        "timeoutSeconds": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.startupProbe.properties.timeoutSeconds",
                                        "format": "int32",
                                        "type": "integer"
                                        }
                                    },
                                    "type": "object"
                                    },
                                    "stdin": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.stdin",
                                    "type": "boolean"
                                    },
                                    "stdinOnce": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.stdinOnce",
                                    "type": "boolean"
                                    },
                                    "targetContainerName": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.targetContainerName",
                                    "type": "string"
                                    },
                                    "terminationMessagePath": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.terminationMessagePath",
                                    "type": "string"
                                    },
                                    "terminationMessagePolicy": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.terminationMessagePolicy",
                                    "type": "string"
                                    },
                                    "tty": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.tty",
                                    "type": "boolean"
                                    },
                                    "volumeDevices": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.volumeDevices",
                                    "items": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.volumeDevices.items",
                                        "properties": {
                                        "devicePath": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.volumeDevices.items.properties.devicePath",
                                            "type": "string"
                                        },
                                        "name": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.volumeDevices.items.properties.name",
                                            "type": "string"
                                        }
                                        },
                                        "required": [
                                        "devicePath",
                                        "name"
                                        ],
                                        "type": "object"
                                    },
                                    "type": "array"
                                    },
                                    "volumeMounts": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.volumeMounts",
                                    "items": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.volumeMounts.items",
                                        "properties": {
                                        "mountPath": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.volumeMounts.items.properties.mountPath",
                                            "type": "string"
                                        },
                                        "mountPropagation": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.volumeMounts.items.properties.mountPropagation",
                                            "type": "string"
                                        },
                                        "name": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.volumeMounts.items.properties.name",
                                            "type": "string"
                                        },
                                        "readOnly": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.volumeMounts.items.properties.readOnly",
                                            "type": "boolean"
                                        },
                                        "subPath": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.volumeMounts.items.properties.subPath",
                                            "type": "string"
                                        },
                                        "subPathExpr": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.volumeMounts.items.properties.subPathExpr",
                                            "type": "string"
                                        }
                                        },
                                        "required": [
                                        "mountPath",
                                        "name"
                                        ],
                                        "type": "object"
                                    },
                                    "type": "array"
                                    },
                                    "workingDir": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.ephemeralContainers.items.properties.workingDir",
                                    "type": "string"
                                    }
                                },
                                "required": [
                                    "name"
                                ],
                                "type": "object"
                                },
                                "type": "array"
                            },
                            "hostAliases": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.hostAliases",
                                "items": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.hostAliases.items",
                                "properties": {
                                    "hostnames": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.hostAliases.items.properties.hostnames",
                                    "items": {
                                        "type": "string"
                                    },
                                    "type": "array"
                                    },
                                    "ip": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.hostAliases.items.properties.ip",
                                    "type": "string"
                                    }
                                },
                                "type": "object"
                                },
                                "type": "array"
                            },
                            "hostIPC": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.hostIPC",
                                "type": "boolean"
                            },
                            "hostNetwork": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.hostNetwork",
                                "type": "boolean"
                            },
                            "hostPID": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.hostPID",
                                "type": "boolean"
                            },
                            "hostname": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.hostname",
                                "type": "string"
                            },
                            "imagePullSecrets": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.imagePullSecrets",
                                "items": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.imagePullSecrets.items",
                                "properties": {
                                    "name": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.imagePullSecrets.items.properties.name",
                                    "type": "string"
                                    }
                                },
                                "type": "object"
                                },
                                "type": "array"
                            },
                            "initContainers": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers",
                                "items": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items",
                                "properties": {
                                    "args": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.args",
                                    "items": {
                                        "type": "string"
                                    },
                                    "type": "array"
                                    },
                                    "command": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.command",
                                    "items": {
                                        "type": "string"
                                    },
                                    "type": "array"
                                    },
                                    "env": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.env",
                                    "items": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.env.items",
                                        "properties": {
                                        "name": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.name",
                                            "type": "string"
                                        },
                                        "value": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.value",
                                            "type": "string"
                                        },
                                        "valueFrom": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom",
                                            "properties": {
                                            "configMapKeyRef": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.configMapKeyRef",
                                                "properties": {
                                                "key": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.configMapKeyRef.properties.key",
                                                    "type": "string"
                                                },
                                                "name": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.configMapKeyRef.properties.name",
                                                    "type": "string"
                                                },
                                                "optional": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.configMapKeyRef.properties.optional",
                                                    "type": "boolean"
                                                }
                                                },
                                                "required": [
                                                "key"
                                                ],
                                                "type": "object"
                                            },
                                            "fieldRef": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.fieldRef",
                                                "properties": {
                                                "apiVersion": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.fieldRef.properties.apiVersion",
                                                    "type": "string"
                                                },
                                                "fieldPath": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.fieldRef.properties.fieldPath",
                                                    "type": "string"
                                                }
                                                },
                                                "required": [
                                                "fieldPath"
                                                ],
                                                "type": "object"
                                            },
                                            "resourceFieldRef": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.resourceFieldRef",
                                                "properties": {
                                                "containerName": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.resourceFieldRef.properties.containerName",
                                                    "type": "string"
                                                },
                                                "divisor": {
                                                    "anyOf": [
                                                    {
                                                        "type": "integer"
                                                    },
                                                    {
                                                        "type": "string"
                                                    }
                                                    ],
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.resourceFieldRef.properties.divisor",
                                                    "pattern": "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$",
                                                    "x-kubernetes-int-or-string": true
                                                },
                                                "resource": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.resourceFieldRef.properties.resource",
                                                    "type": "string"
                                                }
                                                },
                                                "required": [
                                                "resource"
                                                ],
                                                "type": "object"
                                            },
                                            "secretKeyRef": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.secretKeyRef",
                                                "properties": {
                                                "key": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.secretKeyRef.properties.key",
                                                    "type": "string"
                                                },
                                                "name": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.secretKeyRef.properties.name",
                                                    "type": "string"
                                                },
                                                "optional": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.env.items.properties.valueFrom.properties.secretKeyRef.properties.optional",
                                                    "type": "boolean"
                                                }
                                                },
                                                "required": [
                                                "key"
                                                ],
                                                "type": "object"
                                            }
                                            },
                                            "type": "object"
                                        }
                                        },
                                        "required": [
                                        "name"
                                        ],
                                        "type": "object"
                                    },
                                    "type": "array"
                                    },
                                    "envFrom": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.envFrom",
                                    "items": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.envFrom.items",
                                        "properties": {
                                        "configMapRef": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.envFrom.items.properties.configMapRef",
                                            "properties": {
                                            "name": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.envFrom.items.properties.configMapRef.properties.name",
                                                "type": "string"
                                            },
                                            "optional": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.envFrom.items.properties.configMapRef.properties.optional",
                                                "type": "boolean"
                                            }
                                            },
                                            "type": "object"
                                        },
                                        "prefix": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.envFrom.items.properties.prefix",
                                            "type": "string"
                                        },
                                        "secretRef": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.envFrom.items.properties.secretRef",
                                            "properties": {
                                            "name": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.envFrom.items.properties.secretRef.properties.name",
                                                "type": "string"
                                            },
                                            "optional": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.envFrom.items.properties.secretRef.properties.optional",
                                                "type": "boolean"
                                            }
                                            },
                                            "type": "object"
                                        }
                                        },
                                        "type": "object"
                                    },
                                    "type": "array"
                                    },
                                    "image": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.image",
                                    "type": "string"
                                    },
                                    "imagePullPolicy": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.imagePullPolicy",
                                    "type": "string"
                                    },
                                    "lifecycle": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle",
                                    "properties": {
                                        "postStart": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart",
                                        "properties": {
                                            "exec": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.exec",
                                            "properties": {
                                                "command": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.exec.properties.command",
                                                "items": {
                                                    "type": "string"
                                                },
                                                "type": "array"
                                                }
                                            },
                                            "type": "object"
                                            },
                                            "httpGet": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.httpGet",
                                            "properties": {
                                                "host": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.host",
                                                "type": "string"
                                                },
                                                "httpHeaders": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.httpHeaders",
                                                "items": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.httpHeaders.items",
                                                    "properties": {
                                                    "name": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.httpHeaders.items.properties.name",
                                                        "type": "string"
                                                    },
                                                    "value": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.httpHeaders.items.properties.value",
                                                        "type": "string"
                                                    }
                                                    },
                                                    "required": [
                                                    "name",
                                                    "value"
                                                    ],
                                                    "type": "object"
                                                },
                                                "type": "array"
                                                },
                                                "path": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.path",
                                                "type": "string"
                                                },
                                                "port": {
                                                "anyOf": [
                                                    {
                                                    "type": "integer"
                                                    },
                                                    {
                                                    "type": "string"
                                                    }
                                                ],
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.port",
                                                "x-kubernetes-int-or-string": true
                                                },
                                                "scheme": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.httpGet.properties.scheme",
                                                "type": "string"
                                                }
                                            },
                                            "required": [
                                                "port"
                                            ],
                                            "type": "object"
                                            },
                                            "tcpSocket": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.tcpSocket",
                                            "properties": {
                                                "host": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.tcpSocket.properties.host",
                                                "type": "string"
                                                },
                                                "port": {
                                                "anyOf": [
                                                    {
                                                    "type": "integer"
                                                    },
                                                    {
                                                    "type": "string"
                                                    }
                                                ],
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.postStart.properties.tcpSocket.properties.port",
                                                "x-kubernetes-int-or-string": true
                                                }
                                            },
                                            "required": [
                                                "port"
                                            ],
                                            "type": "object"
                                            }
                                        },
                                        "type": "object"
                                        },
                                        "preStop": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop",
                                        "properties": {
                                            "exec": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.exec",
                                            "properties": {
                                                "command": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.exec.properties.command",
                                                "items": {
                                                    "type": "string"
                                                },
                                                "type": "array"
                                                }
                                            },
                                            "type": "object"
                                            },
                                            "httpGet": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.httpGet",
                                            "properties": {
                                                "host": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.host",
                                                "type": "string"
                                                },
                                                "httpHeaders": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.httpHeaders",
                                                "items": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.httpHeaders.items",
                                                    "properties": {
                                                    "name": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.httpHeaders.items.properties.name",
                                                        "type": "string"
                                                    },
                                                    "value": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.httpHeaders.items.properties.value",
                                                        "type": "string"
                                                    }
                                                    },
                                                    "required": [
                                                    "name",
                                                    "value"
                                                    ],
                                                    "type": "object"
                                                },
                                                "type": "array"
                                                },
                                                "path": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.path",
                                                "type": "string"
                                                },
                                                "port": {
                                                "anyOf": [
                                                    {
                                                    "type": "integer"
                                                    },
                                                    {
                                                    "type": "string"
                                                    }
                                                ],
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.port",
                                                "x-kubernetes-int-or-string": true
                                                },
                                                "scheme": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.httpGet.properties.scheme",
                                                "type": "string"
                                                }
                                            },
                                            "required": [
                                                "port"
                                            ],
                                            "type": "object"
                                            },
                                            "tcpSocket": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.tcpSocket",
                                            "properties": {
                                                "host": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.tcpSocket.properties.host",
                                                "type": "string"
                                                },
                                                "port": {
                                                "anyOf": [
                                                    {
                                                    "type": "integer"
                                                    },
                                                    {
                                                    "type": "string"
                                                    }
                                                ],
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.lifecycle.properties.preStop.properties.tcpSocket.properties.port",
                                                "x-kubernetes-int-or-string": true
                                                }
                                            },
                                            "required": [
                                                "port"
                                            ],
                                            "type": "object"
                                            }
                                        },
                                        "type": "object"
                                        }
                                    },
                                    "type": "object"
                                    },
                                    "livenessProbe": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe",
                                    "properties": {
                                        "exec": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.exec",
                                        "properties": {
                                            "command": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.exec.properties.command",
                                            "items": {
                                                "type": "string"
                                            },
                                            "type": "array"
                                            }
                                        },
                                        "type": "object"
                                        },
                                        "failureThreshold": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.failureThreshold",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "httpGet": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.httpGet",
                                        "properties": {
                                            "host": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.httpGet.properties.host",
                                            "type": "string"
                                            },
                                            "httpHeaders": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.httpGet.properties.httpHeaders",
                                            "items": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.httpGet.properties.httpHeaders.items",
                                                "properties": {
                                                "name": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.httpGet.properties.httpHeaders.items.properties.name",
                                                    "type": "string"
                                                },
                                                "value": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.httpGet.properties.httpHeaders.items.properties.value",
                                                    "type": "string"
                                                }
                                                },
                                                "required": [
                                                "name",
                                                "value"
                                                ],
                                                "type": "object"
                                            },
                                            "type": "array"
                                            },
                                            "path": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.httpGet.properties.path",
                                            "type": "string"
                                            },
                                            "port": {
                                            "anyOf": [
                                                {
                                                "type": "integer"
                                                },
                                                {
                                                "type": "string"
                                                }
                                            ],
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.httpGet.properties.port",
                                            "x-kubernetes-int-or-string": true
                                            },
                                            "scheme": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.httpGet.properties.scheme",
                                            "type": "string"
                                            }
                                        },
                                        "required": [
                                            "port"
                                        ],
                                        "type": "object"
                                        },
                                        "initialDelaySeconds": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.initialDelaySeconds",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "periodSeconds": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.periodSeconds",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "successThreshold": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.successThreshold",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "tcpSocket": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.tcpSocket",
                                        "properties": {
                                            "host": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.tcpSocket.properties.host",
                                            "type": "string"
                                            },
                                            "port": {
                                            "anyOf": [
                                                {
                                                "type": "integer"
                                                },
                                                {
                                                "type": "string"
                                                }
                                            ],
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.tcpSocket.properties.port",
                                            "x-kubernetes-int-or-string": true
                                            }
                                        },
                                        "required": [
                                            "port"
                                        ],
                                        "type": "object"
                                        },
                                        "timeoutSeconds": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.livenessProbe.properties.timeoutSeconds",
                                        "format": "int32",
                                        "type": "integer"
                                        }
                                    },
                                    "type": "object"
                                    },
                                    "name": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.name",
                                    "type": "string"
                                    },
                                    "ports": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.ports",
                                    "items": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.ports.items",
                                        "properties": {
                                        "containerPort": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.ports.items.properties.containerPort",
                                            "format": "int32",
                                            "type": "integer"
                                        },
                                        "hostIP": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.ports.items.properties.hostIP",
                                            "type": "string"
                                        },
                                        "hostPort": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.ports.items.properties.hostPort",
                                            "format": "int32",
                                            "type": "integer"
                                        },
                                        "name": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.ports.items.properties.name",
                                            "type": "string"
                                        },
                                        "protocol": {
                                            "default": "TCP",
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.ports.items.properties.protocol",
                                            "type": "string"
                                        }
                                        },
                                        "required": [
                                        "containerPort"
                                        ],
                                        "type": "object"
                                    },
                                    "type": "array",
                                    "x-kubernetes-list-map-keys": [
                                        "containerPort",
                                        "protocol"
                                    ],
                                    "x-kubernetes-list-type": "map"
                                    },
                                    "readinessProbe": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe",
                                    "properties": {
                                        "exec": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.exec",
                                        "properties": {
                                            "command": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.exec.properties.command",
                                            "items": {
                                                "type": "string"
                                            },
                                            "type": "array"
                                            }
                                        },
                                        "type": "object"
                                        },
                                        "failureThreshold": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.failureThreshold",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "httpGet": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.httpGet",
                                        "properties": {
                                            "host": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.httpGet.properties.host",
                                            "type": "string"
                                            },
                                            "httpHeaders": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.httpGet.properties.httpHeaders",
                                            "items": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.httpGet.properties.httpHeaders.items",
                                                "properties": {
                                                "name": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.httpGet.properties.httpHeaders.items.properties.name",
                                                    "type": "string"
                                                },
                                                "value": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.httpGet.properties.httpHeaders.items.properties.value",
                                                    "type": "string"
                                                }
                                                },
                                                "required": [
                                                "name",
                                                "value"
                                                ],
                                                "type": "object"
                                            },
                                            "type": "array"
                                            },
                                            "path": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.httpGet.properties.path",
                                            "type": "string"
                                            },
                                            "port": {
                                            "anyOf": [
                                                {
                                                "type": "integer"
                                                },
                                                {
                                                "type": "string"
                                                }
                                            ],
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.httpGet.properties.port",
                                            "x-kubernetes-int-or-string": true
                                            },
                                            "scheme": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.httpGet.properties.scheme",
                                            "type": "string"
                                            }
                                        },
                                        "required": [
                                            "port"
                                        ],
                                        "type": "object"
                                        },
                                        "initialDelaySeconds": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.initialDelaySeconds",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "periodSeconds": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.periodSeconds",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "successThreshold": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.successThreshold",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "tcpSocket": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.tcpSocket",
                                        "properties": {
                                            "host": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.tcpSocket.properties.host",
                                            "type": "string"
                                            },
                                            "port": {
                                            "anyOf": [
                                                {
                                                "type": "integer"
                                                },
                                                {
                                                "type": "string"
                                                }
                                            ],
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.tcpSocket.properties.port",
                                            "x-kubernetes-int-or-string": true
                                            }
                                        },
                                        "required": [
                                            "port"
                                        ],
                                        "type": "object"
                                        },
                                        "timeoutSeconds": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.readinessProbe.properties.timeoutSeconds",
                                        "format": "int32",
                                        "type": "integer"
                                        }
                                    },
                                    "type": "object"
                                    },
                                    "resources": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.resources",
                                    "properties": {
                                        "limits": {
                                        "additionalProperties": {
                                            "anyOf": [
                                            {
                                                "type": "integer"
                                            },
                                            {
                                                "type": "string"
                                            }
                                            ],
                                            "pattern": "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$",
                                            "x-kubernetes-int-or-string": true
                                        },
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.resources.properties.limits",
                                        "type": "object"
                                        },
                                        "requests": {
                                        "additionalProperties": {
                                            "anyOf": [
                                            {
                                                "type": "integer"
                                            },
                                            {
                                                "type": "string"
                                            }
                                            ],
                                            "pattern": "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$",
                                            "x-kubernetes-int-or-string": true
                                        },
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.resources.properties.requests",
                                        "type": "object"
                                        }
                                    },
                                    "type": "object"
                                    },
                                    "securityContext": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.securityContext",
                                    "properties": {
                                        "allowPrivilegeEscalation": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.allowPrivilegeEscalation",
                                        "type": "boolean"
                                        },
                                        "capabilities": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.capabilities",
                                        "properties": {
                                            "add": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.capabilities.properties.add",
                                            "items": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.capabilities.properties.add.items",
                                                "type": "string"
                                            },
                                            "type": "array"
                                            },
                                            "drop": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.capabilities.properties.drop",
                                            "items": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.capabilities.properties.drop.items",
                                                "type": "string"
                                            },
                                            "type": "array"
                                            }
                                        },
                                        "type": "object"
                                        },
                                        "privileged": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.privileged",
                                        "type": "boolean"
                                        },
                                        "procMount": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.procMount",
                                        "type": "string"
                                        },
                                        "readOnlyRootFilesystem": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.readOnlyRootFilesystem",
                                        "type": "boolean"
                                        },
                                        "runAsGroup": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.runAsGroup",
                                        "format": "int64",
                                        "type": "integer"
                                        },
                                        "runAsNonRoot": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.runAsNonRoot",
                                        "type": "boolean"
                                        },
                                        "runAsUser": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.runAsUser",
                                        "format": "int64",
                                        "type": "integer"
                                        },
                                        "seLinuxOptions": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.seLinuxOptions",
                                        "properties": {
                                            "level": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.seLinuxOptions.properties.level",
                                            "type": "string"
                                            },
                                            "role": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.seLinuxOptions.properties.role",
                                            "type": "string"
                                            },
                                            "type": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.seLinuxOptions.properties.type",
                                            "type": "string"
                                            },
                                            "user": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.seLinuxOptions.properties.user",
                                            "type": "string"
                                            }
                                        },
                                        "type": "object"
                                        },
                                        "windowsOptions": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.windowsOptions",
                                        "properties": {
                                            "gmsaCredentialSpec": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.windowsOptions.properties.gmsaCredentialSpec",
                                            "type": "string"
                                            },
                                            "gmsaCredentialSpecName": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.windowsOptions.properties.gmsaCredentialSpecName",
                                            "type": "string"
                                            },
                                            "runAsUserName": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.securityContext.properties.windowsOptions.properties.runAsUserName",
                                            "type": "string"
                                            }
                                        },
                                        "type": "object"
                                        }
                                    },
                                    "type": "object"
                                    },
                                    "startupProbe": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.startupProbe",
                                    "properties": {
                                        "exec": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.startupProbe.properties.exec",
                                        "properties": {
                                            "command": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.startupProbe.properties.exec.properties.command",
                                            "items": {
                                                "type": "string"
                                            },
                                            "type": "array"
                                            }
                                        },
                                        "type": "object"
                                        },
                                        "failureThreshold": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.startupProbe.properties.failureThreshold",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "httpGet": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.startupProbe.properties.httpGet",
                                        "properties": {
                                            "host": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.startupProbe.properties.httpGet.properties.host",
                                            "type": "string"
                                            },
                                            "httpHeaders": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.startupProbe.properties.httpGet.properties.httpHeaders",
                                            "items": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.startupProbe.properties.httpGet.properties.httpHeaders.items",
                                                "properties": {
                                                "name": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.startupProbe.properties.httpGet.properties.httpHeaders.items.properties.name",
                                                    "type": "string"
                                                },
                                                "value": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.startupProbe.properties.httpGet.properties.httpHeaders.items.properties.value",
                                                    "type": "string"
                                                }
                                                },
                                                "required": [
                                                "name",
                                                "value"
                                                ],
                                                "type": "object"
                                            },
                                            "type": "array"
                                            },
                                            "path": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.startupProbe.properties.httpGet.properties.path",
                                            "type": "string"
                                            },
                                            "port": {
                                            "anyOf": [
                                                {
                                                "type": "integer"
                                                },
                                                {
                                                "type": "string"
                                                }
                                            ],
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.startupProbe.properties.httpGet.properties.port",
                                            "x-kubernetes-int-or-string": true
                                            },
                                            "scheme": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.startupProbe.properties.httpGet.properties.scheme",
                                            "type": "string"
                                            }
                                        },
                                        "required": [
                                            "port"
                                        ],
                                        "type": "object"
                                        },
                                        "initialDelaySeconds": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.startupProbe.properties.initialDelaySeconds",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "periodSeconds": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.startupProbe.properties.periodSeconds",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "successThreshold": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.startupProbe.properties.successThreshold",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "tcpSocket": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.startupProbe.properties.tcpSocket",
                                        "properties": {
                                            "host": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.startupProbe.properties.tcpSocket.properties.host",
                                            "type": "string"
                                            },
                                            "port": {
                                            "anyOf": [
                                                {
                                                "type": "integer"
                                                },
                                                {
                                                "type": "string"
                                                }
                                            ],
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.startupProbe.properties.tcpSocket.properties.port",
                                            "x-kubernetes-int-or-string": true
                                            }
                                        },
                                        "required": [
                                            "port"
                                        ],
                                        "type": "object"
                                        },
                                        "timeoutSeconds": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.startupProbe.properties.timeoutSeconds",
                                        "format": "int32",
                                        "type": "integer"
                                        }
                                    },
                                    "type": "object"
                                    },
                                    "stdin": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.stdin",
                                    "type": "boolean"
                                    },
                                    "stdinOnce": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.stdinOnce",
                                    "type": "boolean"
                                    },
                                    "terminationMessagePath": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.terminationMessagePath",
                                    "type": "string"
                                    },
                                    "terminationMessagePolicy": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.terminationMessagePolicy",
                                    "type": "string"
                                    },
                                    "tty": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.tty",
                                    "type": "boolean"
                                    },
                                    "volumeDevices": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.volumeDevices",
                                    "items": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.volumeDevices.items",
                                        "properties": {
                                        "devicePath": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.volumeDevices.items.properties.devicePath",
                                            "type": "string"
                                        },
                                        "name": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.volumeDevices.items.properties.name",
                                            "type": "string"
                                        }
                                        },
                                        "required": [
                                        "devicePath",
                                        "name"
                                        ],
                                        "type": "object"
                                    },
                                    "type": "array"
                                    },
                                    "volumeMounts": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.volumeMounts",
                                    "items": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.volumeMounts.items",
                                        "properties": {
                                        "mountPath": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.volumeMounts.items.properties.mountPath",
                                            "type": "string"
                                        },
                                        "mountPropagation": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.volumeMounts.items.properties.mountPropagation",
                                            "type": "string"
                                        },
                                        "name": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.volumeMounts.items.properties.name",
                                            "type": "string"
                                        },
                                        "readOnly": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.volumeMounts.items.properties.readOnly",
                                            "type": "boolean"
                                        },
                                        "subPath": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.volumeMounts.items.properties.subPath",
                                            "type": "string"
                                        },
                                        "subPathExpr": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.volumeMounts.items.properties.subPathExpr",
                                            "type": "string"
                                        }
                                        },
                                        "required": [
                                        "mountPath",
                                        "name"
                                        ],
                                        "type": "object"
                                    },
                                    "type": "array"
                                    },
                                    "workingDir": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.initContainers.items.properties.workingDir",
                                    "type": "string"
                                    }
                                },
                                "required": [
                                    "name"
                                ],
                                "type": "object"
                                },
                                "type": "array"
                            },
                            "nodeName": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.nodeName",
                                "type": "string"
                            },
                            "nodeSelector": {
                                "additionalProperties": {
                                "type": "string"
                                },
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.nodeSelector",
                                "type": "object"
                            },
                            "overhead": {
                                "additionalProperties": {
                                "anyOf": [
                                    {
                                    "type": "integer"
                                    },
                                    {
                                    "type": "string"
                                    }
                                ],
                                "pattern": "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$",
                                "x-kubernetes-int-or-string": true
                                },
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.overhead",
                                "type": "object"
                            },
                            "preemptionPolicy": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.preemptionPolicy",
                                "type": "string"
                            },
                            "priority": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.priority",
                                "format": "int32",
                                "type": "integer"
                            },
                            "priorityClassName": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.priorityClassName",
                                "type": "string"
                            },
                            "readinessGates": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.readinessGates",
                                "items": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.readinessGates.items",
                                "properties": {
                                    "conditionType": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.readinessGates.items.properties.conditionType",
                                    "type": "string"
                                    }
                                },
                                "required": [
                                    "conditionType"
                                ],
                                "type": "object"
                                },
                                "type": "array"
                            },
                            "restartPolicy": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.restartPolicy",
                                "type": "string"
                            },
                            "runtimeClassName": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.runtimeClassName",
                                "type": "string"
                            },
                            "schedulerName": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.schedulerName",
                                "type": "string"
                            },
                            "securityContext": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.securityContext",
                                "properties": {
                                "fsGroup": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.securityContext.properties.fsGroup",
                                    "format": "int64",
                                    "type": "integer"
                                },
                                "fsGroupChangePolicy": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.securityContext.properties.fsGroupChangePolicy",
                                    "type": "string"
                                },
                                "runAsGroup": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.securityContext.properties.runAsGroup",
                                    "format": "int64",
                                    "type": "integer"
                                },
                                "runAsNonRoot": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.securityContext.properties.runAsNonRoot",
                                    "type": "boolean"
                                },
                                "runAsUser": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.securityContext.properties.runAsUser",
                                    "format": "int64",
                                    "type": "integer"
                                },
                                "seLinuxOptions": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.securityContext.properties.seLinuxOptions",
                                    "properties": {
                                    "level": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.securityContext.properties.seLinuxOptions.properties.level",
                                        "type": "string"
                                    },
                                    "role": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.securityContext.properties.seLinuxOptions.properties.role",
                                        "type": "string"
                                    },
                                    "type": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.securityContext.properties.seLinuxOptions.properties.type",
                                        "type": "string"
                                    },
                                    "user": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.securityContext.properties.seLinuxOptions.properties.user",
                                        "type": "string"
                                    }
                                    },
                                    "type": "object"
                                },
                                "supplementalGroups": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.securityContext.properties.supplementalGroups",
                                    "items": {
                                    "format": "int64",
                                    "type": "integer"
                                    },
                                    "type": "array"
                                },
                                "sysctls": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.securityContext.properties.sysctls",
                                    "items": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.securityContext.properties.sysctls.items",
                                    "properties": {
                                        "name": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.securityContext.properties.sysctls.items.properties.name",
                                        "type": "string"
                                        },
                                        "value": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.securityContext.properties.sysctls.items.properties.value",
                                        "type": "string"
                                        }
                                    },
                                    "required": [
                                        "name",
                                        "value"
                                    ],
                                    "type": "object"
                                    },
                                    "type": "array"
                                },
                                "windowsOptions": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.securityContext.properties.windowsOptions",
                                    "properties": {
                                    "gmsaCredentialSpec": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.securityContext.properties.windowsOptions.properties.gmsaCredentialSpec",
                                        "type": "string"
                                    },
                                    "gmsaCredentialSpecName": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.securityContext.properties.windowsOptions.properties.gmsaCredentialSpecName",
                                        "type": "string"
                                    },
                                    "runAsUserName": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.securityContext.properties.windowsOptions.properties.runAsUserName",
                                        "type": "string"
                                    }
                                    },
                                    "type": "object"
                                }
                                },
                                "type": "object"
                            },
                            "serviceAccount": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.serviceAccount",
                                "type": "string"
                            },
                            "serviceAccountName": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.serviceAccountName",
                                "type": "string"
                            },
                            "shareProcessNamespace": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.shareProcessNamespace",
                                "type": "boolean"
                            },
                            "subdomain": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.subdomain",
                                "type": "string"
                            },
                            "terminationGracePeriodSeconds": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.terminationGracePeriodSeconds",
                                "format": "int64",
                                "type": "integer"
                            },
                            "tolerations": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.tolerations",
                                "items": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.tolerations.items",
                                "properties": {
                                    "effect": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.tolerations.items.properties.effect",
                                    "type": "string"
                                    },
                                    "key": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.tolerations.items.properties.key",
                                    "type": "string"
                                    },
                                    "operator": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.tolerations.items.properties.operator",
                                    "type": "string"
                                    },
                                    "tolerationSeconds": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.tolerations.items.properties.tolerationSeconds",
                                    "format": "int64",
                                    "type": "integer"
                                    },
                                    "value": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.tolerations.items.properties.value",
                                    "type": "string"
                                    }
                                },
                                "type": "object"
                                },
                                "type": "array"
                            },
                            "topologySpreadConstraints": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.topologySpreadConstraints",
                                "items": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.topologySpreadConstraints.items",
                                "properties": {
                                    "labelSelector": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.topologySpreadConstraints.items.properties.labelSelector",
                                    "properties": {
                                        "matchExpressions": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.topologySpreadConstraints.items.properties.labelSelector.properties.matchExpressions",
                                        "items": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.topologySpreadConstraints.items.properties.labelSelector.properties.matchExpressions.items",
                                            "properties": {
                                            "key": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.topologySpreadConstraints.items.properties.labelSelector.properties.matchExpressions.items.properties.key",
                                                "type": "string"
                                            },
                                            "operator": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.topologySpreadConstraints.items.properties.labelSelector.properties.matchExpressions.items.properties.operator",
                                                "type": "string"
                                            },
                                            "values": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.topologySpreadConstraints.items.properties.labelSelector.properties.matchExpressions.items.properties.values",
                                                "items": {
                                                "type": "string"
                                                },
                                                "type": "array"
                                            }
                                            },
                                            "required": [
                                            "key",
                                            "operator"
                                            ],
                                            "type": "object"
                                        },
                                        "type": "array"
                                        },
                                        "matchLabels": {
                                        "additionalProperties": {
                                            "type": "string"
                                        },
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.topologySpreadConstraints.items.properties.labelSelector.properties.matchLabels",
                                        "type": "object"
                                        }
                                    },
                                    "type": "object"
                                    },
                                    "maxSkew": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.topologySpreadConstraints.items.properties.maxSkew",
                                    "format": "int32",
                                    "type": "integer"
                                    },
                                    "topologyKey": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.topologySpreadConstraints.items.properties.topologyKey",
                                    "type": "string"
                                    },
                                    "whenUnsatisfiable": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.topologySpreadConstraints.items.properties.whenUnsatisfiable",
                                    "type": "string"
                                    }
                                },
                                "required": [
                                    "maxSkew",
                                    "topologyKey",
                                    "whenUnsatisfiable"
                                ],
                                "type": "object"
                                },
                                "type": "array",
                                "x-kubernetes-list-map-keys": [
                                "topologyKey",
                                "whenUnsatisfiable"
                                ],
                                "x-kubernetes-list-type": "map"
                            },
                            "volumes": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes",
                                "items": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items",
                                "properties": {
                                    "awsElasticBlockStore": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.awsElasticBlockStore",
                                    "properties": {
                                        "fsType": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.awsElasticBlockStore.properties.fsType",
                                        "type": "string"
                                        },
                                        "partition": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.awsElasticBlockStore.properties.partition",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "readOnly": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.awsElasticBlockStore.properties.readOnly",
                                        "type": "boolean"
                                        },
                                        "volumeID": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.awsElasticBlockStore.properties.volumeID",
                                        "type": "string"
                                        }
                                    },
                                    "required": [
                                        "volumeID"
                                    ],
                                    "type": "object"
                                    },
                                    "azureDisk": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.azureDisk",
                                    "properties": {
                                        "cachingMode": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.azureDisk.properties.cachingMode",
                                        "type": "string"
                                        },
                                        "diskName": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.azureDisk.properties.diskName",
                                        "type": "string"
                                        },
                                        "diskURI": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.azureDisk.properties.diskURI",
                                        "type": "string"
                                        },
                                        "fsType": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.azureDisk.properties.fsType",
                                        "type": "string"
                                        },
                                        "kind": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.azureDisk.properties.kind",
                                        "type": "string"
                                        },
                                        "readOnly": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.azureDisk.properties.readOnly",
                                        "type": "boolean"
                                        }
                                    },
                                    "required": [
                                        "diskName",
                                        "diskURI"
                                    ],
                                    "type": "object"
                                    },
                                    "azureFile": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.azureFile",
                                    "properties": {
                                        "readOnly": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.azureFile.properties.readOnly",
                                        "type": "boolean"
                                        },
                                        "secretName": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.azureFile.properties.secretName",
                                        "type": "string"
                                        },
                                        "shareName": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.azureFile.properties.shareName",
                                        "type": "string"
                                        }
                                    },
                                    "required": [
                                        "secretName",
                                        "shareName"
                                    ],
                                    "type": "object"
                                    },
                                    "cephfs": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.cephfs",
                                    "properties": {
                                        "monitors": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.cephfs.properties.monitors",
                                        "items": {
                                            "type": "string"
                                        },
                                        "type": "array"
                                        },
                                        "path": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.cephfs.properties.path",
                                        "type": "string"
                                        },
                                        "readOnly": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.cephfs.properties.readOnly",
                                        "type": "boolean"
                                        },
                                        "secretFile": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.cephfs.properties.secretFile",
                                        "type": "string"
                                        },
                                        "secretRef": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.cephfs.properties.secretRef",
                                        "properties": {
                                            "name": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.cephfs.properties.secretRef.properties.name",
                                            "type": "string"
                                            }
                                        },
                                        "type": "object"
                                        },
                                        "user": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.cephfs.properties.user",
                                        "type": "string"
                                        }
                                    },
                                    "required": [
                                        "monitors"
                                    ],
                                    "type": "object"
                                    },
                                    "cinder": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.cinder",
                                    "properties": {
                                        "fsType": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.cinder.properties.fsType",
                                        "type": "string"
                                        },
                                        "readOnly": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.cinder.properties.readOnly",
                                        "type": "boolean"
                                        },
                                        "secretRef": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.cinder.properties.secretRef",
                                        "properties": {
                                            "name": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.cinder.properties.secretRef.properties.name",
                                            "type": "string"
                                            }
                                        },
                                        "type": "object"
                                        },
                                        "volumeID": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.cinder.properties.volumeID",
                                        "type": "string"
                                        }
                                    },
                                    "required": [
                                        "volumeID"
                                    ],
                                    "type": "object"
                                    },
                                    "configMap": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.configMap",
                                    "properties": {
                                        "defaultMode": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.configMap.properties.defaultMode",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "items": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.configMap.properties.items",
                                        "items": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.configMap.properties.items.items",
                                            "properties": {
                                            "key": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.configMap.properties.items.items.properties.key",
                                                "type": "string"
                                            },
                                            "mode": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.configMap.properties.items.items.properties.mode",
                                                "format": "int32",
                                                "type": "integer"
                                            },
                                            "path": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.configMap.properties.items.items.properties.path",
                                                "type": "string"
                                            }
                                            },
                                            "required": [
                                            "key",
                                            "path"
                                            ],
                                            "type": "object"
                                        },
                                        "type": "array"
                                        },
                                        "name": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.configMap.properties.name",
                                        "type": "string"
                                        },
                                        "optional": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.configMap.properties.optional",
                                        "type": "boolean"
                                        }
                                    },
                                    "type": "object"
                                    },
                                    "csi": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.csi",
                                    "properties": {
                                        "driver": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.csi.properties.driver",
                                        "type": "string"
                                        },
                                        "fsType": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.csi.properties.fsType",
                                        "type": "string"
                                        },
                                        "nodePublishSecretRef": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.csi.properties.nodePublishSecretRef",
                                        "properties": {
                                            "name": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.csi.properties.nodePublishSecretRef.properties.name",
                                            "type": "string"
                                            }
                                        },
                                        "type": "object"
                                        },
                                        "readOnly": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.csi.properties.readOnly",
                                        "type": "boolean"
                                        },
                                        "volumeAttributes": {
                                        "additionalProperties": {
                                            "type": "string"
                                        },
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.csi.properties.volumeAttributes",
                                        "type": "object"
                                        }
                                    },
                                    "required": [
                                        "driver"
                                    ],
                                    "type": "object"
                                    },
                                    "downwardAPI": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI",
                                    "properties": {
                                        "defaultMode": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.defaultMode",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "items": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.items",
                                        "items": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.items.items",
                                            "properties": {
                                            "fieldRef": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.items.items.properties.fieldRef",
                                                "properties": {
                                                "apiVersion": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.items.items.properties.fieldRef.properties.apiVersion",
                                                    "type": "string"
                                                },
                                                "fieldPath": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.items.items.properties.fieldRef.properties.fieldPath",
                                                    "type": "string"
                                                }
                                                },
                                                "required": [
                                                "fieldPath"
                                                ],
                                                "type": "object"
                                            },
                                            "mode": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.items.items.properties.mode",
                                                "format": "int32",
                                                "type": "integer"
                                            },
                                            "path": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.items.items.properties.path",
                                                "type": "string"
                                            },
                                            "resourceFieldRef": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.items.items.properties.resourceFieldRef",
                                                "properties": {
                                                "containerName": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.items.items.properties.resourceFieldRef.properties.containerName",
                                                    "type": "string"
                                                },
                                                "divisor": {
                                                    "anyOf": [
                                                    {
                                                        "type": "integer"
                                                    },
                                                    {
                                                        "type": "string"
                                                    }
                                                    ],
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.items.items.properties.resourceFieldRef.properties.divisor",
                                                    "pattern": "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$",
                                                    "x-kubernetes-int-or-string": true
                                                },
                                                "resource": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.downwardAPI.properties.items.items.properties.resourceFieldRef.properties.resource",
                                                    "type": "string"
                                                }
                                                },
                                                "required": [
                                                "resource"
                                                ],
                                                "type": "object"
                                            }
                                            },
                                            "required": [
                                            "path"
                                            ],
                                            "type": "object"
                                        },
                                        "type": "array"
                                        }
                                    },
                                    "type": "object"
                                    },
                                    "emptyDir": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.emptyDir",
                                    "properties": {
                                        "medium": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.emptyDir.properties.medium",
                                        "type": "string"
                                        },
                                        "sizeLimit": {
                                        "anyOf": [
                                            {
                                            "type": "integer"
                                            },
                                            {
                                            "type": "string"
                                            }
                                        ],
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.emptyDir.properties.sizeLimit",
                                        "pattern": "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$",
                                        "x-kubernetes-int-or-string": true
                                        }
                                    },
                                    "type": "object"
                                    },
                                    "fc": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.fc",
                                    "properties": {
                                        "fsType": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.fc.properties.fsType",
                                        "type": "string"
                                        },
                                        "lun": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.fc.properties.lun",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "readOnly": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.fc.properties.readOnly",
                                        "type": "boolean"
                                        },
                                        "targetWWNs": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.fc.properties.targetWWNs",
                                        "items": {
                                            "type": "string"
                                        },
                                        "type": "array"
                                        },
                                        "wwids": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.fc.properties.wwids",
                                        "items": {
                                            "type": "string"
                                        },
                                        "type": "array"
                                        }
                                    },
                                    "type": "object"
                                    },
                                    "flexVolume": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.flexVolume",
                                    "properties": {
                                        "driver": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.flexVolume.properties.driver",
                                        "type": "string"
                                        },
                                        "fsType": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.flexVolume.properties.fsType",
                                        "type": "string"
                                        },
                                        "options": {
                                        "additionalProperties": {
                                            "type": "string"
                                        },
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.flexVolume.properties.options",
                                        "type": "object"
                                        },
                                        "readOnly": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.flexVolume.properties.readOnly",
                                        "type": "boolean"
                                        },
                                        "secretRef": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.flexVolume.properties.secretRef",
                                        "properties": {
                                            "name": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.flexVolume.properties.secretRef.properties.name",
                                            "type": "string"
                                            }
                                        },
                                        "type": "object"
                                        }
                                    },
                                    "required": [
                                        "driver"
                                    ],
                                    "type": "object"
                                    },
                                    "flocker": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.flocker",
                                    "properties": {
                                        "datasetName": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.flocker.properties.datasetName",
                                        "type": "string"
                                        },
                                        "datasetUUID": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.flocker.properties.datasetUUID",
                                        "type": "string"
                                        }
                                    },
                                    "type": "object"
                                    },
                                    "gcePersistentDisk": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.gcePersistentDisk",
                                    "properties": {
                                        "fsType": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.gcePersistentDisk.properties.fsType",
                                        "type": "string"
                                        },
                                        "partition": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.gcePersistentDisk.properties.partition",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "pdName": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.gcePersistentDisk.properties.pdName",
                                        "type": "string"
                                        },
                                        "readOnly": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.gcePersistentDisk.properties.readOnly",
                                        "type": "boolean"
                                        }
                                    },
                                    "required": [
                                        "pdName"
                                    ],
                                    "type": "object"
                                    },
                                    "gitRepo": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.gitRepo",
                                    "properties": {
                                        "directory": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.gitRepo.properties.directory",
                                        "type": "string"
                                        },
                                        "repository": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.gitRepo.properties.repository",
                                        "type": "string"
                                        },
                                        "revision": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.gitRepo.properties.revision",
                                        "type": "string"
                                        }
                                    },
                                    "required": [
                                        "repository"
                                    ],
                                    "type": "object"
                                    },
                                    "glusterfs": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.glusterfs",
                                    "properties": {
                                        "endpoints": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.glusterfs.properties.endpoints",
                                        "type": "string"
                                        },
                                        "path": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.glusterfs.properties.path",
                                        "type": "string"
                                        },
                                        "readOnly": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.glusterfs.properties.readOnly",
                                        "type": "boolean"
                                        }
                                    },
                                    "required": [
                                        "endpoints",
                                        "path"
                                    ],
                                    "type": "object"
                                    },
                                    "hostPath": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.hostPath",
                                    "properties": {
                                        "path": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.hostPath.properties.path",
                                        "type": "string"
                                        },
                                        "type": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.hostPath.properties.type",
                                        "type": "string"
                                        }
                                    },
                                    "required": [
                                        "path"
                                    ],
                                    "type": "object"
                                    },
                                    "iscsi": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.iscsi",
                                    "properties": {
                                        "chapAuthDiscovery": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.chapAuthDiscovery",
                                        "type": "boolean"
                                        },
                                        "chapAuthSession": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.chapAuthSession",
                                        "type": "boolean"
                                        },
                                        "fsType": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.fsType",
                                        "type": "string"
                                        },
                                        "initiatorName": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.initiatorName",
                                        "type": "string"
                                        },
                                        "iqn": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.iqn",
                                        "type": "string"
                                        },
                                        "iscsiInterface": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.iscsiInterface",
                                        "type": "string"
                                        },
                                        "lun": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.lun",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "portals": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.portals",
                                        "items": {
                                            "type": "string"
                                        },
                                        "type": "array"
                                        },
                                        "readOnly": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.readOnly",
                                        "type": "boolean"
                                        },
                                        "secretRef": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.secretRef",
                                        "properties": {
                                            "name": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.secretRef.properties.name",
                                            "type": "string"
                                            }
                                        },
                                        "type": "object"
                                        },
                                        "targetPortal": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.iscsi.properties.targetPortal",
                                        "type": "string"
                                        }
                                    },
                                    "required": [
                                        "iqn",
                                        "lun",
                                        "targetPortal"
                                    ],
                                    "type": "object"
                                    },
                                    "name": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.name",
                                    "type": "string"
                                    },
                                    "nfs": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.nfs",
                                    "properties": {
                                        "path": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.nfs.properties.path",
                                        "type": "string"
                                        },
                                        "readOnly": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.nfs.properties.readOnly",
                                        "type": "boolean"
                                        },
                                        "server": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.nfs.properties.server",
                                        "type": "string"
                                        }
                                    },
                                    "required": [
                                        "path",
                                        "server"
                                    ],
                                    "type": "object"
                                    },
                                    "persistentVolumeClaim": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.persistentVolumeClaim",
                                    "properties": {
                                        "claimName": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.persistentVolumeClaim.properties.claimName",
                                        "type": "string"
                                        },
                                        "readOnly": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.persistentVolumeClaim.properties.readOnly",
                                        "type": "boolean"
                                        }
                                    },
                                    "required": [
                                        "claimName"
                                    ],
                                    "type": "object"
                                    },
                                    "photonPersistentDisk": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.photonPersistentDisk",
                                    "properties": {
                                        "fsType": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.photonPersistentDisk.properties.fsType",
                                        "type": "string"
                                        },
                                        "pdID": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.photonPersistentDisk.properties.pdID",
                                        "type": "string"
                                        }
                                    },
                                    "required": [
                                        "pdID"
                                    ],
                                    "type": "object"
                                    },
                                    "portworxVolume": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.portworxVolume",
                                    "properties": {
                                        "fsType": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.portworxVolume.properties.fsType",
                                        "type": "string"
                                        },
                                        "readOnly": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.portworxVolume.properties.readOnly",
                                        "type": "boolean"
                                        },
                                        "volumeID": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.portworxVolume.properties.volumeID",
                                        "type": "string"
                                        }
                                    },
                                    "required": [
                                        "volumeID"
                                    ],
                                    "type": "object"
                                    },
                                    "projected": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected",
                                    "properties": {
                                        "defaultMode": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.defaultMode",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "sources": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources",
                                        "items": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items",
                                            "properties": {
                                            "configMap": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.configMap",
                                                "properties": {
                                                "items": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.configMap.properties.items",
                                                    "items": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.configMap.properties.items.items",
                                                    "properties": {
                                                        "key": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.configMap.properties.items.items.properties.key",
                                                        "type": "string"
                                                        },
                                                        "mode": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.configMap.properties.items.items.properties.mode",
                                                        "format": "int32",
                                                        "type": "integer"
                                                        },
                                                        "path": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.configMap.properties.items.items.properties.path",
                                                        "type": "string"
                                                        }
                                                    },
                                                    "required": [
                                                        "key",
                                                        "path"
                                                    ],
                                                    "type": "object"
                                                    },
                                                    "type": "array"
                                                },
                                                "name": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.configMap.properties.name",
                                                    "type": "string"
                                                },
                                                "optional": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.configMap.properties.optional",
                                                    "type": "boolean"
                                                }
                                                },
                                                "type": "object"
                                            },
                                            "downwardAPI": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI",
                                                "properties": {
                                                "items": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI.properties.items",
                                                    "items": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI.properties.items.items",
                                                    "properties": {
                                                        "fieldRef": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI.properties.items.items.properties.fieldRef",
                                                        "properties": {
                                                            "apiVersion": {
                                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI.properties.items.items.properties.fieldRef.properties.apiVersion",
                                                            "type": "string"
                                                            },
                                                            "fieldPath": {
                                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI.properties.items.items.properties.fieldRef.properties.fieldPath",
                                                            "type": "string"
                                                            }
                                                        },
                                                        "required": [
                                                            "fieldPath"
                                                        ],
                                                        "type": "object"
                                                        },
                                                        "mode": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI.properties.items.items.properties.mode",
                                                        "format": "int32",
                                                        "type": "integer"
                                                        },
                                                        "path": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI.properties.items.items.properties.path",
                                                        "type": "string"
                                                        },
                                                        "resourceFieldRef": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI.properties.items.items.properties.resourceFieldRef",
                                                        "properties": {
                                                            "containerName": {
                                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI.properties.items.items.properties.resourceFieldRef.properties.containerName",
                                                            "type": "string"
                                                            },
                                                            "divisor": {
                                                            "anyOf": [
                                                                {
                                                                "type": "integer"
                                                                },
                                                                {
                                                                "type": "string"
                                                                }
                                                            ],
                                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI.properties.items.items.properties.resourceFieldRef.properties.divisor",
                                                            "pattern": "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$",
                                                            "x-kubernetes-int-or-string": true
                                                            },
                                                            "resource": {
                                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.downwardAPI.properties.items.items.properties.resourceFieldRef.properties.resource",
                                                            "type": "string"
                                                            }
                                                        },
                                                        "required": [
                                                            "resource"
                                                        ],
                                                        "type": "object"
                                                        }
                                                    },
                                                    "required": [
                                                        "path"
                                                    ],
                                                    "type": "object"
                                                    },
                                                    "type": "array"
                                                }
                                                },
                                                "type": "object"
                                            },
                                            "secret": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.secret",
                                                "properties": {
                                                "items": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.secret.properties.items",
                                                    "items": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.secret.properties.items.items",
                                                    "properties": {
                                                        "key": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.secret.properties.items.items.properties.key",
                                                        "type": "string"
                                                        },
                                                        "mode": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.secret.properties.items.items.properties.mode",
                                                        "format": "int32",
                                                        "type": "integer"
                                                        },
                                                        "path": {
                                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.secret.properties.items.items.properties.path",
                                                        "type": "string"
                                                        }
                                                    },
                                                    "required": [
                                                        "key",
                                                        "path"
                                                    ],
                                                    "type": "object"
                                                    },
                                                    "type": "array"
                                                },
                                                "name": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.secret.properties.name",
                                                    "type": "string"
                                                },
                                                "optional": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.secret.properties.optional",
                                                    "type": "boolean"
                                                }
                                                },
                                                "type": "object"
                                            },
                                            "serviceAccountToken": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.serviceAccountToken",
                                                "properties": {
                                                "audience": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.serviceAccountToken.properties.audience",
                                                    "type": "string"
                                                },
                                                "expirationSeconds": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.serviceAccountToken.properties.expirationSeconds",
                                                    "format": "int64",
                                                    "type": "integer"
                                                },
                                                "path": {
                                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.projected.properties.sources.items.properties.serviceAccountToken.properties.path",
                                                    "type": "string"
                                                }
                                                },
                                                "required": [
                                                "path"
                                                ],
                                                "type": "object"
                                            }
                                            },
                                            "type": "object"
                                        },
                                        "type": "array"
                                        }
                                    },
                                    "required": [
                                        "sources"
                                    ],
                                    "type": "object"
                                    },
                                    "quobyte": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.quobyte",
                                    "properties": {
                                        "group": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.quobyte.properties.group",
                                        "type": "string"
                                        },
                                        "readOnly": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.quobyte.properties.readOnly",
                                        "type": "boolean"
                                        },
                                        "registry": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.quobyte.properties.registry",
                                        "type": "string"
                                        },
                                        "tenant": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.quobyte.properties.tenant",
                                        "type": "string"
                                        },
                                        "user": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.quobyte.properties.user",
                                        "type": "string"
                                        },
                                        "volume": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.quobyte.properties.volume",
                                        "type": "string"
                                        }
                                    },
                                    "required": [
                                        "registry",
                                        "volume"
                                    ],
                                    "type": "object"
                                    },
                                    "rbd": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.rbd",
                                    "properties": {
                                        "fsType": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.rbd.properties.fsType",
                                        "type": "string"
                                        },
                                        "image": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.rbd.properties.image",
                                        "type": "string"
                                        },
                                        "keyring": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.rbd.properties.keyring",
                                        "type": "string"
                                        },
                                        "monitors": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.rbd.properties.monitors",
                                        "items": {
                                            "type": "string"
                                        },
                                        "type": "array"
                                        },
                                        "pool": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.rbd.properties.pool",
                                        "type": "string"
                                        },
                                        "readOnly": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.rbd.properties.readOnly",
                                        "type": "boolean"
                                        },
                                        "secretRef": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.rbd.properties.secretRef",
                                        "properties": {
                                            "name": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.rbd.properties.secretRef.properties.name",
                                            "type": "string"
                                            }
                                        },
                                        "type": "object"
                                        },
                                        "user": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.rbd.properties.user",
                                        "type": "string"
                                        }
                                    },
                                    "required": [
                                        "image",
                                        "monitors"
                                    ],
                                    "type": "object"
                                    },
                                    "scaleIO": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.scaleIO",
                                    "properties": {
                                        "fsType": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.scaleIO.properties.fsType",
                                        "type": "string"
                                        },
                                        "gateway": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.scaleIO.properties.gateway",
                                        "type": "string"
                                        },
                                        "protectionDomain": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.scaleIO.properties.protectionDomain",
                                        "type": "string"
                                        },
                                        "readOnly": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.scaleIO.properties.readOnly",
                                        "type": "boolean"
                                        },
                                        "secretRef": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.scaleIO.properties.secretRef",
                                        "properties": {
                                            "name": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.scaleIO.properties.secretRef.properties.name",
                                            "type": "string"
                                            }
                                        },
                                        "type": "object"
                                        },
                                        "sslEnabled": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.scaleIO.properties.sslEnabled",
                                        "type": "boolean"
                                        },
                                        "storageMode": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.scaleIO.properties.storageMode",
                                        "type": "string"
                                        },
                                        "storagePool": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.scaleIO.properties.storagePool",
                                        "type": "string"
                                        },
                                        "system": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.scaleIO.properties.system",
                                        "type": "string"
                                        },
                                        "volumeName": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.scaleIO.properties.volumeName",
                                        "type": "string"
                                        }
                                    },
                                    "required": [
                                        "gateway",
                                        "secretRef",
                                        "system"
                                    ],
                                    "type": "object"
                                    },
                                    "secret": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.secret",
                                    "properties": {
                                        "defaultMode": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.secret.properties.defaultMode",
                                        "format": "int32",
                                        "type": "integer"
                                        },
                                        "items": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.secret.properties.items",
                                        "items": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.secret.properties.items.items",
                                            "properties": {
                                            "key": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.secret.properties.items.items.properties.key",
                                                "type": "string"
                                            },
                                            "mode": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.secret.properties.items.items.properties.mode",
                                                "format": "int32",
                                                "type": "integer"
                                            },
                                            "path": {
                                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.secret.properties.items.items.properties.path",
                                                "type": "string"
                                            }
                                            },
                                            "required": [
                                            "key",
                                            "path"
                                            ],
                                            "type": "object"
                                        },
                                        "type": "array"
                                        },
                                        "optional": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.secret.properties.optional",
                                        "type": "boolean"
                                        },
                                        "secretName": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.secret.properties.secretName",
                                        "type": "string"
                                        }
                                    },
                                    "type": "object"
                                    },
                                    "storageos": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.storageos",
                                    "properties": {
                                        "fsType": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.storageos.properties.fsType",
                                        "type": "string"
                                        },
                                        "readOnly": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.storageos.properties.readOnly",
                                        "type": "boolean"
                                        },
                                        "secretRef": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.storageos.properties.secretRef",
                                        "properties": {
                                            "name": {
                                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.storageos.properties.secretRef.properties.name",
                                            "type": "string"
                                            }
                                        },
                                        "type": "object"
                                        },
                                        "volumeName": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.storageos.properties.volumeName",
                                        "type": "string"
                                        },
                                        "volumeNamespace": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.storageos.properties.volumeNamespace",
                                        "type": "string"
                                        }
                                    },
                                    "type": "object"
                                    },
                                    "vsphereVolume": {
                                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.vsphereVolume",
                                    "properties": {
                                        "fsType": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.vsphereVolume.properties.fsType",
                                        "type": "string"
                                        },
                                        "storagePolicyID": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.vsphereVolume.properties.storagePolicyID",
                                        "type": "string"
                                        },
                                        "storagePolicyName": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.vsphereVolume.properties.storagePolicyName",
                                        "type": "string"
                                        },
                                        "volumePath": {
                                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.template.properties.spec.properties.volumes.items.properties.vsphereVolume.properties.volumePath",
                                        "type": "string"
                                        }
                                    },
                                    "required": [
                                        "volumePath"
                                    ],
                                    "type": "object"
                                    }
                                },
                                "required": [
                                    "name"
                                ],
                                "type": "object"
                                },
                                "type": "array"
                            }
                            },
                            "required": [
                            "containers"
                            ],
                            "type": "object"
                        }
                        },
                        "type": "object"
                    },
                    "volumeClaim": {
                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.volumeClaim",
                        "items": {
                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.volumeClaim.items",
                        "properties": {
                            "name": {
                            "type": "string"
                            },
                            "size": {
                            "type": "string"
                            },
                            "storageClass": {
                            "type": "string"
                            }
                        },
                        "required": [
                            "name",
                            "size"
                        ],
                        "type": "object"
                        },
                        "type": "array"
                    }
                    },
                    "type": "object"
                },
                "status": {
                    "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.status",
                    "properties": {
                    "conditions": {
                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.conditions",
                        "items": {
                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.conditions.items",
                        "properties": {
                            "lastProbeTime": {
                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.conditions.items.properties.lastProbeTime",
                            "format": "date-time",
                            "type": "string"
                            },
                            "message": {
                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.conditions.items.properties.message",
                            "type": "string"
                            },
                            "reason": {
                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.conditions.items.properties.reason",
                            "type": "string"
                            },
                            "type": {
                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.conditions.items.properties.type",
                            "type": "string"
                            }
                        },
                        "required": [
                            "type"
                        ],
                        "type": "object"
                        },
                        "type": "array"
                    },
                    "containerState": {
                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.containerState",
                        "properties": {
                        "running": {
                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.containerState.properties.running",
                            "properties": {
                            "startedAt": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.containerState.properties.running.properties.startedAt",
                                "format": "date-time",
                                "type": "string"
                            }
                            },
                            "type": "object"
                        },
                        "terminated": {
                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.containerState.properties.terminated",
                            "properties": {
                            "containerID": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.containerState.properties.terminated.properties.containerID",
                                "type": "string"
                            },
                            "exitCode": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.containerState.properties.terminated.properties.exitCode",
                                "format": "int32",
                                "type": "integer"
                            },
                            "finishedAt": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.containerState.properties.terminated.properties.finishedAt",
                                "format": "date-time",
                                "type": "string"
                            },
                            "message": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.containerState.properties.terminated.properties.message",
                                "type": "string"
                            },
                            "reason": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.containerState.properties.terminated.properties.reason",
                                "type": "string"
                            },
                            "signal": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.containerState.properties.terminated.properties.signal",
                                "format": "int32",
                                "type": "integer"
                            },
                            "startedAt": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.containerState.properties.terminated.properties.startedAt",
                                "format": "date-time",
                                "type": "string"
                            }
                            },
                            "required": [
                            "exitCode"
                            ],
                            "type": "object"
                        },
                        "waiting": {
                            "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.containerState.properties.waiting",
                            "properties": {
                            "message": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.containerState.properties.waiting.properties.message",
                                "type": "string"
                            },
                            "reason": {
                                "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.containerState.properties.waiting.properties.reason",
                                "type": "string"
                            }
                            },
                            "type": "object"
                        }
                        },
                        "type": "object"
                    },
                    "readyReplicas": {
                        "description": "%notebooks.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.readyReplicas",
                        "format": "int32",
                        "type": "integer"
                    }
                    },
                    "required": [
                    "conditions",
                    "containerState",
                    "readyReplicas"
                    ],
                    "type": "object"
                }
                },
                "type": "object"
            }
            },
            "served": true,
            "storage": true,
            "subresources": {
            "status": {}
            }
        }
        ]
    },
    "status": {
        "acceptedNames": {
        "kind": "",
        "plural": ""
        },
        "conditions": [],
        "storedVersions": []
    }
    },
    {
    "apiVersion": "v1",
    "kind": "ServiceAccount",
    "metadata": {
        "labels": {
        "app": "notebook-controller",
        "app.kubernetes.io/component": "notebook-controller",
        "app.kubernetes.io/name": "notebook-controller",
        "kustomize.component": "notebook-controller"
        },
        "name": "notebook-controller-service-account",
        "namespace": ai_devops_namespace
    }
    },
    {
    "aggregationRule": {
        "clusterRoleSelectors": [
        {
            "matchLabels": {
            "rbac.authorization.kubeflow.org/aggregate-to-kubeflow-notebooks-admin": "true"
            }
        }
        ]
    },
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRole",
    "metadata": {
        "labels": {
        "app": "notebook-controller",
        "app.kubernetes.io/component": "notebook-controller",
        "app.kubernetes.io/name": "notebook-controller",
        "kustomize.component": "notebook-controller",
        "rbac.authorization.kubeflow.org/aggregate-to-kubeflow-admin": "true"
        },
        "name": "notebook-controller-kubeflow-notebooks-admin"
    },
    "rules": []
    },
    {
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRole",
    "metadata": {
        "labels": {
        "app": "notebook-controller",
        "app.kubernetes.io/component": "notebook-controller",
        "app.kubernetes.io/name": "notebook-controller",
        "kustomize.component": "notebook-controller",
        "rbac.authorization.kubeflow.org/aggregate-to-kubeflow-edit": "true",
        "rbac.authorization.kubeflow.org/aggregate-to-kubeflow-notebooks-admin": "true"
        },
        "name": "notebook-controller-kubeflow-notebooks-edit"
    },
    "rules": [
        {
        "apiGroups": [
            "kubeflow.org"
        ],
        "resources": [
            "notebooks",
            "notebooks/status"
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
        "app": "notebook-controller",
        "app.kubernetes.io/component": "notebook-controller",
        "app.kubernetes.io/name": "notebook-controller",
        "kustomize.component": "notebook-controller",
        "rbac.authorization.kubeflow.org/aggregate-to-kubeflow-view": "true"
        },
        "name": "notebook-controller-kubeflow-notebooks-view"
    },
    "rules": [
        {
        "apiGroups": [
            "kubeflow.org"
        ],
        "resources": [
            "notebooks",
            "notebooks/status"
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
        "app": "notebook-controller",
        "app.kubernetes.io/component": "notebook-controller",
        "app.kubernetes.io/name": "notebook-controller",
        "kustomize.component": "notebook-controller"
        },
        "name": "notebook-controller-role"
    },
    "rules": [
        {
        "apiGroups": [
            "apps"
        ],
        "resources": [
            "statefulsets",
            "deployments"
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
            "pods"
        ],
        "verbs": [
            "get",
            "list",
            "watch"
        ]
        },
        {
        "apiGroups": [
            ""
        ],
        "resources": [
            "services"
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
            "events"
        ],
        "verbs": [
            "get",
            "list",
            "watch",
            "create"
        ]
        },
        {
        "apiGroups": [
            "kubeflow.org"
        ],
        "resources": [
            "notebooks",
            "notebooks/status",
            "notebooks/finalizers"
        ],
        "verbs": [
            "*"
        ]
        },
        {
        "apiGroups": [
            "networking.istio.io"
        ],
        "resources": [
            "virtualservices"
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
        "app": "notebook-controller",
        "app.kubernetes.io/component": "notebook-controller",
        "app.kubernetes.io/name": "notebook-controller",
        "kustomize.component": "notebook-controller"
        },
        "name": "notebook-controller-role-binding"
    },
    "roleRef": {
        "apiGroup": "rbac.authorization.k8s.io",
        "kind": "ClusterRole",
        "name": "cluster-admin"
    },
    "subjects": [
        {
        "kind": "ServiceAccount",
        "name": "notebook-controller-service-account",
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
    "data": {
        "CLIENT_SECRET": tmax_client_secret,
        "DISCOVERY_URL": std.join("", ["https://", hyperauth_url, "/auth/realms/", hyperauth_realm]),
        "CUSTOM_DOMAIN": custom_domain_name
    },
    "kind": "ConfigMap",
    "metadata": {
        "labels": {
        "app": "notebook-controller",
        "app.kubernetes.io/component": "notebook-controller",
        "app.kubernetes.io/name": "notebook-controller",
        "kustomize.component": "notebook-controller"
        },
        "name": "notebook-controller-config",
        "namespace": ai_devops_namespace
    }
    },
    {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
        "labels": {
        "app": "notebook-controller",
        "app.kubernetes.io/component": "notebook-controller",
        "app.kubernetes.io/name": "notebook-controller",
        "kustomize.component": "notebook-controller"
        },
        "name": "notebook-controller-service",
        "namespace": ai_devops_namespace
    },
    "spec": {
        "ports": [
        {
            "port": 443
        }
        ],
        "selector": {
        "app": "notebook-controller",
        "app.kubernetes.io/component": "notebook-controller",
        "app.kubernetes.io/name": "notebook-controller",
        "kustomize.component": "notebook-controller"
        }
    }
    },
    {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
        "labels": {
        "app": "notebook-controller",
        "app.kubernetes.io/component": "notebook-controller",
        "app.kubernetes.io/name": "notebook-controller",
        "kustomize.component": "notebook-controller",
        "name": "notebook-controller-deployment",
        "notebook": "controller"
        },
        "name": "notebook-controller-deployment",
        "namespace": ai_devops_namespace
    },
    "spec": {
        "replicas": 1,
        "selector": {
        "matchLabels": {
            "app": "notebook-controller",
            "app.kubernetes.io/component": "notebook-controller",
            "app.kubernetes.io/name": "notebook-controller",
            "kustomize.component": "notebook-controller",
            "notebook": "controller"
        }
        },
        "strategy": {
        "type": "Recreate"
        },
        "template": {
        "metadata": {
            "labels": {
            "app": "notebook-controller",
            "app.kubernetes.io/component": "notebook-controller",
            "app.kubernetes.io/name": "notebook-controller",
            "kustomize.component": "notebook-controller",
            "notebook": "controller"
            },
            "name": "notebook-controller"
        },
        "spec": {
            "containers": [
            {
                "env": [
                {
                    "name": "CLIENT_SECRET",
                    "valueFrom": {
                    "configMapKeyRef": {
                        "key": "CLIENT_SECRET",
                        "name": "notebook-controller-config"
                    }
                    }
                },
                {
                    "name": "DISCOVERY_URL",
                    "valueFrom": {
                    "configMapKeyRef": {
                        "key": "DISCOVERY_URL",
                        "name": "notebook-controller-config"
                    }
                    }
                },
                {
                    "name": "CUSTOM_DOMAIN",
                    "valueFrom": {
                    "configMapKeyRef": {
                        "key": "CUSTOM_DOMAIN",
                        "name": "notebook-controller-config"
                    }
                    }
                }
                ],
                "image": std.join("", [target_registry, "docker.io/tmaxcloudck/notebook-controller-go:b0.2.1"]),
                "imagePullPolicy": "Always",
                "name": "notebook-controller",
                "volumeMounts": [
                    {
                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                        "name": "notebook-controller-service-account-token",
                        "readOnly": "true"
                    }
                ]
            }
            ],
            "volumes": [
                {
                    "name": "notebook-controller-service-account-token",
                    "secret": {
                        "defaultMode": 420,
                        "secretName": "notebook-controller-service-account-token"
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
        "app.kubernetes.io/component": "notebook-controller",
        "app.kubernetes.io/name": "notebook-controller"
        },
        "name": "notebook-controller",
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
        }
        ],
        "descriptor": {
        "description": "Notebooks controller allows users to create a custom resource \\\"Notebook\\\" (jupyter notebook).",
        "keywords": [
            "jupyter",
            "notebook",
            "notebook-controller",
            "jupyterhub"
        ],
        "links": [
            {
            "description": "About",
            "url": "https://github.com/tmax-cloud/notebook-controller-go"
            }
        ],
        "maintainers": [
            {
            "email": "jeongwan_rho@tmax.co.kr",
            "name": "tmaxcloudck"
            }
        ],
        "owners": [
            {
            "email": "seungjin_lee2@tmax.co.kr",
            "name": "Seungjin Lee"
            }
        ],
        "type": "notebook-controller",
        "version": "v1beta1"
        },
        "selector": {
        "matchLabels": {
            "app.kubernetes.io/component": "notebook-controller-go",
            "app.kubernetes.io/instance": "notebook-controller-go-b0.0.2",
            "app.kubernetes.io/managed-by": "kfctl",
            "app.kubernetes.io/name": "notebook-controller",
            "app.kubernetes.io/part-of": "hyperflow",
            "app.kubernetes.io/version": "b0.0.2"
        }
        }
    }
    },
    {
    "apiVersion": "console.tmax.io/v1",
    "kind": "ConsoleYAMLSample",
    "metadata": {
        "name": "kale"
    },
    "spec": {
        "description": "An example Notebook with Tmax-KALE",
        "targetResource": {
        "apiVersion": "kubeflow.tmax.io/v1",
        "kind": "Notebook"
        },
        "title": "Tmax-KALE Notebook",
        "yaml": "apiVersion: kubeflow.tmax.io/v1\nkind: Notebook\nmetadata:\n  labels:\n    app: kale-notebook\n  name: kale-notebook\nspec:\n  template:\n    spec:\n      containers:\n      - env: []\n        image: tmaxcloudck/kale-tekton-standalone:211231\n        name: demo\n        resources:\n          requests:\n            cpu: \"0.5\"\n            memory: 1.0Gi\n        volumeMounts:\n        - mountPath: /home/jovyan\n          name: demo-pvc\n        - mountPath: /dev/shm\n          name: dshm\n      serviceAccountName: default-editor\n      volumes:\n      - name: demo-pvc\n        persistentVolumeClaim:\n          claimName: demo-pvc\n      - emptyDir:\n          medium: Memory\n        name: dshm\n  volumeClaim:\n  - name: demo-pvc\n    size: 10Gi\n"
    }
    },
    {
    "apiVersion": "v1",
    "kind": "Secret",
    "metadata": {
        "name": "notebook-controller-service-account-token",
        "namespace": ai_devops_namespace,
        "annotations": {
        "kubernetes.io/service-account.name": "notebook-controller-service-account"
        }
    },
    "type": "kubernetes.io/service-account-token"
    },

    if notebook_svc_type == "Ingress" then {        
        "apiVersion": "extensions/v1beta1",
        "kind": "Ingress",
        "metadata": {
            "name": "notebook-ingress",
            "namespace": istio_namespace
        },
        "spec": {
            "ingressClassName": "tmax-cloud",
            "rules": [
            {
                "host": std.join("", ["console.", custom_domain_name]),
                "http": {
                "paths": [
                    {
                    "backend": {
                        "serviceName": "istio-ingressgateway",
                        "servicePort": 80
                    },
                    "path": "/api/kubeflow/notebook/",
                    "pathType": "Prefix"
                    }
                ]
                }
            }
            ],
            "tls": [
            {
                "hosts": [
                std.join("", ["console.", custom_domain_name])
                ]
            }
            ]
        }
        }else {}
]