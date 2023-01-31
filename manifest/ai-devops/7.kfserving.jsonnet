function (    
    is_offline="false",
    private_registry="172.22.6.2:5000",    
    custom_domain_name="tmaxcloud.org",    
    tmax_client_secret="tmax_client_secret",
    hyperauth_url="172.23.4.105",
    hyperauth_realm="tmax",
    console_subdomain="console",    
    gatekeeper_log_level="info",    
    gatekeeper_version="v1.0.2"
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";
[
    {
  "apiVersion": "apps/v1",
  "kind": "Deployment",
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
    "template": {
      "metadata": {
        "annotations": {
          "kubectl.kubernetes.io/default-container": "manager",
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
              "--leader-elect"
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
            "image": std.join("", [target_registry, "docker.io/kserve/kserve-controller:v0.10.0"]),
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
            ]
          },
          {
            "args": [
              "--secure-listen-address=0.0.0.0:8443",
              "--upstream=http://127.0.0.1:8080/",
              "--logtostderr=true",
              "--v=10"
            ],
            "image": std.join("", [target_registry, "gcr.io/kubebuilder/kube-rbac-proxy:v0.13.1"]),
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
        ]
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
    "annotations": {
      "prometheus.kserve.io/path": "/metrics",
      "prometheus.kserve.io/port": "8080"
    },
    "containers": [
      {
        "args": [
          "--model_name={{.Name}}",
          "--model_dir=/mnt/models",
          "--http_port=8080",
          "--nthread=1"
        ],
        "image": std.join("", [target_registry, "docker.io/kserve/lgbserver:v0.10.0"]),
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
    "protocolVersions": [
      "v1"
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
    "annotations": {
      "prometheus.kserve.io/path": "/metrics",
      "prometheus.kserve.io/port": "8080"
    },
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
    "protocolVersions": [
      "v2"
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
    "annotations": {
      "prometheus.kserve.io/path": "/metrics",
      "prometheus.kserve.io/port": "8080"
    },
    "containers": [
      {
        "args": [
          "--model_name={{.Name}}",
          "--model_dir=/mnt/models",
          "--http_port=8080"
        ],
        "image": std.join("", [target_registry, "docker.io/kserve/paddleserver:v0.10.0"]),
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
    "protocolVersions": [
      "v1"
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
    "annotations": {
      "prometheus.kserve.io/path": "/metrics",
      "prometheus.kserve.io/port": "8080"
    },
    "containers": [
      {
        "args": [
          "--model_name={{.Name}}",
          "--model_dir=/mnt/models",
          "--http_port=8080"
        ],
        "image": std.join("", [target_registry, "docker.io/kserve/pmmlserver:v0.10.0"]),
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
    "protocolVersions": [
      "v1"
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
    "annotations": {
      "prometheus.kserve.io/path": "/metrics",
      "prometheus.kserve.io/port": "8080"
    },
    "containers": [
      {
        "args": [
          "--model_name={{.Name}}",
          "--model_dir=/mnt/models",
          "--http_port=8080"
        ],
        "image": std.join("", [target_registry, "docker.io/kserve/sklearnserver:v0.10.0"]),
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
    "protocolVersions": [
      "v1"
    ],
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
    "annotations": {
      "prometheus.kserve.io/path": "/metrics",
      "prometheus.kserve.io/port": "8080"
    },
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
    "protocolVersions": [
      "v1",
      "grpc-v1"
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
    "annotations": {
      "prometheus.kserve.io/path": "/metrics",
      "prometheus.kserve.io/port": "8082"
    },
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
        "image": std.join("", [target_registry, "docker.io/pytorch/torchserve-kfs:0.7.0"]),
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
    "protocolVersions": [
      "v1",
      "v2",
      "grpc-v1"
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
    "annotations": {
      "prometheus.kserve.io/path": "/metrics",
      "prometheus.kserve.io/port": "8002"
    },
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
    "protocolVersions": [
      "v2",
      "grpc-v2"
    ],
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
    "annotations": {
      "prometheus.kserve.io/path": "/metrics",
      "prometheus.kserve.io/port": "8080"
    },
    "containers": [
      {
        "args": [
          "--model_name={{.Name}}",
          "--model_dir=/mnt/models",
          "--http_port=8080",
          "--nthread=1"
        ],
        "image": std.join("", [target_registry, "docker.io/kserve/xgbserver:v0.10.0"]),
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
    "protocolVersions": [
      "v1"
    ],
    "supportedModelFormats": [
      {
        "autoSelect": true,
        "name": "xgboost",
        "version": "1"
      }
    ]
  }
}
]    