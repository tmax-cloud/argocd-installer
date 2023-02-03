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
      "apiVersion": "cluster.x-k8s.io/v1beta1",
      "kind": "Cluster",
      "metadata": {
        "name": "${CLUSTER_NAME}",
        "annotations": {
          "owner": "${OWNER}"
        }
      },
      "spec": {
        "clusterNetwork": {
          "pods": {
            "cidrBlocks": [
              "192.168.0.0/16"
            ]
          }
        },
        "infrastructureRef": {
          "apiVersion": "infrastructure.cluster.x-k8s.io/v1beta2",
          "kind": "AWSCluster",
          "name": "${CLUSTER_NAME}"
        },
        "controlPlaneRef": {
          "kind": "KubeadmControlPlane",
          "apiVersion": "controlplane.cluster.x-k8s.io/v1beta1",
          "name": "${CLUSTER_NAME}-control-plane"
        }
      }
    },
    {
      "apiVersion": "infrastructure.cluster.x-k8s.io/v1beta2",
      "kind": "AWSCluster",
      "metadata": {
        "name": "${CLUSTER_NAME}"
      },
      "spec": {
        "region": "${AWS_REGION}",
        "sshKeyName": "${AWS_SSH_KEY_NAME}"
      },
      "bastion": {
        "enabled": false
      }
    },
    {
      "kind": "KubeadmControlPlane",
      "apiVersion": "controlplane.cluster.x-k8s.io/v1beta1",
      "metadata": {
        "name": "${CLUSTER_NAME}-control-plane"
      },
      "spec": {
        "replicas": "${CONTROL_PLANE_MACHINE_COUNT}",
        "machineTemplate": {
          "infrastructureRef": {
            "kind": "AWSMachineTemplate",
            "apiVersion": "infrastructure.cluster.x-k8s.io/v1beta2",
            "name": "${CLUSTER_NAME}-control-plane"
          }
        },
        "kubeadmConfigSpec": {
          "initConfiguration": {
            "nodeRegistration": {
              "name": "{{ ds.meta_data.local_hostname }}",
              "kubeletExtraArgs": {
                "cloud-provider": "aws"
              }
            }
          },
          "clusterConfiguration": {
            "apiServer": {
              "extraArgs": {
                "cloud-provider": "aws"
              }
            },
            "controllerManager": {
              "extraArgs": {
                "cloud-provider": "aws"
              }
            }
          },
          "joinConfiguration": {
            "nodeRegistration": {
              "name": "{{ ds.meta_data.local_hostname }}",
              "kubeletExtraArgs": {
                "cloud-provider": "aws"
              }
            }
          },
          "postKubeadmCommands": [
            "mkdir -p $HOME/.kube",
            "cp /etc/kubernetes/admin.conf $HOME/.kube/config",
            "chown $USER:$USER $HOME/.kube/config",
            "kubectl apply -f https://docs.projectcalico.org/archive/v3.16/manifests/calico.yaml",
            "sed -i 's/--bind-address=127.0.0.1/--bind-address=0.0.0.0/g' /etc/kubernetes/manifests/kube-controller-manager.yaml || echo",
            "sed -i 's/--bind-address=127.0.0.1/--bind-address=0.0.0.0/g' /etc/kubernetes/manifests/kube-scheduler.yaml || echo",
            "sed -i \"s/--listen-metrics-urls=http:\\/\\/127.0.0.1:2381/--listen-metrics-urls=http:\\/\\/127.0.0.1:2381,http:\\/\\/{{ ds.meta_data.local_ipv4 }}:2381/g\" /etc/kubernetes/manifests/etcd.yaml || echo"
          ]
        },
        "version": "${KUBERNETES_VERSION}"
      }
    },
    {
      "kind": "AWSMachineTemplate",
      "apiVersion": "infrastructure.cluster.x-k8s.io/v1beta2",
      "metadata": {
        "name": "${CLUSTER_NAME}-control-plane"
      },
      "spec": {
        "template": {
          "spec": {
            "instanceType": "${AWS_CONTROL_PLANE_MACHINE_TYPE}",
            "iamInstanceProfile": "control-plane.cluster-api-provider-aws.sigs.k8s.io",
            "sshKeyName": "${AWS_SSH_KEY_NAME}",
            "rootVolume": {
              "size": "${MASTER_DISK_SIZE}"
            }
          }
        }
      }
    },
    {
      "apiVersion": "cluster.x-k8s.io/v1beta1",
      "kind": "MachineDeployment",
      "metadata": {
        "name": "${CLUSTER_NAME}-md-0"
      },
      "spec": {
        "clusterName": "${CLUSTER_NAME}",
        "replicas": "${WORKER_MACHINE_COUNT}",
        "selector": {
          "matchLabels": null
        },
        "template": {
          "spec": {
            "clusterName": "${CLUSTER_NAME}",
            "version": "${KUBERNETES_VERSION}",
            "bootstrap": {
              "configRef": {
                "name": "${CLUSTER_NAME}-md-0",
                "apiVersion": "bootstrap.cluster.x-k8s.io/v1beta1",
                "kind": "KubeadmConfigTemplate"
              }
            },
            "infrastructureRef": {
              "name": "${CLUSTER_NAME}-md-0",
              "apiVersion": "infrastructure.cluster.x-k8s.io/v1beta2",
              "kind": "AWSMachineTemplate"
            }
          }
        }
      }
    },
    {
      "apiVersion": "infrastructure.cluster.x-k8s.io/v1beta2",
      "kind": "AWSMachineTemplate",
      "metadata": {
        "name": "${CLUSTER_NAME}-md-0"
      },
      "spec": {
        "template": {
          "spec": {
            "instanceType": "${AWS_NODE_MACHINE_TYPE}",
            "iamInstanceProfile": "nodes.cluster-api-provider-aws.sigs.k8s.io",
            "sshKeyName": "${AWS_SSH_KEY_NAME}",
            "rootVolume": {
              "size": "${WORKER_DISK_SIZE}"
            }
          }
        }
      }
    },
    {
      "apiVersion": "bootstrap.cluster.x-k8s.io/v1beta1",
      "kind": "KubeadmConfigTemplate",
      "metadata": {
        "name": "${CLUSTER_NAME}-md-0"
      },
      "spec": {
        "template": {
          "spec": {
            "joinConfiguration": {
              "nodeRegistration": {
                "name": "{{ ds.meta_data.local_hostname }}",
                "kubeletExtraArgs": {
                  "cloud-provider": "aws"
                }
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
      "name": "NAMESPACE",
      "required": false,
      "value": "default",
      "valueType": "string"
    },
    {
      "description": "Cluster Owner",
      "displayName": "Owner",
      "name": "OWNER",
      "required": false,
      "value": "admin",
      "valueType": "string"
    },
    {
      "description": "AWS REGION",
      "displayName": "AWS region",
      "name": "AWS_REGION",
      "required": false,
      "value": "us-east-1",
      "valueType": "string"
    },
    {
      "description": "AWS SSH key name",
      "displayName": "AWS SSH key name",
      "name": "AWS_SSH_KEY_NAME",
      "required": false,
      "value": "default",
      "valueType": "string"
    },
    {
      "description": "Cluster name",
      "displayName": "ClusterName",
      "name": "CLUSTER_NAME",
      "required": false,
      "value": "clustername",
      "valueType": "string"
    },
    {
      "description": "Kubernetes version",
      "displayName": "Kubernetes version",
      "name": "KUBERNETES_VERSION",
      "required": false,
      "value": "v1.18.2",
      "valueType": "string"
    },
    {
      "description": "Number of Master node",
      "displayName": "number of master nodes",
      "name": "CONTROL_PLANE_MACHINE_COUNT",
      "required": false,
      "value": 3,
      "valueType": "number"
    },
    {
      "description": "Master nodes instance type",
      "displayName": "MasterNodeType",
      "name": "AWS_CONTROL_PLANE_MACHINE_TYPE",
      "required": false,
      "value": "t3.large",
      "valueType": "string"
    },
    {
      "description": "Number of Worker node",
      "displayName": "number of worker nodes",
      "name": "WORKER_MACHINE_COUNT",
      "required": false,
      "value": 3,
      "valueType": "number"
    },
    {
      "description": "Worker nodes instance type",
      "displayName": "WorkerNodeType",
      "name": "AWS_NODE_MACHINE_TYPE",
      "required": false,
      "value": "t3.large",
      "valueType": "string"
    },
    {
      "description": "Master nodes disk type",
      "displayName": "MasterDiskSize",
      "name": "MASTER_DISK_SIZE",
      "required": false,
      "value": 20,
      "valueType": "number"
    },
    {
      "description": "Worker nodes disk type",
      "displayName": "WorkerDiskSize",
      "name": "WORKER_DISK_SIZE",
      "required": false,
      "value": 20,
      "valueType": "number"
    }
  ],
  "recommend": true,
  "shortDescription": "Cluster template for CAPI provider AWS",
  "urlDescription": ""
}