function (
  timezone="UTC",
  is_offline="false",
  private_registry="172.22.6.2:5000",
  grafana_pvc="10Gi",
  grafana_version="8.2.2",
  grafana_image_repo="docker.io/grafana/grafana",
  is_master_cluster="true",
  grafana_subdomain="grafana"
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";
local admin_info = if is_master_cluster == "true" then "" else "admin_user = " + admin_user;

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
    }
]
