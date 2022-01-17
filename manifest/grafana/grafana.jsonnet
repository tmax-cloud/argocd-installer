function (
	is_offline="false",
    private_registry="172.22.6.2:5000",
    domain="",
	client_id="grafana",
	client_secret="",
	keycloak_addr="",
	grafana_pvc="10Gi",
	grafana_version="6.4.3",
	grafana_image_repo="grafana/grafana",
	ingress_domain=""
)

local target_registry = if is_offline == "flase" then "" else private_registry + "/";

[
	{
	  "kind": "ConfigMap",
	  "apiVersion": "v1",
	  "metadata": {
		"name": "grafana-config",
		"namespace": "monitoring"
	  },
	  "data": {
		"grafana.ini": std.join("",
			[
				"[server]\n",
				"domain =", domain, "\n",
				"http_port = 3000\n",
				"root_url = https://%(domain)s/api/grafana/\n",
				"serve_from_sub_path = true\n",
				"[security]\n",
				"allow_embedding = true\n",
				"[auth]\n",
				"disable_login_form = true\n",
				"[auth.generic_oauth]\n",
				"name = OAuth\n",
				"enabled = true\n",
				"allow_sign_up = true\n",
				"client_id =", client_id, "\n",
				"client_secret =", client_secret, "\n",
				"scopes = openid profile email\n",
				"email_attribute_name = email:primary\n",
				"email_attribute_path = email\n",
				"role_attribute_path = \n",
				"auth_url = https://", keycloak_addr, "/auth/realms/tmax/protocol/openid-connect/auth\n",
				"token_url = https://", keycloak_addr, "/auth/realms/tmax/protocol/openid-connect/token\n",
				"api_url = https://", keycloak_addr, "/auth/realms/tmax/protocol/openid-connect/userinfo\n",
				"allowed_domains = \n",
				"team_ids =\n",
				"allowed_organizations =\n",
				"send_client_credentials_via_post = false\n",
				"tls_skip_verify_insecure = true\n",
				"[auth.anonymous]\n",
				"enabled = true\n",
				"[users]\n",
				"default_theme = light\n"
			]
		)
	  }
	},
	{
	  "apiVersion": "v1",
	  "kind": "PersistentVolumeClaim",
	  "metadata": {
		"name": "grafana-pvc",
		"namespace": "monitoring",
		"labels": {
		  "app": "grafana"
		}
	  },
	  "spec": {
		"accessModes": [
		  "ReadWriteOnce"
		],
		"resources": {
		  "requests": {
			"storage": grafana_pvc
		  }
		}
	  }
	},
	{
	  "kind": "Deployment",
	  "apiVersion": "apps/v1",
	  "metadata": {
		"name": "grafana",
		"namespace": "monitoring",
		"labels": {
		  "app": "grafana"
		}
	  },
	  "spec": {
		"replicas": 1,
		"selector": {
		  "matchLabels": {
			"app": "grafana"
		  }
		},
		"template": {
		  "metadata": {
			"creationTimestamp": null,
			"labels": {
			  "app": "grafana"
			}
		  },
		  "spec": {
			"nodeSelector": {
			  "beta.kubernetes.io/os": "linux"
			},
			"restartPolicy": "Always",
			"serviceAccountName": "grafana",
			"schedulerName": "default-scheduler",
			"terminationGracePeriodSeconds": 30,
			"securityContext": {
			  "runAsUser": 65534,
			  "runAsNonRoot": true
			},
			"containers": [
			  {
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
				"readinessProbe": {
				  "httpGet": {
					"path": "/api/health",
					"port": "http",
					"scheme": "HTTP"
				  },
				  "timeoutSeconds": 1,
				  "periodSeconds": 10,
				  "successThreshold": 1,
				  "failureThreshold": 3
				},
				"terminationMessagePath": "/dev/termination-log",
				"name": "grafana",
				"ports": [
				  {
					"name": "http",
					"containerPort": 3000,
					"protocol": "TCP"
				  }
				],
				"imagePullPolicy": "IfNotPresent",
				"volumeMounts": [
				  {
					"name": "grafana-storage",
					"mountPath": "/var/lib/grafana"
				  },
				  {
					"name": "grafana-config",
					"mountPath": "/etc/grafana"
				  },
				  {
					"name": "grafana-datasources",
					"mountPath": "/etc/grafana/provisioning/datasources"
				  },
				  {
					"name": "grafana-dashboards",
					"mountPath": "/etc/grafana/provisioning/dashboards"
				  },
				  {
					"name": "grafana-dashboard-k8s-resources-namespace",
					"mountPath": "/grafana-dashboard-definitions/0/k8s-resources-namespace"
				  },
				  {
					"name": "grafana-dashboard-hyperauth",
					"mountPath": "/grafana-dashboard-definitions/0/hyperauth"
				  }
				],
				"terminationMessagePolicy": "File",
				"image": std.join("",
					[
						target_registry,
						grafana_image_repo,
						":",
						grafana_version
					]
				)
			  }
			],
			"serviceAccount": "grafana",
			"volumes": [
			  {
				"name": "grafana-storage",
				"persistentVolumeClaim": {
				  "claimName": "grafana-pvc"
				}
			  },
			  {
				"name": "grafana-datasources",
				"secret": {
				  "secretName": "grafana-datasources",
				  "defaultMode": 420
				}
			  },
			  {
				"name": "grafana-config",
				"configMap": {
				  "name": "grafana-config",
				  "defaultMode": 420
				}
			  },
			  {
				"name": "grafana-dashboards",
				"configMap": {
				  "name": "grafana-dashboards",
				  "defaultMode": 420
				}
			  },
			  {
				"name": "grafana-dashboard-k8s-resources-namespace",
				"configMap": {
				  "name": "grafana-dashboard-k8s-resources-namespace",
				  "defaultMode": 420
				}
			  },
			  {
				"name": "grafana-dashboard-hyperauth",
				"configMap": {
				  "name": "grafana-dashboard-hyperauth",
				  "defaultMode": 420
				}
			  }
			],
			"dnsPolicy": "ClusterFirst"
		  }
		},
		"strategy": {
		  "type": "RollingUpdate",
		  "rollingUpdate": {
			"maxUnavailable": "25%",
			"maxSurge": "25%"
		  }
		},
		"revisionHistoryLimit": 10,
		"progressDeadlineSeconds": 600
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
		"host": std.join("", ["grafana.", ingress_domain]),
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
			std.join("", ["grafana.", ingress_domain])
			]
	      }
	    ]
	  }
	}
]
