function(
    natOutgoing=true,
    blockSize=24,
    cidr="10.0.10.0/24",
    asNumber=64512, 
    veth_mtu="1500",
    iptablesBackend="Auto",
    calico_backend="bird",
    ipipMode="Always",
    vxlanMode="Never",
    vxlanVNI=4096,
    vxlanPort=4789,
    datastore="kubernetes",
    is_offline="false",
    private_registry="172.22.6.2:5000",
    calico_version="v3.17.6",
    cni_image_repo="calico/cni",
    pod2daemon_image_repo="calico/pod2daemon-flexvol",
    node_image_repo="calico/node",
    controllers_image_repo="calico/kube-controllers",
    log_level="info",
    logSeverityFile="info",
    logSeverityScreen="info",
    logSeveritySys="info"
)
  local target_registry = if is_offline == "false" then "" else private_registry + "/";
[
  {
    "kind": "ConfigMap",
    "apiVersion": "v1",
    "metadata": {
      "name": "calico-config",
      "namespace": "kube-system"
    },
    "data": {
      "typha_service_name": "none",
      "calico_backend": calico_backend,
      "veth_mtu": veth_mtu,
      "cni_network_config": std.join("\n",
        [
          "{",
          "  \"name\": \"k8s-pod-network\",",
          "  \"cniVersion\": \"0.3.1\",",
          "  \"plugins\": [",
          "    {",
          "      \"type\": \"calico\",",
          "      \"log_level\": \"", log_level, "\",",
          "      \"log_file_path\": \"/var/log/calico/cni/cni.log\",",
          "      \"datastore_type\": \"kubernetes\",",
          "      \"nodename\": \"__KUBERNETES_NODE_NAME__\",",
          "      \"mtu\": __CNI_MTU__,",
          "      \"ipam\": {",
          "        \"type\": \"calico-ipam\"",
          "      },",
          "      \"policy\": {",
          "        \"type\": \"k8s\"",
          "      },",
          "      \"kubernetes\": {",
          "        \"kubeconfig\": \"__KUBECONFIG_FILEPATH__\"",
          "      }",
          "    },",
          "    {",
          "      \"type\": \"portmap\",",
          "      \"snat\": true,",
          "      \"capabilities\": {\"portMappings\": true}",
          "    },",
          "    {",
          "      \"type\": \"bandwidth\",",
          "      \"capabilities\": {\"bandwidth\": true}",
          "    }",
          "  ]",
          "}"
        ]
      ),
    }
  },
  {
    "kind": "DaemonSet",
    "apiVersion": "apps/v1",
    "metadata": {
      "name": "calico-node",
      "namespace": "kube-system",
      "labels": {
        "k8s-app": "calico-node"
      }
    },
    "spec": {
      "selector": {
        "matchLabels": {
          "k8s-app": "calico-node"
        }
      },
      "updateStrategy": {
        "type": "RollingUpdate",
        "rollingUpdate": {
          "maxUnavailable": 1
        }
      },
      "template": {
        "metadata": {
          "labels": {
            "k8s-app": "calico-node"
          }
        },
        "spec": {
          "nodeSelector": {
            "kubernetes.io/os": "linux"
          },
          "hostNetwork": true,
          "tolerations": [
            {
              "effect": "NoSchedule",
              "operator": "Exists"
            },
            {
              "key": "CriticalAddonsOnly",
              "operator": "Exists"
            },
            {
              "effect": "NoExecute",
              "operator": "Exists"
            }
          ],
          "serviceAccountName": "calico-node",
          "terminationGracePeriodSeconds": 0,
          "priorityClassName": "system-node-critical",
          "initContainers": [
            {
              "name": "upgrade-ipam",
              "image": std.join("",
                [
                  target_registry,
                  cni_image_repo,
                  ":",
                  calico_version
                ]
              ),
              "command": [
                "/opt/cni/bin/calico-ipam",
                "-upgrade"
              ],
              "envFrom": [
                {
                  "configMapRef": {
                    "name": "kubernetes-services-endpoint",
                    "optional": true
                  }
                }
              ],
              "env": [
                {
                  "name": "KUBERNETES_NODE_NAME",
                  "valueFrom": {
                    "fieldRef": {
                      "fieldPath": "spec.nodeName"
                    }
                  }
                },
                {
                  "name": "CALICO_NETWORKING_BACKEND",
                  "valueFrom": {
                    "configMapKeyRef": {
                      "name": "calico-config",
                      "key": "calico_backend"
                    }
                  }
                }
              ],
              "volumeMounts": [
                {
                  "mountPath": "/var/lib/cni/networks",
                  "name": "host-local-net-dir"
                },
                {
                  "mountPath": "/host/opt/cni/bin",
                  "name": "cni-bin-dir"
                }
              ],
              "securityContext": {
                "privileged": true
              }
            },
            {
              "name": "install-cni",
              "image": std.join("",
                [
                  target_registry,
                  cni_image_repo,
                  ":",
                  calico_version
                ]
              ),
              "command": [
                "/opt/cni/bin/install"
              ],
              "envFrom": [
                {
                  "configMapRef": {
                    "name": "kubernetes-services-endpoint",
                    "optional": true
                  }
                }
              ],
              "env": [
                {
                  "name": "CNI_CONF_NAME",
                  "value": "10-calico.conflist"
                },
                {
                  "name": "CNI_NETWORK_CONFIG",
                  "valueFrom": {
                    "configMapKeyRef": {
                      "name": "calico-config",
                      "key": "cni_network_config"
                    }
                  }
                },
                {
                  "name": "KUBERNETES_NODE_NAME",
                  "valueFrom": {
                    "fieldRef": {
                      "fieldPath": "spec.nodeName"
                    }
                  }
                },
                {
                  "name": "CNI_MTU",
                  "valueFrom": {
                    "configMapKeyRef": {
                      "name": "calico-config",
                      "key": "veth_mtu"
                    }
                  }
                },
                {
                  "name": "SLEEP",
                  "value": "false"
                }
              ],
              "volumeMounts": [
                {
                  "mountPath": "/host/opt/cni/bin",
                  "name": "cni-bin-dir"
                },
                {
                  "mountPath": "/host/etc/cni/net.d",
                  "name": "cni-net-dir"
                }
              ],
              "securityContext": {
                "privileged": true
              }
            },
            {
              "name": "flexvol-driver",
              "image": std.join("",
                [
                  target_registry,
                  pod2daemon_image_repo,
                  ":",
                  calico_version
                ]
              ),
              "volumeMounts": [
                {
                  "name": "flexvol-driver-host",
                  "mountPath": "/host/driver"
                }
              ],
              "securityContext": {
                "privileged": true
              }
            }
          ],
          "containers": [
            {
              "name": "calico-node",
              "image": std.join("",
                [
                  target_registry,
                  node_image_repo,
                  ":",
                  calico_version
                ]
              ),
              "envFrom": [
                {
                  "configMapRef": {
                    "name": "kubernetes-services-endpoint",
                    "optional": true
                  }
                }
              ],
              "env": [
                {
                  "name": "DATASTORE_TYPE",
                  "value": datastore
                },
                {
                  "name": "WAIT_FOR_DATASTORE",
                  "value": "true"
                },
                {
                  "name": "NODENAME",
                  "valueFrom": {
                    "fieldRef": {
                      "fieldPath": "spec.nodeName"
                    }
                  }
                },
                {
                  "name": "CALICO_NETWORKING_BACKEND",
                  "valueFrom": {
                    "configMapKeyRef": {
                      "name": "calico-config",
                      "key": "calico_backend"
                    }
                  }
                },
                {
                  "name": "CLUSTER_TYPE",
                  "value": "k8s,bgp"
                },
                {
                  "name": "IP",
                  "value": "autodetect"
                },
                {
                  "name": "CALICO_IPV4POOL_IPIP",
                  "value": ipipMode
                },
                {
                  "name": "CALICO_IPV4POOL_VXLAN",
                  "value": vxlanMode
                },
                {
                  "name": "FELIX_IPINIPMTU",
                  "valueFrom": {
                    "configMapKeyRef": {
                      "name": "calico-config",
                      "key": "veth_mtu"
                    }
                  }
                },
                {
                  "name": "FELIX_VXLANMTU",
                  "valueFrom": {
                    "configMapKeyRef": {
                      "name": "calico-config",
                      "key": "veth_mtu"
                    }
                  }
                },
                {
                  "name": "FELIX_WIREGUARDMTU",
                  "valueFrom": {
                    "configMapKeyRef": {
                      "name": "calico-config",
                      "key": "veth_mtu"
                    }
                  }
                },
                {
                  "name": "CALICO_IPV4POOL_CIDR",
                  "value": cidr
                },
                {
                  "name": "CALICO_DISABLE_FILE_LOGGING",
                  "value": "true"
                },
                {
                  "name": "FELIX_DEFAULTENDPOINTTOHOSTACTION",
                  "value": "ACCEPT"
                },
                {
                  "name": "FELIX_IPV6SUPPORT",
                  "value": "false"
                },
                {
                  "name": "FELIX_LOGSEVERITYSCREEN",
                  "value": log_level
                },
                {
                  "name": "FELIX_HEALTHENABLED",
                  "value": "true"
                },
                {
                  "name": "FELIX_IPTABLESBACKEND",
                  "value": iptablesBackend
                },
              ],
              "securityContext": {
                "privileged": true
              },
              "resources": {
                "requests": {
                  "cpu": "250m"
                }
              },
              "livenessProbe": {
                "exec": {
                  "command": [
                    "/bin/calico-node",
                    "-felix-live",
                    "-bird-live"
                  ]
                },
                "periodSeconds": 10,
                "initialDelaySeconds": 10,
                "failureThreshold": 6
              },
              "readinessProbe": {
                "exec": {
                  "command": [
                    "/bin/calico-node",
                    "-felix-ready",
                    "-bird-ready"
                  ]
                },
                "periodSeconds": 10
              },
              "volumeMounts": [
                {
                  "mountPath": "/lib/modules",
                  "name": "lib-modules",
                  "readOnly": true
                },
                {
                  "mountPath": "/run/xtables.lock",
                  "name": "xtables-lock",
                  "readOnly": false
                },
                {
                  "mountPath": "/var/run/calico",
                  "name": "var-run-calico",
                  "readOnly": false
                },
                {
                  "mountPath": "/var/lib/calico",
                  "name": "var-lib-calico",
                  "readOnly": false
                },
                {
                  "name": "policysync",
                  "mountPath": "/var/run/nodeagent"
                },
                {
                  "name": "sysfs",
                  "mountPath": "/sys/fs/",
                  "mountPropagation": "Bidirectional"
                },
                {
                  "name": "cni-log-dir",
                  "mountPath": "/var/log/calico/cni",
                  "readOnly": true
                }
              ]
            }
          ],
          "volumes": [
            {
              "name": "lib-modules",
              "hostPath": {
                "path": "/lib/modules"
              }
            },
            {
              "name": "var-run-calico",
              "hostPath": {
                "path": "/var/run/calico"
              }
            },
            {
              "name": "var-lib-calico",
              "hostPath": {
                "path": "/var/lib/calico"
              }
            },
            {
              "name": "xtables-lock",
              "hostPath": {
                "path": "/run/xtables.lock",
                "type": "FileOrCreate"
              }
            },
            {
              "name": "sysfs",
              "hostPath": {
                "path": "/sys/fs/",
                "type": "DirectoryOrCreate"
              }
            },
            {
              "name": "cni-bin-dir",
              "hostPath": {
                "path": "/opt/cni/bin"
              }
            },
            {
              "name": "cni-net-dir",
              "hostPath": {
                "path": "/etc/cni/net.d"
              }
            },
            {
              "name": "cni-log-dir",
              "hostPath": {
                "path": "/var/log/calico/cni"
              }
            },
            {
              "name": "host-local-net-dir",
              "hostPath": {
                "path": "/var/lib/cni/networks"
              }
            },
            {
              "name": "policysync",
              "hostPath": {
                "type": "DirectoryOrCreate",
                "path": "/var/run/nodeagent"
              }
            },
            {
              "name": "flexvol-driver-host",
              "hostPath": {
                "type": "DirectoryOrCreate",
                "path": "/usr/libexec/kubernetes/kubelet-plugins/volume/exec/nodeagent~uds"
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
      "name": "calico-kube-controllers",
      "namespace": "kube-system",
      "labels": {
        "k8s-app": "calico-kube-controllers"
      }
    },
    "spec": {
      "replicas": 1,
      "selector": {
        "matchLabels": {
          "k8s-app": "calico-kube-controllers"
        }
      },
      "strategy": {
        "type": "Recreate"
      },
      "template": {
        "metadata": {
          "name": "calico-kube-controllers",
          "namespace": "kube-system",
          "labels": {
            "k8s-app": "calico-kube-controllers"
          }
        },
        "spec": {
          "nodeSelector": {
            "kubernetes.io/os": "linux"
          },
          "tolerations": [
            {
              "key": "CriticalAddonsOnly",
              "operator": "Exists"
            },
            {
              "key": "node-role.kubernetes.io/master",
              "effect": "NoSchedule"
            }
          ],
          "serviceAccountName": "calico-kube-controllers",
          "priorityClassName": "system-cluster-critical",
          "containers": [
            {
              "name": "calico-kube-controllers",
              "image": std.join("",
                [
                  target_registry,
                  controllers_image_repo,
                  ":",
                  calico_version
                ]
              ),
              "env": [
                {
                  "name": "ENABLED_CONTROLLERS",
                  "value": "node"
                },
                {
                  "name": "DATASTORE_TYPE",
                  "value": datastore
                }
              ],
              "readinessProbe": {
                "exec": {
                  "command": [
                    "/usr/bin/check-status",
                    "-r"
                  ]
                }
              }
            }
          ]
        }
      }
    }
  },
  {
    "apiVersion": "policy/v1beta1",
    "kind": "PodDisruptionBudget",
    "metadata": {
      "name": "calico-kube-controllers",
      "namespace": "kube-system",
      "labels": {
        "k8s-app": "calico-kube-controllers"
      }
    },
    "spec": {
      "maxUnavailable": 1,
      "selector": {
        "matchLabels": {
          "k8s-app": "calico-kube-controllers"
        }
      }
    }
  },
  {
    "apiVersion": "crd.projectcalico.org/v1",
    "kind": "IPPool",
    "metadata": {
      "name": "default"
    },
    "spec": {
      "blockSize": blockSize,
      "ipipMode": ipipMode,
      "natOutgoing": natOutgoing,
      "vxlanMode": vxlanMode,
      "cidr": cidr
    }
  },
  {
    "apiVersion": "crd.projectcalico.org/v1",
    "kind": "FelixConfiguration",
    "metadata": {
      "name": "default"
    },
    "spec": {
      "vxlanPort": vxlanPort,
      "vxlanVNI": vxlanVNI,
      "logSeverityFile":logSeverityFile,
      "logSeverityScreen": logSeverityScreen,
      "logSeveritySys":logSeveritySys
    }
  },
  {
    "apiVersion": "crd.projectcalico.org/v1",
    "kind": "BGPConfiguration",
    "metadata": {
      "name": "default"
    },
    "spec": {
      "asNumber": asNumber,
      "logSeverityScreen": logSeverityScreen
    }
  },
  {
    "apiVersion": "crd.projectcalico.org/v1",
    "kind": "KubeControllersConfiguration",
    "metadata": {
      "name": "default"
    },
    "spec": {
      "logSeverityScreen": logSeverityScreen
    }
  }
]