{
  "apiVersion": "tmax.io/v1",
  "categories": [
    "CAPI"
  ],
  "imageUrl": "https://a0.awsstatic.com/libra-css/images/logos/aws_logo_smile_1200x630.png",
  "kind": "ClusterTemplate",
  "metadata": {
    "name": "capi-aws-template"
  },
  "objectKinds": [
    "Cluster",
    "AWSCluster",
    "KubeadmControlPlane",
    "AWSMachineTemplate",
    "MachineDeployment",
    "AWSMachineTemplate",
    "KubeadmConfigTemplate"
  ],
  "objects": [
    {
      "apiVersion": "cluster.x-k8s.io/v1alpha3",
      "kind": "Cluster",
      "metadata": {
        "annotations": {
          "federation": "join",
          "owner": "${Owner}"
        },
        "name": "${ClusterName}",
        "namespace": "default"
      },
      "spec": {
        "clusterNetwork": {
          "pods": {
            "cidrBlocks": [
              "192.168.0.0/16"
            ]
          }
        },
        "controlPlaneRef": {
          "apiVersion": "controlplane.cluster.x-k8s.io/v1alpha3",
          "kind": "KubeadmControlPlane",
          "name": "${ClusterName}-control-plane"
        },
        "infrastructureRef": {
          "apiVersion": "infrastructure.cluster.x-k8s.io/v1alpha3",
          "kind": "AWSCluster",
          "name": "${ClusterName}"
        }
      }
    },
    {
      "apiVersion": "infrastructure.cluster.x-k8s.io/v1alpha3",
      "kind": "AWSCluster",
      "metadata": {
        "name": "${ClusterName}",
        "namespace": "default"
      },
      "spec": {
        "region": "${Region}",
        "sshKeyName": "${SshKey}"
      },
      "bastion": {
        "enabled": false
      }
    },
    {
      "apiVersion": "controlplane.cluster.x-k8s.io/v1alpha3",
      "kind": "KubeadmControlPlane",
      "metadata": {
        "name": "${ClusterName}-control-plane",
        "namespace": "default"
      },
      "spec": {
        "infrastructureTemplate": {
          "apiVersion": "infrastructure.cluster.x-k8s.io/v1alpha3",
          "kind": "AWSMachineTemplate",
          "name": "${ClusterName}-control-plane"
        },
        "kubeadmConfigSpec": {
          "clusterConfiguration": {
            "apiServer": {
              "extraArgs": {
                "cloud-provider": "aws",
                "oidc-client-id": "hypercloud5",
                "oidc-groups-claim": "group",
                "oidc-issuer-url": "${HyperAuthUrl}",
                "oidc-username-claim": "preferred_username",
                "oidc-username-prefix": "-"
              }
            },
            "controllerManager": {
              "extraArgs": {
                "cloud-provider": "aws"
              }
            }
          },
          "initConfiguration": {
            "nodeRegistration": {
              "kubeletExtraArgs": {
                "cloud-provider": "aws"
              },
              "name": "{{ ds.meta_data.local_hostname }}"
            }
          },
          "joinConfiguration": {
            "nodeRegistration": {
              "kubeletExtraArgs": {
                "cloud-provider": "aws"
              },
              "name": "{{ ds.meta_data.local_hostname }}"
            }
          },
          "postKubeadmCommands": [
            "mkdir -p $HOME/.kube",
            "cp /etc/kubernetes/admin.conf $HOME/.kube/config",
            "chown $USER:$USER $HOME/.kube/config",
            "kubectl apply -f https://docs.projectcalico.org/archive/v3.16/manifests/calico.yaml"
          ]
        },
        "replicas": "${MasterNum}",
        "version": "${KubernetesVersion}"
      }
    },
    {
      "apiVersion": "infrastructure.cluster.x-k8s.io/v1alpha3",
      "kind": "AWSMachineTemplate",
      "metadata": {
        "name": "${ClusterName}-control-plane",
        "namespace": "default"
      },
      "spec": {
        "template": {
          "spec": {
            "iamInstanceProfile": "control-plane.cluster-api-provider-aws.sigs.k8s.io",
            "instanceType": "${MasterType}",
            "sshKeyName": "${SshKey}"
          }
        }
      }
    },
    {
      "apiVersion": "cluster.x-k8s.io/v1alpha3",
      "kind": "MachineDeployment",
      "metadata": {
        "name": "${ClusterName}-md-0",
        "namespace": "default"
      },
      "spec": {
        "clusterName": "${ClusterName}",
        "replicas": "${WorkerNum}",
        "selector": {},
        "template": {
          "spec": {
            "bootstrap": {
              "configRef": {
                "apiVersion": "bootstrap.cluster.x-k8s.io/v1alpha3",
                "kind": "KubeadmConfigTemplate",
                "name": "${ClusterName}-md-0"
              }
            },
            "clusterName": "${ClusterName}",
            "infrastructureRef": {
              "apiVersion": "infrastructure.cluster.x-k8s.io/v1alpha3",
              "kind": "AWSMachineTemplate",
              "name": "${ClusterName}-md-0"
            },
            "version": "${KubernetesVersion}"
          }
        }
      }
    },
    {
      "apiVersion": "infrastructure.cluster.x-k8s.io/v1alpha3",
      "kind": "AWSMachineTemplate",
      "metadata": {
        "name": "${ClusterName}-md-0",
        "namespace": "default"
      },
      "spec": {
        "template": {
          "spec": {
            "iamInstanceProfile": "nodes.cluster-api-provider-aws.sigs.k8s.io",
            "instanceType": "${WorkerType}",
            "sshKeyName": "${SshKey}"
          }
        }
      }
    },
    {
      "apiVersion": "bootstrap.cluster.x-k8s.io/v1alpha3",
      "kind": "KubeadmConfigTemplate",
      "metadata": {
        "name": "${ClusterName}-md-0",
        "namespace": "default"
      },
      "spec": {
        "template": {
          "spec": {
            "clusterConfiguration": {
              "apiServer": {
                "extraArgs": {
                  "audit-webhook-mode": "batch"
                }
              }
            },
            "joinConfiguration": {
              "nodeRegistration": {
                "kubeletExtraArgs": {
                  "cloud-provider": "aws"
                },
                "name": "{{ ds.meta_data.local_hostname }}"
              }
            }
          }
        }
      }
    }
  ],
  "parameters": [
    {
      "description": "namespace",
      "displayName": "Namespace",
      "name": "Namespace",
      "required": false,
      "value": "default",
      "valueType": "string"
    },
    {
      "description": "Cluster Owner",
      "displayName": "Owner",
      "name": "Owner",
      "required": false,
      "value": "admin",
      "valueType": "string"
    },
    {
      "description": "AWS REGION",
      "displayName": "AWS region",
      "name": "Region",
      "required": false,
      "value": "us-east-1",
      "valueType": "string"
    },
    {
      "description": "AWS SSH key name",
      "displayName": "AWS SSH key name",
      "name": "SshKey",
      "required": false,
      "value": "default",
      "valueType": "string"
    },
    {
      "description": "Cluster name",
      "displayName": "ClusterName",
      "name": "ClusterName",
      "required": false,
      "value": "clustername",
      "valueType": "string"
    },
    {
      "description": "Kubernetes version",
      "displayName": "Kubernetes version",
      "name": "KubernetesVersion",
      "required": false,
      "value": "v1.18.2",
      "valueType": "string"
    },
    {
      "description": "Number of Master node",
      "displayName": "number of master nodes",
      "name": "MasterNum",
      "required": false,
      "value": 3,
      "valueType": "number"
    },
    {
      "description": "Master nodes instance type",
      "displayName": "MasterNodeType",
      "name": "MasterType",
      "required": false,
      "value": "t3.large",
      "valueType": "string"
    },
    {
      "description": "Number of Worker node",
      "displayName": "number of worker nodes",
      "name": "WorkerNum",
      "required": false,
      "value": 3,
      "valueType": "number"
    },
    {
      "description": "Worker nodes instance type",
      "displayName": "WorkerNodeType",
      "name": "WorkerType",
      "required": false,
      "value": "t3.large",
      "valueType": "string"
    },
    {
      "description": "HyperAuth url for open id connect",
      "displayName": "HyperAuth URL",
      "name": "HyperAuthUrl",
      "required": false,
      "value": "hyperauth.tmax.co.kr",
      "valueType": "string"
    }
  ],
  "recommend": true,
  "shortDescription": "Cluster template for CAPI provider AWS",
  "urlDescription": ""
}