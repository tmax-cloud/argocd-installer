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
[
  {
  "apiVersion": "apps/v1",
  "kind": "StatefulSet",
  "metadata": {
    "labels": {
      "app": "kserve",
      "app.kubernetes.io/name": "kserve",
      "control-plane": "kserve-controller-manager",
      "controller-tools.k8s.io": "1.0"
    },
    "name": "kserve-controller-manager",
    "namespace": "kubeflow"
  },
  "spec": {
    "selector": {
      "matchLabels": {
        "app": "kserve",
        "app.kubernetes.io/name": "kserve",
        "control-plane": "kserve-controller-manager",
        "controller-tools.k8s.io": "1.0"
      }
    },
    "serviceName": "controller-manager-service",
    "template": {
      "metadata": {
        "annotations": {
          "sidecar.istio.io/inject": "false"
        },
        "labels": {
          "app": "kserve",
          "app.kubernetes.io/name": "kserve",
          "control-plane": "kserve-controller-manager",
          "controller-tools.k8s.io": "1.0"
        }
      },
      "spec": {
        "containers": [
          {
            "args": [
              "--metrics-addr=127.0.0.1:8080",
              std.join("", ["--zap-log-level=", log_level])
            ],
            "command": [
              "/manager"
            ],
            "env": [
              {
                "name": "POD_NAMESPACE",
                "valueFrom": {
                  "fieldRef": {
                    "fieldPath": "metadata.namespace"
                  }
                }
              },
              {
                "name": "SECRET_NAME",
                "value": "kserve-webhook-server-cert"
              }
            ],
            "image": std.join("", [target_registry, "docker.io/tmaxcloudck/kserve-controller-manager:b0.8.0-tw"]),
            "imagePullPolicy": "Always",
            "name": "manager",
            "ports": [
              {
                "containerPort": 9443,
                "name": "webhook-server",
                "protocol": "TCP"
              }
            ],
            "resources": {
              "limits": {
                "cpu": "100m",
                "memory": "300Mi"
              },
              "requests": {
                "cpu": "100m",
                "memory": "200Mi"
              }
            },
            "securityContext": {
              "allowPrivilegeEscalation": false
            },
            "volumeMounts": [
              {
                "mountPath": "/tmp/k8s-webhook-server/serving-certs",
                "name": "cert",
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
          },
          {
            "args": [
              "--secure-listen-address=0.0.0.0:8443",
              "--upstream=http://127.0.0.1:8080/",
              "--logtostderr=true",
              "--v=10"
            ],
            "image": std.join("", [target_registry, "gcr.io/kubebuilder/kube-rbac-proxy:v0.8.0"]),
            "name": "kube-rbac-proxy",
            "ports": [
              {
                "containerPort": 8443,
                "name": "https",
                "protocol": "TCP"
              }
            ]
          }
        ],
        "securityContext": {
          "runAsNonRoot": true
        },
        "serviceAccountName": "kserve-controller-manager",
        "terminationGracePeriodSeconds": 10,
        "volumes": [
          {
            "name": "cert",
            "secret": {
              "defaultMode": 420,
              "secretName": "kserve-webhook-server-cert"
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
  "apiVersion": "serving.kserve.io/v1alpha1",
  "kind": "ClusterServingRuntime",
  "metadata": {
    "name": "kserve-lgbserver"
  },
  "spec": {    
    "containers": [
      {
        "args": [
          "--model_name={{.Name}}",
          "--model_dir=/mnt/models",
          "--http_port=8080",
          "--nthread=1"
        ],
        "image": std.join("", [target_registry, "docker.io/kserve/lgbserver:v0.8.0"]),
        "name": "kserve-container",
        "resources": {
          "limits": {
            "cpu": "1",
            "memory": "2Gi"
          },
          "requests": {
            "cpu": "1",
            "memory": "2Gi"
          }
        }
      }
    ],    
    "supportedModelFormats": [
      {
        "autoSelect": true,
        "name": "lightgbm",
        "version": "3"
      }
    ]
  }
},
{
  "apiVersion": "serving.kserve.io/v1alpha1",
  "kind": "ClusterServingRuntime",
  "metadata": {
    "name": "kserve-mlserver"
  },
  "spec": {    
    "containers": [
      {
        "env": [
          {
            "name": "MLSERVER_MODEL_IMPLEMENTATION",
            "value": "{{.Labels.modelClass}}"
          },
          {
            "name": "MLSERVER_HTTP_PORT",
            "value": "8080"
          },
          {
            "name": "MLSERVER_GRPC_PORT",
            "value": "9000"
          },
          {
            "name": "MODELS_DIR",
            "value": "/mnt/models"
          }
        ],
        "image": std.join("", [target_registry, "docker.io/seldonio/mlserver:1.0.0"]),
        "name": "kserve-container",
        "resources": {
          "limits": {
            "cpu": "1",
            "memory": "2Gi"
          },
          "requests": {
            "cpu": "1",
            "memory": "2Gi"
          }
        }
      }
    ],    
    "supportedModelFormats": [
      {
        "autoSelect": true,
        "name": "sklearn",
        "version": "0"
      },
      {
        "autoSelect": true,
        "name": "xgboost",
        "version": "1"
      },
      {
        "autoSelect": true,
        "name": "lightgbm",
        "version": "3"
      },
      {
        "autoSelect": true,
        "name": "mlflow",
        "version": "1"
      }
    ]
  }
},
{
  "apiVersion": "serving.kserve.io/v1alpha1",
  "kind": "ClusterServingRuntime",
  "metadata": {
    "name": "kserve-paddleserver"
  },
  "spec": {    
    "containers": [
      {
        "args": [
          "--model_name={{.Name}}",
          "--model_dir=/mnt/models",
          "--http_port=8080"
        ],
        "image": std.join("", [target_registry, "docker.io/kserve/paddleserver:v0.8.0"]),
        "name": "kserve-container",
        "resources": {
          "limits": {
            "cpu": "1",
            "memory": "2Gi"
          },
          "requests": {
            "cpu": "1",
            "memory": "2Gi"
          }
        }
      }
    ],    
    "supportedModelFormats": [
      {
        "autoSelect": true,
        "name": "paddle",
        "version": "2"
      }
    ]
  }
},
{
  "apiVersion": "serving.kserve.io/v1alpha1",
  "kind": "ClusterServingRuntime",
  "metadata": {
    "name": "kserve-pmmlserver"
  },
  "spec": {    
    "containers": [
      {
        "args": [
          "--model_name={{.Name}}",
          "--model_dir=/mnt/models",
          "--http_port=8080"
        ],
        "image": std.join("", [target_registry, "docker.io/kserve/pmmlserver:v0.8.0"]),
        "name": "kserve-container",
        "resources": {
          "limits": {
            "cpu": "1",
            "memory": "2Gi"
          },
          "requests": {
            "cpu": "1",
            "memory": "2Gi"
          }
        }
      }
    ],    
    "supportedModelFormats": [
      {
        "autoSelect": true,
        "name": "pmml",
        "version": "3"
      },
      {
        "autoSelect": true,
        "name": "pmml",
        "version": "4"
      }
    ]
  }
},
{
  "apiVersion": "serving.kserve.io/v1alpha1",
  "kind": "ClusterServingRuntime",
  "metadata": {
    "name": "kserve-sklearnserver"
  },
  "spec": {    
    "containers": [
      {
        "args": [
          "--model_name={{.Name}}",
          "--model_dir=/mnt/models",
          "--http_port=8080"
        ],
        "image": std.join("", [target_registry, "docker.io/kserve/sklearnserver:v0.8.0"]),
        "name": "kserve-container",
        "resources": {
          "limits": {
            "cpu": "1",
            "memory": "2Gi"
          },
          "requests": {
            "cpu": "1",
            "memory": "2Gi"
          }
        }
      }
    ],
    "multiModel": true,    
    "supportedModelFormats": [
      {
        "autoSelect": true,
        "name": "sklearn",
        "version": "1"
      }
    ]
  }
},
{
  "apiVersion": "serving.kserve.io/v1alpha1",
  "kind": "ClusterServingRuntime",
  "metadata": {
    "name": "kserve-tensorflow-serving"
  },
  "spec": {    
    "containers": [
      {
        "args": [
          "--model_name={{.Name}}",
          "--port=9000",
          "--rest_api_port=8080",
          "--model_base_path=/mnt/models",
          "--rest_api_timeout_in_ms=60000"
        ],
        "command": [
          "/usr/bin/tensorflow_model_server"
        ],
        "image": std.join("", [target_registry, "docker.io/tensorflow/serving:2.6.2"]),
        "name": "kserve-container",
        "resources": {
          "limits": {
            "cpu": "1",
            "memory": "2Gi"
          },
          "requests": {
            "cpu": "1",
            "memory": "2Gi"
          }
        }
      }
    ],    
    "supportedModelFormats": [
      {
        "autoSelect": true,
        "name": "tensorflow",
        "version": "1"
      },
      {
        "autoSelect": true,
        "name": "tensorflow",
        "version": "2"
      }
    ]
  }
},
{
  "apiVersion": "serving.kserve.io/v1alpha1",
  "kind": "ClusterServingRuntime",
  "metadata": {
    "name": "kserve-torchserve"
  },
  "spec": {    
    "containers": [
      {
        "args": [
          "torchserve",
          "--start",
          "--model-store=/mnt/models/model-store",
          "--ts-config=/mnt/models/config/config.properties"
        ],
        "env": [
          {
            "name": "TS_SERVICE_ENVELOPE",
            "value": "{{.Labels.serviceEnvelope}}"
          }
        ],
        "image": std.join("", [target_registry, "docker.io/kserve/torchserve-kfs:0.5.3"]),
        "name": "kserve-container",
        "resources": {
          "limits": {
            "cpu": "1",
            "memory": "2Gi"
          },
          "requests": {
            "cpu": "1",
            "memory": "2Gi"
          }
        }
      }
    ],    
    "supportedModelFormats": [
      {
        "autoSelect": true,
        "name": "pytorch",
        "version": "1"
      }
    ]
  }
},
{
  "apiVersion": "serving.kserve.io/v1alpha1",
  "kind": "ClusterServingRuntime",
  "metadata": {
    "name": "kserve-tritonserver"
  },
  "spec": {    
    "containers": [
      {
        "args": [
          "tritonserver",
          "--model-store=/mnt/models",
          "--grpc-port=9000",
          "--http-port=8080",
          "--allow-grpc=true",
          "--allow-http=true"
        ],
        "image": std.join("", [target_registry, "nvcr.io/nvidia/tritonserver:21.09-py3"]),
        "name": "kserve-container",
        "resources": {
          "limits": {
            "cpu": "1",
            "memory": "2Gi"
          },
          "requests": {
            "cpu": "1",
            "memory": "2Gi"
          }
        }
      }
    ],
    "multiModel": true,    
    "supportedModelFormats": [
      {
        "autoSelect": true,
        "name": "tensorrt",
        "version": "8"
      },
      {
        "autoSelect": true,
        "name": "tensorflow",
        "version": "1"
      },
      {
        "autoSelect": true,
        "name": "tensorflow",
        "version": "2"
      },
      {
        "autoSelect": true,
        "name": "onnx",
        "version": "1"
      },
      {
        "name": "pytorch",
        "version": "1"
      },
      {
        "autoSelect": true,
        "name": "triton",
        "version": "2"
      }
    ]
  }
},
{
  "apiVersion": "serving.kserve.io/v1alpha1",
  "kind": "ClusterServingRuntime",
  "metadata": {
    "name": "kserve-xgbserver"
  },
  "spec": {    
    "containers": [
      {
        "args": [
          "--model_name={{.Name}}",
          "--model_dir=/mnt/models",
          "--http_port=8080",
          "--nthread=1"
        ],
        "image": std.join("", [target_registry, "docker.io/kserve/xgbserver:v0.8.0"]),
        "name": "kserve-container",
        "resources": {
          "limits": {
            "cpu": "1",
            "memory": "2Gi"
          },
          "requests": {
            "cpu": "1",
            "memory": "2Gi"
          }
        }
      }
    ],
    "multiModel": true,    
    "supportedModelFormats": [
      {
        "autoSelect": true,
        "name": "xgboost",
        "version": "1"
      }
    ]
  }
},
{
  "apiVersion": "v1",
  "data": {
    "agent": std.join("", ["{\n    \"image\" : \"", target_registry, "docker.io/kserve/agent:v0.8.0\",\n    \"memoryRequest\": \"100Mi\",\n    \"memoryLimit\": \"1Gi\",\n    \"cpuRequest\": \"100m\",\n    \"cpuLimit\": \"1\"\n}"]),
    "batcher": std.join("", ["{\n    \"image\" : \"", target_registry, "docker.io/kserve/agent:v0.8.0\",\n    \"memoryRequest\": \"1Gi\",\n    \"memoryLimit\": \"1Gi\",\n    \"cpuRequest\": \"1\",\n    \"cpuLimit\": \"1\"\n}"]),
    "credentials": "{\n   \"gcs\": {\n       \"gcsCredentialFileName\": \"gcloud-application-credentials.json\"\n   },\n   \"s3\": {\n       \"s3AccessKeyIDName\": \"AWS_ACCESS_KEY_ID\",\n       \"s3SecretAccessKeyName\": \"AWS_SECRET_ACCESS_KEY\"\n   }\n}",
    "deploy": "{\n  \"defaultDeploymentMode\": \"Serverless\"\n}",
    "explainers": std.join("", ["{\n    \"alibi\": {\n        \"image\" : \"", target_registry, "docker.io/kserve/alibi-explainer\",\n        \"defaultImageVersion\": \"v0.8.0\"\n    },\n    \"aix\": {\n        \"image\" : \"", target_registry, "docker.io/kserve/aix-explainer\",\n        \"defaultImageVersion\": \"v0.8.0\"\n    },\n    \"art\": {\n        \"image\" : \"", target_registry, "docker.io/kserve/art-explainer\",\n        \"defaultImageVersion\": \"v0.8.0\"\n    }\n}"]),
    "ingress": "{\n    \"ingressGateway\" : \"kubeflow/kubeflow-gateway\",\n    \"ingressService\" : \"ingressgateway.istio-system.svc.cluster.local\",\n    \"localGateway\" : \"knative-serving/knative-local-gateway\",\n    \"localGatewayService\" : \"knative-local-gateway.istio-system.svc.cluster.local\",\n    \"ingressDomain\"  : \"example.com\"\n}",
    "logger": std.join("", ["{\n    \"image\" : \"", target_registry, "docker.io/kserve/agent:v0.8.0\",\n    \"memoryRequest\": \"100Mi\",\n    \"memoryLimit\": \"1Gi\",\n    \"cpuRequest\": \"100m\",\n    \"cpuLimit\": \"1\",\n    \"defaultUrl\": \"http://default-broker\"\n}"]),
    "predictors": std.join("", ["{\n    \"tensorflow\": {\n        \"image\": \"", target_registry, "docker.io/tensorflow/serving\",\n        \"defaultImageVersion\": \"2.6.2\",\n        \"defaultGpuImageVersion\": \"2.6.2-gpu\",\n        \"defaultTimeout\": \"60\",\n        \"supportedFrameworks\": [\n          \"tensorflow\"\n        ],\n        \"multiModelServer\": false\n    },\n    \"onnx\": {\n        \"image\": \"", target_registry, "mcr.microsoft.com/onnxruntime/server\",\n        \"defaultImageVersion\": \"v1.0.0\",\n        \"supportedFrameworks\": [\n          \"onnx\"\n        ],\n        \"multiModelServer\": false\n    },\n    \"sklearn\": {\n      \"v1\": {\n        \"image\": \"", target_registry, "docker.io/kserve/sklearnserver\",\n        \"defaultImageVersion\": \"v0.8.0\",\n        \"supportedFrameworks\": [\n          \"sklearn\"\n        ],\n        \"multiModelServer\": true\n      },\n      \"v2\": {\n        \"image\": \"", target_registry, "docker.io/seldonio/mlserver\",\n        \"defaultImageVersion\": \"0.5.3\",\n        \"supportedFrameworks\": [\n          \"sklearn\"\n        ],\n        \"multiModelServer\": true\n      }\n    },\n    \"xgboost\": {\n      \"v1\": {\n        \"image\": \"", target_registry, "docker.io/kserve/xgbserver\",\n        \"defaultImageVersion\": \"v0.8.0\",\n        \"supportedFrameworks\": [\n          \"xgboost\"\n        ],\n        \"multiModelServer\": true\n      },\n      \"v2\": {\n        \"image\": \"", target_registry, "docker.io/seldonio/mlserver\",\n        \"defaultImageVersion\": \"0.5.3\",\n        \"supportedFrameworks\": [\n          \"xgboost\"\n        ],\n        \"multiModelServer\": true\n      }\n    },\n    \"pytorch\": {\n      \"v1\" : {\n        \"image\": \"", target_registry, "docker.io/kserve/torchserve-kfs\",\n        \"defaultImageVersion\": \"0.5.3\",\n        \"defaultGpuImageVersion\": \"0.5.3-gpu\",\n        \"supportedFrameworks\": [\n          \"pytorch\"\n        ],\n        \"multiModelServer\": false\n      },\n      \"v2\" : {\n        \"image\": \"", target_registry, "docker.io/kserve/torchserve-kfs\",\n        \"defaultImageVersion\": \"0.5.3\",\n        \"defaultGpuImageVersion\": \"0.5.3-gpu\",\n        \"supportedFrameworks\": [\n          \"pytorch\"\n        ],\n        \"multiModelServer\": false\n      }\n    },\n    \"triton\": {\n        \"image\": \"", target_registry, "nvcr.io/nvidia/tritonserver\",\n        \"defaultImageVersion\": \"21.09-py3\",\n        \"supportedFrameworks\": [\n          \"tensorrt\",\n          \"tensorflow\",\n          \"onnx\",\n          \"pytorch\"\n        ],\n        \"multiModelServer\": true\n    },\n    \"pmml\": {\n        \"image\": \"", target_registry, "docker.io/kserve/pmmlserver\",\n        \"defaultImageVersion\": \"v0.8.0\",\n        \"supportedFrameworks\": [\n          \"pmml\"\n        ],\n        \"multiModelServer\": false\n    },\n    \"lightgbm\": {\n        \"image\": \"", target_registry, "docker.io/kserve/lgbserver\",\n        \"defaultImageVersion\": \"v0.8.0\",\n        \"supportedFrameworks\": [\n          \"lightgbm\"\n        ],\n        \"multiModelServer\": false\n    },\n    \"paddle\": {\n        \"image\": \"", target_registry, "docker.io/kserve/paddleserver\",\n        \"defaultImageVersion\": \"v0.8.0\",\n        \"supportedFrameworks\": [\n          \"paddle\"\n        ],\n        \"multiModelServer\": false\n    }\n}"]),
    "storageInitializer": std.join("", ["{\n    \"image\" : \"", target_registry, "docker.io/kserve/storage-initializer:v0.8.0\",\n    \"memoryRequest\": \"100Mi\",\n    \"memoryLimit\": \"1Gi\",\n    \"cpuRequest\": \"100m\",\n    \"cpuLimit\": \"1\"\n}"]),
    "transformers": "{\n}"
  },
  "kind": "ConfigMap",
  "metadata": {
    "labels": {
      "app": "kserve",
      "app.kubernetes.io/name": "kserve"
    },
    "name": "inferenceservice-config",
    "namespace": "kubeflow"
  }
}
]    