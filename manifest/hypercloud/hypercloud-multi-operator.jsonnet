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
  multi_operator_log_level="info",
  single_operator_log_level="info",
  api_server_log_level="INFO",
  postgres_log_level="WARNING",
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";

[
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "labels": {
        "hypercloud": "multi-operator"
      },
      "name": "hypercloud-multi-operator-controller-manager",
      "namespace": "hypercloud5-system"
    },
    "spec": {
      "replicas": 1,
      "selector": {
        "matchLabels": {
          "hypercloud": "multi-operator"
        }
      },
      "template": {
        "metadata": {
          "labels": {
            "hypercloud": "multi-operator"
          }
        },
        "spec": {
          "containers": [
            {
              "args": [
                "--metrics-addr=127.0.0.1:8080",
                "--enable-leader-election",
                std.join("", ["--zap-log-level=", multi_operator_log_level])
              ],
              "command": [
                "/manager"
              ],
              "env": [
                {
                  "name": "TZ",
                  "value": "Asia/Seoul"
                },
                {
                  "name": "HC_DOMAIN",
                  "value": domain
                },
                {
                  "name": "AUTH_CLIENT_SECRET",
                  "value": hyperauth_client_secret
                },
                {
                  "name": "AUTH_SUBDOMAIN",
                  "value": hyperauth_subdomain
                },
                {
                  "name": "HYPERREGISTRY_ENABLED",
                  "value": hyperregistry_enabled
                },
              ],
              "image": std.join("", [target_registry, "docker.io/tmaxcloudck/hypercloud-multi-operator:b5.0.26.14"]),
              "name": "manager",
              "ports": [
                {
                  "containerPort": 9443,
                  "name": "webhook-server",
                  "protocol": "TCP"
                }
              ],
              "resources": {
                "limits": {
                  "cpu": "100m",
                  "memory": "100Mi"
                },
                "requests": {
                  "cpu": "100m",
                  "memory": "20Mi"
                }
              },
              "volumeMounts": [
                {
                  "mountPath": "/tmp/k8s-webhook-server/serving-certs",
                  "name": "cert",
                  "readOnly": true
                },
                {
                  "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                  "name": "hypercloud-multi-operator-controller-manager-token",
                  "readOnly": true
                }
              ]
            },
            {
              "args": [
                "--secure-listen-address=0.0.0.0:8443",
                "--upstream=http://127.0.0.1:8080/",
                "--logtostderr=true",
                "--v=10"
              ],
              "image": std.join("", [target_registry, "gcr.io/kubebuilder/kube-rbac-proxy:v0.5.0"]),
              "name": "kube-rbac-proxy",
              "ports": [
                {
                  "containerPort": 8443,
                  "name": "https"
                }
              ],
              "resources": {
                "limits": {
                  "cpu": "100m",
                  "memory": "30Mi"
                },
                "requests": {
                  "cpu": "100m",
                  "memory": "20Mi"
                }
              },
              "volumeMounts": [
                {
                  "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                  "name": "hypercloud-multi-operator-controller-manager-token",
                  "readOnly": true
                }
              ]
            }
          ],
          "serviceAccountName": "hypercloud-multi-operator-controller-manager",
          "terminationGracePeriodSeconds": 10,
          "volumes": [
            {
              "name": "cert",
              "secret": {
                "defaultMode": 420,
                "secretName": "hypercloud-multi-operator-webhook-server-cert"
              }
            },
            {
              "name": "hypercloud-multi-operator-controller-manager-token",
              "secret": {
                "defaultMode": 420,
                "secretName": "hypercloud-multi-operator-controller-manager-token"
              }
            }
          ]
        }
      }
    }
  }
] + (if aws_enabled == "true" then [
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
                  "oidc-issuer-url": std.join("", ["https://", hyperauth_url, "/auth/realms/tmax"]),
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
              "kubectl apply -f https://docs.projectcalico.org/archive/v3.16/manifests/calico.yaml",
              "kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.41.0/deploy/static/provider/aws/deploy.yaml"
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
      }
    ],
    "recommend": true,
    "shortDescription": "Cluster template for CAPI provider AWS",
    "urlDescription": ""
  }
] else []) + (if vsphere_enabled == "true" then [
  {
    "apiVersion": "tmax.io/v1",
    "categories": [
      "CAPI"
    ],
    "imageUrl": "https://blogs.vmware.com/vsphere/files/2021/02/VMware-vSphere-Blog-Images-vSphere.jpg",
    "kind": "ClusterTemplate",
    "metadata": {
      "name": "capi-vsphere-template"
    },
    "objectKinds": [
      "Cluster",
      "VSphereCluster",
      "VSphereMachineTemplate",
      "KubeadmControlPlane",
      "KubeadmConfigTemplate",
      "MachineDeployment",
      "ClusterResourceSet",
      "Secret",
      "ConfigMap",
      "ConfigMap",
      "Secret",
      "ConfigMap",
      "ConfigMap",
      "ConfigMap",
      "ConfigMap"
    ],
    "objects": [
      {
        "apiVersion": "cluster.x-k8s.io/v1alpha3",
        "kind": "Cluster",
        "metadata": {
          "labels": {
            "cluster.x-k8s.io/cluster-name": "${ClusterName}"
          },
          "annotations": {
            "federation": "join",
            "owner": "${Owner}"
          },
          "name": "${ClusterName}",
          "namespace": "${Namespace}"
        },
        "spec": {
          "clusterNetwork": {
            "pods": {
              "cidrBlocks": [
                "${PodCidr}"
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
            "kind": "VSphereCluster",
            "name": "${ClusterName}"
          }
        }
      },
      {
        "apiVersion": "infrastructure.cluster.x-k8s.io/v1alpha3",
        "kind": "VSphereCluster",
        "metadata": {
          "name": "${ClusterName}",
          "namespace": "${Namespace}"
        },
        "spec": {
          "cloudProviderConfiguration": {
            "global": {
              "secretName": "cloud-provider-vsphere-credentials",
              "secretNamespace": "kube-system",
              "thumbprint": "${VcenterThumbprint}"
            },
            "network": {
              "name": "${VcenterNetwork}"
            },
            "providerConfig": {
              "cloud": {
                "controllerImage": "gcr.io/cloud-provider-vsphere/cpi/release/manager:v1.18.1"
              }
            },
            "virtualCenter": {
              "${VcenterIp}": {
                "datacenters": "${VcenterDataCenter}",
                "thumbprint": "${VcenterThumbprint}"
              }
            },
            "workspace": {
              "datacenter": "${VcenterDataCenter}",
              "datastore": "${VcenterDataStore}",
              "folder": "${VcenterFolder}",
              "resourcePool": "${VcenterResourcePool}",
              "server": "${VcenterIp}"
            }
          },
          "controlPlaneEndpoint": {
            "host": "${VcenterKcpIp}",
            "port": 6443
          },
          "server": "${VcenterIp}",
          "thumbprint": "${VcenterThumbprint}"
        }
      },
      {
        "apiVersion": "infrastructure.cluster.x-k8s.io/v1alpha3",
        "kind": "VSphereMachineTemplate",
        "metadata": {
          "name": "${ClusterName}",
          "namespace": "${Namespace}"
        },
        "spec": {
          "template": {
            "spec": {
              "cloneMode": "linkedClone",
              "datacenter": "${VcenterDataCenter}",
              "datastore": "${VcenterDataStore}",
              "diskGiB": "${VcenterDiskSize}",
              "folder": "${VcenterFolder}",
              "memoryMiB": "${VcenterMemSize}",
              "network": {
                "devices": [
                  {
                    "dhcp4": true,
                    "networkName": "${VcenterNetwork}"
                  }
                ]
              },
              "numCPUs": "${VcenterCpuNum}",
              "resourcePool": "${VcenterResourcePool}",
              "server": "${VcenterIp}",
              "template": "${VcenterTemplate}",
              "thumbprint": "${VcenterThumbprint}"
            }
          }
        }
      },
      {
        "apiVersion": "controlplane.cluster.x-k8s.io/v1alpha3",
        "kind": "KubeadmControlPlane",
        "metadata": {
          "name": "${ClusterName}-control-plane",
          "namespace": "${Namespace}"
        },
        "spec": {
          "infrastructureTemplate": {
            "apiVersion": "infrastructure.cluster.x-k8s.io/v1alpha3",
            "kind": "VSphereMachineTemplate",
            "name": "${ClusterName}"
          },
          "kubeadmConfigSpec": {
            "clusterConfiguration": {
              "apiServer": {
                "extraArgs": {
                  "cloud-provider": "external",
                  "oidc-client-id": "hypercloud5",
                  "oidc-groups-claim": "group",
                  "oidc-issuer-url": std.join("", ["https://", hyperauth_url, "/auth/realms/tmax"]),
                  "oidc-username-claim": "preferred_username",
                  "oidc-username-prefix": "-"
                }
              },
              "controllerManager": {
                "extraArgs": {
                  "cloud-provider": "external"
                }
              }
            },
            "files": [
              {
                "content": std.join("\n",
                  [
                    "apiVersion: v1",
                    "kind: Pod",
                    "metadata:",
                    "  creationTimestamp: null",
                    "  name: kube-vip",
                    "  namespace: kube-system",
                    "spec:",
                    "  containers:",
                    "  - args:",
                    "    - start",
                    "    env:",
                    "    - name: vip_arp",
                    "      value: \"true\"",
                    "    - name: vip_leaderelection",
                    "      value: \"true\"",
                    "    - name: vip_address",
                    "      value: ${VcenterKcpIp}",
                    "    - name: vip_interface",
                    "      value: eth0",
                    "    - name: vip_leaseduration",
                    "      value: \"15\"",
                    "    - name: vip_renewdeadline",
                    "      value: \"10\"",
                    "    - name: vip_retryperiod",
                    "      value: \"2\"",
                    "    image: plndr/kube-vip:0.3.2",
                    "    imagePullPolicy: IfNotPresent",
                    "    name: kube-vip",
                    "    resources: {}",
                    "    securityContext:",
                    "      capabilities:",
                    "        add:",
                    "        - NET_ADMIN",
                    "        - SYS_TIME",
                    "    volumeMounts:",
                    "    - mountPath: /etc/kubernetes/admin.conf",
                    "      name: kubeconfig",
                    "  hostNetwork: true",
                    "  volumes:",
                    "  - hostPath:",
                    "      path: /etc/kubernetes/admin.conf",
                    "      type: FileOrCreate",
                    "    name: kubeconfig",
                    "status: {}"
                  ]
                ),
                "owner": "root:root",
                "path": "/etc/kubernetes/manifests/kube-vip.yaml"
              },
            ],
            "initConfiguration": {
              "nodeRegistration": {
                "criSocket": "/var/run/containerd/containerd.sock",
                "kubeletExtraArgs": {
                  "cloud-provider": "external"
                },
                "name": "{{ ds.meta_data.hostname }}"
              }
            },
            "joinConfiguration": {
              "nodeRegistration": {
                "criSocket": "/var/run/containerd/containerd.sock",
                "kubeletExtraArgs": {
                  "cloud-provider": "external"
                },
                "name": "{{ ds.meta_data.hostname }}"
              }
            },
            "preKubeadmCommands": [
              "hostname \"{{ ds.meta_data.hostname }}\"",
              "echo \"::1         ipv6-localhost ipv6-loopback\" >/etc/hosts",
              "echo \"127.0.0.1   localhost\" >>/etc/hosts",
              "echo \"127.0.0.1   {{ ds.meta_data.hostname }}\" >>/etc/hosts",
              "echo \"{{ ds.meta_data.hostname }}\" >/etc/hostname"
            ],
            "postKubeadmCommands": [
              "mkdir -p $HOME/.kube",
              "cp /etc/kubernetes/admin.conf $HOME/.kube/config",
              "chown $USER:$USER $HOME/.kube/config",
              "kubectl apply -f https://docs.projectcalico.org/archive/v3.16/manifests/calico.yaml",
              "kubectl apply -f https://github.com/tmax-cloud/capi-template-ingress/releases/download/v0.41.0/ingress-nodeport.yaml"
            ],
            "useExperimentalRetryJoin": true,
            "users": [
              {
                "name": "root",
                "sshAuthorizedKeys": [
                  ""
              ],
              "sudo": "ALL=(ALL) NOPASSWD:ALL"
              }
            ]
          },
          "replicas": "${MasterNum}",
          "version": "${KubernetesVersion}"
        }
      },
      {
        "apiVersion": "bootstrap.cluster.x-k8s.io/v1alpha3",
        "kind": "KubeadmConfigTemplate",
        "metadata": {
          "name": "${ClusterName}-md-0",
          "namespace": "${Namespace}"
        },
        "spec": {
          "template": {
            "spec": {
              "joinConfiguration": {
                "nodeRegistration": {
                  "criSocket": "/var/run/containerd/containerd.sock",
                  "kubeletExtraArgs": {
                    "cloud-provider": "external"
                  },
                  "name": "{{ ds.meta_data.hostname }}"
                }
              },
              "preKubeadmCommands": [
                "hostname \"{{ ds.meta_data.hostname }}\"",
                "echo \"::1         ipv6-localhost ipv6-loopback\" >/etc/hosts",
                "echo \"127.0.0.1   localhost\" >>/etc/hosts",
                "echo \"127.0.0.1   {{ ds.meta_data.hostname }}\" >>/etc/hosts",
                "echo \"{{ ds.meta_data.hostname }}\" >/etc/hostname"
              ],
              "users": [
                {
                  "name": "root",
                  "sshAuthorizedKeys": [
                    ""
                  ],
                  "sudo": "ALL=(ALL) NOPASSWD:ALL"
                }
              ]
            }
          }
        }
      },
      {
        "apiVersion": "cluster.x-k8s.io/v1alpha3",
        "kind": "MachineDeployment",
        "metadata": {
          "labels": {
            "cluster.x-k8s.io/cluster-name": "${ClusterName}"
          },
          "name": "${ClusterName}-md-0",
          "namespace": "${Namespace}"
        },
        "spec": {
          "clusterName": "${ClusterName}",
          "replicas": "${WorkerNum}",
          "selector": {
            "matchLabels": {}
          },
          "template": {
            "metadata": {
              "labels": {
                "cluster.x-k8s.io/cluster-name": "${ClusterName}"
              }
            },
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
                "kind": "VSphereMachineTemplate",
                "name": "${ClusterName}"
              },
              "version": "${KubernetesVersion}"
            }
          }
        }
      },
      {
        "apiVersion": "addons.cluster.x-k8s.io/v1alpha3",
        "kind": "ClusterResourceSet",
        "metadata": {
          "labels": {
            "cluster.x-k8s.io/cluster-name": "${ClusterName}"
          },
          "name": "${ClusterName}-crs-0",
          "namespace": "${Namespace}"
        },
        "spec": {
          "clusterSelector": {
            "matchLabels": {
              "cluster.x-k8s.io/cluster-name": "${ClusterName}"
            }
          },
          "resources": [
            {
              "kind": "Secret",
              "name": "${ClusterName}-vsphere-csi-controller"
            },
            {
              "kind": "ConfigMap",
              "name": "${ClusterName}-vsphere-csi-controller-role"
            },
            {
              "kind": "ConfigMap",
              "name": "${ClusterName}-vsphere-csi-controller-binding"
            },
            {
              "kind": "Secret",
              "name": "${ClusterName}-csi-vsphere-config"
            },
            {
              "kind": "ConfigMap",
              "name": "${ClusterName}-csi.vsphere.vmware.com"
            },
            {
              "kind": "ConfigMap",
              "name": "${ClusterName}-vsphere-csi-node"
            },
            {
              "kind": "ConfigMap",
              "name": "${ClusterName}-vsphere-csi-controller"
            }
          ]
        }
      },
      {
        "apiVersion": "v1",
        "kind": "Secret",
        "metadata": {
          "name": "${ClusterName}-vsphere-csi-controller",
          "namespace": "${Namespace}"
        },
        "stringData": {
          "data": std.join("\n",
            [
              "apiVersion: v1",
              "kind: ServiceAccount",
              "metadata:",
              "  name: vsphere-csi-controller",
              "  namespace: kube-system"
            ]
          )
        },
        "type": "addons.cluster.x-k8s.io/resource-set"
      },
      {
        "apiVersion": "v1",
        "data": {
          "data": std.join("\n",
            [
              "apiVersion: rbac.authorization.k8s.io/v1",
              "kind: ClusterRole",
              "metadata:",
              "  name: vsphere-csi-controller-role",
              "rules:",
              "- apiGroups:",
              "  - storage.k8s.io",
              "  resources:",
              "  - csidrivers",
              "  verbs:",
              "  - create",
              "  - delete",
              "- apiGroups:",
              "  - \"\"",
              "  resources:",
              "  - nodes",
              "  - pods",
              "  - secrets",
              "  - configmaps",
              "  verbs:",
              "  - get",
              "  - list",
              "  - watch",
              "- apiGroups:",
              "  - \"\"",
              "  resources:",
              "  - persistentvolumes",
              "  verbs:",
              "  - get",
              "  - list",
              "  - watch",
              "  - update",
              "  - create",
              "  - delete",
              "  - patch",
              "- apiGroups:",
              "  - storage.k8s.io",
              "  resources:",
              "  - volumeattachments",
              "  verbs:",
              "  - get",
              "  - list",
              "  - watch",
              "  - update",
              "  - patch",
              "- apiGroups:",
              "  - storage.k8s.io",
              "  resources:",
              "  - volumeattachments/status",
              "  verbs:",
              "  - patch",
              "- apiGroups:",
              "  - \"\"",
              "  resources:",
              "  - persistentvolumeclaims",
              "  verbs:",
              "  - get",
              "  - list",
              "  - watch",
              "  - update",
              "- apiGroups:",
              "  - storage.k8s.io",
              "  resources:",
              "  - storageclasses",
              "  - csinodes",
              "  verbs:",
              "  - get",
              "  - list",
              "  - watch",
              "- apiGroups:",
              "  - \"\"",
              "  resources:",
              "  - events",
              "  verbs:",
              "  - list",
              "  - watch",
              "  - create",
              "  - update",
              "  - patch",
              "- apiGroups:",
              "  - coordination.k8s.io",
              "  resources:",
              "  - leases",
              "  verbs:",
              "  - get",
              "  - watch",
              "  - list",
              "  - delete",
              "  - update",
              "  - create",
              "- apiGroups:",
              "  - snapshot.storage.k8s.io",
              "  resources:",
              "  - volumesnapshots",
              "  verbs:",
              "  - get",
              "  - list",
              "- apiGroups:",
              "  - snapshot.storage.k8s.io",
              "  resources:",
              "  - volumesnapshotcontents",
              "  verbs:",
              "  - get",
              "  - list"
            ]
          )
        },
        "kind": "ConfigMap",
        "metadata": {
          "name": "${ClusterName}-vsphere-csi-controller-role",
          "namespace": "${Namespace}"
        }
      },
      {
        "apiVersion": "v1",
        "data": {
          "data": std.join("\n",
            [
              "apiVersion: rbac.authorization.k8s.io/v1",
              "kind: ClusterRoleBinding",
              "metadata:",
              "  name: vsphere-csi-controller-binding",
              "roleRef:",
              "  apiGroup: rbac.authorization.k8s.io",
              "  kind: ClusterRole",
              "  name: vsphere-csi-controller-role",
              "subjects:",
              "- kind: ServiceAccount",
              "  name: vsphere-csi-controller",
              "  namespace: kube-system"
            ]
          )
        },
        "kind": "ConfigMap",
        "metadata": {
          "name": "${ClusterName}-vsphere-csi-controller-binding",
          "namespace": "${Namespace}"
        }
      },
      {
        "apiVersion": "v1",
        "kind": "Secret",
        "metadata": {
          "name": "${ClusterName}-csi-vsphere-config",
          "namespace": "${Namespace}"
        },
        "stringData": {
          "data": std.join("\n",
            [
              "apiVersion: v1",
              "kind: Secret",
              "metadata:",
              "  name: csi-vsphere-config",
              "  namespace: kube-system",
              "stringData:",
              "  csi-vsphere.conf: |+",
              "    [Global]",
              "    cluster-id = \"${Namespace}/${ClusterName}\"",
              "",
              "    [VirtualCenter \"${VcenterIp}\"]",
              "    insecure-flag = \"true\"",
              "    user = \"${VcenterId}\"",
              "    password = \"${VcenterPassword}\"",
              "    datacenters = \"${VcenterDataCenter}\"",
              "",
              "    [Network]",
              "    public-network = \"${VcenterNetwork}\"",
              "",
              "type: Opaque"
            ]
          )
        },
        "type": "addons.cluster.x-k8s.io/resource-set"
      },
      {
        "apiVersion": "v1",
        "data": {
          "data": std.join("\n",
            [
              "apiVersion: storage.k8s.io/v1",
              "kind: CSIDriver",
              "metadata:",
              "  name: csi.vsphere.vmware.com",
              "spec:",
              "  attachRequired: true"
            ]
          )
        },
        "kind": "ConfigMap",
        "metadata": {
          "name": "${ClusterName}-csi.vsphere.vmware.com",
          "namespace": "${Namespace}"
        }
      },
      {
        "apiVersion": "v1",
        "data": {
          "data": std.join("\n",
            [
              "apiVersion: apps/v1",
              "kind: DaemonSet",
              "metadata:",
              "  name: vsphere-csi-node",
              "  namespace: kube-system",
              "spec:",
              "  selector:",
              "    matchLabels:",
              "      app: vsphere-csi-node",
              "  template:",
              "    metadata:",
              "      labels:",
              "        app: vsphere-csi-node",
              "        role: vsphere-csi",
              "    spec:",
              "      containers:",
              "      - args:",
              "        - --v=5",
              "        - --csi-address=$(ADDRESS)",
              "        - --kubelet-registration-path=$(DRIVER_REG_SOCK_PATH)",
              "        env:",
              "        - name: ADDRESS",
              "          value: /csi/csi.sock",
              "        - name: DRIVER_REG_SOCK_PATH",
              "          value: /var/lib/kubelet/plugins/csi.vsphere.vmware.com/csi.sock",
              "        image: quay.io/k8scsi/csi-node-driver-registrar:v2.0.1",
              "        lifecycle:",
              "          preStop:",
              "            exec:",
              "              command:",
              "              - /bin/sh",
              "              - -c",
              "              - rm -rf /registration/csi.vsphere.vmware.com-reg.sock /csi/csi.sock",
              "        name: node-driver-registrar",
              "        resources: {}",
              "        securityContext:",
              "          privileged: true",
              "        volumeMounts:",
              "        - mountPath: /csi",
              "          name: plugin-dir",
              "        - mountPath: /registration",
              "          name: registration-dir",
              "      - env:",
              "        - name: CSI_ENDPOINT",
              "          value: unix:///csi/csi.sock",
              "        - name: X_CSI_MODE",
              "          value: node",
              "        - name: X_CSI_SPEC_REQ_VALIDATION",
              "          value: \"false\"",
              "        - name: VSPHERE_CSI_CONFIG",
              "          value: /etc/cloud/csi-vsphere.conf",
              "        - name: LOGGER_LEVEL",
              "          value: PRODUCTION",
              "        - name: X_CSI_LOG_LEVEL",
              "          value: INFO",
              "        - name: NODE_NAME",
              "          valueFrom:",
              "            fieldRef:",
              "              fieldPath: spec.nodeName",
              "        image: gcr.io/cloud-provider-vsphere/csi/release/driver:v2.1.0",
              "        livenessProbe:",
              "          failureThreshold: 3",
              "          httpGet:",
              "            path: /healthz",
              "            port: healthz",
              "          initialDelaySeconds: 10",
              "          periodSeconds: 5",
              "          timeoutSeconds: 3",
              "        name: vsphere-csi-node",
              "        ports:",
              "        - containerPort: 9808",
              "          name: healthz",
              "          protocol: TCP",
              "        resources: {}",
              "        securityContext:",
              "          allowPrivilegeEscalation: true",
              "          capabilities:",
              "            add:",
              "            - SYS_ADMIN",
              "          privileged: true",
              "        volumeMounts:",
              "        - mountPath: /etc/cloud",
              "          name: vsphere-config-volume",
              "        - mountPath: /csi",
              "          name: plugin-dir",
              "        - mountPath: /var/lib/kubelet",
              "          mountPropagation: Bidirectional",
              "          name: pods-mount-dir",
              "        - mountPath: /dev",
              "          name: device-dir",
              "      - args:",
              "        - --csi-address=/csi/csi.sock",
              "        image: quay.io/k8scsi/livenessprobe:v2.1.0",
              "        name: liveness-probe",
              "        resources: {}",
              "        volumeMounts:",
              "        - mountPath: /csi",
              "          name: plugin-dir",
              "      dnsPolicy: Default",
              "      tolerations:",
              "      - effect: NoSchedule",
              "        operator: Exists",
              "      - effect: NoExecute",
              "        operator: Exists",
              "      volumes:",
              "      - name: vsphere-config-volume",
              "        secret:",
              "          secretName: csi-vsphere-config",
              "      - hostPath:",
              "          path: /var/lib/kubelet/plugins_registry",
              "          type: Directory",
              "        name: registration-dir",
              "      - hostPath:",
              "          path: /var/lib/kubelet/plugins/csi.vsphere.vmware.com/",
              "          type: DirectoryOrCreate",
              "        name: plugin-dir",
              "      - hostPath:",
              "          path: /var/lib/kubelet",
              "          type: Directory",
              "        name: pods-mount-dir",
              "      - hostPath:",
              "          path: /dev",
              "        name: device-dir",
              "  updateStrategy:",
              "    type: RollingUpdate"
            ]
          )
        },
        "kind": "ConfigMap",
        "metadata": {
          "name": "${ClusterName}-vsphere-csi-node",
          "namespace": "${Namespace}"
        }
      },
      {
        "apiVersion": "v1",
        "data": {
          "data": std.join("\n",
            [
              "apiVersion: apps/v1",
              "kind: Deployment",
              "metadata:",
              "  name: vsphere-csi-controller",
              "  namespace: kube-system",
              "spec:",
              "  replicas: 1",
              "  selector:",
              "    matchLabels:",
              "      app: vsphere-csi-controller",
              "  template:",
              "    metadata:",
              "      labels:",
              "        app: vsphere-csi-controller",
              "        role: vsphere-csi",
              "    spec:",
              "      containers:",
              "      - args:",
              "        - --v=4",
              "        - --timeout=300s",
              "        - --csi-address=$(ADDRESS)",
              "        - --leader-election",
              "        env:",
              "        - name: ADDRESS",
              "          value: /csi/csi.sock",
              "        image: quay.io/k8scsi/csi-attacher:v3.0.0",
              "        name: csi-attacher",
              "        resources: {}",
              "        volumeMounts:",
              "        - mountPath: /csi",
              "          name: socket-dir",
              "      - env:",
              "        - name: CSI_ENDPOINT",
              "          value: unix:///var/lib/csi/sockets/pluginproxy/csi.sock",
              "        - name: X_CSI_MODE",
              "          value: controller",
              "        - name: VSPHERE_CSI_CONFIG",
              "          value: /etc/cloud/csi-vsphere.conf",
              "        - name: LOGGER_LEVEL",
              "          value: PRODUCTION",
              "        - name: X_CSI_LOG_LEVEL",
              "          value: INFO",
              "        image: gcr.io/cloud-provider-vsphere/csi/release/driver:v2.1.0",
              "        livenessProbe:",
              "          failureThreshold: 3",
              "          httpGet:",
              "            path: /healthz",
              "            port: healthz",
              "          initialDelaySeconds: 10",
              "          periodSeconds: 5",
              "          timeoutSeconds: 3",
              "        name: vsphere-csi-controller",
              "        ports:",
              "        - containerPort: 9808",
              "          name: healthz",
              "          protocol: TCP",
              "        resources: {}",
              "        volumeMounts:",
              "        - mountPath: /etc/cloud",
              "          name: vsphere-config-volume",
              "          readOnly: true",
              "        - mountPath: /var/lib/csi/sockets/pluginproxy/",
              "          name: socket-dir",
              "      - args:",
              "        - --csi-address=$(ADDRESS)",
              "        env:",
              "        - name: ADDRESS",
              "          value: /var/lib/csi/sockets/pluginproxy/csi.sock",
              "        image: quay.io/k8scsi/livenessprobe:v2.1.0",
              "        name: liveness-probe",
              "        resources: {}",
              "        volumeMounts:",
              "        - mountPath: /var/lib/csi/sockets/pluginproxy/",
              "          name: socket-dir",
              "      - args:",
              "        - --leader-election",
              "        env:",
              "        - name: X_CSI_FULL_SYNC_INTERVAL_MINUTES",
              "          value: \"30\"",
              "        - name: LOGGER_LEVEL",
              "          value: PRODUCTION",
              "        - name: VSPHERE_CSI_CONFIG",
              "          value: /etc/cloud/csi-vsphere.conf",
              "        image: gcr.io/cloud-provider-vsphere/csi/release/syncer:v2.1.0",
              "        name: vsphere-syncer",
              "        resources: {}",
              "        volumeMounts:",
              "        - mountPath: /etc/cloud",
              "          name: vsphere-config-volume",
              "          readOnly: true",
              "      - args:",
              "        - --v=4",
              "        - --timeout=300s",
              "        - --csi-address=$(ADDRESS)",
              "        - --leader-election",
              "        - --default-fstype=ext4",
              "        env:",
              "        - name: ADDRESS",
              "          value: /csi/csi.sock",
              "        image: quay.io/k8scsi/csi-provisioner:v2.0.0",
              "        name: csi-provisioner",
              "        resources: {}",
              "        volumeMounts:",
              "        - mountPath: /csi",
              "          name: socket-dir",
              "      dnsPolicy: Default",
              "      serviceAccountName: vsphere-csi-controller",
              "      tolerations:",
              "      - effect: NoSchedule",
              "        key: node-role.kubernetes.io/master",
              "        operator: Exists",
              "      volumes:",
              "      - name: vsphere-config-volume",
              "        secret:",
              "          secretName: csi-vsphere-config",
              "      - emptyDir: {}",
              "        name: socket-dir"
            ]
          )
        },
        "kind": "ConfigMap",
        "metadata": {
          "name": "${ClusterName}-vsphere-csi-controller",
          "namespace": "${Namespace}"
        }
      },
      {
        "apiVersion": "v1",
        "data": {
          "data": std.join("\n",
            [
              "apiVersion: v1",
              "data:",
              "  csi-migration: \"false\"",
              "kind: ConfigMap",
              "metadata:",
              "  name: internal-feature-states.csi.vsphere.vmware.com",
              "  namespace: kube-system"
            ]
          )
        },
        "kind": "ConfigMap",
        "metadata": {
          "name": "${ClusterName}-internal-feature-states.csi.vsphere.vmware.com",
          "namespace": "${Namespace}"
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
        "description": "Cluster Name",
        "displayName": "Cluster Name",
        "name": "ClusterName",
        "required": false,
        "value": "clustername",
        "valueType": "string"
      },
      {
        "description": "Internal IP Cidr Block for Pods",
        "displayName": "Cidr Block",
        "name": "PodCidr",
        "required": false,
        "value": "0.0.0.0/0",
        "valueType": "string"
      },
      {
        "description": "vCenter Server IP",
        "displayName": "VCSA IP",
        "name": "VcenterIp",
        "required": false,
        "value": "0.0.0.0",
        "valueType": "string"
      },
      {
        "description": "vCenter User Name",
        "displayName": "User Name",
        "name": "VcenterId",
        "required": false,
        "value": "example@domain.local",
        "valueType": "string"
      },
      {
        "description": "vCenter User Password",
        "displayName": "User Password",
        "name": "VcenterPassword",
        "required": false,
        "value": "password",
        "valueType": "string"
      },
      {
        "description": "vCenter TLS Thumbprint",
        "displayName": "Thumbprint",
        "name": "VcenterThumbprint",
        "required": false,
        "value": "00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00",
        "valueType": "string"
      },
      {
        "description": "vCenter Network Name",
        "displayName": "Network Name",
        "name": "VcenterNetwork",
        "required": false,
        "value": "VM Network",
        "valueType": "string"
      },
      {
        "description": "vCenter DataCenter Name",
        "displayName": "DataCenter Name",
        "name": "VcenterDataCenter",
        "required": false,
        "value": "Datacenter",
        "valueType": "string"
      },
      {
        "description": "vCenter DataStore Name",
        "displayName": "DataStore Name",
        "name": "VcenterDataStore",
        "required": false,
        "value": "datastore1",
        "valueType": "string"
      },
      {
        "description": "vCenter Folder Name",
        "displayName": "Folder Name",
        "name": "VcenterFolder",
        "required": false,
        "value": "vm",
        "valueType": "string"
      },
      {
        "description": "vCenter Resource Pool Name",
        "displayName": "Resource Pool Name",
        "name": "VcenterResourcePool",
        "required": false,
        "value": "VM Resource",
        "valueType": "string"
      },
      {
        "description": "VM Disk Size",
        "displayName": "Disk Size",
        "name": "VcenterDiskSize",
        "required": false,
        "value": 25,
        "valueType": "number"
      },
      {
        "description": "VM Memory Size",
        "displayName": "Memory Size",
        "name": "VcenterMemSize",
        "required": false,
        "value": 8192,
        "valueType": "number"
      },
      {
        "description": "Number of CPUs",
        "displayName": "Number of CPUs",
        "name": "VcenterCpuNum",
        "required": false,
        "value": 2,
        "valueType": "number"
      },
      {
        "description": "Target Template Name",
        "displayName": "Template Name",
        "name": "VcenterTemplate",
        "required": false,
        "value": "ubuntu-1804-kube-v1.17.3",
        "valueType": "string"
      },
      {
        "description": "Control Plane Endpoint IP",
        "displayName": "Control Plane Endpoint IP",
        "name": "VcenterKcpIp",
        "required": false,
        "value": "0.0.0.0",
        "valueType": "string"
      },
      {
        "description": "Kubernetes version",
        "displayName": "Kubernetes version",
        "name": "KubernetesVersion",
        "required": false,
        "value": "v1.18.16",
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
        "description": "Number of Worker node",
        "displayName": "number of worker nodes",
        "name": "WorkerNum",
        "required": false,
        "value": 3,
        "valueType": "number"
      }
    ],
    "recommend": true,
    "shortDescription": "Cluster template for CAPI provider vSphere",
    "urlDescription": ""
  }
] else [])
