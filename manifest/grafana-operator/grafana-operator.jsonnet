function (
	is_offline="false",
	private_registry="172.22.6.2:5000",
	client_id="grafana",
	tmax_client_secret="tmax_client_secret",
	kube_rbac_proxy_image_repo="",
	kube_rbac_proxy_version="",
	grafana_operator_image_repo="",
	grafana_operator_version="v0.0.2",
	keycloak_addr="",
	ingress_domain="",
	admin_user="test@test.co.kr",
	is_master_cluster="true",
	grafana_subdomain="grafana",
  	timezone="UTC",
	grafana_pvc_size = "10Gi"
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";
local admin_info = if is_master_cluster == "true" then "" else "admin_user = " + admin_user + "\n";

[
	{
	  "apiVersion": "apps/v1",
	  "kind": "Deployment",
	  "metadata": {
		"labels": {
		  "control-plane": "grafana-operator"
		},
		"name": "grafana-operator",
		"namespace": "monitoring"
	  },
	  "spec": {
		"replicas": 1,
		"selector": {
		  "matchLabels": {
			"control-plane": "grafana-operator"
		  }
		},
		"strategy": {
		  "type": "Recreate"
		},
		"template": {
		  "metadata": {
			"labels": {
			  "control-plane": "grafana-operator"
			}
		  },
		  "spec": {
			"containers": [
			  {
				"args": [
				  "--secure-listen-address=0.0.0.0:8443",
				  "--upstream=http://127.0.0.1:8080/",
				  "--logtostderr=true",
				  "--v=10"
				],
				"image":  std.join("",
						[
							target_registry,
							"gcr.io/kubebuilder/kube-rbac-proxy:",
							kube_rbac_proxy_version
						],
				),
				"name": "kube-rbac-proxy",
				"ports": [
				  {
					"containerPort": 8443,
					"name": "https",
					"protocol": "TCP"
				  },
				  {
					"containerPort": 9443,
					"name": "webhook",
					"protocol": "TCP"
				  }
				]
			  },
			  {
				"args": [
				  "--health-probe-bind-address=:8081",
				  "--metrics-bind-address=127.0.0.1:8080",
				  "--scan-all"
				],
				"command": [
				  "/manager"
				],
				"env": [
				  {
					"name": "POD_NAME",
					"valueFrom": {
					  "fieldRef": {
						"fieldPath": "metadata.name"
					  }
					}
				  },
				  {
					"name": "WATCH_NAMESPACE",
					"valueFrom": {
					  "fieldRef": {
						"fieldPath": "metadata.namespace"
					  }
					}
				  }
				],
				"image": std.join("",
						[
							target_registry,
							grafana_operator_image_repo,
							":",
							grafana_operator_version
						]
				),		
				"volumeMounts": [
				  {
					"name": "nsdashboard",
					"mountPath": "/var/dashboard/"
				  },
				  {
					"name": "webhook-tls",
					"mountPath": "/run/secrets/tls",
					"readOnly": true
				  },
				] + (
				  if timezone != "UTC" then [
				{
				"name": "timezone-config",
				"mountPath": "/etc/localtime"
				}
				  ] else []
				)
				,
				"imagePullPolicy": "Always",
				"livenessProbe": {
				  "httpGet": {
					"path": "/healthz",
					"port": 8081
				  },
				  "initialDelaySeconds": 15,
				  "periodSeconds": 20
				},
				"name": "grafana-operator",
				"readinessProbe": {
				  "httpGet": {
					"path": "/readyz",
					"port": 8081
				  },
				  "initialDelaySeconds": 5,
				  "periodSeconds": 10
				},
				"resources": {
				  "limits": {
					"cpu": "200m",
					"memory": "300Mi"
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
			"serviceAccountName": "grafana-operator",
			"terminationGracePeriodSeconds": 10,
			"volumes": [
			  {
				"name": "nsdashboard",
				"configMap": {
				  "name": "ns-dashboard"
				}
			  },
			  {
				"name": "webhook-tls",
				"secret": {
				  "defaultMode": 420,
				  "secretName": "grafana-webhook"
				}
			  }
			]+ (
			  if timezone != "UTC" then [
				{
				  "name": "timezone-config",
				  "hostPath": {
					"path": std.join("", [
						"/usr/share/zoneinfo/",
						 timezone
						 ]
					)
				   }
				 }
			  ] else []
			),
		  }
		}
	  }
	},
	{
	  "apiVersion": "integreatly.org/v1alpha1",
	  "kind": "Grafana",
	  "metadata": {
		"name": "grafana",
		"namespace": "monitoring",
		"labels": {
		  "grafana": "hypercloud"
		}
	  },
	  "spec": {
		"deployment": {
		  "replicas": 2
		},
		"ingress": {
		  "enabled": true,
		  "ingressClassName": "tmax-cloud",
		  "hostname": "grafana.192.168.9.241.nip.io",
		  "tlsEnabled": true,
		  "pathType": "Prefix",
		  "path": "/",
		  "labels": {
			"ingress.tmaxcloud.org/name": "grafana"
		  }
		},
		"config": {
		  "server": {
			"domain": std.join("", [
				grafana_subdomain, 
				".", 
				ingress_domain
				]
			),
			"root_url": "http://%(domain)s/api/grafana/",
			"serve_from_sub_path": true,
			"http_port": "3000"
		  },
		  "log": {
			"mode": "console",
			"level": "warn"
		  },
		  "log.frontend": {
			"enabled": true
		  },
		  "auth": {
			"disable_login_form": false
		  },
		  "auth.anonymous": {
			"enabled": true
		  },
		  "auth.generic_oauth": {
			"enabled": true,
			"allow_sign_up": true,
			"client_id": "grafana",
			"client_secret": tmax_client_secret,
			"scopes": "openid profile email",
			"email_attribute_path": "email",
			"auth_url": std.join("", ["https://", keycloak_addr, "/auth/realms/tmax/protocol/openid-connect/auth" ]),
			"token_url": std.join("", ["https://", keycloak_addr, "/auth/realms/tmax/protocol/openid-connect/token" ]),
			"api_url": std.join("", ["https://", keycloak_addr, "/auth/realms/tmax/protocol/openid-connect/userinfo" ]),
			"tls_skip_verify_insecure": true
		  },
		  "security": {
			"allow_embedding": true,
			"admin_user": "admin",
			"admin_password": "admin"
		  }
		},
		"service": {
		  "name": "grafana-service",
		  "type": "NodePort",
		  "labels": {
			"app": "grafana",
			"type": "grafana-service"
		  }
		},
		"dashboardLabelSelector": [
		  {
			"matchExpressions": [
			  {
				"key": "app",
				"operator": "In",
				"values": [
				  "grafana"
				]
			  }
			]
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
	},
	{
		"apiVersion": "networking.k8s.io/v1",
		"kind": "Ingress",
		"metadata": {
			"labels": {
				"ingress.tmaxcloud.org/name": "grafana"
			},
			"annotations": {
				"traefik.ingress.kubernetes.io/router.entrypoints": "websecure"
			},
			"name": "grafana",
			"namespace": "monitoring"
		},
		"spec": {
			"ingressClassName": "tmax-cloud",
			"rules": [
				{
					"host": std.join("", [grafana_subdomain, ".", ingress_domain]),
					"http": {
						"paths": [
							{
								"backend": {
									"service": {
										"name": "grafana",
										"port": {
											"number": 3000
										}
									}
								},
								"path": "/",
								"pathType": "Prefix"
							}
						]
					}
				}
			],
			"tls": [
				{
					"hosts": [
						std.join("", [grafana_subdomain, ".", ingress_domain])
					]
				}
			]
		}
	}
]