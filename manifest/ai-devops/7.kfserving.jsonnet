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
        "apiVersion": "v1",
        "data": {
            "agent": std.join("", ["{\n    \"image\" : \"", target_registry, "docker.io/kserve/agent:v0.10.0\",\n    \"memoryRequest\": \"100Mi\",\n    \"memoryLimit\": \"1Gi\",\n    \"cpuRequest\": \"100m\",\n    \"cpuLimit\": \"1\"\n}"]),
            "batcher": std.join("", ["{\n    \"image\" : \"", target_registry, "docker.io/kserve/agent:v0.10.0\",\n    \"memoryRequest\": \"1Gi\",\n    \"memoryLimit\": \"1Gi\",\n    \"cpuRequest\": \"1\",\n    \"cpuLimit\": \"1\"\n}"]),
            "credentials": "{\n   \"gcs\": {\n       \"gcsCredentialFileName\": \"gcloud-application-credentials.json\"\n   },\n   \"s3\": {\n       \"s3AccessKeyIDName\": \"AWS_ACCESS_KEY_ID\",\n       \"s3SecretAccessKeyName\": \"AWS_SECRET_ACCESS_KEY\"\n   }\n}",
            "explainers": std.join("", ["{\n    \"alibi\": {\n        \"image\" : \"", target_registry, "docker.io/kserve/alibi-explainer\",\n        \"defaultImageVersion\": \"v0.10.0\"\n    },\n    \"aix\": {\n        \"image\" : \"", target_registry, "docker.io/kserve/aix-explainer\",\n        \"defaultImageVersion\": \"v0.10.0\"\n    },\n    \"art\": {\n        \"image\" : \"", target_registry, "docker.io/kserve/art-explainer\",\n        \"defaultImageVersion\": \"v0.10.0\"\n    }\n}"]),
            "ingress": "{\n    \"ingressGateway\" : \"kubeflow-gateway.kubeflow\",\n    \"ingressService\" : \"ingressgateway.istio-system.svc.cluster.local\",\n    \"localGateway\" : \"cluster-local-gateway.knative-serving\",\n    \"localGatewayService\" : \"cluster-local-gateway.istio-system.svc.cluster.local\"\n}",
            "logger": std.join("", ["{\n    \"image\" : \"", target_registry, "docker.io/kserve/agent:v0.10.0\",\n    \"memoryRequest\": \"100Mi\",\n    \"memoryLimit\": \"1Gi\",\n    \"cpuRequest\": \"100m\",\n    \"cpuLimit\": \"1\",\n    \"defaultUrl\": \"http://default-broker\"\n}"]),
            "predictors": std.join("", ["{\n    \"tensorflow\": {\n        \"image\": \"", target_registry, "docker.io/tensorflow/serving\",\n        \"defaultImageVersion\": \"1.14.0\",\n        \"defaultGpuImageVersion\": \"1.14.0-gpu\",\n        \"defaultTimeout\": \"60\",\n        \"supportedFrameworks\": [\n          \"tensorflow\"\n        ],\n        \"multiModelServer\": false\n    },\n    \"onnx\": {\n        \"image\": \"", target_registry, "mcr.microsoft.com/onnxruntime/server\",\n        \"defaultImageVersion\": \"v1.0.0\",\n        \"supportedFrameworks\": [\n          \"onnx\"\n        ],\n        \"multiModelServer\": false\n    },\n    \"sklearn\": {\n      \"v1\": {\n        \"image\": \"", target_registry, "docker.io/kserve/sklearnserver\",\n        \"defaultImageVersion\": \"v0.10.0\",\n        \"supportedFrameworks\": [\n          \"sklearn\"\n        ],\n        \"multiModelServer\": false\n      },\n      \"v2\": {\n        \"image\": \"", target_registry, "docker.io/seldonio/mlserver\",\n        \"defaultImageVersion\": \"0.2.1\",\n        \"supportedFrameworks\": [\n          \"sklearn\"\n        ],\n        \"multiModelServer\": false\n      }\n    },\n    \"xgboost\": {\n      \"v1\": {\n        \"image\": \"", target_registry, "docker.io/kserve/xgbserver\",\n        \"defaultImageVersion\": \"v0.10.0\",\n        \"supportedFrameworks\": [\n          \"xgboost\"\n        ],\n        \"multiModelServer\": false\n      },\n      \"v2\": {\n        \"image\": \"", target_registry, "docker.io/seldonio/mlserver\",\n        \"defaultImageVersion\": \"0.2.1\",\n        \"supportedFrameworks\": [\n          \"xgboost\"\n        ],\n        \"multiModelServer\": false\n      }\n    },\n    \"pytorch\": {\n      \"v1\" : {\n        \"image\": \"", target_registry, "docker.io/kserve/pytorchserver\",\n        \"defaultImageVersion\": \"v0.10.0\",\n        \"defaultGpuImageVersion\": \"v0.10.0-gpu\",\n        \"supportedFrameworks\": [\n          \"pytorch\"\n        ],\n        \"multiModelServer\": false\n      },\n      \"v2\" : {\n        \"image\": \"", target_registry, "docker.io/kserve/torchserve-kfs\",\n        \"defaultImageVersion\": \"0.3.0\",\n        \"defaultGpuImageVersion\": \"0.3.0-gpu\",\n        \"supportedFrameworks\": [\n          \"pytorch\"\n        ],\n        \"multiModelServer\": false\n      }\n    },\n    \"triton\": {\n        \"image\": \"", target_registry, "nvcr.io/nvidia/tritonserver\",\n        \"defaultImageVersion\": \"20.08-py3\",\n        \"supportedFrameworks\": [\n          \"tensorrt\",\n          \"tensorflow\",\n          \"onnx\",\n          \"pytorch\",\n          \"caffe2\"\n        ],\n        \"multiModelServer\": true\n    },\n    \"pmml\": {\n        \"image\": \"", target_registry, "docker.io/kserve/pmmlserver\",\n        \"defaultImageVersion\": \"v0.10.0\",\n        \"supportedFrameworks\": [\n          \"pmml\"\n        ],\n        \"multiModelServer\": false\n    },\n    \"lightgbm\": {\n        \"image\": \"", target_registry, "docker.io/kserve/lgbserver\",\n        \"defaultImageVersion\": \"v0.10.0\",\n        \"supportedFrameworks\": [\n          \"lightgbm\"\n        ],\n        \"multiModelServer\": false\n    }\n}"]),
            "storageInitializer": std.join("", ["{\n    \"image\" : \"", target_registry, "docker.io/kserve/storage-initializer:v0.10.0\",\n    \"memoryRequest\": \"100Mi\",\n    \"memoryLimit\": \"1Gi\",\n    \"cpuRequest\": \"100m\",\n    \"cpuLimit\": \"1\"\n}"]),
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
    },   
]