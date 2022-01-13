function (
    	domain="",
	client_id="grafana",
	client_secret="",
	keycloak_addr="",
	grafana_pvc="10Gi",
	grafana_version="6.4.3",
	grafana_image_repo="grafana/grafana"
)

[
	{
	  "kind": "ConfigMap",
	  "apiVersion": "v1",
	  "metadata": {
		"name": "grafana-config",
		"namespace": "monitoring"
	  },
	  "data": {
		"grafana.ini": std.join("",["[server]\ndomain =", domain,"\nhttp_port = 3000\nroot_url = https://%(domain)s/api/grafana/\nserve_from_sub_path = true\n[security]\nallow_embedding = true\n[auth]\ndisable_login_form = true\n[auth.generic_oauth]\nname = OAuth\nenabled = true\nallow_sign_up = true\nclient_id =", client_id,"\nclient_secret =", client_secret,"\nscopes = openid profile email\nemail_attribute_name = email:primary\nemail_attribute_path = email\nrole_attribute_path = \nauth_url = https://",keycloak_addr,"/auth/realms/tmax/protocol/openid-connect/auth\ntoken_url = https://",keycloak_addr,"/auth/realms/tmax/protocol/openid-connect/token\napi_url = https://",keycloak_addr,"/auth/realms/tmax/protocol/openid-connect/userinfo\nallowed_domains = \nteam_ids =\nallowed_organizations =\nsend_client_credentials_via_post = false\ntls_skip_verify_insecure = true\n[auth.anonymous]\nenabled = true\n[users]\ndefault_theme = light\n"])
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
		"storageClassName": "csi-cephfs-sc",
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
				"image": std.join("",[grafana_image_repo,":", grafana_version])
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
	}
]
