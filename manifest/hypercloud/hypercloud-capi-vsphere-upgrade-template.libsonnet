{
  "apiVersion": "tmax.io/v1",
  "categories": [
    "CAPI"
  ],
  "imageUrl": "https://blogs.vmware.com/vsphere/files/2021/02/VMware-vSphere-Blog-Images-vSphere.jpg",
  "kind": "ClusterTemplate",
  "metadata": {
    "name": "capi-vsphere-upgrade-template"
  },
  "objectKinds": [
    "VSphereMachineTemplate"
  ],
  "objects": [
    {
      "apiVersion": "infrastructure.cluster.x-k8s.io/v1beta1",
      "kind": "VSphereMachineTemplate",
      "metadata": {
        "name": "${UPGRADE_TEMPLATE_NAME}",
        "namespace": "${NAMESPACE}"
      },
      "spec": {
        "template": {
          "spec": {
            "cloneMode": "linkedClone",
            "datacenter": "${VSPHERE_DATACENTER}",
            "datastore": "${VSPHERE_DATASTORE}",
            "diskGiB": "${DISK_SIZE}",
            "folder": "${VSPHERE_FOLDER}",
            "memoryMiB": "${MEM_SIZE}",
            "network": {
              "devices": [
                {
                  "dhcp4": true,
                  "networkName": "${VSPHERE_NETWORK}"
                }
              ]
            },
            "numCPUs": "${CPU_NUM}",
            "os": "Linux",
            "resourcePool": "${VSPHERE_RESOURCE_POOL}",
            "server": "${VSPHERE_SERVER}",
            "storagePolicyName": "${VSPHERE_STORAGE_POLICY}",
            "template": "${VSPHERE_TEMPLATE}",
            "thumbprint": "${VSPHERE_TLS_THUMBPRINT}"
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
      "description": "upgrade template name",
      "displayName": "upgrade template name",
      "name": "UPGRADE_TEMPLATE_NAME",
      "required": false,
      "value": "upgrade_template_name",
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
      "description": "VM Disk Size",
      "displayName": "Disk Size",
      "name": "DISK_SIZE",
      "required": false,
      "value": 25,
      "valueType": "number"
    },
    {
      "description": "VM Memory Size",
      "displayName": "Memory Size",
      "name": "MEM_SIZE",
      "required": false,
      "value": 8192,
      "valueType": "number"
    },
    {
      "description": "Number of CPUs",
      "displayName": "Number of CPUs",
      "name": "CPU_NUM",
      "required": false,
      "value": 2,
      "valueType": "number"
    },
    {
      "description": "Target Template Name",
      "displayName": "Template Name",
      "name": "VSPHERE_TEMPLATE",
      "required": false,
      "value": "ubuntu-1804-kube-v1.19.6",
      "valueType": "string"
    },
    {
      "description": "Kubernetes version",
      "displayName": "Kubernetes version",
      "name": "KUBERNETES_VERSION",
      "required": false,
      "value": "v1.19.6",
      "valueType": "string"
    }
  ],
  "recommend": true,
  "shortDescription": "Cluster template for CAPI provider vSphere upgrade",
  "urlDescription": ""
}