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
      "apiVersion": "infrastructure.cluster.x-k8s.io/v1alpha3",
      "kind": "VSphereMachineTemplate",
      "metadata": {
        "name": "${ClusterName}-${KubernetesVersion}",
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
      "description": "Cluster Name",
      "displayName": "Cluster Name",
      "name": "ClusterName",
      "required": false,
      "value": "clustername",
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
      "value": "ubuntu-1804-kube-v1.19.6",
      "valueType": "string"
    },
    {
      "description": "Kubernetes version",
      "displayName": "Kubernetes version",
      "name": "KubernetesVersion",
      "required": false,
      "value": "v1.19.6",
      "valueType": "string"
    }
  ],
  "recommend": true,
  "shortDescription": "Cluster template for CAPI provider vSphere upgrade",
  "urlDescription": ""
}