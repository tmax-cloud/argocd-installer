function (
  timezone="UTC",
  is_offline="false",
  private_registry="172.22.6.2:5000",
  client_id="grafana",
  tmax_client_secret="tmax_client_secret",
  keycloak_addr="",
  grafana_pvc="10Gi",
  grafana_version="8.2.2",
  grafana_image_repo="grafana/grafana",
  ingress_domain="",
  admin_user="test@test.co.kr",
  is_master_cluster="true",
  grafana_subdomain="grafana"
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";
local admin_info = if is_master_cluster == "true" then "" else "admin_user = " + admin_user;

[
  {
    "kind": "ConfigMap",
    "apiVersion": "v1",
    "metadata": {
      "name": "grafana-config",
      "namespace": "monitoring"
    },
    "data": {
      "grafana.ini": std.join("\n",
        [
          "[server]",
          std.join("", ["domain = ", grafana_subdomain, ".", ingress_domain, ""]),
          "http_port = 3000",
          "root_url = https://%(domain)s/api/grafana/",
          "serve_from_sub_path = true",
          "[security]",
          admin_info,
          "allow_embedding = true",
          "[auth]",
          "disable_login_form = true",
          "[auth.generic_oauth]",
          "name = OAuth",
          "enabled = true",
          "allow_sign_up = true",
          std.join("", ["client_id = ", client_id]),
          std.join("", ["client_secret = ", tmax_client_secret]),
          "scopes = openid profile email",
          "email_attribute_name = email:primary",
          "email_attribute_path = email",
          "role_attribute_path = ",
          std.join("", ["auth_url = https://", keycloak_addr, "/auth/realms/tmax/protocol/openid-connect/auth"]),
          std.join("", ["token_url = https://", keycloak_addr, "/auth/realms/tmax/protocol/openid-connect/token"]),
          std.join("", ["api_url = https://", keycloak_addr, "/auth/realms/tmax/protocol/openid-connect/userinfo"]),
          "allowed_domains = ",
          "team_ids =",
          "allowed_organizations =",
          "send_client_credentials_via_post = false",
          "tls_skip_verify_insecure = true",
          "[auth.anonymous]",
          "enabled = true",
          "[users]",
          "default_theme = light"
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
