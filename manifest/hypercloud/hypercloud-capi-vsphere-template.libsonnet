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
        "namespace": "${Namespace}",
        "labels": {
          "cluster.tmax.io/cluster-name": "${ClusterName}",
          "cluster.tmax.io/controlplane": "controlplane"
        }
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
                "oidc-issuer-url": "${HyperAuthUrl}",
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
              "content": "apiVersion: v1\nkind: Pod\nmetadata:\n  creationTimestamp: null\n  name: kube-vip\n  namespace: kube-system\nspec:\n  containers:\n  - args:\n    - start\n    env:\n    - name: vip_arp\n      value: \"true\"\n    - name: vip_leaderelection\n      value: \"true\"\n    - name: vip_address\n      value: ${VcenterKcpIp}\n    - name: vip_interface\n      value: eth0\n    - name: vip_leaseduration\n      value: \"15\"\n    - name: vip_renewdeadline\n      value: \"10\"\n    - name: vip_retryperiod\n      value: \"2\"\n    image: plndr/kube-vip:0.3.2\n    imagePullPolicy: IfNotPresent\n    name: kube-vip\n    resources: {}\n    securityContext:\n      capabilities:\n        add:\n        - NET_ADMIN\n        - SYS_TIME\n    volumeMounts:\n    - mountPath: /etc/kubernetes/admin.conf\n      name: kubeconfig\n  hostNetwork: true\n  volumes:\n  - hostPath:\n      path: /etc/kubernetes/admin.conf\n      type: FileOrCreate\n    name: kubeconfig\nstatus: {}\n",
              "owner": "root:root",
              "path": "/etc/kubernetes/manifests/kube-vip.yaml"
            }
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
            "sed -i 's/--bind-address=127.0.0.1/--bind-address=0.0.0.0/g' /etc/kubernetes/manifests/kube-controller-manager.yaml || echo",
            "sed -i 's/--bind-address=127.0.0.1/--bind-address=0.0.0.0/g' /etc/kubernetes/manifests/kube-scheduler.yaml || echo",
            "sed -i \"s/--listen-metrics-urls=http:\\/\\/127.0.0.1:2381/--listen-metrics-urls=http:\\/\\/127.0.0.1:2381,http:\\/\\/{{ ds.meta_data.local_ipv4 }}:2381/g\" /etc/kubernetes/manifests/etcd.yaml || echo"
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
          "cluster.tmax.io/cluster-name": "${ClusterName}",
          "cluster.tmax.io/worker": "worker"
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
        "data": "apiVersion: v1\nkind: ServiceAccount\nmetadata:\n  name: vsphere-csi-controller\n  namespace: kube-system\n"
      },
      "type": "addons.cluster.x-k8s.io/resource-set"
    },
    {
      "apiVersion": "v1",
      "data": {
        "data": "apiVersion: rbac.authorization.k8s.io/v1\nkind: ClusterRole\nmetadata:\n  name: vsphere-csi-controller-role\nrules:\n- apiGroups:\n  - storage.k8s.io\n  resources:\n  - csidrivers\n  verbs:\n  - create\n  - delete\n- apiGroups:\n  - \"\"\n  resources:\n  - nodes\n  - pods\n  - secrets\n  - configmaps\n  verbs:\n  - get\n  - list\n  - watch\n- apiGroups:\n  - \"\"\n  resources:\n  - persistentvolumes\n  verbs:\n  - get\n  - list\n  - watch\n  - update\n  - create\n  - delete\n  - patch\n- apiGroups:\n  - storage.k8s.io\n  resources:\n  - volumeattachments\n  verbs:\n  - get\n  - list\n  - watch\n  - update\n  - patch\n- apiGroups:\n  - storage.k8s.io\n  resources:\n  - volumeattachments/status\n  verbs:\n  - patch\n- apiGroups:\n  - \"\"\n  resources:\n  - persistentvolumeclaims\n  verbs:\n  - get\n  - list\n  - watch\n  - update\n- apiGroups:\n  - storage.k8s.io\n  resources:\n  - storageclasses\n  - csinodes\n  verbs:\n  - get\n  - list\n  - watch\n- apiGroups:\n  - \"\"\n  resources:\n  - events\n  verbs:\n  - list\n  - watch\n  - create\n  - update\n  - patch\n- apiGroups:\n  - coordination.k8s.io\n  resources:\n  - leases\n  verbs:\n  - get\n  - watch\n  - list\n  - delete\n  - update\n  - create\n- apiGroups:\n  - snapshot.storage.k8s.io\n  resources:\n  - volumesnapshots\n  verbs:\n  - get\n  - list\n- apiGroups:\n  - snapshot.storage.k8s.io\n  resources:\n  - volumesnapshotcontents\n  verbs:\n  - get\n  - list\n"
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
        "data": "apiVersion: rbac.authorization.k8s.io/v1\nkind: ClusterRoleBinding\nmetadata:\n  name: vsphere-csi-controller-binding\nroleRef:\n  apiGroup: rbac.authorization.k8s.io\n  kind: ClusterRole\n  name: vsphere-csi-controller-role\nsubjects:\n- kind: ServiceAccount\n  name: vsphere-csi-controller\n  namespace: kube-system\n"
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
        "data": "apiVersion: v1\nkind: Secret\nmetadata:\n  name: csi-vsphere-config\n  namespace: kube-system\nstringData:\n  csi-vsphere.conf: |+\n    [Global]\n    cluster-id = \"${Namespace}/${ClusterName}\"\n\n    [VirtualCenter \"${VcenterIp}\"]\n    insecure-flag = \"true\"\n    user = \"${VcenterId}\"\n    password = \"${VcenterPassword}\"\n    datacenters = \"${VcenterDataCenter}\"\n\n    [Network]\n    public-network = \"${VcenterNetwork}\"\n\ntype: Opaque\n"
      },
      "type": "addons.cluster.x-k8s.io/resource-set"
    },
    {
      "apiVersion": "v1",
      "data": {
        "data": "apiVersion: storage.k8s.io/v1\nkind: CSIDriver\nmetadata:\n  name: csi.vsphere.vmware.com\nspec:\n  attachRequired: true\n"
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
        "data": "apiVersion: apps/v1\nkind: DaemonSet\nmetadata:\n  name: vsphere-csi-node\n  namespace: kube-system\nspec:\n  selector:\n    matchLabels:\n      app: vsphere-csi-node\n  template:\n    metadata:\n      labels:\n        app: vsphere-csi-node\n        role: vsphere-csi\n    spec:\n      containers:\n      - args:\n        - --v=5\n        - --csi-address=$(ADDRESS)\n        - --kubelet-registration-path=$(DRIVER_REG_SOCK_PATH)\n        env:\n        - name: ADDRESS\n          value: /csi/csi.sock\n        - name: DRIVER_REG_SOCK_PATH\n          value: /var/lib/kubelet/plugins/csi.vsphere.vmware.com/csi.sock\n        image: quay.io/k8scsi/csi-node-driver-registrar:v2.0.1\n        lifecycle:\n          preStop:\n            exec:\n              command:\n              - /bin/sh\n              - -c\n              - rm -rf /registration/csi.vsphere.vmware.com-reg.sock /csi/csi.sock\n        name: node-driver-registrar\n        resources: {}\n        securityContext:\n          privileged: true\n        volumeMounts:\n        - mountPath: /csi\n          name: plugin-dir\n        - mountPath: /registration\n          name: registration-dir\n      - env:\n        - name: CSI_ENDPOINT\n          value: unix:///csi/csi.sock\n        - name: X_CSI_MODE\n          value: node\n        - name: X_CSI_SPEC_REQ_VALIDATION\n          value: \"false\"\n        - name: VSPHERE_CSI_CONFIG\n          value: /etc/cloud/csi-vsphere.conf\n        - name: LOGGER_LEVEL\n          value: PRODUCTION\n        - name: X_CSI_LOG_LEVEL\n          value: INFO\n        - name: NODE_NAME\n          valueFrom:\n            fieldRef:\n              fieldPath: spec.nodeName\n        image: gcr.io/cloud-provider-vsphere/csi/release/driver:v2.1.0\n        livenessProbe:\n          failureThreshold: 3\n          httpGet:\n            path: /healthz\n            port: healthz\n          initialDelaySeconds: 10\n          periodSeconds: 5\n          timeoutSeconds: 3\n        name: vsphere-csi-node\n        ports:\n        - containerPort: 9808\n          name: healthz\n          protocol: TCP\n        resources: {}\n        securityContext:\n          allowPrivilegeEscalation: true\n          capabilities:\n            add:\n            - SYS_ADMIN\n          privileged: true\n        volumeMounts:\n        - mountPath: /etc/cloud\n          name: vsphere-config-volume\n        - mountPath: /csi\n          name: plugin-dir\n        - mountPath: /var/lib/kubelet\n          mountPropagation: Bidirectional\n          name: pods-mount-dir\n        - mountPath: /dev\n          name: device-dir\n      - args:\n        - --csi-address=/csi/csi.sock\n        image: quay.io/k8scsi/livenessprobe:v2.1.0\n        name: liveness-probe\n        resources: {}\n        volumeMounts:\n        - mountPath: /csi\n          name: plugin-dir\n      dnsPolicy: Default\n      tolerations:\n      - effect: NoSchedule\n        operator: Exists\n      - effect: NoExecute\n        operator: Exists\n      volumes:\n      - name: vsphere-config-volume\n        secret:\n          secretName: csi-vsphere-config\n      - hostPath:\n          path: /var/lib/kubelet/plugins_registry\n          type: Directory\n        name: registration-dir\n      - hostPath:\n          path: /var/lib/kubelet/plugins/csi.vsphere.vmware.com/\n          type: DirectoryOrCreate\n        name: plugin-dir\n      - hostPath:\n          path: /var/lib/kubelet\n          type: Directory\n        name: pods-mount-dir\n      - hostPath:\n          path: /dev\n        name: device-dir\n  updateStrategy:\n    type: RollingUpdate\n"
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
        "data": "apiVersion: apps/v1\nkind: Deployment\nmetadata:\n  name: vsphere-csi-controller\n  namespace: kube-system\nspec:\n  replicas: 1\n  selector:\n    matchLabels:\n      app: vsphere-csi-controller\n  template:\n    metadata:\n      labels:\n        app: vsphere-csi-controller\n        role: vsphere-csi\n    spec:\n      containers:\n      - args:\n        - --v=4\n        - --timeout=300s\n        - --csi-address=$(ADDRESS)\n        - --leader-election\n        env:\n        - name: ADDRESS\n          value: /csi/csi.sock\n        image: quay.io/k8scsi/csi-attacher:v3.0.0\n        name: csi-attacher\n        resources: {}\n        volumeMounts:\n        - mountPath: /csi\n          name: socket-dir\n      - env:\n        - name: CSI_ENDPOINT\n          value: unix:///var/lib/csi/sockets/pluginproxy/csi.sock\n        - name: X_CSI_MODE\n          value: controller\n        - name: VSPHERE_CSI_CONFIG\n          value: /etc/cloud/csi-vsphere.conf\n        - name: LOGGER_LEVEL\n          value: PRODUCTION\n        - name: X_CSI_LOG_LEVEL\n          value: INFO\n        image: gcr.io/cloud-provider-vsphere/csi/release/driver:v2.1.0\n        livenessProbe:\n          failureThreshold: 3\n          httpGet:\n            path: /healthz\n            port: healthz\n          initialDelaySeconds: 10\n          periodSeconds: 5\n          timeoutSeconds: 3\n        name: vsphere-csi-controller\n        ports:\n        - containerPort: 9808\n          name: healthz\n          protocol: TCP\n        resources: {}\n        volumeMounts:\n        - mountPath: /etc/cloud\n          name: vsphere-config-volume\n          readOnly: true\n        - mountPath: /var/lib/csi/sockets/pluginproxy/\n          name: socket-dir\n      - args:\n        - --csi-address=$(ADDRESS)\n        env:\n        - name: ADDRESS\n          value: /var/lib/csi/sockets/pluginproxy/csi.sock\n        image: quay.io/k8scsi/livenessprobe:v2.1.0\n        name: liveness-probe\n        resources: {}\n        volumeMounts:\n        - mountPath: /var/lib/csi/sockets/pluginproxy/\n          name: socket-dir\n      - args:\n        - --leader-election\n        env:\n        - name: X_CSI_FULL_SYNC_INTERVAL_MINUTES\n          value: \"30\"\n        - name: LOGGER_LEVEL\n          value: PRODUCTION\n        - name: VSPHERE_CSI_CONFIG\n          value: /etc/cloud/csi-vsphere.conf\n        image: gcr.io/cloud-provider-vsphere/csi/release/syncer:v2.1.0\n        name: vsphere-syncer\n        resources: {}\n        volumeMounts:\n        - mountPath: /etc/cloud\n          name: vsphere-config-volume\n          readOnly: true\n      - args:\n        - --v=4\n        - --timeout=300s\n        - --csi-address=$(ADDRESS)\n        - --leader-election\n        - --default-fstype=ext4\n        env:\n        - name: ADDRESS\n          value: /csi/csi.sock\n        image: quay.io/k8scsi/csi-provisioner:v2.0.0\n        name: csi-provisioner\n        resources: {}\n        volumeMounts:\n        - mountPath: /csi\n          name: socket-dir\n      dnsPolicy: Default\n      serviceAccountName: vsphere-csi-controller\n      tolerations:\n      - effect: NoSchedule\n        key: node-role.kubernetes.io/master\n        operator: Exists\n      volumes:\n      - name: vsphere-config-volume\n        secret:\n          secretName: csi-vsphere-config\n      - emptyDir: {}\n        name: socket-dir\n"
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
        "data": "apiVersion: v1\ndata:\n  csi-migration: \"false\"\nkind: ConfigMap\nmetadata:\n  name: internal-feature-states.csi.vsphere.vmware.com\n  namespace: kube-system\n"
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
  "shortDescription": "Cluster template for CAPI provider vSphere",
  "urlDescription": ""
}