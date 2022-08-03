function (
  is_offline="false",
  private_registry="registry.hypercloud.org",
  hypercloud_hpcd_mode="multi",
  hypercloud_kafka_enabled="\"true\"",
  hyperauth_url="hyperauth.172.22.6.18.nip.io",
  hyperauth_client_secret="tmax_client_secret",
  domain="tmaxcloud.org",
  hyperauth_subdomain="hyperauth",
  console_subdomain="console",
  hyperregistry_enabled="true",
  storageClass="default",
  aws_enabled="true",
  vsphere_enabled="true",
  kube_version="1.19"
)

if kube_version == "1.19" then [
  {
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
      "annotations": {
        "cert-manager.io/inject-ca-from": "hypercloud5-system/hypercloud-multi-operator-serving-cert",
        "controller-gen.kubebuilder.io/version": "v0.6.2"
      },
      "name": "clustermanagers.cluster.tmax.io"
    },
    "spec": {
      "additionalPrinterColumns": [
        {
          "JSONPath": ".spec.provider",
          "description": "provider",
          "name": "Provider",
          "type": "string"
        },
        {
          "JSONPath": ".spec.version",
          "description": "k8s version",
          "name": "Version",
          "type": "string"
        },
        {
          "JSONPath": ".status.ready",
          "description": "is running",
          "name": "Ready",
          "type": "string"
        },
        {
          "JSONPath": ".spec.masterNum",
          "description": "replica number of master",
          "name": "MasterNum",
          "type": "string"
        },
        {
          "JSONPath": ".status.masterRun",
          "description": "running of master",
          "name": "MasterRun",
          "type": "string"
        },
        {
          "JSONPath": ".spec.workerNum",
          "description": "replica number of worker",
          "name": "WorkerNum",
          "type": "string"
        },
        {
          "JSONPath": ".status.workerRun",
          "description": "running of worker",
          "name": "WorkerRun",
          "type": "string"
        },
        {
          "JSONPath": ".status.phase",
          "description": "cluster status phase",
          "name": "Phase",
          "type": "string"
        }
      ],
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
      "subresources": {
        "status": {}
      },
      "validation": {
        "openAPIV3Schema": {
          "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema",
          "properties": {
            "apiVersion": {
              "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.apiVersion",
              "type": "string"
            },
            "awsSpec": {
              "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.awsSpec",
              "properties": {
                "masterType": {
                  "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.awsSpec.properties.masterType",
                  "type": "string"
                },
                "region": {
                  "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.awsSpec.properties.region",
                  "type": "string"
                },
                "sshKey": {
                  "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.awsSpec.properties.sshKey",
                  "type": "string"
                },
                "workerType": {
                  "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.awsSpec.properties.workerType",
                  "type": "string"
                }
              },
              "type": "object"
            },
            "kind": {
              "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.kind",
              "type": "string"
            },
            "metadata": {
              "type": "object"
            },
            "spec": {
              "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.spec",
              "properties": {
                "masterNum": {
                  "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.masterNum",
                  "type": "integer"
                },
                "provider": {
                  "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.provider",
                  "type": "string"
                },
                "version": {
                  "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.version",
                  "type": "string"
                },
                "workerNum": {
                  "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.workerNum",
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
              "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.status",
              "properties": {
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
                "hyperregistryOidcReady": {
                  "type": "boolean"
                },
                "masterRun": {
                  "type": "integer"
                },
                "nodeInfo": {
                  "items": {
                    "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.status.properties.nodeInfo.items",
                    "properties": {
                      "architecture": {
                        "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.architecture",
                        "type": "string"
                      },
                      "bootID": {
                        "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.bootID",
                        "type": "string"
                      },
                      "containerRuntimeVersion": {
                        "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.containerRuntimeVersion",
                        "type": "string"
                      },
                      "kernelVersion": {
                        "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.kernelVersion",
                        "type": "string"
                      },
                      "kubeProxyVersion": {
                        "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.kubeProxyVersion",
                        "type": "string"
                      },
                      "kubeletVersion": {
                        "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.kubeletVersion",
                        "type": "string"
                      },
                      "machineID": {
                        "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.machineID",
                        "type": "string"
                      },
                      "operatingSystem": {
                        "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.operatingSystem",
                        "type": "string"
                      },
                      "osImage": {
                        "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.osImage",
                        "type": "string"
                      },
                      "systemUUID": {
                        "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.systemUUID",
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
                  "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.status.properties.prometheusReady",
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
                "workerRun": {
                  "type": "integer"
                }
              },
              "type": "object"
            },
            "vsphereSpec": {
              "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.vsphereSpec",
              "properties": {
                "podCidr": {
                  "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.vsphereSpec.properties.podCidr",
                  "type": "string"
                },
                "vcenterCpuNum": {
                  "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.vsphereSpec.properties.vcenterCpuNum",
                  "type": "integer"
                },
                "vcenterDataCenter": {
                  "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.vsphereSpec.properties.vcenterDataCenter",
                  "type": "string"
                },
                "vcenterDataStore": {
                  "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.vsphereSpec.properties.vcenterDataStore",
                  "type": "string"
                },
                "vcenterDiskSize": {
                  "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.vsphereSpec.properties.vcenterDiskSize",
                  "type": "integer"
                },
                "vcenterFolder": {
                  "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.vsphereSpec.properties.vcenterFolder",
                  "type": "string"
                },
                "vcenterId": {
                  "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.vsphereSpec.properties.vcenterId",
                  "type": "string"
                },
                "vcenterIp": {
                  "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.vsphereSpec.properties.vcenterIp",
                  "type": "string"
                },
                "vcenterKcpIp": {
                  "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.vsphereSpec.properties.vcenterKcpIp",
                  "type": "string"
                },
                "vcenterMemSize": {
                  "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.vsphereSpec.properties.vcenterMemSize",
                  "type": "integer"
                },
                "vcenterNetwork": {
                  "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.vsphereSpec.properties.vcenterNetwork",
                  "type": "string"
                },
                "vcenterPassword": {
                  "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.vsphereSpec.properties.vcenterPassword",
                  "type": "string"
                },
                "vcenterResourcePool": {
                  "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.vsphereSpec.properties.vcenterResourcePool",
                  "type": "string"
                },
                "vcenterTemplate": {
                  "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.vsphereSpec.properties.vcenterTemplate",
                  "type": "string"
                },
                "vcenterThumbprint": {
                  "description": "%clustermanagers.yaml.spec.validation.openAPIV3Schema.properties.vsphereSpec.properties.vcenterThumbprint",
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
      "version": "v1alpha1",
      "versions": [
        {
          "name": "v1alpha1",
          "served": true,
          "storage": true
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
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
      "annotations": {
        "cert-manager.io/inject-ca-from": "hypercloud5-system/hypercloud-multi-operator-serving-cert",
        "controller-gen.kubebuilder.io/version": "v0.6.2"
      },
      "name": "clusterclaims.claim.tmax.io"
    },
    "spec": {
      "additionalPrinterColumns": [
        {
          "JSONPath": ".status.phase",
          "name": "Status",
          "type": "string"
        },
        {
          "JSONPath": ".status.reason",
          "name": "Reason",
          "type": "string"
        },
        {
          "JSONPath": ".metadata.creationTimestamp",
          "name": "Age",
          "type": "date"
        }
      ],
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
      "subresources": {
        "status": {}
      },
      "validation": {
        "openAPIV3Schema": {
          "description": "%clusterclaims.yaml.spec.validation.openAPIV3Schema",
          "properties": {
            "apiVersion": {
              "description": "%clusterclaims.yaml.spec.validation.openAPIV3Schema.properties.apiVersion",
              "type": "string"
            },
            "kind": {
              "description": "%clusterclaims.yaml.spec.validation.openAPIV3Schema.properties.kind",
              "type": "string"
            },
            "metadata": {
              "type": "object"
            },
            "spec": {
              "description": "%clusterclaims.yaml.spec.validation.openAPIV3Schema.properties.spec",
              "properties": {
                "clusterName": {
                  "description": "%clusterclaims.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.clusterName",
                  "type": "string"
                },
                "masterNum": {
                  "description": "%clusterclaims.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.masterNum",
                  "type": "integer"
                },
                "provider": {
                  "description": "%clusterclaims.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.provider",
                  "enum": [
                    "AWS",
                    "vSphere"
                  ],
                  "type": "string"
                },
                "providerAwsSpec": {
                  "description": "%clusterclaims.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.providerAwsSpec",
                  "properties": {
                    "masterType": {
                      "description": "%clusterclaims.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.providerAwsSpec.properties.masterType",
                      "type": "string"
                    },
                    "region": {
                      "description": "%clusterclaims.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.providerAwsSpec.properties.region",
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
                      "description": "%clusterclaims.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.providerAwsSpec.properties.sshKey",
                      "type": "string"
                    },
                    "workerType": {
                      "description": "%clusterclaims.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.providerAwsSpec.properties.workerType",
                      "type": "string"
                    }
                  },
                  "type": "object"
                },
                "providerVsphereSpec": {
                  "description": "%clusterclaims.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.providerVsphereSpec",
                  "properties": {
                    "podCidr": {
                      "description": "%clusterclaims.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.providerVsphereSpec.properties.podCidr",
                      "type": "string"
                    },
                    "vcenterCpuNum": {
                      "description": "%clusterclaims.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.providerVsphereSpec.properties.vcenterCpuNum",
                      "type": "integer"
                    },
                    "vcenterDataCenter": {
                      "description": "%clusterclaims.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.providerVsphereSpec.properties.vcenterDataCenter",
                      "type": "string"
                    },
                    "vcenterDataStore": {
                      "description": "%clusterclaims.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.providerVsphereSpec.properties.vcenterDataStore",
                      "type": "string"
                    },
                    "vcenterDiskSize": {
                      "description": "%clusterclaims.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.providerVsphereSpec.properties.vcenterDiskSize",
                      "type": "integer"
                    },
                    "vcenterFolder": {
                      "description": "%clusterclaims.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.providerVsphereSpec.properties.vcenterFolder",
                      "type": "string"
                    },
                    "vcenterId": {
                      "description": "%clusterclaims.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.providerVsphereSpec.properties.vcenterId",
                      "type": "string"
                    },
                    "vcenterIp": {
                      "description": "%clusterclaims.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.providerVsphereSpec.properties.vcenterIp",
                      "type": "string"
                    },
                    "vcenterKcpIp": {
                      "description": "%clusterclaims.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.providerVsphereSpec.properties.vcenterKcpIp",
                      "type": "string"
                    },
                    "vcenterMemSize": {
                      "description": "%clusterclaims.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.providerVsphereSpec.properties.vcenterMemSize",
                      "type": "integer"
                    },
                    "vcenterNetwork": {
                      "description": "%clusterclaims.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.providerVsphereSpec.properties.vcenterNetwork",
                      "type": "string"
                    },
                    "vcenterPassword": {
                      "description": "%clusterclaims.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.providerVsphereSpec.properties.vcenterPassword",
                      "type": "string"
                    },
                    "vcenterResourcePool": {
                      "description": "%clusterclaims.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.providerVsphereSpec.properties.vcenterResourcePool",
                      "type": "string"
                    },
                    "vcenterTemplate": {
                      "description": "%clusterclaims.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.providerVsphereSpec.properties.vcenterTemplate",
                      "type": "string"
                    },
                    "vcenterThumbprint": {
                      "description": "%clusterclaims.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.providerVsphereSpec.properties.vcenterThumbprint",
                      "type": "string"
                    }
                  },
                  "type": "object"
                },
                "version": {
                  "description": "%clusterclaims.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.version",
                  "type": "string"
                },
                "workerNum": {
                  "description": "%clusterclaims.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.workerNum",
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
              "description": "%clusterclaims.yaml.spec.validation.openAPIV3Schema.properties.status",
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
                    "ClusterDeleted"
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
      "version": "v1alpha1",
      "versions": [
        {
          "name": "v1alpha1",
          "served": true,
          "storage": true
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
    "apiVersion": "apiextensions.k8s.io/v1beta1",
    "kind": "CustomResourceDefinition",
    "metadata": {
      "annotations": {
        "cert-manager.io/inject-ca-from": "hypercloud5-system/hypercloud-multi-operator-serving-cert",
        "controller-gen.kubebuilder.io/version": "v0.6.2"
      },
      "name": "clusterregistrations.cluster.tmax.io"
    },
    "spec": {
      "additionalPrinterColumns": [
        {
          "JSONPath": ".status.phase",
          "description": "cluster status phase",
          "name": "Phase",
          "type": "string"
        },
        {
          "JSONPath": ".status.reason",
          "description": "cluster status reason",
          "name": "Reason",
          "type": "string"
        },
        {
          "JSONPath": ".metadata.creationTimestamp",
          "name": "Age",
          "type": "date"
        }
      ],
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
      "subresources": {
        "status": {}
      },
      "validation": {
        "openAPIV3Schema": {
          "description": "%clusterregistrations.yaml.spec.validation.openAPIV3Schema",
          "properties": {
            "apiVersion": {
              "description": "%clusterregistrations.yaml.spec.validation.openAPIV3Schema.properties.apiVersion",
              "type": "string"
            },
            "kind": {
              "description": "%clusterregistrations.yaml.spec.validation.openAPIV3Schema.properties.kind",
              "type": "string"
            },
            "metadata": {
              "type": "object"
            },
            "spec": {
              "description": "%clusterregistrations.yaml.spec.validation.openAPIV3Schema.properties.spec",
              "properties": {
                "clusterName": {
                  "description": "%clusterregistrations.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.clusterName",
                  "type": "string"
                },
                "kubeConfig": {
                  "description": "%clusterregistrations.yaml.spec.validation.openAPIV3Schema.properties.spec.properties.kubeConfig",
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
              "description": "%clusterregistrations.yaml.spec.validation.openAPIV3Schema.properties.status",
              "properties": {
                "masterNum": {
                  "type": "integer"
                },
                "masterRun": {
                  "type": "integer"
                },
                "nodeInfo": {
                  "items": {
                    "description": "%clusterregistrations.yaml.spec.validation.openAPIV3Schema.properties.status.properties.nodeInfo.items",
                    "properties": {
                      "architecture": {
                        "description": "%clusterregistrations.yaml.spec.validation.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.architecture",
                        "type": "string"
                      },
                      "bootID": {
                        "description": "%clusterregistrations.yaml.spec.validation.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.bootID",
                        "type": "string"
                      },
                      "containerRuntimeVersion": {
                        "description": "%clusterregistrations.yaml.spec.validation.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.containerRuntimeVersion",
                        "type": "string"
                      },
                      "kernelVersion": {
                        "description": "%clusterregistrations.yaml.spec.validation.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.kernelVersion",
                        "type": "string"
                      },
                      "kubeProxyVersion": {
                        "description": "%clusterregistrations.yaml.spec.validation.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.kubeProxyVersion",
                        "type": "string"
                      },
                      "kubeletVersion": {
                        "description": "%clusterregistrations.yaml.spec.validation.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.kubeletVersion",
                        "type": "string"
                      },
                      "machineID": {
                        "description": "%clusterregistrations.yaml.spec.validation.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.machineID",
                        "type": "string"
                      },
                      "operatingSystem": {
                        "description": "%clusterregistrations.yaml.spec.validation.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.operatingSystem",
                        "type": "string"
                      },
                      "osImage": {
                        "description": "%clusterregistrations.yaml.spec.validation.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.osImage",
                        "type": "string"
                      },
                      "systemUUID": {
                        "description": "%clusterregistrations.yaml.spec.validation.openAPIV3Schema.properties.status.properties.nodeInfo.items.properties.systemUUID",
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
      "version": "v1alpha1",
      "versions": [
        {
          "name": "v1alpha1",
          "served": true,
          "storage": true
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
  }
] else [
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
                    "hyperregistryOidcReady": {
                      "type": "boolean"
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
                          "type": "string"
                        },
                        "vcenterCpuNum": {
                          "description": "%clusterclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.providerVsphereSpec.properties.vcenterCpuNum",
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
                      "type": "string"
                    },
                    "workerNum": {
                      "description": "%clusterclaims.yaml.spec.versions.schema.openAPIV3Schema.properties.spec.properties.workerNum",
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
                        "ClusterDeleted"
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
  }
]