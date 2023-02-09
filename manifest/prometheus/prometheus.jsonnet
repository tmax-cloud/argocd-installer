function (
  timezone="UTC",
  is_offline="false",
  private_registry="172.22.6.2:5000",
  coreos_image_repo="quay.io/coreos",
  prometheus_image_repo="quay.io/prometheus",
  prometheus_operator_image_repo="quay.io/prometheus-operator",
  kube_state_metrics_image_repo="k8s.gcr.io/kube-state-metrics",
  brancz_image_repo="quay.io/brancz",
  prometheus_adapter_image_repo="k8s.gcr.io/prometheus-adapter",
  configmap_reload_version="v0.0.1",
  configmap_reloader_version="v0.62.0",
  prometheus_operator_version="v0.62.0",
  alertmanager_version="v0.25.0",
  kube_rbac_proxy_version="v0.14.0",
  kube_state_metrics_version="v2.7.0",
  node_exporter_version="v1.5.0",
  prometheus_adapter_version="v0.10.0",
  prometheus_pvc="10Gi",
  prometheus_version="v2.41.0"
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";

[
  {
	  "apiVersion": "apps/v1",
	  "kind": "Deployment",
	  "metadata": {
		"labels": {
		  "app.kubernetes.io/component": "controller",
		  "app.kubernetes.io/name": "prometheus-operator",
		  "app.kubernetes.io/part-of": "kube-prometheus",
		  "app.kubernetes.io/version": "0.62.0"
		},
		"name": "prometheus-operator",
		"namespace": "monitoring"
	  },
	  "spec": {
		"replicas": 1,
		"selector": {
		  "matchLabels": {
			"app.kubernetes.io/component": "controller",
			"app.kubernetes.io/name": "prometheus-operator",
			"app.kubernetes.io/part-of": "kube-prometheus"
		  }
		},
		"template": {
		  "metadata": {
			"annotations": {
			  "kubectl.kubernetes.io/default-container": "prometheus-operator"
			},
			"labels": {
			  "app.kubernetes.io/component": "controller",
			  "app.kubernetes.io/name": "prometheus-operator",
			  "app.kubernetes.io/part-of": "kube-prometheus",
			  "app.kubernetes.io/version": "0.62.0"
			}
		  },
		  "spec": {
			"automountServiceAccountToken": true,
			"containers": [
			  {
				"args": [
				  "--kubelet-service=kube-system/kubelet",
				  std.join("",
					  [
						"--prometheus-config-reloader=",
						target_registry,
						prometheus_operator_image_repo,
						"/prometheus-config-reloader:",
						configmap_reloader_version
					  ]
					)
				],
				"image": std.join("",
					[
					  target_registry,
					  prometheus_operator_image_repo,
					  "/prometheus-operator:",
					  prometheus_operator_version
					]
				  ),
				"name": "prometheus-operator",
				"ports": [
				  {
					"containerPort": 8080,
					"name": "http"
				  }
				],
				"resources": {
				  "limits": {
					"cpu": "200m",
					"memory": "200Mi"
				  },
				  "requests": {
					"cpu": "100m",
					"memory": "100Mi"
				  }
				},
				"securityContext": {
				  "allowPrivilegeEscalation": false,
				  "capabilities": {
					"drop": [
					  "ALL"
					]
				  },
				  "readOnlyRootFilesystem": true
				}
			  },
			  {
				"args": [
				  "--logtostderr",
				  "--secure-listen-address=:8443",
				  "--tls-cipher-suites=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305",
				  "--upstream=http://127.0.0.1:8080/"
				],
				"image": std.join("",
					[
					  target_registry,
					  brancz_image_repo,
					  "/kube-rbac-proxy:",
					  kube_rbac_proxy_version
					]
				  ),
				"name": "kube-rbac-proxy",
				"ports": [
				  {
					"containerPort": 8443,
					"name": "https"
				  }
				],
				"resources": {
				  "limits": {
					"cpu": "20m",
					"memory": "40Mi"
				  },
				  "requests": {
					"cpu": "10m",
					"memory": "20Mi"
				  }
				},
				"securityContext": {
				  "allowPrivilegeEscalation": false,
				  "capabilities": {
					"drop": [
					  "ALL"
					]
				  },
				  "readOnlyRootFilesystem": true,
				  "runAsGroup": 65532,
				  "runAsNonRoot": true,
				  "runAsUser": 65532
				}
			  }
			],
			"nodeSelector": {
			  "kubernetes.io/os": "linux"
			},
			"securityContext": {
			  "runAsNonRoot": true,
			  "runAsUser": 65534
			},
			"serviceAccountName": "prometheus-operator"
		  }
		}
	  }
	},
  {
    "apiVersion": "monitoring.coreos.com/v1",
    "kind": "Alertmanager",
    "metadata": {
      "labels": {
        "app.kubernetes.io/instance": "main",
        "app.kubernetes.io/component": "alert-router",
        "app.kubernetes.io/name": "alertmanager",
        "app.kubernetes.io/part-of": "kube-prometheus",
        "app.kubernetes.io/version": "0.25.0"
      },
      "name": "main",
      "namespace": "monitoring"
    },
    "spec": {
      "image": std.join("",
        [
          target_registry,
          prometheus_image_repo,
          "/alertmanager:",
          alertmanager_version
        ]
      ),
      "nodeSelector": {
        "kubernetes.io/os": "linux"
      },
      "podMetadata": {
        "labels": {
          "app.kubernetes.io/component": "alert-router",
          "app.kubernetes.io/name": "alertmanager",
		  "app.kubernetes.io/instance": "main",
          "app.kubernetes.io/part-of": "kube-prometheus",
          "app.kubernetes.io/version": "0.23.0"
        }
      },
	  "volumeMounts": [
	    ] + (
               if timezone != "UTC" then [
                 {
                   "name": "timezone-config",
                   "mountPath": "/etc/localtime"
                 }
               ] else []
             ),
      "volumes": [
        ] + (
            if timezone != "UTC" then [
            {
              "name": "timezone-config",
              "hostPath": {
                "path": std.join("", ["/usr/share/zoneinfo/", timezone])
               }
            }
          ] else []
        ),
      "replicas": 1,
      "resources": {
        "limits": {
          "cpu": "100m",
          "memory": "100Mi"
        },
        "requests": {
          "cpu": "4m",
          "memory": "100Mi"
        }
      },
      "securityContext": {
        "fsGroup": 2000,
        "runAsNonRoot": true,
        "runAsUser": 1000
      },
      "serviceAccountName": "alertmanager-main",
      "version": "v0.23.0"
    }
  },
  {
	  "apiVersion": "apps/v1",
	  "kind": "Deployment",
	  "metadata": {
		"labels": {
		  "app.kubernetes.io/component": "exporter",
		  "app.kubernetes.io/name": "kube-state-metrics",
		  "app.kubernetes.io/part-of": "kube-prometheus",
		  "app.kubernetes.io/version": "2.7.0"
		},
		"name": "kube-state-metrics",
		"namespace": "monitoring"
	  },
	  "spec": {
		"replicas": 1,
		"selector": {
		  "matchLabels": {
			"app.kubernetes.io/component": "exporter",
			"app.kubernetes.io/name": "kube-state-metrics",
			"app.kubernetes.io/part-of": "kube-prometheus"
		  }
		},
		"template": {
		  "metadata": {
			"annotations": {
			  "kubectl.kubernetes.io/default-container": "kube-state-metrics"
			},
			"labels": {
			  "app.kubernetes.io/component": "exporter",
			  "app.kubernetes.io/name": "kube-state-metrics",
			  "app.kubernetes.io/part-of": "kube-prometheus",
			  "app.kubernetes.io/version": "2.7.0"
			}
		  },
		  "spec": {
			"automountServiceAccountToken": true,
			"containers": [
			  {
				"args": [
				  "--host=127.0.0.1",
				  "--port=8081",
				  "--telemetry-host=127.0.0.1",
				  "--telemetry-port=8082"
				],
				"image": std.join("",
					[
					  target_registry,
					  kube_state_metrics_image_repo,
					  "/kube-state-metrics:",
					  kube_state_metrics_version
					]
				),
				"name": "kube-state-metrics",
				"resources": {
				  "limits": {
					"cpu": "100m",
					"memory": "250Mi"
				  },
				  "requests": {
					"cpu": "10m",
					"memory": "190Mi"
				  }
				},
				"securityContext": {
				  "allowPrivilegeEscalation": false,
				  "capabilities": {
					"drop": [
					  "ALL"
					]
				  },
				  "readOnlyRootFilesystem": true,
				  "runAsUser": 65534
				}
			  },
			  {
				"args": [
				  "--logtostderr",
				  "--secure-listen-address=:8443",
				  "--tls-cipher-suites=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305",
				  "--upstream=http://127.0.0.1:8081/"
				],
				"image": std.join("",
					[
					  target_registry,
					  brancz_image_repo,
					  "/kube-rbac-proxy:",
					  kube_rbac_proxy_version
					]
				),
				"name": "kube-rbac-proxy-main",
				"ports": [
				  {
					"containerPort": 8443,
					"name": "https-main"
				  }
				],
				"resources": {
				  "limits": {
					"cpu": "40m",
					"memory": "40Mi"
				  },
				  "requests": {
					"cpu": "20m",
					"memory": "20Mi"
				  }
				},
				"securityContext": {
				  "allowPrivilegeEscalation": false,
				  "capabilities": {
					"drop": [
					  "ALL"
					]
				  },
				  "readOnlyRootFilesystem": true,
				  "runAsGroup": 65532,
				  "runAsNonRoot": true,
				  "runAsUser": 65532
				},
				"volumeMounts": [
					] + (
					  if timezone != "UTC" then [
						{
						  "name": "timezone-config",
						  "mountPath": "/etc/localtime"
						}
					  ] else []
					)
			  },
			  {
				"args": [
				  "--logtostderr",
				  "--secure-listen-address=:9443",
				  "--tls-cipher-suites=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305",
				  "--upstream=http://127.0.0.1:8082/"
				],
				"image": std.join("",
					[
					  target_registry,
					  brancz_image_repo,
					  "/kube-rbac-proxy:",
					  kube_rbac_proxy_version
					]
				),
				"name": "kube-rbac-proxy-self",
				"ports": [
				  {
					"containerPort": 9443,
					"name": "https-self"
				  }
				],
				"resources": {
				  "limits": {
					"cpu": "20m",
					"memory": "40Mi"
				  },
				  "requests": {
					"cpu": "10m",
					"memory": "20Mi"
				  }
				},
				"securityContext": {
				  "allowPrivilegeEscalation": false,
				  "capabilities": {
					"drop": [
					  "ALL"
					]
				  },
				  "readOnlyRootFilesystem": true,
				  "runAsGroup": 65532,
				  "runAsNonRoot": true,
				  "runAsUser": 65532
				}
			  }
			],
			"nodeSelector": {
			  "kubernetes.io/os": "linux"
			},
			"serviceAccountName": "kube-state-metrics",
			"volumes": (
				if timezone != "UTC" then [
				{
					"name": "timezone-config",
					"hostPath": {
					  "path": std.join("", ["/usr/share/zoneinfo/", timezone])
					 }
				  }
				] else []
			)
		  }
		}
	  }
  },
  {
	  "apiVersion": "apps/v1",
	  "kind": "DaemonSet",
	  "metadata": {
		"labels": {
		  "app.kubernetes.io/component": "exporter",
		  "app.kubernetes.io/name": "node-exporter",
		  "app.kubernetes.io/part-of": "kube-prometheus",
		  "app.kubernetes.io/version": "1.5.0"
		},
		"name": "node-exporter",
		"namespace": "monitoring"
	  },
	  "spec": {
		"selector": {
		  "matchLabels": {
			"app.kubernetes.io/component": "exporter",
			"app.kubernetes.io/name": "node-exporter",
			"app.kubernetes.io/part-of": "kube-prometheus"
		  }
		},
		"template": {
		  "metadata": {
			"annotations": {
			  "kubectl.kubernetes.io/default-container": "node-exporter"
			},
			"labels": {
			  "app.kubernetes.io/component": "exporter",
			  "app.kubernetes.io/name": "node-exporter",
			  "app.kubernetes.io/part-of": "kube-prometheus",
			  "app.kubernetes.io/version": "1.5.0"
			}
		  },
		  "spec": {
			"automountServiceAccountToken": true,
			"containers": [
			  {
				"args": [
				  "--web.listen-address=127.0.0.1:9100",
				  "--path.sysfs=/host/sys",
				  "--path.rootfs=/host/root",
				  "--path.udev.data=/host/root/run/udev/data",
				  "--no-collector.wifi",
				  "--no-collector.hwmon",
				  "--collector.filesystem.mount-points-exclude=^/(dev|proc|sys|run/k3s/containerd/.+|var/lib/docker/.+|var/lib/kubelet/pods/.+)($|/)",
				  "--collector.netclass.ignored-devices=^(veth.*|[a-f0-9]{15})$",
				  "--collector.netdev.device-exclude=^(veth.*|[a-f0-9]{15})$"
				],
				"image": std.join("",
					[
					  target_registry,
					  prometheus_image_repo,
					  "/node-exporter:",
					  node_exporter_version
					]
				),
				"name": "node-exporter",
				"resources": {
				  "limits": {
					"cpu": "250m",
					"memory": "180Mi"
				  },
				  "requests": {
					"cpu": "102m",
					"memory": "180Mi"
				  }
				},
				"securityContext": {
				  "allowPrivilegeEscalation": false,
				  "capabilities": {
					"add": [
					  "SYS_TIME"
					],
					"drop": [
					  "ALL"
					]
				  },
				  "readOnlyRootFilesystem": true
				},
				"volumeMounts": [
				  {
					"mountPath": "/host/sys",
					"mountPropagation": "HostToContainer",
					"name": "sys",
					"readOnly": true
				  },
				  {
					"mountPath": "/host/root",
					"mountPropagation": "HostToContainer",
					"name": "root",
					"readOnly": true
				  }
				] + (
					 if timezone != "UTC" then [
					   {
						 "name": "timezone-config",
						 "mountPath": "/etc/localtime"
					   }
					 ] else []
				   )
			  },
			  {
				"args": [
				  "--logtostderr",
				  "--secure-listen-address=[$(IP)]:9100",
				  "--tls-cipher-suites=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305",
				  "--upstream=http://127.0.0.1:9100/"
				],
				"env": [
				  {
					"name": "IP",
					"valueFrom": {
					  "fieldRef": {
						"fieldPath": "status.podIP"
					  }
					}
				  }
				],
				"image": std.join("",
					[
					  target_registry,
					  brancz_image_repo,
					  "/kube-rbac-proxy:",
					  kube_rbac_proxy_version
					]
				),
				"name": "kube-rbac-proxy",
				"ports": [
				  {
					"containerPort": 9100,
					"hostPort": 9100,
					"name": "https"
				  }
				],
				"resources": {
				  "limits": {
					"cpu": "20m",
					"memory": "40Mi"
				  },
				  "requests": {
					"cpu": "10m",
					"memory": "20Mi"
				  }
				},
				"securityContext": {
				  "allowPrivilegeEscalation": false,
				  "capabilities": {
					"drop": [
					  "ALL"
					]
				  },
				  "readOnlyRootFilesystem": true,
				  "runAsGroup": 65532,
				  "runAsNonRoot": true,
				  "runAsUser": 65532
				}
			  }
			],
			"hostNetwork": true,
			"hostPID": true,
			"nodeSelector": {
			  "kubernetes.io/os": "linux"
			},
			"priorityClassName": "system-cluster-critical",
			"securityContext": {
			  "runAsNonRoot": true,
			  "runAsUser": 65534
			},
			"serviceAccountName": "node-exporter",
			"tolerations": [
			  {
				"operator": "Exists"
			  }
			],
			"volumes": [
			  {
				"hostPath": {
				  "path": "/sys"
				},
				"name": "sys"
			  },
			  {
				"hostPath": {
				  "path": "/"
				},
				"name": "root"
			  }
			] + (
			if timezone != "UTC" then [
			{
				"name": "timezone-config",
				"hostPath": {
				  "path": std.join("", ["/usr/share/zoneinfo/", timezone])
				 }
			  }
			] else []
			)
		  }
		},
		"updateStrategy": {
		  "rollingUpdate": {
			"maxUnavailable": "10%"
		  },
		  "type": "RollingUpdate"
		}
	  }
	},
  {
	  "apiVersion": "apps/v1",
	  "kind": "Deployment",
	  "metadata": {
		"labels": {
		  "app.kubernetes.io/component": "metrics-adapter",
		  "app.kubernetes.io/name": "prometheus-adapter",
		  "app.kubernetes.io/part-of": "kube-prometheus",
		  "app.kubernetes.io/version": "0.10.0"
		},
		"name": "prometheus-adapter",
		"namespace": "monitoring"
	  },
	  "spec": {
		"replicas": 2,
		"selector": {
		  "matchLabels": {
			"app.kubernetes.io/component": "metrics-adapter",
			"app.kubernetes.io/name": "prometheus-adapter",
			"app.kubernetes.io/part-of": "kube-prometheus"
		  }
		},
		"strategy": {
		  "rollingUpdate": {
			"maxSurge": 1,
			"maxUnavailable": 1
		  }
		},
		"template": {
		  "metadata": {
			"labels": {
			  "app.kubernetes.io/component": "metrics-adapter",
			  "app.kubernetes.io/name": "prometheus-adapter",
			  "app.kubernetes.io/part-of": "kube-prometheus",
			  "app.kubernetes.io/version": "0.10.0"
			}
		  },
		  "spec": {
			"automountServiceAccountToken": true,
			"containers": [
			  {
				"args": [
				  "--cert-dir=/var/run/serving-cert",
				  "--config=/etc/adapter/config.yaml",
				  "--logtostderr=true",
				  "--metrics-relist-interval=1m",
				  "--prometheus-url=http://prometheus-k8s.monitoring.svc:9090/",
				  "--secure-port=6443",
				  "--tls-cipher-suites=TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA,TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA,TLS_RSA_WITH_AES_128_GCM_SHA256,TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_128_CBC_SHA,TLS_RSA_WITH_AES_256_CBC_SHA"
				],
				"image": std.join("",
					[
					  target_registry,
					  prometheus_adapter_image_repo,
					  "/prometheus-adapter:",
					  prometheus_adapter_version
					]
				  ),
				"livenessProbe": {
				  "failureThreshold": 5,
				  "httpGet": {
					"path": "/livez",
					"port": "https",
					"scheme": "HTTPS"
				  },
				  "initialDelaySeconds": 30,
				  "periodSeconds": 5
				},
				"name": "prometheus-adapter",
				"ports": [
				  {
					"containerPort": 6443,
					"name": "https"
				  }
				],
				"readinessProbe": {
				  "failureThreshold": 5,
				  "httpGet": {
					"path": "/readyz",
					"port": "https",
					"scheme": "HTTPS"
				  },
				  "initialDelaySeconds": 30,
				  "periodSeconds": 5
				},
				"resources": {
				  "limits": {
					"cpu": "250m",
					"memory": "180Mi"
				  },
				  "requests": {
					"cpu": "102m",
					"memory": "180Mi"
				  }
				},
				"securityContext": {
				  "allowPrivilegeEscalation": false,
				  "capabilities": {
					"drop": [
					  "ALL"
					]
				  },
				  "readOnlyRootFilesystem": true
				},
				"volumeMounts": [
				  {
					"mountPath": "/tmp",
					"name": "tmpfs",
					"readOnly": false
				  },
				  {
					"mountPath": "/var/run/serving-cert",
					"name": "volume-serving-cert",
					"readOnly": false
				  },
				  ] + (
					 if timezone != "UTC" then [
					   {
						 "name": "timezone-config",
						 "mountPath": "/etc/localtime"
					   }
					 ] else []
				   ) + [
				  {
					"mountPath": "/etc/adapter",
					"name": "config",
					"readOnly": false
				  }
				]
			  }
			],
			"nodeSelector": {
			  "kubernetes.io/os": "linux"
			},
			"serviceAccountName": "prometheus-adapter",
			"volumes": [
			  {
				"emptyDir": {},
				"name": "tmpfs"
			  },
			  {
				"emptyDir": {},
				"name": "volume-serving-cert"
			  },
			  {
				"configMap": {
				  "name": "adapter-config"
				},
				"name": "config"
			  }
			] + (
			if timezone != "UTC" then [
			{
				"name": "timezone-config",
				"hostPath": {
				  "path": std.join("", ["/usr/share/zoneinfo/", timezone])
				 }
			}
			] 
			else []
			)
		  }
		  }
		}
	  },
  {
	  "apiVersion": "monitoring.coreos.com/v1",
	  "kind": "Prometheus",
	  "metadata": {
		"labels": {
		  "app.kubernetes.io/component": "prometheus",
		  "app.kubernetes.io/instance": "k8s",
		  "app.kubernetes.io/name": "prometheus",
		  "app.kubernetes.io/part-of": "kube-prometheus",
		  "app.kubernetes.io/version": "2.41.0"
		},
		"name": "k8s",
		"namespace": "monitoring"
	  },
	  "spec": {
		"alerting": {
		  "alertmanagers": [
			{
			  "apiVersion": "v2",
			  "name": "alertmanager-main",
			  "namespace": "monitoring",
			  "port": "web"
			}
		  ]
		},
		"enableFeatures": [],
		"externalLabels": {},
		 "image": std.join("",
			[
			  target_registry,
			  prometheus_image_repo,
			  "/prometheus:",
			  prometheus_version
			]
		  ),
		"storage": {
			"volumeClaimTemplate": {
			  "spec": {
				"accessModes": [
				  "ReadWriteMany"
				],
				"resources": {
				  "requests": {
					"storage": prometheus_pvc
				  }
				}
			  }
			}
		  },
		"volumeMounts": [
	    ] + (
               if timezone != "UTC" then [
                 {
                   "name": "timezone-config",
                   "mountPath": "/etc/localtime"
                 }
               ] else []
             ),
      "volumes": [
        ] + (
            if timezone != "UTC" then [
            {
              "name": "timezone-config",
              "hostPath": {
                "path": std.join("", ["/usr/share/zoneinfo/", timezone])
               }
            }
          ] else []
        ),
		"nodeSelector": {
		  "kubernetes.io/os": "linux"
		},
		"podMetadata": {
		  "labels": {
			"app.kubernetes.io/component": "prometheus",
			"app.kubernetes.io/instance": "k8s",
			"app.kubernetes.io/name": "prometheus",
			"app.kubernetes.io/part-of": "kube-prometheus",
			"app.kubernetes.io/version": "2.41.0"
		  }
		},
		"podMonitorNamespaceSelector": {},
		"podMonitorSelector": {},
		"probeNamespaceSelector": {},
		"probeSelector": {},
		"replicas": 1,
		"resources": {
		  "requests": {
		  	"cpu": "100m",
			"memory": "4Gi"
		  },
		  "limits": {
		  	"cpu": "100m",
			"memory": "4Gi"
		  }
		},
		"ruleNamespaceSelector": {},
		"ruleSelector": {},
		"securityContext": {
		  "fsGroup": 2000,
		  "runAsNonRoot": true,
		  "runAsUser": 1000
		},
		"serviceAccountName": "prometheus-k8s",
		"serviceMonitorNamespaceSelector": {},
		"serviceMonitorSelector": {},
		"version": "2.41.0"
	  }
}
]
