function (
  timezone="UTC",
  is_offline="false",
  private_registry="172.22.6.2:5000",
  grafana_pvc_size="10Gi",
  grafana_sc="",
  grafana_version="10.3.1",
  grafana_image_repo="docker.io/grafana/grafana",
  is_master_cluster="true",
  grafana_subdomain="grafana",
  grafana_domain="",
  keycloak_addr="",
  admin_email="",
  tmax_client_secret="",
  grafana_sc="default"
  
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";
local grafana_ingress = std.join("", [grafana_subdomain, ".", grafana_domain]);

[
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
      "resources": 
        {
        "requests": {
          "storage": grafana_pvc_size
        }
      },
      "storageClassName": grafana_sc
    }
  },
  	{
	  "apiVersion": "apps/v1",
	  "kind": "Deployment",
	  "metadata": {
		"labels": {
		  "app": "grafana",
		  "app.kubernetes.io/instance": "grafana"
		},
		"name": "grafana",
		"namespace": "monitoring"
	  },
	  "spec": {
		"replicas": 1,
		"selector": {
		  "matchLabels": {
			"app": "grafana"
		  }
		},
		"strategy": {
		  "rollingUpdate": {
			"maxSurge": "25%",
			"maxUnavailable": "25%"
		  },
		  "type": "RollingUpdate"
		},
		"template": {
		  "metadata": {
			"labels": {
			  "app": "grafana"
			}
		  },
		  "spec": {
			"containers": [
			  {
				"image": std.join("",
				  [
					target_registry,
					grafana_image_repo,
					":",
					grafana_version
				  ]
				),
				"imagePullPolicy": "IfNotPresent",
				"name": "grafana",
				"ports": [
				  {
					"containerPort": 3000,
					"name": "http",
					"protocol": "TCP"
				  }
				],
				"readinessProbe": {
				  "failureThreshold": 3,
				  "httpGet": {
					"path": "/api/health",
					"port": "http",
					"scheme": "HTTP"
				  },
				  "periodSeconds": 10,
				  "successThreshold": 1,
				  "timeoutSeconds": 1
				},
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
				"terminationMessagePath": "/dev/termination-log",
				"volumeMounts": [
				  {
					"mountPath": "/var/lib/grafana",
					"name": "grafana-storage"
				  },
				  {
					"mountPath": "/etc/grafana",
					"name": "grafana-config"
				  },
          {
					"mountPath": "/etc/grafana/provisioning/dashboards",
					"name": "grafana-dashboards"
				  },
          {
					"mountPath": "/grafana-dashboard-definitions/0/k8s-resources-namespace",
					"name": "grafana-dashboard-k8s-resources-namespace"
				  },
          {
					"mountPath": "/grafana-dashboard-definitions/0/grafana-loki-dashboard",
					"name": "grafana-loki-dashboard"
				  },
          {
					"mountPath": "/grafana-dashboard-definitions/0/grafana-node-exporter",
					"name": "grafana-node-exporter"
				  },
				  {
					"mountPath": "/etc/grafana/provisioning/datasources",
					"name": "grafana-datasources"
				  }
				]+ (
					  if timezone != "UTC" then [
				{
				  "name": "timezone-config",
				  "mountPath": "/etc/localtime"
				}
					  ] else []
					)
			  }
			],
			"dnsPolicy": "ClusterFirst",
			"nodeSelector": {
			  "beta.kubernetes.io/os": "linux"
			},
			"restartPolicy": "Always",
			"schedulerName": "default-scheduler",
			"securityContext": {
			  "runAsNonRoot": false,
			  "runAsUser": 0

			},
			"serviceAccountName": "grafana",
			"terminationGracePeriodSeconds": 30,
			"volumes": [
			  {
				"name": "grafana-storage",
				"persistentVolumeClaim": {
				  "claimName": "grafana-pvc"
				}
			  },
			  {
				"name": "grafana-config",
				"configMap": {
				  "defaultMode": 420,
				  "name": "grafana-config"
				}
			  },
        {
				"name": "grafana-dashboard-k8s-resources-namespace",
				"configMap": {
				  "defaultMode": 420,
				  "name": "grafana-dashboard-k8s-resources-namespace"
				}
			  },
        {
				"name": "grafana-node-exporter",
				"configMap": {
				  "defaultMode": 420,
				  "name": "grafana-node-exporter"
				}
			  },
        {
				"name": "grafana-loki-dashboard",
				"configMap": {
				  "defaultMode": 420,
				  "name": "grafana-loki-dashboard"
				}
			  },
        {
				"name": "grafana-dashboards",
				"configMap": {
				  "defaultMode": 420,
				  "name": "grafana-dashboards"
				}
			  },
			  {
				"name": "grafana-datasources",
				"secret": {
				  "secretName": "grafana-datasources"
				}
			  }
			]+ (
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
      "kind": "ConfigMap",
      "apiVersion": "v1",
      "metadata": {
        "name": "grafana-config",
        "namespace": "monitoring"
      },
      "data": {
        "grafana.ini": std.join('\n', [
          "[datasources]",
          "yaml = /etc/grafana/provisioning/datasources",
          "[auth]",
          "disable_login_form = false",
          "",
          "[auth.anonymous]",
          "enabled = true",
          "",
          "[auth.generic_oauth]",
          "allow_sign_up = true",
          "api_url = https://" + keycloak_addr + "/realms/tmax/protocol/openid-connect/userinfo",
          "auth_url = https://" + keycloak_addr + "/realms/tmax/protocol/openid-connect/auth",
          "client_id = grafana",
          "client_secret = '" + tmax_client_secret + "'",
          "email_attribute_path = email",
          "role_attribute_path = contains(email, '" + admin_email + "') && 'Admin' || 'Viewer'",
          "enabled = true",
          "scopes = openid profile email",
          "tls_skip_verify_insecure = true",
          "token_url = https://" + keycloak_addr + "/realms/tmax/protocol/openid-connect/token",
          "",
          "[log]",
          "level = debug",
          "mode = console",
          "",
          "[log.frontend]",
          "enabled = true",
          "",
          "[paths]",
          "data = /var/lib/grafana",
          "logs = /var/log/grafana",
          "provisioning = /etc/grafana/provisioning",
          "",
          "[security]",
          "admin_password = admin",
          "admin_user = admin",
          "allow_embedding = true",
          "",
          "[server]",
          "domain = '" + grafana_ingress + "'",
          "http_port = 3000",
          "root_url = https://%(domain)s/api/grafana/",
          "serve_from_sub_path = true"
        ])
      }
    },
    {
      "apiVersion": "networking.k8s.io/v1",
      "kind": "Ingress",
      "metadata": {
        "labels": {
          "ingress.tmaxcloud.org/name": "grafana"
        },
        "name": "grafana-ingress",
        "namespace": "monitoring"
      },
      "spec": {
        "ingressClassName": "nginx-system",
        "rules": [
          {
            "host": grafana_ingress,
            "http": {
              "paths": [
                {
                  "path": "/",
                  "pathType": "Prefix",
                  "backend": {
                    "service": {
                      "name": "grafana",
                      "port": {
                        "name": "http"
                      }
                    }
                  }
                }
              ]
            }
          }
        ]
      }
    }


]
