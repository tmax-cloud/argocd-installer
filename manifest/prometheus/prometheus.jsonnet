function (
	is_offline="false",
	private_registry="172.22.6.2:5000",
	coreos_image_repo="quay.io/coreos",
	prometheus_image_repo="quay.io/prometheus",
	configmap_reload_version="v0.0.1",
	configmap_reloader_version="v0.34.0",
	prometheus_operator_version="v0.34.0",
	alertmanager_version="v0.20.0",
	kube_rbac_proxy_version="v0.4.1",
	kube_state_metrics_version="v1.8.0",
	node_exporter_version="v0.18.1",
	prometheus_adapter_version="v0.5.0",
	prometheus_pvc="10Gi",
	prometheus_version="v2.11.0"
)

local target_registry = if is_offline == "flase" then "" else private_registry + "/";

[
	{
	  "apiVersion": "apps/v1",
	  "kind": "Deployment",
	  "metadata": {
		"labels": {
		  "app.kubernetes.io/component": "controller",
		  "app.kubernetes.io/name": "prometheus-operator",
		  "app.kubernetes.io/version": "v0.34.0"
		},
		"name": "prometheus-operator",
		"namespace": "monitoring"
	  },
	  "spec": {
		"replicas": 1,
		"selector": {
		  "matchLabels": {
			"app.kubernetes.io/component": "controller",
			"app.kubernetes.io/name": "prometheus-operator"
		  }
		},
		"template": {
		  "metadata": {
			"labels": {
			  "app.kubernetes.io/component": "controller",
			  "app.kubernetes.io/name": "prometheus-operator",
			  "app.kubernetes.io/version": "v0.34.0"
			}
		  },
		  "spec": {
			"containers": [
			  {
				"args": [
				  "--kubelet-service=kube-system/kubelet",
				  "--logtostderr=true",
				  std.join("",
				  	[
						"--config-reloader-image=",
						target_registry,
						coreos_image_repo,
						"/configmap-reload:",
						configmap_reload_version
					]
				  ),
				  std.join("",
				  	[
					  "--prometheus-config-reloader=",
					  target_registry,
					  coreos_image_repo,
					  "/prometheus-config-reloader:",
					  configmap_reloader_version
					]
				  )
				],
				"image": std.join("",
					[
						target_registry,
						coreos_image_repo,
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
				  "allowPrivilegeEscalation": false
				}
			  }
			],
			"nodeSelector": {
			  "beta.kubernetes.io/os": "linux"
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
		  "alertmanager": "main"
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
		"resources": {
		  "requests": {
			"memory": "200Mi",
			"cpu": "100m"
		  }
		},
		"nodeSelector": {
		  "kubernetes.io/os": "linux"
		},
		"replicas": 1,
		"securityContext": {
		  "fsGroup": 2000,
		  "runAsNonRoot": true,
		  "runAsUser": 1000
		},
		"serviceAccountName": "alertmanager-main",
		"version": alertmanager_version
	  }
	},
	{
	  "apiVersion": "apps/v1",
	  "kind": "Deployment",
	  "metadata": {
		"labels": {
		  "app": "kube-state-metrics"
		},
		"name": "kube-state-metrics",
		"namespace": "monitoring"
	  },
	  "spec": {
		"replicas": 1,
		"selector": {
		  "matchLabels": {
			"app": "kube-state-metrics"
		  }
		},
		"template": {
		  "metadata": {
			"labels": {
			  "app": "kube-state-metrics"
			}
		  },
		  "spec": {
			"containers": [
			  {
				"args": [
				  "--logtostderr",
				  "--secure-listen-address=:8443",
				  "--tls-cipher-suites=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_RSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256",
				  "--upstream=http://127.0.0.1:8081/"
				],
				"image": std.join("",
					[
						target_registry,
						coreos_image_repo,
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
					"cpu": "20m",
					"memory": "40Mi"
				  },
				  "requests": {
					"cpu": "10m",
					"memory": "20Mi"
				  }
				}
			  },
			  {
				"args": [
				  "--logtostderr",
				  "--secure-listen-address=:9443",
				  "--tls-cipher-suites=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_RSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256",
				  "--upstream=http://127.0.0.1:8082/"
				],
				"image": std.join("",
					[
						target_registry,
						coreos_image_repo,
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
				}
			  },
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
						coreos_image_repo,
						"/kube-state-metrics:",
						kube_state_metrics_version
					]
				),
				"name": "kube-state-metrics",
				"resources": {
				  "limits": {
					"cpu": "100m",
					"memory": "150Mi"
				  },
				  "requests": {
					"cpu": "100m",
					"memory": "150Mi"
				  }
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
			"serviceAccountName": "kube-state-metrics"
		  }
		}
	  }
	},
	{
	  "apiVersion": "apps/v1",
	  "kind": "DaemonSet",
	  "metadata": {
		"labels": {
		  "app": "node-exporter"
		},
		"name": "node-exporter",
		"namespace": "monitoring"
	  },
	  "spec": {
		"selector": {
		  "matchLabels": {
			"app": "node-exporter"
		  }
		},
		"template": {
		  "metadata": {
			"labels": {
			  "app": "node-exporter"
			}
		  },
		  "spec": {
			"containers": [
			  {
				"args": [
				  "--web.listen-address=127.0.0.1:9100",
				  "--path.procfs=/host/proc",
				  "--path.sysfs=/host/sys",
				  "--path.rootfs=/host/root",
				  "--collector.filesystem.ignored-mount-points=^/(dev|proc|sys|var/lib/docker/.+)($|/)",
				  "--collector.filesystem.ignored-fs-types=^(autofs|binfmt_misc|cgroup|configfs|debugfs|devpts|devtmpfs|fusectl|hugetlbfs|mqueue|overlay|proc|procfs|pstore|rpc_pipefs|securityfs|sysfs|tracefs)$"
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
				"volumeMounts": [
				  {
					"mountPath": "/host/proc",
					"name": "proc",
					"readOnly": false
				  },
				  {
					"mountPath": "/host/sys",
					"name": "sys",
					"readOnly": false
				  },
				  {
					"mountPath": "/host/root",
					"mountPropagation": "HostToContainer",
					"name": "root",
					"readOnly": true
				  }
				]
			  },
			  {
				"args": [
				  "--logtostderr",
				  "--secure-listen-address=$(IP):9100",
				  "--tls-cipher-suites=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_RSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256",
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
						coreos_image_repo,
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
				}
			  }
			],
			"hostNetwork": true,
			"hostPID": true,
			"nodeSelector": {
			  "kubernetes.io/os": "linux"
			},
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
				  "path": "/proc"
				},
				"name": "proc"
			  },
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
			]
		  }
		}
	  }
	},
	{
	  "apiVersion": "apps/v1",
	  "kind": "Deployment",
	  "metadata": {
		"name": "prometheus-adapter",
		"namespace": "monitoring"
	  },
	  "spec": {
		"replicas": 1,
		"selector": {
		  "matchLabels": {
			"name": "prometheus-adapter"
		  }
		},
		"strategy": {
		  "rollingUpdate": {
			"maxSurge": 1,
			"maxUnavailable": 0
		  }
		},
		"template": {
		  "metadata": {
			"labels": {
			  "name": "prometheus-adapter"
			}
		  },
		  "spec": {
			"containers": [
			  {
				"args": [
				  "--cert-dir=/var/run/serving-cert",
				  "--config=/etc/adapter/config.yaml",
				  "--logtostderr=true",
				  "--metrics-relist-interval=1m",
				  "--prometheus-url=http://prometheus-k8s.monitoring.svc:9090/",
				  "--secure-port=6443"
				],
				"image": std.join("",
					[
						target_registry,
						coreos_image_repo,
						"/k8s-prometheus-adapter-amd64:",
						prometheus_adapter_version
					]
				),
				"name": "prometheus-adapter",
				"ports": [
				  {
					"containerPort": 6443
				  }
				],
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
				  {
					"mountPath": "/etc/adapter",
					"name": "config",
					"readOnly": false
				  }
				],
				"resources": {
				  "limits": {
					"cpu": "200m",
					"memory": "200Mi"
				  },
				  "requests": {
					"cpu": "200m",
					"memory": "200Mi"
				  }
				}
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
			]
		  }
		}
	  }
	},
	{
	  "apiVersion": "monitoring.coreos.com/v1",
	  "kind": "Prometheus",
	  "metadata": {
		"labels": {
		  "prometheus": "k8s"
		},
		"name": "k8s",
		"namespace": "monitoring"
	  },
	  "spec": {
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
		"alerting": {
		  "alertmanagers": [
			{
			  "name": "alertmanager-main",
			  "namespace": "monitoring",
			  "port": "web"
			}
		  ]
		},
		"image": std.join("",
			[
				target_registry,
				prometheus_image_repo,
				"/prometheus:",
				prometheus_version
			]
		),
		"nodeSelector": {
		  "kubernetes.io/os": "linux"
		},
		"podMonitorSelector": {},
		"podMonitorNamespaceSelector": {},
		"replicas": 1,
		"resources": {
		  "requests": {
			"cpu": "10m",
			"memory": "2Gi"
		  }
		},
		"ruleSelector": {
		  "matchLabels": {
			"prometheus": "k8s",
			"role": "alert-rules"
		  }
		},
		"securityContext": {
		  "fsGroup": 2000,
		  "runAsNonRoot": true,
		  "runAsUser": 1000
		},
		"serviceAccountName": "prometheus-k8s",
		"serviceMonitorNamespaceSelector": {},
		"serviceMonitorSelector": {},
		"version": prometheus_version
	  }
	}
]
