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

local target_registry = if is_offline == "false" then "" else private_registry + "/";
local katib_object_image_tag = "v0.11.0";

[
  {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
      "name": "experiments.kubeflow.org"
    },
    "spec": {
      "additionalPrinterColumns": [
        {
          "JSONPath": ".status.conditions[-1:].type",
          "name": "Type",
          "type": "string"
        },
        {
          "JSONPath": ".status.conditions[-1:].status",
          "name": "Status",
          "type": "string"
        },
        {
          "JSONPath": ".metadata.creationTimestamp",
          "name": "Age",
          "type": "date"
        }
      ],
      "group": "kubeflow.org",
      "version": "v1beta1",
      "names": {
        "categories": [
          "all",
          "kubeflow",
          "katib"
        ],
        "kind": "Experiment",
        "listKind": "ExperimentList",
        "plural": "experiments",
        "singular": "experiment"
      },
      "scope": "Namespaced",
      "subresources": {
        "status": {}
      },
      "validation": {
        "openAPIV3Schema": {
          "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema",
          "type": "object",
          "properties": {
            "apiVersion": {
              "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.apiVersion",
              "type": "string"
            },
            "kind": {
              "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.kind",
              "type": "string"
            },
            "metadata": {
              "type": "object"
            },
            "spec": {
              "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec",
              "type": "object",
              "properties": {
                "algorithm": {
                  "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.algorithm",
                  "type": "object",
                  "properties": {
                    "algorithmName": {
                      "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.algorithm.properties.algorithmName",
                      "type": "string"
                    },
                    "algorithmSettings": {
                      "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.algorithm.properties.algorithmSettings",
                      "type": "array",
                      "items": {
                        "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.algorithm.properties.algorithmSettings.items",
                        "type": "object",
                        "properties": {
                          "name": {
                            "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.algorithm.properties.algorithmSettings.items.properties.name",
                            "type": "string"
                          },
                          "value": {
                            "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.algorithm.properties.algorithmSettings.items.properties.value",
                            "type": "string"
                          }
                        }
                      }
                    }
                  }
                },
                "earlyStopping": {
                  "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.earlyStopping",
                  "type": "object",
                  "properties": {
                    "algorithmName": {
                      "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.earlyStopping.properties.algorithmName",
                      "type": "string"
                    },
                    "algorithmSettings": {
                      "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.earlyStopping.properties.algorithmSettings",
                      "type": "array",
                      "items": {
                        "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.earlyStopping.properties.algorithmSettings.items",
                        "type": "object",
                        "properties": {
                          "name": {
                            "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.earlyStopping.properties.algorithmSettings.items.properties.name",
                            "type": "string"
                          },
                          "value": {
                            "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.earlyStopping.properties.algorithmSettings.items.properties.value",
                            "type": "string"
                          }
                        }
                      }
                    }
                  }
                },
                "maxFailedTrialCount": {
                  "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.maxFailedTrialCount",
                  "type": "integer",
                  "format": "int32"
                },
                "maxTrialCount": {
                  "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.maxTrialCount",
                  "type": "integer",
                  "format": "int32"
                },
                "metricsCollectorSpec": {
                  "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.metricsCollectorSpec",
                  "type": "object",
                  "properties": {
                    "collector": {
                      "type": "object",
                      "required": [
                        "kind"
                      ],
                      "properties": {
                        "customCollector": {
                          "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.metricsCollectorSpec.properties.collector.properties.customCollector",
                          "type": "object",
                          "required": [
                            "image"
                          ],
                          "properties": {
                            "image": {
                              "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.metricsCollectorSpec.properties.collector.properties.customCollector.properties.image",
                              "type": "string"
                            }
                          }
                        },
                        "kind": {
                          "type": "string"
                        }
                      }
                    },
                    "source": {
                      "type": "object",
                      "properties": {
                        "fileSystemPath": {
                          "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.metricsCollectorSpec.properties.source.properties.fileSystemPath",
                          "type": "object",
                          "properties": {
                            "kind": {
                              "type": "string"
                            },
                            "path": {
                              "type": "string"
                            }
                          }
                        },
                        "filter": {
                          "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.metricsCollectorSpec.properties.source.properties.filter",
                          "type": "object",
                          "properties": {
                            "metricsFormat": {
                              "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.metricsCollectorSpec.properties.source.properties.filter.properties.metricsFormat",
                              "type": "array",
                              "items": {
                                "type": "string"
                              }
                            }
                          }
                        },
                        "httpGet": {
                          "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.metricsCollectorSpec.properties.source.properties.httpGet",
                          "type": "object",
                          "required": [
                            "port"
                          ],
                          "properties": {
                            "host": {
                              "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.metricsCollectorSpec.properties.source.properties.httpGet.properties.host",
                              "type": "string"
                            },
                            "httpHeaders": {
                              "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.metricsCollectorSpec.properties.source.properties.httpGet.properties.httpHeaders",
                              "type": "array",
                              "items": {
                                "type": "object",
                                "required": [
                                  "name",
                                  "value"
                                ],
                                "properties": {
                                  "name": {
                                    "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.metricsCollectorSpec.properties.source.properties.httpGet.properties.httpHeaders.items.properties.name",
                                    "type": "string"
                                  },
                                  "value": {
                                    "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.metricsCollectorSpec.properties.source.properties.httpGet.properties.httpHeaders.items.properties.value",
                                    "type": "string"
                                  }
                                }
                              }
                            },
                            "path": {
                              "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.metricsCollectorSpec.properties.source.properties.httpGet.properties.path",
                              "type": "string"
                            },
                            "port": {
                              "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.metricsCollectorSpec.properties.source.properties.httpGet.properties.port",
                              "type": "string"
                            },
                            "scheme": {
                              "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.metricsCollectorSpec.properties.source.properties.httpGet.properties.scheme",
                              "type": "string"
                            }
                          }
                        }
                      }
                    }
                  }
                },
                "nasConfig": {
                  "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.nasConfig",
                  "type": "object",
                  "properties": {
                    "graphConfig": {
                      "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.nasConfig.properties.graphConfig",
                      "type": "object",
                      "properties": {
                        "inputSizes": {
                          "type": "array",
                          "items": {
                            "type": "integer",
                            "format": "int32"
                          }
                        },
                        "numLayers": {
                          "type": "integer",
                          "format": "int32"
                        },
                        "outputSizes": {
                          "type": "array",
                          "items": {
                            "type": "integer",
                            "format": "int32"
                          }
                        }
                      }
                    },
                    "operations": {
                      "type": "array",
                      "items": {
                        "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.nasConfig.properties.operations.items",
                        "type": "object",
                        "properties": {
                          "operationType": {
                            "type": "string"
                          },
                          "parameters": {
                            "type": "array",
                            "items": {
                              "type": "object",
                              "properties": {
                                "feasibleSpace": {
                                  "type": "object",
                                  "properties": {
                                    "list": {
                                      "type": "array",
                                      "items": {
                                        "type": "string"
                                      }
                                    },
                                    "max": {
                                      "type": "string"
                                    },
                                    "min": {
                                      "type": "string"
                                    },
                                    "step": {
                                      "type": "string"
                                    }
                                  }
                                },
                                "name": {
                                  "type": "string"
                                },
                                "parameterType": {
                                  "type": "string"
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                },
                "objective": {
                  "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.objective",
                  "type": "object",
                  "properties": {
                    "additionalMetricNames": {
                      "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.objective.properties.additionalMetricNames",
                      "type": "array",
                      "items": {
                        "type": "string"
                      }
                    },
                    "goal": {
                      "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.objective.properties.goal",
                      "type": "number",
                      "format": "double"
                    },
                    "metricStrategies": {
                      "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.objective.properties.metricStrategies",
                      "type": "array",
                      "items": {
                        "type": "object",
                        "properties": {
                          "name": {
                            "type": "string"
                          },
                          "value": {
                            "type": "string"
                          }
                        }
                      }
                    },
                    "objectiveMetricName": {
                      "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.objective.properties.objectiveMetricName",
                      "type": "string"
                    },
                    "type": {
                      "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.objective.properties.type",
                      "type": "string"
                    }
                  }
                },
                "parallelTrialCount": {
                  "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.parallelTrialCount",
                  "type": "integer",
                  "format": "int32"
                },
                "parameters": {
                  "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.parameters",
                  "type": "array",
                  "items": {
                    "type": "object",
                    "properties": {
                      "feasibleSpace": {
                        "type": "object",
                        "properties": {
                          "list": {
                            "type": "array",
                            "items": {
                              "type": "string"
                            }
                          },
                          "max": {
                            "type": "string"
                          },
                          "min": {
                            "type": "string"
                          },
                          "step": {
                            "type": "string"
                          }
                        }
                      },
                      "name": {
                        "type": "string"
                      },
                      "parameterType": {
                        "type": "string"
                      }
                    }
                  }
                },
                "resumePolicy": {
                  "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.resumePolicy",
                  "type": "string"
                },
                "trialTemplate": {
                  "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.trialTemplate",
                  "type": "object",
                  "properties": {
                    "configMap": {
                      "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.trialTemplate.properties.configMap",
                      "type": "object",
                      "properties": {
                        "configMapName": {
                          "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.trialTemplate.properties.configMap.properties.configMapName",
                          "type": "string"
                        },
                        "configMapNamespace": {
                          "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.trialTemplate.properties.configMap.properties.configMapNamespace",
                          "type": "string"
                        },
                        "templatePath": {
                          "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.trialTemplate.properties.configMap.properties.templatePath",
                          "type": "string"
                        }
                      }
                    },
                    "failureCondition": {
                      "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.trialTemplate.properties.failureCondition",
                      "type": "string"
                    },
                    "primaryContainerName": {
                      "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.trialTemplate.properties.primaryContainerName",
                      "type": "string"
                    },
                    "primaryPodLabels": {
                      "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.trialTemplate.properties.primaryPodLabels",
                      "type": "object",
                      "additionalProperties": {
                        "type": "string"
                      }
                    },
                    "retain": {
                      "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.trialTemplate.properties.retain",
                      "type": "boolean"
                    },
                    "successCondition": {
                      "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.trialTemplate.properties.successCondition",
                      "type": "string"
                    },
                    "trialParameters": {
                      "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.trialTemplate.properties.trialParameters",
                      "type": "array",
                      "items": {
                        "type": "object",
                        "properties": {
                          "description": {
                            "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.trialTemplate.properties.trialParameters.items.properties.description",
                            "type": "string"
                          },
                          "name": {
                            "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.trialTemplate.properties.trialParameters.items.properties.name",
                            "type": "string"
                          },
                          "reference": {
                            "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.trialTemplate.properties.trialParameters.items.properties.reference",
                            "type": "string"
                          }
                        }
                      }
                    },
                    "trialSpec": {
                      "description": "%experiment_original.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.trialTemplate.properties.trialSpec",
                      "type": "object"
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
          "name": "v1beta1",
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
      "name": "suggestions.kubeflow.org"
    },
    "spec": {
      "additionalPrinterColumns": [
        {
          "JSONPath": ".status.conditions[-1:].type",
          "name": "Type",
          "type": "string"
        },
        {
          "JSONPath": ".status.conditions[-1:].status",
          "name": "Status",
          "type": "string"
        },
        {
          "JSONPath": ".spec.requests",
          "name": "Requested",
          "type": "string"
        },
        {
          "JSONPath": ".status.suggestionCount",
          "name": "Assigned",
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
        "categories": [
          "all",
          "kubeflow",
          "katib"
        ],
        "kind": "Suggestion",
        "plural": "suggestions",
        "singular": "suggestion"
      },
      "scope": "Namespaced",
      "subresources": {
        "status": {}
      },
      "version": "v1beta1"
    }
  },
  {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
      "name": "trials.kubeflow.org"
    },
    "spec": {
      "additionalPrinterColumns": [
        {
          "JSONPath": ".status.conditions[-1:].type",
          "name": "Type",
          "type": "string"
        },
        {
          "JSONPath": ".status.conditions[-1:].status",
          "name": "Status",
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
        "categories": [
          "all",
          "kubeflow",
          "katib"
        ],
        "kind": "Trial",
        "plural": "trials",
        "singular": "trial"
      },
      "scope": "Namespaced",
      "subresources": {
        "status": {}
      },
      "version": "v1beta1"
    }
  },
  {
    "apiVersion": "v1",
    "kind": "ServiceAccount",
    "metadata": {
      "name": "katib-cert-generator",
      "namespace": ai_devops_namespace
    }
  },
  {
    "apiVersion": "v1",
    "kind": "ServiceAccount",
    "metadata": {
      "name": "katib-controller",
      "namespace": ai_devops_namespace
    }
  },
  {
    "apiVersion": "v1",
    "kind": "ServiceAccount",
    "metadata": {
      "name": "katib-ui",
      "namespace": ai_devops_namespace
    }
  },
  {
    "apiVersion": "v1",
    "kind": "Secret",
    "metadata": {
        "name": "katib-controller-token",
        "namespace": ai_devops_namespace,
        "annotations": {
        "kubernetes.io/service-account.name": "katib-controller"
        }
    },
    "type": "kubernetes.io/service-account-token"
  },
  {
    "apiVersion": "v1",
    "kind": "Secret",
    "metadata": {
        "name": "katib-ui-token",
        "namespace": ai_devops_namespace,
        "annotations": {
        "kubernetes.io/service-account.name": "katib-ui"
        }
    },
    "type": "kubernetes.io/service-account-token"
  },
  {
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRole",
    "metadata": {
      "name": "katib-cert-generator"
    },
    "rules": [
      {
        "apiGroups": [
          ""
        ],
        "resources": [
          "secrets"
        ],
        "verbs": [
          "get",
          "create",
          "delete"
        ]
      },
      {
        "apiGroups": [
          "batch"
        ],
        "resources": [
          "jobs"
        ],
        "verbs": [
          "get"
        ]
      },
      {
        "apiGroups": [
          "admissionregistration.k8s.io"
        ],
        "resources": [
          "validatingwebhookconfigurations",
          "mutatingwebhookconfigurations"
        ],
        "verbs": [
          "get",
          "patch"
        ]
      },
      {
        "apiGroups": [
          "certificates.k8s.io"
        ],
        "resources": [
          "certificatesigningrequests"
        ],
        "verbs": [
          "get",
          "create",
          "delete"
        ]
      },
      {
        "apiGroups": [
          "certificates.k8s.io"
        ],
        "resources": [
          "certificatesigningrequests/approval"
        ],
        "verbs": [
          "update"
        ]
      },
      {
        "apiGroups": [
          "certificates.k8s.io"
        ],
        "resourceNames": [
          "kubernetes.io/*"
        ],
        "resources": [
          "signers"
        ],
        "verbs": [
          "approve"
        ]
      }
    ]
  },
  {
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRole",
    "metadata": {
      "name": "katib-controller"
    },
    "rules": [
      {
        "apiGroups": [
          ""
        ],
        "resources": [
          "configmaps",
          "serviceaccounts",
          "services",
          "events",
          "namespaces",
          "persistentvolumes",
          "persistentvolumeclaims",
          "pods",
          "pods/log",
          "pods/status"
        ],
        "verbs": [
          "*"
        ]
      },
      {
        "apiGroups": [
          "apps"
        ],
        "resources": [
          "deployments"
        ],
        "verbs": [
          "*"
        ]
      },
      {
        "apiGroups": [
          "rbac.authorization.k8s.io"
        ],
        "resources": [
          "roles",
          "rolebindings"
        ],
        "verbs": [
          "*"
        ]
      },
      {
        "apiGroups": [
          "batch"
        ],
        "resources": [
          "jobs",
          "cronjobs"
        ],
        "verbs": [
          "*"
        ]
      },
      {
        "apiGroups": [
          "kubeflow.org"
        ],
        "resources": [
          "experiments",
          "experiments/status",
          "experiments/finalizers",
          "trials",
          "trials/status",
          "trials/finalizers",
          "suggestions",
          "suggestions/status",
          "suggestions/finalizers",
          "tfjobs",
          "pytorchjobs",
          "mpijobs"
        ],
        "verbs": [
          "*"
        ]
      },
      {
        "apiGroups": [
          "tekton.dev"
        ],
        "resources": [
          "pipelineruns",
          "taskruns"
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
      "name": "katib-ui"
    },
    "rules": [
      {
        "apiGroups": [
          ""
        ],
        "resources": [
          "configmaps",
          "namespaces"
        ],
        "verbs": [
          "*"
        ]
      },
      {
        "apiGroups": [
          "kubeflow.org"
        ],
        "resources": [
          "experiments",
          "trials",
          "suggestions"
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
      "name": "katib-cert-generator"
    },
    "roleRef": {
      "apiGroup": "rbac.authorization.k8s.io",
      "kind": "ClusterRole",
      "name": "katib-cert-generator"
    },
    "subjects": [
      {
        "kind": "ServiceAccount",
        "name": "katib-cert-generator",
        "namespace": ai_devops_namespace
      }
    ]
  },
  {
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRoleBinding",
    "metadata": {
      "name": "katib-controller"
    },
    "roleRef": {
      "apiGroup": "rbac.authorization.k8s.io",
      "kind": "ClusterRole",
      "name": "katib-controller"
    },
    "subjects": [
      {
        "kind": "ServiceAccount",
        "name": "katib-controller",
        "namespace": ai_devops_namespace
      }
    ]
  },
  {
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRoleBinding",
    "metadata": {
      "name": "katib-ui"
    },
    "roleRef": {
      "apiGroup": "rbac.authorization.k8s.io",
      "kind": "ClusterRole",
      "name": "katib-ui"
    },
    "subjects": [
      {
        "kind": "ServiceAccount",
        "name": "katib-ui",
        "namespace": ai_devops_namespace
      }
    ]
  },
  {
    "apiVersion": "v1",
    "data": {
      "early-stopping": std.join("", ["{\n  \"medianstop\": {\n    \"image\": \"", target_registry, "docker.io/kubeflowkatib/earlystopping-medianstop:v0.12.0", "\"\n  }\n}"]),
      "metrics-collector-sidecar": std.join("", ["{\n  \"StdOut\": {\n    \"image\": \"", target_registry, "docker.io/kubeflowkatib/file-metrics-collector:v0.12.0\"", "\n  },\n  \"File\": {\n    \"image\": \"", target_registry, "docker.io/kubeflowkatib/file-metrics-collector:v0.12.0\"\n  },\n  \"TensorFlowEvent\": {\n    \"image\": \"", target_registry, "docker.io/kubeflowkatib/tfevent-metrics-collector:v0.12.0\",\n    \"resources\": {\n      \"limits\": {\n        \"memory\": \"1Gi\"\n      }\n    }\n  }\n}"]),
      "suggestion": std.join("", ["{\n  \"random\": {\n    \"image\": \"", target_registry, "docker.io/kubeflowkatib/suggestion-hyperopt:v0.12.0\"\n  },\n  \"tpe\": {\n    \"image\": \"", target_registry, "docker.io/kubeflowkatib/suggestion-hyperopt:v0.12.0\"\n  },\n  \"grid\": {\n    \"image\": \"", target_registry, "docker.io/kubeflowkatib/suggestion-chocolate:v0.12.0\"\n  },\n  \"hyperband\": {\n    \"image\": \"", target_registry, "docker.io/kubeflowkatib/suggestion-hyperband:v0.12.0\"\n  },\n  \"bayesianoptimization\": {\n    \"image\": \"", target_registry, "docker.io/kubeflowkatib/suggestion-skopt:v0.12.0\"\n  },\n  \"cmaes\": {\n    \"image\": \"", target_registry, "docker.io/kubeflowkatib/suggestion-goptuna:v0.12.0\"\n  },\n  \"sobol\": {\n    \"image\": \"", target_registry, "docker.io/kubeflowkatib/suggestion-goptuna:v0.12.0\"\n  },\n  \"multivariate-tpe\": {\n    \"image\": \"", target_registry, "docker.io/kubeflowkatib/suggestion-optuna:v0.12.0\"\n  },\n  \"enas\": {\n    \"image\": \"", target_registry, "docker.io/kubeflowkatib/suggestion-enas:v0.12.0\",\n    \"resources\": {\n      \"limits\": {\n        \"memory\": \"200Mi\"\n      }\n    }\n  },\n  \"darts\": {\n    \"image\": \"", target_registry, "docker.io/kubeflowkatib/suggestion-darts:v0.12.0\"\n  }\n}"])
    },
    "kind": "ConfigMap",
    "metadata": {
      "name": "katib-config",
      "namespace": ai_devops_namespace
    }
  },  
  {
    "apiVersion": "v1",
    "kind": "ConfigMap",
    "metadata": {
      "name": "trial-templates",
      "namespace": ai_devops_namespace,
      "labels": {
        "katib.kubeflow.org/component": "trial-templates"
      }
    },
    "data": {
      "defaultTrialTemplate.yaml": "apiVersion: batch/v1\nkind: Job\nspec:\n  template:\n    spec:\n      containers:\n        - name: training-container\n          image: docker.io/kubeflowkatib/mxnet-mnist:latest\n          command:\n            - \"python3\"\n            - \"/opt/mxnet-mnist/mnist.py\"\n            - \"--batch-size=64\"\n            - \"--lr=${trialParameters.learningRate}\"\n            - \"--num-layers=${trialParameters.numberLayers}\"\n            - \"--optimizer=${trialParameters.optimizer}\"\n      restartPolicy: Never",
      "enasCPUTemplate": "apiVersion: batch/v1\nkind: Job\nspec:\n  template:\n    spec:\n      containers:\n        - name: training-container\n          image: docker.io/kubeflowkatib/enas-cnn-cifar10-cpu:latest\n          command:\n            - python3\n            - -u\n            - RunTrial.py\n            - --num_epochs=1\n            - \"--architecture=\\\"${trialParameters.neuralNetworkArchitecture}\\\"\"\n            - \"--nn_config=\\\"${trialParameters.neuralNetworkConfig}\\\"\"\n      restartPolicy: Never",
      "pytorchJobTemplate": "apiVersion: kubeflow.org/v1\nkind: PyTorchJob\nspec:\n  pytorchReplicaSpecs:\n    Master:\n      replicas: 1\n      restartPolicy: OnFailure\n      template:\n        spec:\n          containers:\n            - name: pytorch\n              image: docker.io/kubeflowkatib/pytorch-mnist:latest\n              imagePullPolicy: Always\n              command:\n                - \"python3\"\n                - \"/opt/pytorch-mnist/mnist.py\"\n                - \"--epochs=1\"\n                - \"--lr=${trialParameters.learningRate}\"\n                - \"--momentum=${trialParameters.momentum}\"\n    Worker:\n      replicas: 2\n      restartPolicy: OnFailure\n      template:\n        spec:\n          containers:\n            - name: pytorch\n              image: docker.io/kubeflowkatib/pytorch-mnist:latest\n              imagePullPolicy: Always\n              command:\n                - \"python3\"\n                - \"/opt/pytorch-mnist/mnist.py\"\n                - \"--epochs=1\"\n                - \"--lr=${trialParameters.learningRate}\"\n                - \"--momentum=${trialParameters.momentum}\""
    }
  },
  {
    "apiVersion": "v1",
    "data": {
      "MYSQL_ROOT_PASSWORD": "dGVzdA=="
    },
    "kind": "Secret",
    "metadata": {
      "name": "katib-mysql-secrets",
      "namespace": ai_devops_namespace
    },
    "type": "Opaque"
  },
  {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
      "annotations": {
        "prometheus.io/port": "8080",
        "prometheus.io/scheme": "http",
        "prometheus.io/scrape": "true"
      },
      "name": "katib-controller",
      "namespace": ai_devops_namespace
    },
    "spec": {
      "ports": [
        {
          "name": "webhook",
          "port": 443,
          "protocol": "TCP",
          "targetPort": 8443
        },
        {
          "name": "metrics",
          "port": 8080,
          "targetPort": 8080
        }
      ],
      "selector": {
        "app": "katib-controller"
      }
    }
  },
  {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
      "labels": {
        "app": "katib-db-manager"
      },
      "name": "katib-db-manager",
      "namespace": ai_devops_namespace
    },
    "spec": {
      "ports": [
        {
          "name": "api",
          "port": 6789,
          "protocol": "TCP"
        }
      ],
      "selector": {
        "app": "katib-db-manager"
      },
      "type": "ClusterIP"
    }
  },
  {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
      "labels": {
        "app": "katib-mysql"
      },
      "name": "katib-mysql",
      "namespace": ai_devops_namespace
    },
    "spec": {
      "ports": [
        {
          "name": "dbapi",
          "port": 3306,
          "protocol": "TCP"
        }
      ],
      "selector": {
        "app": "katib-mysql"
      },
      "type": "ClusterIP"
    }
  },
  {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
      "labels": {
        "app": "katib-ui"
      },
      "name": "katib-ui",
      "namespace": ai_devops_namespace
    },
    "spec": {
      "ports": [
        {
          "name": "ui",
          "port": 80,
          "protocol": "TCP",
          "targetPort": 8080
        }
      ],
      "selector": {
        "app": "katib-ui"
      },
      "type": "ClusterIP"
    }
  },
  {
    "apiVersion": "v1",
    "kind": "PersistentVolumeClaim",
    "metadata": {
      "name": "katib-mysql",
      "namespace": ai_devops_namespace
    },
    "spec": {      
      "accessModes": [
        "ReadWriteOnce"
      ],
      "resources": {
        "requests": {
          "storage": "10Gi"
        }
      }
    }
  },
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "labels": {
        "app": "katib-controller"
      },
      "name": "katib-controller",
      "namespace": ai_devops_namespace
    },
    "spec": {
      "replicas": 1,
      "selector": {
        "matchLabels": {
          "app": "katib-controller"
        }
      },
      "template": {
        "metadata": {
          "annotations": {
            "prometheus.io/scrape": "true",
            "sidecar.istio.io/inject": "false"
          },
          "labels": {
            "app": "katib-controller"
          }
        },
        "spec": {
          "containers": [
            {
              "args": [
                "--webhook-port=8443",
                "--trial-resources=Job.v1.batch",
                "--trial-resources=TFJob.v1.kubeflow.org",
                "--trial-resources=PyTorchJob.v1.kubeflow.org",
                "--trial-resources=MPIJob.v1.kubeflow.org",
                "--trial-resources=PipelineRun.v1beta1.tekton.dev"
              ],
              "command": [
                "./katib-controller"
              ],
              "env": [
                {
                  "name": "KATIB_CORE_NAMESPACE",
                  "valueFrom": {
                    "fieldRef": {
                      "fieldPath": "metadata.namespace"
                    }
                  }
                }
              ],
              "image": std.join("", [target_registry, "docker.io/kubeflowkatib/katib-controller:", katib_object_image_tag]),
              "name": "katib-controller",
              "ports": [
                {
                  "containerPort": 8443,
                  "name": "webhook",
                  "protocol": "TCP"
                },
                {
                  "containerPort": 8080,
                  "name": "metrics",
                  "protocol": "TCP"
                }
              ],
              "volumeMounts": [
                {
                  "mountPath": "/tmp/cert",
                  "name": "cert",
                  "readOnly": true
                },
                {
                  "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                  "name": "katib-controller-token",
                  "readOnly": true
                }
              ]
            }
          ],
          "volumes": [
            {
              "name": "cert",
              "secret": {
                "defaultMode": 420,
                "secretName": "katib-webhook-cert"
              }
            },
            {
              "name": "katib-controller-token",
              "secret": {
                "defaultMode": 420,
                "secretName": "katib-controller-token"
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
        "app": "katib-db-manager"
      },
      "name": "katib-db-manager",
      "namespace": ai_devops_namespace
    },
    "spec": {
      "replicas": 1,
      "selector": {
        "matchLabels": {
          "app": "katib-db-manager"
        }
      },
      "template": {
        "metadata": {
          "annotations": {
            "sidecar.istio.io/inject": "false"
          },
          "labels": {
            "app": "katib-db-manager"
          }
        },
        "spec": {
          "containers": [
            {
              "command": [
                "./katib-db-manager"
              ],
              "env": [
                {
                  "name": "DB_NAME",
                  "value": "mysql"
                },
                {
                  "name": "DB_PASSWORD",
                  "valueFrom": {
                    "secretKeyRef": {
                      "key": "MYSQL_ROOT_PASSWORD",
                      "name": "katib-mysql-secrets"
                    }
                  }
                }
              ],
              "image": std.join("", [target_registry, "docker.io/kubeflowkatib/katib-db-manager:", katib_object_image_tag]),
              "livenessProbe": {
                "exec": {
                  "command": [
                    "/bin/grpc_health_probe",
                    "-addr=:6789"
                  ]
                },
                "failureThreshold": 5,
                "initialDelaySeconds": 10,
                "periodSeconds": 60
              },
              "name": "katib-db-manager",
              "ports": [
                {
                  "containerPort": 6789,
                  "name": "api"
                }
              ]
            }
          ],
        }
      }
    }
  },
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "labels": {
        "app": "katib-mysql"
      },
      "name": "katib-mysql",
      "namespace": ai_devops_namespace
    },
    "spec": {
      "replicas": 1,
      "selector": {
        "matchLabels": {
          "app": "katib-mysql"
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
            "app": "katib-mysql"
          }
        },
        "spec": {
          "containers": [
            {
              "args": [
                "--datadir",
                "/var/lib/mysql/datadir"
              ],
              "env": [
                {
                  "name": "MYSQL_ROOT_PASSWORD",
                  "valueFrom": {
                    "secretKeyRef": {
                      "key": "MYSQL_ROOT_PASSWORD",
                      "name": "katib-mysql-secrets"
                    }
                  }
                },
                {
                  "name": "MYSQL_ALLOW_EMPTY_PASSWORD",
                  "value": "true"
                },
                {
                  "name": "MYSQL_DATABASE",
                  "value": "katib"
                }
              ],
              "image": std.join("", [target_registry, "docker.io/library/mysql:8.0.27"]),
              "livenessProbe": {
                "exec": {
                  "command": [
                    "/bin/bash",
                    "-c",
                    "mysqladmin ping -u root -p${MYSQL_ROOT_PASSWORD}"
                  ]
                },
                "failureThreshold": 10,
                "periodSeconds": 2,
                "initialDelaySeconds": 300
              },
              "name": "katib-mysql",
              "ports": [
                {
                  "containerPort": 3306,
                  "name": "dbapi"
                }
              ],
              "readinessProbe": {
                "exec": {
                  "command": [
                    "/bin/bash",
                    "-c",
                    "mysql -D ${MYSQL_DATABASE} -u root -p${MYSQL_ROOT_PASSWORD} -e 'SELECT 1'"
                  ]
                },
                "failureThreshold": 10,
                "periodSeconds": 2
              },
              "startupProbe": {
                "exec": {
                  "command": [
                    "/bin/bash",
                    "-c",
                    "mysqladmin ping -u root -p${MYSQL_ROOT_PASSWORD}"
                  ]
                },
                "failureThreshold": 60,
                "periodSeconds": 15
              },
              "volumeMounts": [
                {
                  "mountPath": "/var/lib/mysql",
                  "name": "katib-mysql"
                }
              ]
            }
          ],
          "volumes": [
            {
              "name": "katib-mysql",
              "persistentVolumeClaim": {
                "claimName": "katib-mysql"
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
        "app": "katib-ui"
      },
      "name": "katib-ui",
      "namespace": ai_devops_namespace
    },
    "spec": {
      "replicas": 1,
      "selector": {
        "matchLabels": {
          "app": "katib-ui"
        }
      },
      "template": {
        "metadata": {
          "annotations": {
            "sidecar.istio.io/inject": "false"
          },
          "labels": {
            "app": "katib-ui"
          }
        },
        "spec": {
          "containers": [
            {
              "args": [
                "--port=8080"
              ],
              "command": [
                "./katib-ui"
              ],
              "env": [
                {
                  "name": "KATIB_CORE_NAMESPACE",
                  "valueFrom": {
                    "fieldRef": {
                      "fieldPath": "metadata.namespace"
                    }
                  }
                }
              ],
              "image": std.join("", [target_registry, "docker.io/kubeflowkatib/katib-ui:", katib_object_image_tag]),
              "name": "katib-ui",
              "ports": [
                {
                  "containerPort": 8080,
                  "name": "ui"
                }
              ],
              "volumeMounts": [
                {
                    "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                    "name": "katib-ui-token",
                    "readOnly": true
                }
              ]
            }
          ],
          "volumes": [            
            {
              "name": "katib-ui-token",
              "secret": {
                "defaultMode": 420,
                "secretName": "katib-ui-token"
              }
            }
          ]
        }
      }
    }
  },
  {
    "apiVersion": "v1",
    "kind": "Secret",
    "metadata": {
        "name": "katib-cert-generator-token",
        "namespace": ai_devops_namespace,
        "annotations": {
        "kubernetes.io/service-account.name": "katib-cert-generator"
        }
    },
    "type": "kubernetes.io/service-account-token"
  },
  {
    "apiVersion": "batch/v1",
    "kind": "Job",
    "metadata": {
      "name": "katib-cert-generator",
      "namespace": ai_devops_namespace
    },
    "spec": {
      "backoffLimit": 4,
      "template": {
        "metadata": {
          "annotations": {
            "sidecar.istio.io/inject": "false"
          }
        },
        "spec": {
          "containers": [
            {
              "env": [
                {
                  "name": "KATIB_CORE_NAMESPACE",
                  "valueFrom": {
                    "fieldRef": {
                      "fieldPath": "metadata.namespace"
                    }
                  }
                }
              ],
              "image": std.join("", [target_registry, "docker.io/kubeflowkatib/cert-generator:", katib_object_image_tag]),
              "imagePullPolicy": "Always",
              "name": "cert-generator",
              "volumeMounts": [
                {
                  "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                  "name": "katib-cert-generator-token",
                  "readOnly": true
                }
              ]
            }
          ],
          "restartPolicy": "Never",
          "volumes": [
            {
              "name": "katib-cert-generator-token",
              "secret": {
                "defaultMode": 420,
                "secretName": "katib-cert-generator-token"
              }
            }
          ]
        }
      }
    }
  }, 
  {
    "apiVersion": "admissionregistration.k8s.io/v1",
    "kind": "MutatingWebhookConfiguration",
    "metadata": {
      "name": "katib.kubeflow.org"
    },
    "webhooks": [
      {
        "admissionReviewVersions": [
          "v1beta1"
        ],
        "clientConfig": {
          "service": {
            "name": "katib-controller",
            "namespace": ai_devops_namespace,
            "path": "/mutate-experiment"
          }
        },
        "failurePolicy": "Ignore",
        "name": "defaulter.experiment.katib.kubeflow.org",
        "rules": [
          {
            "apiGroups": [
              "kubeflow.org"
            ],
            "apiVersions": [
              "v1beta1"
            ],
            "operations": [
              "CREATE",
              "UPDATE"
            ],
            "resources": [
              "experiments"
            ]
          }
        ],
        "sideEffects": "None"
      },
      {
        "admissionReviewVersions": [
          "v1beta1"
        ],
        "clientConfig": {
          "service": {
            "name": "katib-controller",
            "namespace": ai_devops_namespace,
            "path": "/mutate-pod"
          }
        },
        "failurePolicy": "Ignore",
        "name": "mutator.pod.katib.kubeflow.org",
        "namespaceSelector": {
          "matchLabels": {
            "katib-metricscollector-injection": "enabled"
          }
        },
        "rules": [
          {
            "apiGroups": [
              ""
            ],
            "apiVersions": [
              "v1"
            ],
            "operations": [
              "CREATE"
            ],
            "resources": [
              "pods"
            ]
          }
        ],
        "sideEffects": "None"
      }
    ]
  },
  {
    "apiVersion": "admissionregistration.k8s.io/v1",
    "kind": "ValidatingWebhookConfiguration",
    "metadata": {
      "name": "katib.kubeflow.org"
    },
    "webhooks": [
      {
        "admissionReviewVersions": [
          "v1beta1"
        ],
        "clientConfig": {
          "service": {
            "name": "katib-controller",
            "namespace": ai_devops_namespace,
            "path": "/validate-experiment"
          }
        },
        "failurePolicy": "Ignore",
        "name": "validator.experiment.katib.kubeflow.org",
        "rules": [
          {
            "apiGroups": [
              "kubeflow.org"
            ],
            "apiVersions": [
              "v1beta1"
            ],
            "operations": [
              "CREATE",
              "UPDATE"
            ],
            "resources": [
              "experiments"
            ]
          }
        ],
        "sideEffects": "None"
      }
    ]
  }
]