[
  {
    "apiVersion": "apiextensions.k8s.io/v1",
    "kind": "CustomResourceDefinition",
    "metadata": {
      "annotations": {
        "cert-manager.io/inject-ca-from": "hypercloud5-system/hypercloud-multi-operator-serving-cert",
        "controller-gen.kubebuilder.io/version": "v0.6.2"
      },
      "name": "clustermanagers.cluster.tmax.io"
    },
    "spec": {
      "group": "cluster.tmax.io",
      "names": {
        "kind": "ClusterManager",
        "listKind": "ClusterManagerList",
        "plural": "clustermanagers",
        "shortNames": [
          "clm"
        ],
        "singular": "clustermanager"
      },
      "scope": "Namespaced",
      "versions": [
        {
          "additionalPrinterColumns": [
            {
              "description": "provider",
              "jsonPath": ".spec.provider",
              "name": "Provider",
              "type": "string"
            },
            {
              "description": "k8s version",
              "jsonPath": ".spec.version",
              "name": "Version",
              "type": "string"
            },
            {
              "description": "is running",
              "jsonPath": ".status.ready",
              "name": "Ready",
              "type": "string"
            },
            {
              "description": "replica number of master",
              "jsonPath": ".spec.masterNum",
              "name": "MasterNum",
              "type": "string"
            },
            {
              "description": "running of master",
              "jsonPath": ".status.masterRun",
              "name": "MasterRun",
              "type": "string"
            },
            {
              "description": "replica number of worker",
              "jsonPath": ".spec.workerNum",
              "name": "WorkerNum",
              "type": "string"
            },
            {
              "description": "running of worker",
              "jsonPath": ".status.workerRun",
              "name": "WorkerRun",
              "type": "string"
            },
            {
              "description": "cluster status phase",
              "jsonPath": ".status.phase",
              "name": "Phase",
              "type": "string"
            }
          ],
          "name": "v1alpha1",
          "schema": {
            "openAPIV3Schema": {
              "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema",
              "properties": {
                "apiVersion": {
                  "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.apiVersion",
                  "type": "string"
                },
                "awsSpec": {
                  "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.awsSpec",
                  "properties": {
                    "masterDiskSize": {
                      "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.awsSpec.properties.masterDiskSize",
                      "type": "integer"
                    },
                    "masterType": {
                      "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.awsSpec.properties.masterType",
                      "type": "string"
                    },
                    "region": {
                      "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.awsSpec.properties.region",
                      "type": "string"
                    },
                    "sshKey": {
                      "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.awsSpec.properties.sshKey",
                      "type": "string"
                    },
                    "workerDiskSize": {
                      "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.awsSpec.properties.workerDiskSize",
                      "type": "integer"
                    },
                    "workerType": {
                      "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.awsSpec.properties.workerType",
                      "type": "string"
                    }
                  },
                  "type": "object"
                },
                "kind": {
                  "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.kind",
                  "type": "string"
                },
                "metadata": {
                  "type": "object"
                },
                "spec": {
                  "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.spec",
                  "properties": {
                    "masterNum": {
                      "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.masterNum",
                      "type": "integer"
                    },
                    "provider": {
                      "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.provider",
                      "type": "string"
                    },
                    "version": {
                      "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.version",
                      "type": "string"
                    },
                    "workerNum": {
                      "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.workerNum",
                      "type": "integer"
                    }
                  },
                  "required": [
                    "masterNum",
                    "provider",
                    "version",
                    "workerNum"
                  ],
                  "type": "object"
                },
                "status": {
                  "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.status",
                  "properties": {
                    "applicationLink": {
                      "type": "string"
                    },
                    "argoReady": {
                      "type": "boolean"
                    },
                    "authClientReady": {
                      "type": "boolean"
                    },
                    "controlPlaneEndpoint": {
                      "type": "string"
                    },
                    "controlPlaneReady": {
                      "type": "boolean"
                    },
                    "gatewayReady": {
                      "type": "boolean"
                    },
                    "gatewayReadyMigration": {
                      "type": "boolean"
                    },
                    "masterNum": {
                      "type": "integer"
                    },
                    "masterRun": {
                      "type": "integer"
                    },
                    "nodeInfo": {
                      "items": {
                        "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.nodeInfo.items",
                        "properties": {
                          "architecture": {
                            "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.architecture",
                            "type": "string"
                          },
                          "bootID": {
                            "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.bootID",
                            "type": "string"
                          },
                          "containerRuntimeVersion": {
                            "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.containerRuntimeVersion",
                            "type": "string"
                          },
                          "kernelVersion": {
                            "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.kernelVersion",
                            "type": "string"
                          },
                          "kubeProxyVersion": {
                            "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.kubeProxyVersion",
                            "type": "string"
                          },
                          "kubeletVersion": {
                            "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.kubeletVersion",
                            "type": "string"
                          },
                          "machineID": {
                            "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.machineID",
                            "type": "string"
                          },
                          "operatingSystem": {
                            "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.operatingSystem",
                            "type": "string"
                          },
                          "osImage": {
                            "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.osImage",
                            "type": "string"
                          },
                          "systemUUID": {
                            "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.systemUUID",
                            "type": "string"
                          }
                        },
                        "required": [
                          "architecture",
                          "bootID",
                          "containerRuntimeVersion",
                          "kernelVersion",
                          "kubeProxyVersion",
                          "kubeletVersion",
                          "machineID",
                          "operatingSystem",
                          "osImage",
                          "systemUUID"
                        ],
                        "type": "object"
                      },
                      "type": "array"
                    },
                    "openSearchReady": {
                      "type": "boolean"
                    },
                    "phase": {
                      "type": "string"
                    },
                    "prometheusReady": {
                      "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.prometheusReady",
                      "type": "boolean"
                    },
                    "provider": {
                      "type": "string"
                    },
                    "ready": {
                      "type": "boolean"
                    },
                    "traefikReady": {
                      "type": "boolean"
                    },
                    "version": {
                      "type": "string"
                    },
                    "workerNum": {
                      "type": "integer"
                    },
                    "workerRun": {
                      "type": "integer"
                    }
                  },
                  "type": "object"
                },
                "vsphereSpec": {
                  "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.vsphereSpec",
                  "properties": {
                    "podCidr": {
                      "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.vsphereSpec.properties.podCidr",
                      "type": "string"
                    },
                    "vcenterCpuNum": {
                      "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.vsphereSpec.properties.vcenterCpuNum",
                      "type": "integer"
                    },
                    "vcenterDataCenter": {
                      "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.vsphereSpec.properties.vcenterDataCenter",
                      "type": "string"
                    },
                    "vcenterDataStore": {
                      "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.vsphereSpec.properties.vcenterDataStore",
                      "type": "string"
                    },
                    "vcenterDiskSize": {
                      "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.vsphereSpec.properties.vcenterDiskSize",
                      "type": "integer"
                    },
                    "vcenterFolder": {
                      "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.vsphereSpec.properties.vcenterFolder",
                      "type": "string"
                    },
                    "vcenterId": {
                      "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.vsphereSpec.properties.vcenterId",
                      "type": "string"
                    },
                    "vcenterIp": {
                      "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.vsphereSpec.properties.vcenterIp",
                      "type": "string"
                    },
                    "vcenterKcpIp": {
                      "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.vsphereSpec.properties.vcenterKcpIp",
                      "type": "string"
                    },
                    "vcenterMemSize": {
                      "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.vsphereSpec.properties.vcenterMemSize",
                      "type": "integer"
                    },
                    "vcenterNetwork": {
                      "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.vsphereSpec.properties.vcenterNetwork",
                      "type": "string"
                    },
                    "vcenterPassword": {
                      "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.vsphereSpec.properties.vcenterPassword",
                      "type": "string"
                    },
                    "vcenterResourcePool": {
                      "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.vsphereSpec.properties.vcenterResourcePool",
                      "type": "string"
                    },
                    "vcenterTemplate": {
                      "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.vsphereSpec.properties.vcenterTemplate",
                      "type": "string"
                    },
                    "vcenterThumbprint": {
                      "description": "%clustermanagers.yaml.spec.versions.schema.openAPIV3Schema.properties.vsphereSpec.properties.vcenterThumbprint",
                      "type": "string"
                    }
                  },
                  "type": "object"
                }
              },
              "required": [
                "spec"
              ],
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
    "apiVersion": "apiextensions.k8s.io/v1",
    "kind": "CustomResourceDefinition",
    "metadata": {
      "annotations": {
        "cert-manager.io/inject-ca-from": "hypercloud5-system/hypercloud-multi-operator-serving-cert",
        "controller-gen.kubebuilder.io/version": "v0.6.2"
      },
      "name": "clusterclaims.claim.tmax.io"
    },
    "spec": {
      "group": "claim.tmax.io",
      "names": {
        "kind": "ClusterClaim",
        "listKind": "ClusterClaimList",
        "plural": "clusterclaims",
        "shortNames": [
          "cc"
        ],
        "singular": "clusterclaim"
      },
      "scope": "Namespaced",
      "versions": [
        {
          "additionalPrinterColumns": [
            {
              "jsonPath": ".status.phase",
              "name": "Status",
              "type": "string"
            },
            {
              "jsonPath": ".status.reason",
              "name": "Reason",
              "type": "string"
            },
            {
              "jsonPath": ".metadata.creationTimestamp",
              "name": "Age",
              "type": "date"
            }
          ],
          "name": "v1alpha1",
          "schema": {
            "openAPIV3Schema": {
              "description": "%clusterclaims.yaml.spec.versions.schema.openAPIV3Schema",
              "properties": {
                "apiVersion": {
                  "description": "%clusterclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.apiVersion",
                  "type": "string"
                },
                "kind": {
                  "description": "%clusterclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.kind",
                  "type": "string"
                },
                "metadata": {
                  "type": "object"
                },
                "spec": {
                  "description": "%clusterclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec",
                  "properties": {
                    "clusterName": {
                      "description": "%clusterclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.clusterName",
                      "type": "string"
                    },
                    "masterNum": {
                      "description": "%clusterclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.masterNum",
                      "minimum": 1,
                      "type": "integer"
                    },
                    "provider": {
                      "description": "%clusterclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.provider",
                      "enum": [
                        "AWS",
                        "vSphere"
                      ],
                      "type": "string"
                    },
                    "providerAwsSpec": {
                      "description": "%clusterclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.providerAwsSpec",
                      "properties": {
                        "masterDiskSize": {
                          "description": "%clusterclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.providerAwsSpec.properties.masterDiskSize",
                          "minimum": 8,
                          "type": "integer"
                        },
                        "masterType": {
                          "description": "%clusterclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.providerAwsSpec.properties.masterType",
                          "type": "string"
                        },
                        "region": {
                          "description": "%clusterclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.providerAwsSpec.properties.region",
                          "enum": [
                            "ap-northeast-1",
                            "ap-northeast-2",
                            "ap-south-1",
                            "ap-southeast-1",
                            "ap-northeast-2",
                            "ca-central-1",
                            "eu-central-1",
                            "eu-west-1",
                            "eu-west-2",
                            "eu-west-3",
                            "sa-east-1",
                            "us-east-1",
                            "us-east-2",
                            "us-west-1",
                            "us-west-2"
                          ],
                          "type": "string"
                        },
                        "sshKey": {
                          "description": "%clusterclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.providerAwsSpec.properties.sshKey",
                          "type": "string"
                        },
                        "workerDiskSize": {
                          "description": "%clusterclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.providerAwsSpec.properties.workerDiskSize",
                          "minimum": 8,
                          "type": "integer"
                        },
                        "workerType": {
                          "description": "%clusterclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.providerAwsSpec.properties.workerType",
                          "type": "string"
                        }
                      },
                      "type": "object"
                    },
                    "providerVsphereSpec": {
                      "description": "%clusterclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.providerVsphereSpec",
                      "properties": {
                        "podCidr": {
                          "description": "%clusterclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.providerVsphereSpec.properties.podCidr",
                          "pattern": "^[0-9]+.[0-9]+.[0-9]+.[0-9]+\\/[0-9]+",
                          "type": "string"
                        },
                        "vcenterCpuNum": {
                          "description": "%clusterclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.providerVsphereSpec.properties.vcenterCpuNum",
                          "minimum": 2,
                          "type": "integer"
                        },
                        "vcenterDataCenter": {
                          "description": "%clusterclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.providerVsphereSpec.properties.vcenterDataCenter",
                          "type": "string"
                        },
                        "vcenterDataStore": {
                          "description": "%clusterclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.providerVsphereSpec.properties.vcenterDataStore",
                          "type": "string"
                        },
                        "vcenterDiskSize": {
                          "description": "%clusterclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.providerVsphereSpec.properties.vcenterDiskSize",
                          "minimum": 20,
                          "type": "integer"
                        },
                        "vcenterFolder": {
                          "description": "%clusterclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.providerVsphereSpec.properties.vcenterFolder",
                          "type": "string"
                        },
                        "vcenterId": {
                          "description": "%clusterclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.providerVsphereSpec.properties.vcenterId",
                          "type": "string"
                        },
                        "vcenterIp": {
                          "description": "%clusterclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.providerVsphereSpec.properties.vcenterIp",
                          "type": "string"
                        },
                        "vcenterKcpIp": {
                          "description": "%clusterclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.providerVsphereSpec.properties.vcenterKcpIp",
                          "type": "string"
                        },
                        "vcenterMemSize": {
                          "description": "%clusterclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.providerVsphereSpec.properties.vcenterMemSize",
                          "minimum": 2048,
                          "type": "integer"
                        },
                        "vcenterNetwork": {
                          "description": "%clusterclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.providerVsphereSpec.properties.vcenterNetwork",
                          "type": "string"
                        },
                        "vcenterPassword": {
                          "description": "%clusterclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.providerVsphereSpec.properties.vcenterPassword",
                          "type": "string"
                        },
                        "vcenterResourcePool": {
                          "description": "%clusterclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.providerVsphereSpec.properties.vcenterResourcePool",
                          "type": "string"
                        },
                        "vcenterTemplate": {
                          "description": "%clusterclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.providerVsphereSpec.properties.vcenterTemplate",
                          "type": "string"
                        },
                        "vcenterThumbprint": {
                          "description": "%clusterclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.providerVsphereSpec.properties.vcenterThumbprint",
                          "type": "string"
                        }
                      },
                      "type": "object"
                    },
                    "version": {
                      "description": "%clusterclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.version",
                      "pattern": "^v[0-9].[0-9]+.[0-9]+",
                      "type": "string"
                    },
                    "workerNum": {
                      "description": "%clusterclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.workerNum",
                      "minimum": 1,
                      "type": "integer"
                    }
                  },
                  "required": [
                    "clusterName",
                    "masterNum",
                    "provider",
                    "version",
                    "workerNum"
                  ],
                  "type": "object"
                },
                "status": {
                  "description": "%clusterclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.status",
                  "properties": {
                    "message": {
                      "type": "string"
                    },
                    "phase": {
                      "enum": [
                        "Awaiting",
                        "Admitted",
                        "Approved",
                        "Rejected",
                        "Error",
                        "ClusterDeleted",
                        "Cluster Deleted"
                      ],
                      "type": "string"
                    },
                    "reason": {
                      "type": "string"
                    }
                  },
                  "type": "object"
                }
              },
              "required": [
                "spec"
              ],
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
    "apiVersion": "apiextensions.k8s.io/v1",
    "kind": "CustomResourceDefinition",
    "metadata": {
      "annotations": {
        "cert-manager.io/inject-ca-from": "hypercloud5-system/hypercloud-multi-operator-serving-cert",
        "controller-gen.kubebuilder.io/version": "v0.6.2"
      },
      "name": "clusterregistrations.cluster.tmax.io"
    },
    "spec": {
      "group": "cluster.tmax.io",
      "names": {
        "kind": "ClusterRegistration",
        "listKind": "ClusterRegistrationList",
        "plural": "clusterregistrations",
        "shortNames": [
          "clr"
        ],
        "singular": "clusterregistration"
      },
      "scope": "Namespaced",
      "versions": [
        {
          "additionalPrinterColumns": [
            {
              "description": "cluster status phase",
              "jsonPath": ".status.phase",
              "name": "Phase",
              "type": "string"
            },
            {
              "description": "cluster status reason",
              "jsonPath": ".status.reason",
              "name": "Reason",
              "type": "string"
            },
            {
              "jsonPath": ".metadata.creationTimestamp",
              "name": "Age",
              "type": "date"
            }
          ],
          "name": "v1alpha1",
          "schema": {
            "openAPIV3Schema": {
              "description": "%clusterregistrations.yaml.spec.versions.schema.openAPIV3Schema",
              "properties": {
                "apiVersion": {
                  "description": "%clusterregistrations.yaml.spec.versions.schema.openAPIV3Schema.properties.apiVersion",
                  "type": "string"
                },
                "kind": {
                  "description": "%clusterregistrations.yaml.spec.versions.schema.openAPIV3Schema.properties.kind",
                  "type": "string"
                },
                "metadata": {
                  "type": "object"
                },
                "spec": {
                  "description": "%clusterregistrations.yaml.spec.versions.schema.openAPIV3Schema.properties.spec",
                  "properties": {
                    "clusterName": {
                      "description": "%clusterregistrations.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.clusterName",
                      "type": "string"
                    },
                    "kubeConfig": {
                      "description": "%clusterregistrations.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.kubeConfig",
                      "format": "data-url",
                      "type": "string"
                    }
                  },
                  "required": [
                    "clusterName",
                    "kubeConfig"
                  ],
                  "type": "object"
                },
                "status": {
                  "description": "%clusterregistrations.yaml.spec.versions.schema.openAPIV3Schema.properties.status",
                  "properties": {
                    "clusterValidated": {
                      "type": "boolean"
                    },
                    "masterNum": {
                      "type": "integer"
                    },
                    "masterRun": {
                      "type": "integer"
                    },
                    "nodeInfo": {
                      "items": {
                        "description": "%clusterregistrations.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.nodeInfo.items",
                        "properties": {
                          "architecture": {
                            "description": "%clusterregistrations.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.architecture",
                            "type": "string"
                          },
                          "bootID": {
                            "description": "%clusterregistrations.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.bootID",
                            "type": "string"
                          },
                          "containerRuntimeVersion": {
                            "description": "%clusterregistrations.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.containerRuntimeVersion",
                            "type": "string"
                          },
                          "kernelVersion": {
                            "description": "%clusterregistrations.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.kernelVersion",
                            "type": "string"
                          },
                          "kubeProxyVersion": {
                            "description": "%clusterregistrations.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.kubeProxyVersion",
                            "type": "string"
                          },
                          "kubeletVersion": {
                            "description": "%clusterregistrations.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.kubeletVersion",
                            "type": "string"
                          },
                          "machineID": {
                            "description": "%clusterregistrations.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.machineID",
                            "type": "string"
                          },
                          "operatingSystem": {
                            "description": "%clusterregistrations.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.operatingSystem",
                            "type": "string"
                          },
                          "osImage": {
                            "description": "%clusterregistrations.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.osImage",
                            "type": "string"
                          },
                          "systemUUID": {
                            "description": "%clusterregistrations.yaml.spec.versions.schema.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.systemUUID",
                            "type": "string"
                          }
                        },
                        "required": [
                          "architecture",
                          "bootID",
                          "containerRuntimeVersion",
                          "kernelVersion",
                          "kubeProxyVersion",
                          "kubeletVersion",
                          "machineID",
                          "operatingSystem",
                          "osImage",
                          "systemUUID"
                        ],
                        "type": "object"
                      },
                      "type": "array"
                    },
                    "phase": {
                      "type": "string"
                    },
                    "provider": {
                      "type": "string"
                    },
                    "ready": {
                      "type": "boolean"
                    },
                    "reason": {
                      "type": "string"
                    },
                    "secretReady": {
                      "type": "boolean"
                    },
                    "version": {
                      "type": "string"
                    },
                    "workerNum": {
                      "type": "integer"
                    },
                    "workerRun": {
                      "type": "integer"
                    }
                  },
                  "type": "object"
                }
              },
              "required": [
                "spec"
              ],
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
    "apiVersion": "apiextensions.k8s.io/v1",
    "kind": "CustomResourceDefinition",
    "metadata": {
      "annotations": {
        "cert-manager.io/inject-ca-from": "hypercloud5-system/hypercloud-multi-operator-serving-cert",
        "controller-gen.kubebuilder.io/version": "v0.6.2"
      },
      "name": "clusterupdateclaims.claim.tmax.io"
    },
    "spec": {
      "group": "claim.tmax.io",
      "names": {
        "kind": "ClusterUpdateClaim",
        "listKind": "ClusterUpdateClaimList",
        "plural": "clusterupdateclaims",
        "shortNames": [
          "cuc"
        ],
        "singular": "clusterupdateclaim"
      },
      "scope": "Namespaced",
      "versions": [
        {
          "additionalPrinterColumns": [
            {
              "jsonPath": ".spec.clusterName",
              "name": "Cluster",
              "type": "string"
            },
            {
              "jsonPath": ".status.phase",
              "name": "Status",
              "type": "string"
            },
            {
              "jsonPath": ".status.reason",
              "name": "Reason",
              "type": "string"
            },
            {
              "jsonPath": ".metadata.creationTimestamp",
              "name": "Age",
              "type": "date"
            }
          ],
          "name": "v1alpha1",
          "schema": {
            "openAPIV3Schema": {
              "description": "%clusterupdateclaims.yaml.spec.versions.schema.openAPIV3Schema",
              "properties": {
                "apiVersion": {
                  "description": "%clusterupdateclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.apiVersion",
                  "type": "string"
                },
                "kind": {
                  "description": "%clusterupdateclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.kind",
                  "type": "string"
                },
                "metadata": {
                  "type": "object"
                },
                "spec": {
                  "description": "%clusterupdateclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec",
                  "properties": {
                    "clusterName": {
                      "description": "%clusterupdateclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.clusterName",
                      "type": "string"
                    },
                    "expectedMasterNum": {
                      "description": "%clusterupdateclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.expectedMasterNum",
                      "minimum": 1,
                      "type": "integer"
                    },
                    "expectedWorkerNum": {
                      "description": "%clusterupdateclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.expectedWorkerNum",
                      "minimum": 1,
                      "type": "integer"
                    },
                    "updateType": {
                      "description": "%clusterupdateclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.updateType",
                      "enum": [
                        "NodeScale"
                      ],
                      "type": "string"
                    }
                  },
                  "required": [
                    "clusterName",
                    "updateType"
                  ],
                  "type": "object"
                },
                "status": {
                  "description": "%clusterupdateclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.status",
                  "properties": {
                    "message": {
                      "type": "string"
                    },
                    "phase": {
                      "enum": [
                        "Awaiting",
                        "Approved",
                        "Rejected",
                        "Error",
                        "Cluster Deleted"
                      ],
                      "type": "string"
                    },
                    "reason": {
                      "type": "string"
                    }
                  },
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
      "name": "hypercloud-multi-operator-controller-manager",
      "namespace": "hypercloud5-system"
    }
  },
  {
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "Role",
    "metadata": {
      "name": "hypercloud-multi-operator-leader-election-role",
      "namespace": "hypercloud5-system"
    },
    "rules": [
      {
        "apiGroups": [
          ""
        ],
        "resources": [
          "configmaps"
        ],
        "verbs": [
          "get",
          "list",
          "watch",
          "create",
          "update",
          "patch",
          "delete"
        ]
      },
      {
        "apiGroups": [
          ""
        ],
        "resources": [
          "configmaps/status"
        ],
        "verbs": [
          "get",
          "update",
          "patch"
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
          "create",
          "patch"
        ]
      }
    ]
  },
  {
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRole",
    "metadata": {
      "creationTimestamp": null,
      "name": "hypercloud-multi-operator-manager-role"
    },
    "rules": [
      {
        "apiGroups": [
          ""
        ],
        "resources": [
          "endpoints",
          "services"
        ],
        "verbs": [
          "create",
          "delete",
          "get",
          "list",
          "patch",
          "update",
          "watch"
        ]
      },
      {
        "apiGroups": [
          ""
        ],
        "resources": [
          "namespaces",
          "secrets",
          "serviceaccounts"
        ],
        "verbs": [
          "create",
          "delete",
          "get",
          "list",
          "patch",
          "post",
          "update",
          "watch"
        ]
      },
      {
        "apiGroups": [
          ""
        ],
        "resources": [
          "nodes"
        ],
        "verbs": [
          "get",
          "list",
          "patch",
          "update",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "argoproj.io"
        ],
        "resources": [
          "applications"
        ],
        "verbs": [
          "create",
          "delete",
          "get",
          "list",
          "patch",
          "update",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "cert-manager.io"
        ],
        "resources": [
          "certificates"
        ],
        "verbs": [
          "create",
          "delete",
          "get",
          "list",
          "patch",
          "update",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "claim.tmax.io"
        ],
        "resources": [
          "clusterclaims"
        ],
        "verbs": [
          "create",
          "delete",
          "get",
          "list",
          "patch",
          "update",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "claim.tmax.io"
        ],
        "resources": [
          "clusterclaims/status"
        ],
        "verbs": [
          "get",
          "patch",
          "update"
        ]
      },
      {
        "apiGroups": [
          "claim.tmax.io"
        ],
        "resources": [
          "clusterupdateclaims"
        ],
        "verbs": [
          "create",
          "delete",
          "get",
          "list",
          "patch",
          "update",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "claim.tmax.io"
        ],
        "resources": [
          "clusterupdateclaims/status"
        ],
        "verbs": [
          "get",
          "patch",
          "update"
        ]
      },
      {
        "apiGroups": [
          "cluster.tmax.io"
        ],
        "resources": [
          "clustermanagers"
        ],
        "verbs": [
          "create",
          "delete",
          "get",
          "list",
          "patch",
          "update",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "cluster.tmax.io"
        ],
        "resources": [
          "clustermanagers/status"
        ],
        "verbs": [
          "get",
          "list",
          "patch",
          "update",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "cluster.tmax.io"
        ],
        "resources": [
          "clusterregistrations"
        ],
        "verbs": [
          "create",
          "delete",
          "get",
          "list",
          "patch",
          "update",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "cluster.tmax.io"
        ],
        "resources": [
          "clusterregistrations/status"
        ],
        "verbs": [
          "get",
          "patch",
          "update"
        ]
      },
      {
        "apiGroups": [
          "cluster.x-k8s.io"
        ],
        "resources": [
          "clusters"
        ],
        "verbs": [
          "get",
          "list",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "cluster.x-k8s.io"
        ],
        "resources": [
          "machinedeployments"
        ],
        "verbs": [
          "create",
          "delete",
          "get",
          "list",
          "patch",
          "update",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "cluster.x-k8s.io"
        ],
        "resources": [
          "machinedeployments/status"
        ],
        "verbs": [
          "get",
          "list",
          "patch",
          "update",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "cluster.x-k8s.io"
        ],
        "resources": [
          "machines"
        ],
        "verbs": [
          "get",
          "list",
          "patch",
          "update",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "cluster.x-k8s.io"
        ],
        "resources": [
          "machines/status"
        ],
        "verbs": [
          "get",
          "list",
          "patch",
          "update",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "controlplane.cluster.x-k8s.io"
        ],
        "resources": [
          "kubeadmcontrolplanes"
        ],
        "verbs": [
          "create",
          "delete",
          "get",
          "list",
          "patch",
          "update",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "controlplane.cluster.x-k8s.io"
        ],
        "resources": [
          "kubeadmcontrolplanes/status"
        ],
        "verbs": [
          "get",
          "list",
          "patch",
          "update",
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
          "create",
          "delete",
          "get",
          "list",
          "patch",
          "update",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "networking.k8s.io"
        ],
        "resources": [
          "ingresses"
        ],
        "verbs": [
          "create",
          "delete",
          "get",
          "list",
          "patch",
          "update",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "rbac.authorization.k8s.io"
        ],
        "resources": [
          "clusterrolebindings"
        ],
        "verbs": [
          "create",
          "delete",
          "get",
          "list",
          "patch",
          "update",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "rbac.authorization.k8s.io"
        ],
        "resources": [
          "clusterrolebindings",
          "clusterroles",
          "rolebindings",
          "roles"
        ],
        "verbs": [
          "create",
          "delete",
          "get",
          "list",
          "patch",
          "update",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "rbac.authorization.k8s.io"
        ],
        "resources": [
          "clusterroles"
        ],
        "verbs": [
          "create",
          "delete",
          "get",
          "list",
          "patch",
          "update",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "rbac.authorization.k8s.io"
        ],
        "resources": [
          "rolebindings"
        ],
        "verbs": [
          "create",
          "delete",
          "get",
          "list",
          "patch",
          "update",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "rbac.authorization.k8s.io"
        ],
        "resources": [
          "roles"
        ],
        "verbs": [
          "create",
          "delete",
          "get",
          "list",
          "patch",
          "update",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "servicecatalog.k8s.io"
        ],
        "resources": [
          "serviceinstances"
        ],
        "verbs": [
          "create",
          "delete",
          "get",
          "list",
          "patch",
          "update",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "servicecatalog.k8s.io"
        ],
        "resources": [
          "serviceinstances/status"
        ],
        "verbs": [
          "get",
          "list",
          "patch",
          "update",
          "watch"
        ]
      },
      {
        "apiGroups": [
          "traefik.containo.us"
        ],
        "resources": [
          "middlewares"
        ],
        "verbs": [
          "create",
          "delete",
          "get",
          "list",
          "patch",
          "update",
          "watch"
        ]
      }
    ]
  },
  {
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRole",
    "metadata": {
      "name": "hypercloud-multi-operator-metrics-reader"
    },
    "rules": [
      {
        "nonResourceURLs": [
          "/metrics"
        ],
        "verbs": [
          "get"
        ]
      }
    ]
  },
  {
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRole",
    "metadata": {
      "name": "hypercloud-multi-operator-proxy-role"
    },
    "rules": [
      {
        "apiGroups": [
          "authentication.k8s.io"
        ],
        "resources": [
          "tokenreviews"
        ],
        "verbs": [
          "create"
        ]
      },
      {
        "apiGroups": [
          "authorization.k8s.io"
        ],
        "resources": [
          "subjectaccessreviews"
        ],
        "verbs": [
          "create"
        ]
      }
    ]
  },
  {
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "RoleBinding",
    "metadata": {
      "name": "hypercloud-multi-operator-leader-election-rolebinding",
      "namespace": "hypercloud5-system"
    },
    "roleRef": {
      "apiGroup": "rbac.authorization.k8s.io",
      "kind": "Role",
      "name": "hypercloud-multi-operator-leader-election-role"
    },
    "subjects": [
      {
        "kind": "ServiceAccount",
        "name": "hypercloud-multi-operator-controller-manager",
        "namespace": "hypercloud5-system"
      }
    ]
  },
  {
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRoleBinding",
    "metadata": {
      "name": "hypercloud-multi-operator-manager-rolebinding"
    },
    "roleRef": {
      "apiGroup": "rbac.authorization.k8s.io",
      "kind": "ClusterRole",
      "name": "hypercloud-multi-operator-manager-role"
    },
    "subjects": [
      {
        "kind": "ServiceAccount",
        "name": "hypercloud-multi-operator-controller-manager",
        "namespace": "hypercloud5-system"
      }
    ]
  },
  {
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRoleBinding",
    "metadata": {
      "name": "hypercloud-multi-operator-proxy-rolebinding"
    },
    "roleRef": {
      "apiGroup": "rbac.authorization.k8s.io",
      "kind": "ClusterRole",
      "name": "hypercloud-multi-operator-proxy-role"
    },
    "subjects": [
      {
        "kind": "ServiceAccount",
        "name": "hypercloud-multi-operator-controller-manager",
        "namespace": "hypercloud5-system"
      }
    ]
  },
  {
    "apiVersion": "v1",
    "kind": "Secret",
    "metadata": {
      "annotations": {
        "kubernetes.io/service-account.name": "hypercloud-multi-operator-controller-manager"
      },
      "name": "hypercloud-multi-operator-controller-manager-token",
      "namespace": "hypercloud5-system"
    },
    "type": "kubernetes.io/service-account-token"
  },
  {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
      "labels": {
        "hypercloud": "multi-operator"
      },
      "name": "hypercloud-multi-operator-controller-manager-metrics-service",
      "namespace": "hypercloud5-system"
    },
    "spec": {
      "ports": [
        {
          "name": "https",
          "port": 8443,
          "targetPort": "https"
        }
      ],
      "selector": {
        "hypercloud": "multi-operator"
      }
    }
  },
  {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
      "name": "hypercloud-multi-operator-webhook-service",
      "namespace": "hypercloud5-system"
    },
    "spec": {
      "ports": [
        {
          "port": 443,
          "targetPort": 9443
        }
      ],
      "selector": {
        "hypercloud": "multi-operator"
      }
    }
  },
  {
    "apiVersion": "cert-manager.io/v1",
    "kind": "Certificate",
    "metadata": {
      "name": "hypercloud-multi-operator-serving-cert",
      "namespace": "hypercloud5-system"
    },
    "spec": {
      "dnsNames": [
        "hypercloud-multi-operator-webhook-service.hypercloud5-system.svc",
        "hypercloud-multi-operator-webhook-service.hypercloud5-system.svc.cluster.local"
      ],
      "issuerRef": {
        "group": "cert-manager.io",
        "kind": "ClusterIssuer",
        "name": "tmaxcloud-issuer"
      },
      "secretName": "hypercloud-multi-operator-webhook-server-cert",
      "usages": [
        "digital signature",
        "key encipherment",
        "server auth",
        "client auth"
      ]
    }
  },
  {
    "apiVersion": "admissionregistration.k8s.io/v1",
    "kind": "MutatingWebhookConfiguration",
    "metadata": {
      "annotations": {
        "cert-manager.io/inject-ca-from": "hypercloud5-system/hypercloud-multi-operator-serving-cert"
      },
      "name": "hypercloud-multi-operator-mutating-webhook-configuration"
    },
    "webhooks": [
      {
        "admissionReviewVersions": [
          "v1beta1",
          "v1"
        ],
        "clientConfig": {
          "service": {
            "name": "hypercloud-multi-operator-webhook-service",
            "namespace": "hypercloud5-system",
            "path": "/mutate-claim-tmax-io-v1alpha1-clusterclaim"
          }
        },
        "failurePolicy": "Fail",
        "name": "mutation.webhook.clusterclaim",
        "rules": [
          {
            "apiGroups": [
              "claim.tmax.io"
            ],
            "apiVersions": [
              "v1alpha1"
            ],
            "operations": [
              "UPDATE"
            ],
            "resources": [
              "clusterclaims"
            ]
          }
        ],
        "sideEffects": "NoneOnDryRun"
      }
    ]
  },
  {
    "apiVersion": "admissionregistration.k8s.io/v1",
    "kind": "ValidatingWebhookConfiguration",
    "metadata": {
      "annotations": {
        "cert-manager.io/inject-ca-from": "hypercloud5-system/hypercloud-multi-operator-serving-cert"
      },
      "name": "hypercloud-multi-operator-validating-webhook-configuration"
    },
    "webhooks": [
      {
        "admissionReviewVersions": [
          "v1beta1",
          "v1"
        ],
        "clientConfig": {
          "service": {
            "name": "hypercloud-multi-operator-webhook-service",
            "namespace": "hypercloud5-system",
            "path": "/validate-claim-tmax-io-v1alpha1-clusterclaim"
          }
        },
        "failurePolicy": "Fail",
        "name": "validation.webhook.clusterclaim",
        "rules": [
          {
            "apiGroups": [
              "claim.tmax.io"
            ],
            "apiVersions": [
              "v1alpha1"
            ],
            "operations": [
              "CREATE",
              "UPDATE",
              "DELETE"
            ],
            "resources": [
              "clusterclaims",
              "clusterclaims/status"
            ]
          }
        ],
        "sideEffects": "NoneOnDryRun"
      },
      {
        "admissionReviewVersions": [
          "v1beta1",
          "v1"
        ],
        "clientConfig": {
          "service": {
            "name": "hypercloud-multi-operator-webhook-service",
            "namespace": "hypercloud5-system",
            "path": "/validate-cluster-tmax-io-v1alpha1-clustermanager"
          }
        },
        "failurePolicy": "Fail",
        "name": "validation.webhook.clustermanager",
        "rules": [
          {
            "apiGroups": [
              "cluster.tmax.io"
            ],
            "apiVersions": [
              "v1alpha1"
            ],
            "operations": [
              "UPDATE"
            ],
            "resources": [
              "clustermanagers"
            ]
          }
        ],
        "sideEffects": "NoneOnDryRun"
      },
      {
        "admissionReviewVersions": [
          "v1beta1",
          "v1"
        ],
        "clientConfig": {
          "service": {
            "name": "hypercloud-multi-operator-webhook-service",
            "namespace": "hypercloud5-system",
            "path": "/validate-cluster-tmax-io-v1alpha1-clusterregistration"
          }
        },
        "failurePolicy": "Fail",
        "name": "validation.webhook.clusterregistration",
        "rules": [
          {
            "apiGroups": [
              "cluster.tmax.io"
            ],
            "apiVersions": [
              "v1alpha1"
            ],
            "operations": [
              "CREATE",
              "UPDATE",
              "DELETE"
            ],
            "resources": [
              "clusterregistrations"
            ]
          }
        ],
        "sideEffects": "NoneOnDryRun"
      }
    ]
  },
]