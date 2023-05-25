function (    
    is_offline="false",
    private_registry="172.22.6.2:5000",    
    custom_domain_name="tmaxcloud.org",    
    tmax_client_secret="tmax_client_secret",
    hyperauth_url="172.23.4.105",
    hyperauth_realm="tmax",
    console_subdomain="console",    
    gatekeeper_log_level="info",    
    gatekeeper_version="v1.0.2",
    log_level="info",
    time_zone="UTC"
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";
local mysql_log_level = if log_level == "error" then "1" else if log_level == "debug" then "2"  else "3";
[
  {
    "apiVersion": "v1",
    "data": {
      "early-stopping": std.join("", ["{\n  \"medianstop\": {\n    \"image\": \"", target_registry, "docker.io/kubeflowkatib/earlystopping-medianstop:v0.15.0", "\"\n  }\n}"]),
      "metrics-collector-sidecar": std.join("", ["{\n  \"StdOut\": {\n    \"image\": \"", target_registry, "docker.io/kubeflowkatib/file-metrics-collector:v0.15.0\"", "\n  },\n  \"File\": {\n    \"image\": \"", target_registry, "docker.io/kubeflowkatib/file-metrics-collector:v0.15.0\"\n  },\n  \"TensorFlowEvent\": {\n    \"image\": \"", target_registry, "docker.io/kubeflowkatib/tfevent-metrics-collector:v0.15.0\",\n    \"resources\": {\n      \"limits\": {\n        \"memory\": \"1Gi\"\n      }\n    }\n  }\n}"]),
      "suggestion": std.join("", ["{\n  \"random\": {\n    \"image\": \"", target_registry, "docker.io/kubeflowkatib/suggestion-hyperopt:v0.15.0\"\n  },\n  \"tpe\": {\n    \"image\": \"", target_registry, "docker.io/kubeflowkatib/suggestion-hyperopt:v0.15.0\"\n  },\n  \"grid\": {\n    \"image\": \"", target_registry, "docker.io/kubeflowkatib/suggestion-chocolate:v0.15.0\"\n  },\n  \"hyperband\": {\n    \"image\": \"", target_registry, "docker.io/kubeflowkatib/suggestion-hyperband:v0.15.0\"\n  },\n  \"bayesianoptimization\": {\n    \"image\": \"", target_registry, "docker.io/kubeflowkatib/suggestion-skopt:v0.15.0\"\n  },\n  \"cmaes\": {\n    \"image\": \"", target_registry, "docker.io/kubeflowkatib/suggestion-goptuna:v0.15.0\"\n  },\n  \"sobol\": {\n    \"image\": \"", target_registry, "docker.io/kubeflowkatib/suggestion-goptuna:v0.15.0\"\n  },\n  \"multivariate-tpe\": {\n    \"image\": \"", target_registry, "docker.io/kubeflowkatib/suggestion-optuna:v0.15.0\"\n  },\n  \"enas\": {\n    \"image\": \"", target_registry, "docker.io/kubeflowkatib/suggestion-enas:v0.15.0\",\n    \"resources\": {\n      \"limits\": {\n        \"memory\": \"200Mi\"\n      }\n    }\n  },\n  \"darts\": {\n    \"image\": \"", target_registry, "docker.io/kubeflowkatib/suggestion-darts:v0.15.0\"\n  }\n}"])
    },
    "kind": "ConfigMap",
    "metadata": {
      "name": "katib-config",
      "namespace": "kubeflow"
    }
  },
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
        "labels": {
        "katib.kubeflow.org/component": "controller"
        },
        "name": "katib-controller",
        "namespace": "kubeflow"
    },
    "spec": {
        "replicas": 1,
        "selector": {
        "matchLabels": {
            "katib.kubeflow.org/component": "controller"
        }
        },
        "template": {
        "metadata": {
            "annotations": {
            "prometheus.io/port": "8080",
            "prometheus.io/scrape": "true",
            "sidecar.istio.io/inject": "false"
            },
            "labels": {
            "katib.kubeflow.org/component": "controller"
            }
        },
        "spec": {
            "containers": [
            {
                "args": [
                std.join("", ["--zap-log-level=", log_level]),    
                "--webhook-port=8443",
                "--trial-resources=Job.v1.batch",
                "--trial-resources=TFJob.v1.kubeflow.org",
                "--trial-resources=PyTorchJob.v1.kubeflow.org",
                "--trial-resources=MPIJob.v1.kubeflow.org",
                "--trial-resources=XGBoostJob.v1.kubeflow.org",
                "--trial-resources=MXJob.v1.kubeflow.org"
                ],
                "command": [
                "./katib-controller"
                ],
                "env": [
                {
                    "name": "KATIB_CORE_NAMESPACE",
                    "valueFrom": {
                    "fieldRef": {
                        "fieldPath": "metadata.namespace"
                    }
                    }
                }
                ],
                "image": std.join("", [target_registry, "docker.io/tmaxcloudck/katib-controller:v0.15-lls"]),
                "name": "katib-controller",
                "ports": [
                {
                    "containerPort": 8443,
                    "name": "webhook",
                    "protocol": "TCP"
                },
                {
                    "containerPort": 8080,
                    "name": "metrics",
                    "protocol": "TCP"
                }
                ],
                "resources": {
                    "limits": {
                        "cpu": "1",
                        "memory": "4Gi"
                    },
                    "requests": {
                        "cpu": "30m",
                        "memory": "400Mi"
                    }
                },
                "volumeMounts": [
                {
                    "mountPath": "/tmp/cert",
                    "name": "cert",
                    "readOnly": true
                },
                {
                    "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                    "name": "katib-controller-token",
                    "readOnly": true
                }
                ] + (
                    if time_zone != "UTC" then [
                    {
                        "name": "timezone-config",
                        "mountPath": "/etc/localtime"
                    },
                    ] else []
                )
            }
            ],
            "volumes": [
            {
                "name": "cert",
                "secret": {
                "defaultMode": 420,
                "secretName": "katib-webhook-cert"
                }
            },
            {
                "name": "katib-controller-token",
                "secret": {
                "defaultMode": 420,
                "secretName": "katib-controller-token"
                }
            }
            ] + (
                if time_zone != "UTC" then [
                {
                    "name": "timezone-config",
                    "hostPath": {
                    "path": std.join("", ["/usr/share/zoneinfo/", time_zone])
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
    "kind": "Deployment",
    "metadata": {
        "labels": {
        "katib.kubeflow.org/component": "db-manager"
        },
        "name": "katib-db-manager",
        "namespace": "kubeflow"
    },
    "spec": {
        "replicas": 1,
        "selector": {
        "matchLabels": {
            "katib.kubeflow.org/component": "db-manager"
        }
        },
        "template": {
        "metadata": {
            "annotations": {
            "sidecar.istio.io/inject": "false"
            },
            "labels": {
            "katib.kubeflow.org/component": "db-manager"
            }
        },
        "spec": {
            "containers": [
            {
                "command": [
                "./katib-db-manager"
                ],
                "args": [
                  std.join("", ["--log-level=", log_level])
                ],
                "env": [
                {
                    "name": "DB_NAME",
                    "value": "mysql"
                },
                {
                    "name": "DB_PASSWORD",
                    "valueFrom": {
                    "secretKeyRef": {
                        "key": "MYSQL_ROOT_PASSWORD",
                        "name": "katib-mysql-secrets"
                    }
                    }
                }
                ],
                "image": std.join("", [target_registry, "docker.io/tmaxcloudck/katib-db-manager:v0.15-lls"]),
                "livenessProbe": {
                "exec": {
                    "command": [
                    "/bin/grpc_health_probe",
                    "-addr=:6789"
                    ]
                },
                "failureThreshold": 5,
                "initialDelaySeconds": 10,
                "periodSeconds": 60
                },
                "name": "katib-db-manager",
                "resources": {
                    "limits": {
                        "cpu": "1",
                        "memory": "2Gi"
                    },
                    "requests": {
                        "cpu": "20m",
                        "memory": "100Mi"
                    }
                },
                "ports": [
                {
                    "containerPort": 6789,
                    "name": "api"
                }
                ]
            } + if time_zone != "UTC" then {
              "volumeMounts": [
                {
                  "name": "timezone-config",
                  "mountPath": "/etc/localtime"
                }
              ],
            } else {},
            ]
        } + if time_zone != "UTC" then {
          "volumes":[
            {
              "name": "timezone-config",
              "hostPath": {
                "path": std.join("", ["/usr/share/zoneinfo/", time_zone])
              },
            },
          ],
        } else {},
        }
    }
  },
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
        "labels": {
        "katib.kubeflow.org/component": "mysql"
        },
        "name": "katib-mysql",
        "namespace": "kubeflow"
    },
    "spec": {
        "replicas": 1,
        "selector": {
        "matchLabels": {
            "katib.kubeflow.org/component": "mysql"
        }
        },
        "strategy": {
        "type": "Recreate"
        },
        "template": {
        "metadata": {
            "annotations": {
            "sidecar.istio.io/inject": "false"
            },
            "labels": {
            "katib.kubeflow.org/component": "mysql"
            }
        },
        "spec": {
            "containers": [
            {
                "args": [
                "--datadir",
                "/var/lib/mysql/datadir"
                ],
                "env": [
                {
                    "name": "MYSQL_ROOT_PASSWORD",
                    "valueFrom": {
                    "secretKeyRef": {
                        "key": "MYSQL_ROOT_PASSWORD",
                        "name": "katib-mysql-secrets"
                    }
                    }
                },
                {
                    "name": "MYSQL_ALLOW_EMPTY_PASSWORD",
                    "value": "true"
                },
                {
                    "name": "MYSQL_DATABASE",
                    "value": "katib"
                }
                ],
                "image": std.join("", [target_registry, "docker.io/library/mysql:8.0.29"]),
                "livenessProbe": {
                "exec": {
                    "command": [
                    "/bin/bash",
                    "-c",
                    "mysqladmin ping -u root -p${MYSQL_ROOT_PASSWORD}"
                    ]
                },
                "failureThreshold": 10,
                "initialDelaySeconds": 10,
                "periodSeconds": 5
                },
                "name": "katib-mysql",
                "ports": [
                {
                    "containerPort": 3306,
                    "name": "dbapi"
                }
                ],
                "readinessProbe": {
                "exec": {
                    "command": [
                    "/bin/bash",
                    "-c",
                    std.join("", ["mysql -D ${MYSQL_DATABASE} -u root -p${MYSQL_ROOT_PASSWORD} -e 'SET GLOBAL log_error_verbosity = ", mysql_log_level, ";'"])
                    ]
                },
                "failureThreshold": 10,
                "initialDelaySeconds": 10,
                "periodSeconds": 5
                },
                "startupProbe": {
                "exec": {
                    "command": [
                    "/bin/bash",
                    "-c",
                    "mysqladmin ping -u root -p${MYSQL_ROOT_PASSWORD}"
                    ]
                },
                "failureThreshold": 60,
                "periodSeconds": 15
                },
                "resources": {
                    "limits": {
                        "cpu": "1",
                        "memory": "4Gi"
                    },
                    "requests": {
                        "cpu": "1",
                        "memory": "2Gi"
                    }
                },
                "volumeMounts": [
                {
                    "mountPath": "/var/lib/mysql",
                    "name": "katib-mysql"
                }
                ] + (
                if time_zone != "UTC" then [
                  {
                    "name": "timezone-config",
                    "mountPath": "/etc/localtime"
                  },
                ] else []
              )
            }
            ],
            "volumes": [
            {
                "name": "katib-mysql",
                "persistentVolumeClaim": {
                "claimName": "katib-mysql"
                }
            }
            ] + (
            if time_zone != "UTC" then [
              {
                "name": "timezone-config",
                "hostPath": {
                  "path": std.join("", ["/usr/share/zoneinfo/", time_zone])
                }
              }
            ] else []
          )
        }
        }
    }
  }
]    