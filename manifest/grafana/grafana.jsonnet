function (
  timezone="UTC",
  is_offline="false",
  private_registry="172.22.6.2:5000",
  grafana_pvc_size="10Gi",
  grafana_version="10.3.1",
  grafana_image_repo="docker.io/grafana/grafana",
  is_master_cluster="true",
  grafana_subdomain="grafana",
  grafana_domain="",
  keycloak_addr="",
  admin_email="",
  tmax_client_secret="",
  
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
      "resources": {
        "requests": {
          "storage": grafana_pvc_size
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
                "name": "grafana-datasources-prometheus",
                "mountPath": "/etc/grafana/provisioning/datasources/prometheus.yaml",
                "subPath": "datasources.yaml"
              },
              {
                "name": "grafana-datasources-loki",
                "mountPath": "/etc/grafana/provisioning/datasources/loki.yaml",
                "subPath": "datasources.yaml"
              },
              {
                "name": "grafana-dashboard-prometheus",
                "mountPath": "/etc/grafana/provisioning/dashboards/prometheus-dashboard.json",
                "subPath": "dashboard.json"
              }
			  ] + (
				  if timezone != "UTC" then [
            {
              "name": "timezone-config",
              "mountPath": "/etc/localtime"
            }
				  ] else []
				),
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
          },
        "serviceAccount": "grafana",
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
              "name": "grafana-config",
              "defaultMode": 420
            }
          },
          {
            "name": "grafana-datasources-prometheus",
            "secret": {
              "secretName": "grafana-datasources-prometheus"
            }
          },
          {
            "name": "grafana-datasources-loki",
            "secret": {
              "secretName": "grafana-datasources-loki"
            }
          },
          {
            "name": "grafana-dashboard-prometheus",
            "configMap": {
              "name": "prometheus-dashboard"
            }
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
			),
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
    },
    {
      "kind": "ConfigMap",
      "apiVersion": "v1",
      "metadata": {
        "name": "grafana-config",
        "namespace": "monitoring"
      },
      "data": {
        "grafana.ini": [
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
          "",
          "[security]",
          "admin_password = admin",
          "admin_user = admin",
          "allow_embedding = true",
          "",
          "[server]",
          "domain = grafana-aks.tmaxcloudqa.link",
          "http_port = 3000",
          "root_url = https://%(domain)s/api/grafana/",
          "serve_from_sub_path = true"
        ].join("\n")
      }
    },
    {
      "apiVersion": "networking.k8s.io/v1",
      "kind": "Ingress",
      "metadata": {
        "labels": {
          "ingress.tmaxcloud.org/name": "argocd"
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
