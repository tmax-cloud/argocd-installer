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
    "VSphereMachineTemplate",
    "KubeadmControlPlane",
    "KubeadmConfigTemplate",
    "MachineDeployment",
    "ClusterResourceSet",
    "Secret",
    "Secret",
    "ConfigMap",
    "ConfigMap",
    "Secret",
    "ConfigMap",
    "ConfigMap",
    "ConfigMap",
    "Secret",
    "Secret",
    "ConfigMap"
  ],
  "objects": [
    {
      "apiVersion": "cluster.x-k8s.io/v1beta1",
      "kind": "Cluster",
      "metadata": {
        "labels": {
          "cluster.x-k8s.io/cluster-name": "${CLUSTER_NAME}"
        },
        "annotations": {
          "owner": "${OWNER}"
        },
        "name": "${CLUSTER_NAME}",
        "namespace": "${NAMESPACE}"
      },
      "spec": {
        "clusterNetwork": {
          "pods": {
            "cidrBlocks": [
              "${POD_CIDR}"
            ]
          }
        },
        "controlPlaneRef": {
          "apiVersion": "controlplane.cluster.x-k8s.io/v1beta1",
          "kind": "KubeadmControlPlane",
          "name": "${CLUSTER_NAME}"
        },
        "infrastructureRef": {
          "apiVersion": "infrastructure.cluster.x-k8s.io/v1beta1",
          "kind": "VSphereCluster",
          "name": "${CLUSTER_NAME}"
        }
      }
    },
    {
      "apiVersion": "infrastructure.cluster.x-k8s.io/v1beta1",
      "kind": "VSphereCluster",
      "metadata": {
        "name": "${CLUSTER_NAME}",
        "namespace": "${NAMESPACE}"
      },
      "spec": {
        "controlPlaneEndpoint": {
          "host": "${CONTROL_PLANE_ENDPOINT_IP}",
          "port": 6443
        },
        "identityRef": {
          "kind": "Secret",
          "name": "${CLUSTER_NAME}"
        },
        "server": "${VSPHERE_SERVER}",
        "thumbprint": "${VSPHERE_TLS_THUMBPRINT}"
      }
    },
    {
      "apiVersion": "infrastructure.cluster.x-k8s.io/v1beta1",
      "kind": "VSphereMachineTemplate",
      "metadata": {
        "name": "${CLUSTER_NAME}",
        "namespace": "${NAMESPACE}"
      },
      "spec": {
        "template": {
          "spec": {
            "cloneMode": "linkedClone",
            "datacenter": "${VSPHERE_DATACENTER}",
            "datastore": "${VSPHERE_DATASTORE}",
            "diskGiB": "${MASTER_DISK_SIZE}",
            "folder": "${VSPHERE_FOLDER}",
            "memoryMiB": "${MASTER_MEM_SIZE}",
            "network": {
              "devices": [
                {
                  "dhcp4": true,
                  "networkName": "${VSPHERE_NETWORK}"
                }
              ]
            },
            "numCPUs": "${MASTER_CPU_NUM}",
            "os": "Linux",
            "resourcePool": "${VSPHERE_RESOURCE_POOL}",
            "server": "${VSPHERE_SERVER}",
            "storagePolicyName": "",
            "template": "${VSPHERE_TEMPLATE}",
            "thumbprint": "${VSPHERE_TLS_THUMBPRINT}"
          }
        }
      }
    },
    {
      "apiVersion": "infrastructure.cluster.x-k8s.io/v1beta1",
      "kind": "VSphereMachineTemplate",
      "metadata": {
        "name": "${CLUSTER_NAME}-worker",
        "namespace": "${NAMESPACE}"
      },
      "spec": {
        "template": {
          "spec": {
            "cloneMode": "linkedClone",
            "datacenter": "${VSPHERE_DATACENTER}",
            "datastore": "${VSPHERE_DATASTORE}",
            "diskGiB": "${WORKER_DISK_SIZE}",
            "folder": "${VSPHERE_FOLDER}",
            "memoryMiB": "${WORKER_MEM_SIZE}",
            "network": {
              "devices": [
                {
                  "dhcp4": true,
                  "networkName": "${VSPHERE_NETWORK}"
                }
              ]
            },
            "numCPUs": "${WORKER_CPU_NUM}",
            "os": "Linux",
            "resourcePool": "${VSPHERE_RESOURCE_POOL}",
            "server": "${VSPHERE_SERVER}",
            "storagePolicyName": "",
            "template": "${VSPHERE_TEMPLATE}",
            "thumbprint": "${VSPHERE_TLS_THUMBPRINT}"
          }
        }
      }
    },
    {
      "apiVersion": "controlplane.cluster.x-k8s.io/v1beta1",
      "kind": "KubeadmControlPlane",
      "metadata": {
        "name": "${CLUSTER_NAME}",
        "namespace": "${NAMESPACE}"
      },
      "spec": {
        "kubeadmConfigSpec": {
          "clusterConfiguration": {
            "apiServer": {
              "extraArgs": {
                "cloud-provider": "external"
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
              "content": "apiVersion: v1\nkind: Pod\nmetadata:\n  creationTimestamp: null\n  name: kube-vip\n  namespace: kube-system\nspec:\n  containers:\n  - args:\n    - manager\n    env:\n    - name: cp_enable\n      value: \"true\"\n    - name: vip_interface\n      value: \"\"\n    - name: address\n      value: ${CONTROL_PLANE_ENDPOINT_IP}\n    - name: port\n      value: \"6443\"\n    - name: vip_arp\n      value: \"true\"\n    - name: vip_leaderelection\n      value: \"true\"\n    - name: vip_leaseduration\n      value: \"15\"\n    - name: vip_renewdeadline\n      value: \"10\"\n    - name: vip_retryperiod\n      value: \"2\"\n    image: ghcr.io/kube-vip/kube-vip:v0.5.5\n    imagePullPolicy: IfNotPresent\n    name: kube-vip\n    resources: {}\n    securityContext:\n      capabilities:\n        add:\n        - NET_ADMIN\n        - NET_RAW\n    volumeMounts:\n    - mountPath: /etc/kubernetes/admin.conf\n      name: kubeconfig\n  hostAliases:\n  - hostnames:\n    - kubernetes\n    ip: 127.0.0.1\n  hostNetwork: true\n  volumes:\n  - hostPath:\n      path: /etc/kubernetes/admin.conf\n      type: FileOrCreate\n    name: kubeconfig\nstatus: {}\n",
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
            "echo \"{{ ds.meta_data.hostname }}\" >/etc/hostname",
            "echo 'root:dG1heEAyMw==' | chpasswd",
            "sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config",
            "systemctl restart sshd"
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
          "users": [
            {
              "name": "root",
              "sshAuthorizedKeys": [
                ""
              ]
            }
          ]
        },
        "machineTemplate": {
          "infrastructureRef": {
            "apiVersion": "infrastructure.cluster.x-k8s.io/v1beta1",
            "kind": "VSphereMachineTemplate",
            "name": "${CLUSTER_NAME}"
          }
        },
        "replicas": "${CONTROL_PLANE_MACHINE_COUNT}",
        "version": "${KUBERNETES_VERSION}"
      }
    },
    {
      "apiVersion": "bootstrap.cluster.x-k8s.io/v1beta1",
      "kind": "KubeadmConfigTemplate",
      "metadata": {
        "name": "${CLUSTER_NAME}-md-0",
        "namespace": "${NAMESPACE}"
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
              "echo \"{{ ds.meta_data.hostname }}\" >/etc/hostname",
              "echo 'root:dG1heEAyMw==' | chpasswd",
              "sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config",
              "systemctl restart sshd"
            ],
            "users": [
              {
                "name": "root",
                "sshAuthorizedKeys": [
                  ""
                ]
              }
            ]
          }
        }
      }
    },
    {
      "apiVersion": "cluster.x-k8s.io/v1beta1",
      "kind": "MachineDeployment",
      "metadata": {
        "labels": {
          "cluster.x-k8s.io/cluster-name": "${CLUSTER_NAME}"
        },
        "name": "${CLUSTER_NAME}-md-0",
        "namespace": "${NAMESPACE}"
      },
      "spec": {
        "clusterName": "${CLUSTER_NAME}",
        "replicas": "${WORKER_MACHINE_COUNT}",
        "selector": {
          "matchLabels": {}
        },
        "template": {
          "metadata": {
            "labels": {
              "cluster.x-k8s.io/cluster-name": "${CLUSTER_NAME}"
            }
          },
          "spec": {
            "bootstrap": {
              "configRef": {
                "apiVersion": "bootstrap.cluster.x-k8s.io/v1beta1",
                "kind": "KubeadmConfigTemplate",
                "name": "${CLUSTER_NAME}-md-0"
              }
            },
            "clusterName": "${CLUSTER_NAME}",
            "infrastructureRef": {
              "apiVersion": "infrastructure.cluster.x-k8s.io/v1beta1",
              "kind": "VSphereMachineTemplate",
              "name": "${CLUSTER_NAME}-worker"
            },
            "version": "${KUBERNETES_VERSION}"
          }
        }
      }
    },
    {
      "apiVersion": "addons.cluster.x-k8s.io/v1beta1",
      "kind": "ClusterResourceSet",
      "metadata": {
        "labels": {
          "cluster.x-k8s.io/cluster-name": "${CLUSTER_NAME}"
        },
        "name": "${CLUSTER_NAME}-crs-0",
        "namespace": "${NAMESPACE}"
      },
      "spec": {
        "clusterSelector": {
          "matchLabels": {
            "cluster.x-k8s.io/cluster-name": "${CLUSTER_NAME}"
          }
        },
        "resources": [
          {
            "kind": "Secret",
            "name": "${CLUSTER_NAME}-vsphere-csi-controller"
          },
          {
            "kind": "ConfigMap",
            "name": "${CLUSTER_NAME}-vsphere-csi-controller-role"
          },
          {
            "kind": "ConfigMap",
            "name": "${CLUSTER_NAME}-vsphere-csi-controller-binding"
          },
          {
            "kind": "Secret",
            "name": "${CLUSTER_NAME}-csi-vsphere-config"
          },
          {
            "kind": "ConfigMap",
            "name": "${CLUSTER_NAME}-csi.vsphere.vmware.com"
          },
          {
            "kind": "ConfigMap",
            "name": "${CLUSTER_NAME}-vsphere-csi-node"
          },
          {
            "kind": "ConfigMap",
            "name": "${CLUSTER_NAME}-vsphere-csi-controller"
          },
          {
            "kind": "Secret",
            "name": "${CLUSTER_NAME}-cloud-controller-manager"
          },
          {
            "kind": "Secret",
            "name": "${CLUSTER_NAME}-cloud-provider-vsphere-credentials"
          },
          {
            "kind": "ConfigMap",
            "name": "${CLUSTER_NAME}-cpi-manifests"
          }
        ]
      }
    },
    {
      "apiVersion": "v1",
      "kind": "Secret",
      "metadata": {
        "name": "${CLUSTER_NAME}",
        "namespace": "${NAMESPACE}"
      },
      "stringData": {
        "password": "${VSPHERE_PASSWORD}",
        "username": "${VSPHERE_USERNAME}"
      }
    },
    {
      "apiVersion": "v1",
      "kind": "Secret",
      "metadata": {
        "name": "${CLUSTER_NAME}-vsphere-csi-controller",
        "namespace": "${NAMESPACE}"
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
        "name": "${CLUSTER_NAME}-vsphere-csi-controller-role",
        "namespace": "${NAMESPACE}"
      }
    },
    {
      "apiVersion": "v1",
      "data": {
        "data": "apiVersion: rbac.authorization.k8s.io/v1\nkind: ClusterRoleBinding\nmetadata:\n  name: vsphere-csi-controller-binding\nroleRef:\n  apiGroup: rbac.authorization.k8s.io\n  kind: ClusterRole\n  name: vsphere-csi-controller-role\nsubjects:\n- kind: ServiceAccount\n  name: vsphere-csi-controller\n  namespace: kube-system\n"
      },
      "kind": "ConfigMap",
      "metadata": {
        "name": "${CLUSTER_NAME}-vsphere-csi-controller-binding",
        "namespace": "${NAMESPACE}"
      }
    },
    {
      "apiVersion": "v1",
      "kind": "Secret",
      "metadata": {
        "name": "${CLUSTER_NAME}-csi-vsphere-config",
        "namespace": "${NAMESPACE}"
      },
      "stringData": {
        "data": "apiVersion: v1\nkind: Secret\nmetadata:\n  name: csi-vsphere-config\n  namespace: kube-system\nstringData:\n  csi-vsphere.conf: |+\n    [Global]\n    cluster-id = \"${NAMESPACE}/${CLUSTER_NAME}\"\n    insecure-flag = \"1\"\n    \n    [VirtualCenter \"${VSPHERE_SERVER}\"]\n    user = \"${VSPHERE_USERNAME}\"\n    password = \"${VSPHERE_PASSWORD}\"\n    datacenters = \"${VSPHERE_DATACENTER}\"\n\n    [Network]\n    public-network = \"${VSPHERE_NETWORK}\"\n\ntype: Opaque\n"
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
        "name": "${CLUSTER_NAME}-csi.vsphere.vmware.com",
        "namespace": "${NAMESPACE}"
      }
    },
    {
      "apiVersion": "v1",
      "data": {
        "data": "apiVersion: apps/v1\nkind: DaemonSet\nmetadata:\n  name: vsphere-csi-node\n  namespace: kube-system\nspec:\n  selector:\n    matchLabels:\n      app: vsphere-csi-node\n  template:\n    metadata:\n      labels:\n        app: vsphere-csi-node\n        role: vsphere-csi\n    spec:\n      containers:\n      - args:\n        - --v=5\n        - --csi-address=$(ADDRESS)\n        - --kubelet-registration-path=$(DRIVER_REG_SOCK_PATH)\n        env:\n        - name: ADDRESS\n          value: /csi/csi.sock\n        - name: DRIVER_REG_SOCK_PATH\n          value: /var/lib/kubelet/plugins/csi.vsphere.vmware.com/csi.sock\n        image: quay.io/k8scsi/csi-node-driver-registrar:v2.0.1\n        lifecycle:\n          preStop:\n            exec:\n              command:\n              - /bin/sh\n              - -c\n              - rm -rf /registration/csi.vsphere.vmware.com-reg.sock /csi/csi.sock\n        name: node-driver-registrar\n        resources: {}\n        securityContext:\n          privileged: true\n        volumeMounts:\n        - mountPath: /csi\n          name: plugin-dir\n        - mountPath: /registration\n          name: registration-dir\n      - env:\n        - name: CSI_ENDPOINT\n          value: unix:///csi/csi.sock\n        - name: X_CSI_MODE\n          value: node\n        - name: X_CSI_SPEC_REQ_VALIDATION\n          value: \"false\"\n        - name: VSPHERE_CSI_CONFIG\n          value: /etc/cloud/csi-vsphere.conf\n        - name: LOGGER_LEVEL\n          value: PRODUCTION\n        - name: X_CSI_LOG_LEVEL\n          value: INFO\n        - name: NODE_NAME\n          valueFrom:\n            fieldRef:\n              fieldPath: spec.nodeName\n        image: gcr.io/cloud-provider-vsphere/csi/release/driver:v2.1.0\n        livenessProbe:\n          failureThreshold: 3\n          httpGet:\n            path: /healthz\n            port: healthz\n          initialDelaySeconds: 10\n          periodSeconds: 5\n          timeoutSeconds: 3\n        name: vsphere-csi-node\n        ports:\n        - containerPort: 9808\n          name: healthz\n          protocol: TCP\n        resources: {}\n        securityContext:\n          allowPrivilegeEscalation: true\n          capabilities:\n            add:\n            - SYS_ADMIN\n          privileged: true\n        volumeMounts:\n        - mountPath: /etc/cloud\n          name: vsphere-config-volume\n        - mountPath: /csi\n          name: plugin-dir\n        - mountPath: /var/lib/kubelet\n          mountPropagation: Bidirectional\n          name: pods-mount-dir\n        - mountPath: /dev\n          name: device-dir\n      - args:\n        - --csi-address=/csi/csi.sock\n        image: quay.io/k8scsi/livenessprobe:v2.1.0\n        name: liveness-probe\n        resources: {}\n        volumeMounts:\n        - mountPath: /csi\n          name: plugin-dir\n      dnsPolicy: Default\n      tolerations:\n      - effect: NoSchedule\n        operator: Exists\n      - effect: NoExecute\n        operator: Exists\n      volumes:\n      - name: vsphere-config-volume\n        secret:\n          secretName: csi-vsphere-config\n      - hostPath:\n          path: /var/lib/kubelet/plugins_registry\n          type: Directory\n        name: registration-dir\n      - hostPath:\n          path: /var/lib/kubelet/plugins/csi.vsphere.vmware.com/\n          type: DirectoryOrCreate\n        name: plugin-dir\n      - hostPath:\n          path: /var/lib/kubelet\n          type: Directory\n        name: pods-mount-dir\n      - hostPath:\n          path: /dev\n        name: device-dir\n  updateStrategy:\n    type: RollingUpdate\n"
      },
      "kind": "ConfigMap",
      "metadata": {
        "name": "${CLUSTER_NAME}-vsphere-csi-node",
        "namespace": "${NAMESPACE}"
      }
    },
    {
      "apiVersion": "v1",
      "data": {
        "data": "apiVersion: apps/v1\nkind: Deployment\nmetadata:\n  name: vsphere-csi-controller\n  namespace: kube-system\nspec:\n  replicas: 1\n  selector:\n    matchLabels:\n      app: vsphere-csi-controller\n  template:\n    metadata:\n      labels:\n        app: vsphere-csi-controller\n        role: vsphere-csi\n    spec:\n      containers:\n      - args:\n        - --v=4\n        - --timeout=300s\n        - --csi-address=$(ADDRESS)\n        - --leader-election\n        env:\n        - name: ADDRESS\n          value: /csi/csi.sock\n        image: quay.io/k8scsi/csi-attacher:v3.0.0\n        name: csi-attacher\n        resources: {}\n        volumeMounts:\n        - mountPath: /csi\n          name: socket-dir\n      - env:\n        - name: CSI_ENDPOINT\n          value: unix:///var/lib/csi/sockets/pluginproxy/csi.sock\n        - name: X_CSI_MODE\n          value: controller\n        - name: VSPHERE_CSI_CONFIG\n          value: /etc/cloud/csi-vsphere.conf\n        - name: LOGGER_LEVEL\n          value: PRODUCTION\n        - name: X_CSI_LOG_LEVEL\n          value: INFO\n        image: gcr.io/cloud-provider-vsphere/csi/release/driver:v2.1.0\n        livenessProbe:\n          failureThreshold: 3\n          httpGet:\n            path: /healthz\n            port: healthz\n          initialDelaySeconds: 10\n          periodSeconds: 5\n          timeoutSeconds: 3\n        name: vsphere-csi-controller\n        ports:\n        - containerPort: 9808\n          name: healthz\n          protocol: TCP\n        resources: {}\n        volumeMounts:\n        - mountPath: /etc/cloud\n          name: vsphere-config-volume\n          readOnly: true\n        - mountPath: /var/lib/csi/sockets/pluginproxy/\n          name: socket-dir\n      - args:\n        - --csi-address=$(ADDRESS)\n        env:\n        - name: ADDRESS\n          value: /var/lib/csi/sockets/pluginproxy/csi.sock\n        image: quay.io/k8scsi/livenessprobe:v2.1.0\n        name: liveness-probe\n        resources: {}\n        volumeMounts:\n        - mountPath: /var/lib/csi/sockets/pluginproxy/\n          name: socket-dir\n      - args:\n        - --leader-election\n        env:\n        - name: X_CSI_FULL_SYNC_INTERVAL_MINUTES\n          value: \"30\"\n        - name: LOGGER_LEVEL\n          value: PRODUCTION\n        - name: VSPHERE_CSI_CONFIG\n          value: /etc/cloud/csi-vsphere.conf\n        image: gcr.io/cloud-provider-vsphere/csi/release/syncer:v2.1.0\n        name: vsphere-syncer\n        resources: {}\n        volumeMounts:\n        - mountPath: /etc/cloud\n          name: vsphere-config-volume\n          readOnly: true\n      - args:\n        - --v=4\n        - --timeout=300s\n        - --csi-address=$(ADDRESS)\n        - --leader-election\n        - --default-fstype=ext4\n        env:\n        - name: ADDRESS\n          value: /csi/csi.sock\n        image: quay.io/k8scsi/csi-provisioner:v2.0.0\n        name: csi-provisioner\n        resources: {}\n        volumeMounts:\n        - mountPath: /csi\n          name: socket-dir\n      dnsPolicy: Default\n      serviceAccountName: vsphere-csi-controller\n      tolerations:\n      - effect: NoSchedule\n        key: node-role.kubernetes.io/master\n        operator: Exists\n      volumes:\n      - name: vsphere-config-volume\n        secret:\n          secretName: csi-vsphere-config\n      - emptyDir: {}\n        name: socket-dir\n"
      },
      "kind": "ConfigMap",
      "metadata": {
        "name": "${CLUSTER_NAME}-vsphere-csi-controller",
        "namespace": "${NAMESPACE}"
      }
    },
    {
      "apiVersion": "v1",
      "kind": "Secret",
      "metadata": {
        "name": "${CLUSTER_NAME}-cloud-controller-manager",
        "namespace": "${NAMESPACE}"
      },
      "stringData": {
        "data": "apiVersion: v1\nkind: ServiceAccount\nmetadata:\n  name: cloud-controller-manager\n  namespace: kube-system\n"
      },
      "type": "addons.cluster.x-k8s.io/resource-set"
    },
    {
      "apiVersion": "v1",
      "kind": "Secret",
      "metadata": {
        "name": "${CLUSTER_NAME}-cloud-provider-vsphere-credentials",
        "namespace": "${NAMESPACE}"
      },
      "stringData": {
        "data": "apiVersion: v1\nkind: Secret\nmetadata:\n  name: cloud-provider-vsphere-credentials\n  namespace: kube-system\nstringData:\n  ${VSPHERE_SERVER}.password: ${VSPHERE_PASSWORD}\n  ${VSPHERE_SERVER}.username: ${VSPHERE_USERNAME}\ntype: Opaque\n"
      },
      "type": "addons.cluster.x-k8s.io/resource-set"
    },
    {
      "apiVersion": "v1",
      "data": {
        "data": "---\napiVersion: rbac.authorization.k8s.io/v1\nkind: ClusterRole\nmetadata:\n  name: system:cloud-controller-manager\nrules:\n- apiGroups:\n  - \"\"\n  resources:\n  - events\n  verbs:\n  - create\n  - patch\n  - update\n- apiGroups:\n  - \"\"\n  resources:\n  - nodes\n  verbs:\n  - '*'\n- apiGroups:\n  - \"\"\n  resources:\n  - nodes/status\n  verbs:\n  - patch\n- apiGroups:\n  - \"\"\n  resources:\n  - services\n  verbs:\n  - list\n  - patch\n  - update\n  - watch\n- apiGroups:\n  - \"\"\n  resources:\n  - serviceaccounts\n  verbs:\n  - create\n  - get\n  - list\n  - watch\n  - update\n- apiGroups:\n  - \"\"\n  resources:\n  - persistentvolumes\n  verbs:\n  - get\n  - list\n  - watch\n  - update\n- apiGroups:\n  - \"\"\n  resources:\n  - endpoints\n  verbs:\n  - create\n  - get\n  - list\n  - watch\n  - update\n- apiGroups:\n  - \"\"\n  resources:\n  - secrets\n  verbs:\n  - get\n  - list\n  - watch\n- apiGroups:\n  - coordination.k8s.io\n  resources:\n  - leases\n  verbs:\n  - get\n  - watch\n  - list\n  - delete\n  - update\n  - create\n---\napiVersion: rbac.authorization.k8s.io/v1\nkind: ClusterRoleBinding\nmetadata:\n  name: system:cloud-controller-manager\nroleRef:\n  apiGroup: rbac.authorization.k8s.io\n  kind: ClusterRole\n  name: system:cloud-controller-manager\nsubjects:\n- kind: ServiceAccount\n  name: cloud-controller-manager\n  namespace: kube-system\n- kind: User\n  name: cloud-controller-manager\n---\napiVersion: v1\ndata:\n  vsphere.conf: |\n    global:\n      secretName: cloud-provider-vsphere-credentials\n      secretNamespace: kube-system\n      thumbprint: '${VSPHERE_TLS_THUMBPRINT}'\n    vcenter:\n      ${VSPHERE_SERVER}:\n        datacenters:\n        - '${VSPHERE_DATACENTER}'\n        secretName: cloud-provider-vsphere-credentials\n        secretNamespace: kube-system\n        server: '${VSPHERE_SERVER}'\n        thumbprint: '${VSPHERE_TLS_THUMBPRINT}'\nkind: ConfigMap\nmetadata:\n  name: vsphere-cloud-config\n  namespace: kube-system\n---\napiVersion: rbac.authorization.k8s.io/v1\nkind: RoleBinding\nmetadata:\n  name: servicecatalog.k8s.io:apiserver-authentication-reader\n  namespace: kube-system\nroleRef:\n  apiGroup: rbac.authorization.k8s.io\n  kind: Role\n  name: extension-apiserver-authentication-reader\nsubjects:\n- kind: ServiceAccount\n  name: cloud-controller-manager\n  namespace: kube-system\n- kind: User\n  name: cloud-controller-manager\n---\napiVersion: v1\nkind: Service\nmetadata:\n  labels:\n    component: cloud-controller-manager\n  name: cloud-controller-manager\n  namespace: kube-system\nspec:\n  ports:\n  - port: 443\n    protocol: TCP\n    targetPort: 43001\n  selector:\n    component: cloud-controller-manager\n  type: NodePort\n---\napiVersion: apps/v1\nkind: DaemonSet\nmetadata:\n  labels:\n    k8s-app: vsphere-cloud-controller-manager\n  name: vsphere-cloud-controller-manager\n  namespace: kube-system\nspec:\n  selector:\n    matchLabels:\n      k8s-app: vsphere-cloud-controller-manager\n  template:\n    metadata:\n      labels:\n        k8s-app: vsphere-cloud-controller-manager\n    spec:\n      containers:\n      - args:\n        - --v=2\n        - --cloud-provider=vsphere\n        - --cloud-config=/etc/cloud/vsphere.conf\n        image: gcr.io/cloud-provider-vsphere/cpi/release/manager:v1.18.1\n        name: vsphere-cloud-controller-manager\n        resources:\n          requests:\n            cpu: 200m\n        volumeMounts:\n        - mountPath: /etc/cloud\n          name: vsphere-config-volume\n          readOnly: true\n      hostNetwork: true\n      serviceAccountName: cloud-controller-manager\n      tolerations:\n      - effect: NoSchedule\n        key: node.cloudprovider.kubernetes.io/uninitialized\n        value: \"true\"\n      - effect: NoSchedule\n        key: node-role.kubernetes.io/master\n      - effect: NoSchedule\n        key: node.kubernetes.io/not-ready\n      volumes:\n      - configMap:\n          name: vsphere-cloud-config\n        name: vsphere-config-volume\n  updateStrategy:\n    type: RollingUpdate\n"
      },
      "kind": "ConfigMap",
      "metadata": {
        "name": "${CLUSTER_NAME}-cpi-manifests",
        "namespace": "${NAMESPACE}"
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
      "description": "Cluster Name",
      "displayName": "Cluster Name",
      "name": "CLUSTER_NAME",
      "required": false,
      "value": "clustername",
      "valueType": "string"
    },
    {
      "description": "Internal IP Cidr Block for Pods",
      "displayName": "Cidr Block",
      "name": "POD_CIDR",
      "required": false,
      "value": "0.0.0.0/0",
      "valueType": "string"
    },
    {
      "description": "vCenter Server IP",
      "displayName": "VCSA IP",
      "name": "VSPHERE_SERVER",
      "required": false,
      "value": "0.0.0.0",
      "valueType": "string"
    },
    {
      "description": "vCenter User Name",
      "displayName": "User Name",
      "name": "VSPHERE_USERNAME",
      "required": false,
      "value": "example@domain.local",
      "valueType": "string"
    },
    {
      "description": "vCenter User Password",
      "displayName": "User Password",
      "name": "VSPHERE_PASSWORD",
      "required": false,
      "value": "password",
      "valueType": "string"
    },
    {
      "description": "vCenter TLS Thumbprint",
      "displayName": "Thumbprint",
      "name": "VSPHERE_TLS_THUMBPRINT",
      "required": false,
      "value": "00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00",
      "valueType": "string"
    },
    {
      "description": "vCenter Network Name",
      "displayName": "Network Name",
      "name": "VSPHERE_NETWORK",
      "required": false,
      "value": "VM Network",
      "valueType": "string"
    },
    {
      "description": "vCenter DataCenter Name",
      "displayName": "DataCenter Name",
      "name": "VSPHERE_DATACENTER",
      "required": false,
      "value": "Datacenter",
      "valueType": "string"
    },
    {
      "description": "vCenter DataStore Name",
      "displayName": "DataStore Name",
      "name": "VSPHERE_DATASTORE",
      "required": false,
      "value": "datastore1",
      "valueType": "string"
    },
    {
      "description": "vCenter Folder Name",
      "displayName": "Folder Name",
      "name": "VSPHERE_FOLDER",
      "required": false,
      "value": "vm",
      "valueType": "string"
    },
    {
      "description": "vCenter Resource Pool Name",
      "displayName": "Resource Pool Name",
      "name": "VSPHERE_RESOURCE_POOL",
      "required": false,
      "value": "VM Resource",
      "valueType": "string"
    },
    {
      "description": "Master VM Disk Size",
      "displayName": "Master Disk Size",
      "name": "MASTER_DISK_SIZE",
      "required": false,
      "value": 25,
      "valueType": "number"
    },
    {
      "description": "Master VM Memory Size",
      "displayName": "Master Memory Size",
      "name": "MASTER_MEM_SIZE",
      "required": false,
      "value": 8192,
      "valueType": "number"
    },
    {
      "description": "Master Number of CPUs",
      "displayName": "Master Number of CPUs",
      "name": "MASTER_CPU_NUM",
      "required": false,
      "value": 2,
      "valueType": "number"
    },
    {
      "description": "Worker Number of CPUs",
      "displayName": "Worker Number of CPUs",
      "name": "WORKER_CPU_NUM",
      "required": false,
      "value": 2,
      "valueType": "number"
    },
    {
      "description": "Worker VM Disk Size",
      "displayName": "Worker Disk Size",
      "name": "WORKER_DISK_SIZE",
      "required": false,
      "value": 25,
      "valueType": "number"
    },
    {
      "description": "Worker VM Memory Size",
      "displayName": "Worker Memory Size",
      "name": "WORKER_MEM_SIZE",
      "required": false,
      "value": 8192,
      "valueType": "number"
    },
    {
      "description": "Target Template Name",
      "displayName": "Template Name",
      "name": "VSPHERE_TEMPLATE",
      "required": false,
      "value": "ubuntu-1804-kube-v1.17.3",
      "valueType": "string"
    },
    {
      "description": "Control Plane Endpoint IP",
      "displayName": "Control Plane Endpoint IP",
      "name": "CONTROL_PLANE_ENDPOINT_IP",
      "required": false,
      "value": "0.0.0.0",
      "valueType": "string"
    },
    {
      "description": "Kubernetes version",
      "displayName": "Kubernetes version",
      "name": "KUBERNETES_VERSION",
      "required": false,
      "value": "v1.18.16",
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
      "description": "Number of Worker node",
      "displayName": "number of worker nodes",
      "name": "WORKER_MACHINE_COUNT",
      "required": false,
      "value": 2,
      "valueType": "number"
    }
  ],
  "recommend": true,
  "shortDescription": "Cluster template for CAPI provider vSphere",
  "urlDescription": ""
}