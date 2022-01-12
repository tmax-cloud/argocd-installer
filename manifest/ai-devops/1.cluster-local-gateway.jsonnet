function (
    ai_devops_namespace="kubeflow",
    istio_namespace="istio-system",
    knative_namespace="knative-serving", 
    tmaxcloud_image_repo="docker.io/tmaxcloudck",
    istio_image_repo="docker.io/istio",
    gatewaySelector="ingressgateway",
    kubeflow_public_image_repo="gcr.io/kubeflow-images-public",
    katib_image_repo="docker.io/kubeflowkatib",
    katib_image_tag="v0.12.0",
    katib_object_image_tag="v0.11.0",
    mysql_deploy_image_repo="mysql",
    mysql_deploy_image_tag="8.0.27",
    argo_image_repo="docker.io/argoproj",
    argo_image_tag="v2.12.10",
    minio_image_repo="gcr.io/ml-pipeline/minio",
    minio_image_tag="RELEASE.2019-08-14T20-37-41Z-license-compliance",
    notebook_svc_type="Ingress",
    custom_domain_name="tmaxcloud.org",
    knative_serving_image_repo="gcr.io/knative-releases/knative.dev/serving/cmd",
    knative_istio_image_repo="gcr.io/knative-releases/knative.dev/net-istio/cmd",
    knative_serving_image_tag="v0.14.3",
    knative_istio_image_tag="v0.14.1",
    kfserving_image_tag="v0.5.1",
    kfserving_gcr_image_repo="gcr.io/kfserving",
    kfserving_docker_image_repo="docker.io/kfserving",
    kube_rbac_proxy_image_repo="gcr.io/kubebuilder/kube-rbac-proxy",
    kube_rbac_proxy_image_tag="v0.4.0",
    tensorflow_image_repo="docker.io/tensorflow/serving",
    tensorflow_image_tag="1.14.0",
    tensorflow_image_gpu_tag="1.14.0-gpu",
    onnx_image_repo="mcr.microsoft.com/onnxruntime/server",
    onnx_image_tag="v1.0.0",
    mlserver_image_repo="docker.io/seldonio/mlserver",
    mlserver_image_tag="0.2.1",
    pytorch_server_image_gpu_tag="v0.5.1-gpu",
    torchserve_kfs_image_tag="0.3.0",
    torchserve_kfs_image_gpu_tag="0.3.0-gpu",
    triton_image_repo="nvcr.io/nvidia/tritonserver",
    triton_image_tag="20.08-py3"
)
[
    {
    "apiVersion": "v1",
    "kind": "Namespace",
    "metadata": {
        "labels": {
        "katib-metricscollector-injection": "enabled"
        },
        "name": ai_devops_namespace
    }
    },
    {
    "apiVersion": "v1",
    "kind": "ServiceAccount",
    "metadata": {
        "labels": {
        "app": "cluster-local-gateway",
        "kustomize.component": "cluster-local-gateway"
        },
        "name": "cluster-local-gateway-service-account",
        "namespace": istio_namespace
    }
    },
    {
    "apiVersion": "v1",
    "kind": "ServiceAccount",
    "metadata": {
        "labels": {
        "kustomize.component": "cluster-local-gateway"
        },
        "name": "istio-multi",
        "namespace": istio_namespace
    }
    },
    {
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRole",
    "metadata": {
        "labels": {
        "kustomize.component": "cluster-local-gateway"
        },
        "name": "istio-reader"
    },
    "rules": [
        {
        "apiGroups": [
            ""
        ],
        "resources": [
            "nodes",
            "pods",
            "services",
            "endpoints",
            "replicationcontrollers"
        ],
        "verbs": [
            "get",
            "watch",
            "list"
        ]
        },
        {
        "apiGroups": [
            "extensions",
            "apps"
        ],
        "resources": [
            "replicasets"
        ],
        "verbs": [
            "get",
            "list",
            "watch"
        ]
        }
    ]
    },
    {
    "apiVersion": "rbac.authorization.k8s.io/v1",
    "kind": "ClusterRoleBinding",
    "metadata": {
        "labels": {
        "kustomize.component": "cluster-local-gateway"
        },
        "name": "istio-multi"
    },
    "roleRef": {
        "apiGroup": "rbac.authorization.k8s.io",
        "kind": "ClusterRole",
        "name": "istio-reader"
    },
    "subjects": [
        {
        "kind": "ServiceAccount",
        "name": "istio-multi",
        "namespace": istio_namespace
        }
    ]
    },
    {
    "apiVersion": "v1",
    "data": {
        "namespace": istio_namespace
    },
    "kind": "ConfigMap",
    "metadata": {
        "labels": {
        "kustomize.component": "cluster-local-gateway"
        },
        "name": "cluster-local-gateway-config",
        "namespace": istio_namespace
    }
    },
    {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
        "labels": {
        "app": "cluster-local-gateway",
        "istio": "cluster-local-gateway",
        "kustomize.component": "cluster-local-gateway"
        },
        "name": "cluster-local-gateway",
        "namespace": istio_namespace
    },
    "spec": {
        "ports": [
        {
            "name": "http2",
            "port": 80,
            "targetPort": 80
        },
        {
            "name": "https",
            "port": 443
        },
        {
            "name": "tcp",
            "port": 31400
        },
        {
            "name": "tcp-pilot-grpc-tls",
            "port": 15011,
            "targetPort": 15011
        },
        {
            "name": "tcp-citadel-grpc-tls",
            "port": 8060,
            "targetPort": 8060
        },
        {
            "name": "http2-kiali",
            "port": 15029,
            "targetPort": 15029
        },
        {
            "name": "http2-prometheus",
            "port": 15030,
            "targetPort": 15030
        },
        {
            "name": "http2-grafana",
            "port": 15031,
            "targetPort": 15031
        },
        {
            "name": "http2-tracing",
            "port": 15032,
            "targetPort": 15032
        }
        ],
        "selector": {
        "app": "cluster-local-gateway",
        "istio": "cluster-local-gateway",
        "kustomize.component": "cluster-local-gateway"
        },
        "type": "ClusterIP"
    }
    },
    {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
        "labels": {
        "app": "cluster-local-gateway",
        "istio": "cluster-local-gateway",
        "kustomize.component": "cluster-local-gateway"
        },
        "name": "cluster-local-gateway",
        "namespace": istio_namespace
    },
    "spec": {
        "replicas": 1,
        "selector": {
        "matchLabels": {
            "app": "cluster-local-gateway",
            "istio": "cluster-local-gateway",
            "kustomize.component": "cluster-local-gateway"
        }
        },
        "strategy": {
        "rollingUpdate": {
            "maxSurge": null,
            "maxUnavailable": null
        }
        },
        "template": {
        "metadata": {
            "annotations": {
            "sidecar.istio.io/inject": "false"
            },
            "labels": {
            "app": "cluster-local-gateway",
            "istio": "cluster-local-gateway",
            "kustomize.component": "cluster-local-gateway"
            }
        },
        "spec": {
            "affinity": {
            "nodeAffinity": {
                "preferredDuringSchedulingIgnoredDuringExecution": [
                {
                    "preference": {
                    "matchExpressions": [
                        {
                        "key": "beta.kubernetes.io/arch",
                        "operator": "In",
                        "values": [
                            "amd64"
                        ]
                        }
                    ]
                    },
                    "weight": 2
                },
                {
                    "preference": {
                    "matchExpressions": [
                        {
                        "key": "beta.kubernetes.io/arch",
                        "operator": "In",
                        "values": [
                            "ppc64le"
                        ]
                        }
                    ]
                    },
                    "weight": 2
                },
                {
                    "preference": {
                    "matchExpressions": [
                        {
                        "key": "beta.kubernetes.io/arch",
                        "operator": "In",
                        "values": [
                            "s390x"
                        ]
                        }
                    ]
                    },
                    "weight": 2
                }
                ],
                "requiredDuringSchedulingIgnoredDuringExecution": {
                "nodeSelectorTerms": [
                    {
                    "matchExpressions": [
                        {
                        "key": "beta.kubernetes.io/arch",
                        "operator": "In",
                        "values": [
                            "amd64",
                            "ppc64le",
                            "s390x"
                        ]
                        }
                    ]
                    }
                ]
                }
            }
            },
            "containers": [
            {
                "args": [
                "proxy",
                "router",
                "--domain",
                "$(POD_NAMESPACE).svc.cluster.local",
                "--log_output_level=default:info",
                "--drainDuration",
                "45s",
                "--parentShutdownDuration",
                "1m0s",
                "--connectTimeout",
                "10s",
                "--serviceCluster",
                "cluster-local-gateway",
                "--zipkinAddress",
                "zipkin.istio-system:9411",
                "--proxyAdminPort",
                "15000",
                "--statusPort",
                "15020",
                "--controlPlaneAuthPolicy",
                "NONE",
                "--discoveryAddress",
                "istio-pilot.istio-system:15010"
                ],
                "env": [
                {
                    "name": "NODE_NAME",
                    "valueFrom": {
                    "fieldRef": {
                        "apiVersion": "v1",
                        "fieldPath": "spec.nodeName"
                    }
                    }
                },
                {
                    "name": "POD_NAME",
                    "valueFrom": {
                    "fieldRef": {
                        "apiVersion": "v1",
                        "fieldPath": "metadata.name"
                    }
                    }
                },
                {
                    "name": "POD_NAMESPACE",
                    "valueFrom": {
                    "fieldRef": {
                        "apiVersion": "v1",
                        "fieldPath": "metadata.namespace"
                    }
                    }
                },
                {
                    "name": "INSTANCE_IP",
                    "valueFrom": {
                    "fieldRef": {
                        "apiVersion": "v1",
                        "fieldPath": "status.podIP"
                    }
                    }
                },
                {
                    "name": "HOST_IP",
                    "valueFrom": {
                    "fieldRef": {
                        "apiVersion": "v1",
                        "fieldPath": "status.hostIP"
                    }
                    }
                },
                {
                    "name": "SERVICE_ACCOUNT",
                    "valueFrom": {
                    "fieldRef": {
                        "fieldPath": "spec.serviceAccountName"
                    }
                    }
                },
                {
                    "name": "ISTIO_META_POD_NAME",
                    "valueFrom": {
                    "fieldRef": {
                        "apiVersion": "v1",
                        "fieldPath": "metadata.name"
                    }
                    }
                },
                {
                    "name": "ISTIO_META_CONFIG_NAMESPACE",
                    "valueFrom": {
                    "fieldRef": {
                        "fieldPath": "metadata.namespace"
                    }
                    }
                },
                {
                    "name": "SDS_ENABLED",
                    "value": "false"
                },
                {
                    "name": "ISTIO_META_WORKLOAD_NAME",
                    "value": "cluster-local-gateway"
                },
                {
                    "name": "ISTIO_META_OWNER",
                    "value": "kubernetes://api/apps/v1/namespaces/istio-system/deployments/cluster-local-gateway"
                }
                ],
                "image": std.join("", [istio_image_repo, "/proxyv2:1.3.1"]),
                "imagePullPolicy": "ifNotPresent",
                "name": "istio-proxy",
                "ports": [
                {
                    "containerPort": 80
                },
                {
                    "containerPort": 443
                },
                {
                    "containerPort": 31400
                },
                {
                    "containerPort": 15011
                },
                {
                    "containerPort": 8060
                },
                {
                    "containerPort": 15029
                },
                {
                    "containerPort": 15030
                },
                {
                    "containerPort": 15031
                },
                {
                    "containerPort": 15032
                },
                {
                    "containerPort": 15090,
                    "name": "http-envoy-prom",
                    "protocol": "TCP"
                }
                ],
                "readinessProbe": {
                "failureThreshold": 30,
                "httpGet": {
                    "path": "/healthz/ready",
                    "port": 15020,
                    "scheme": "HTTP"
                },
                "initialDelaySeconds": 1,
                "periodSeconds": 2,
                "successThreshold": 1,
                "timeoutSeconds": 1
                },
                "resources": {
                "requests": {
                    "cpu": "10m"
                }
                },
                "volumeMounts": [
                {
                    "mountPath": "/etc/certs",
                    "name": "istio-certs",
                    "readOnly": true
                },
                {
                    "mountPath": "/etc/istio/clusterlocalgateway-certs",
                    "name": "clusterlocalgateway-certs",
                    "readOnly": true
                },
                {
                    "mountPath": "/etc/istio/clusterlocalgateway-ca-certs",
                    "name": "clusterlocalgateway-ca-certs",
                    "readOnly": true
                }
                ]
            }
            ],
            "serviceAccountName": "cluster-local-gateway-service-account",
            "volumes": [
            {
                "name": "istio-certs",
                "secret": {
                "optional": true,
                "secretName": "istio.cluster-local-gateway-service-account"
                }
            },
            {
                "name": "clusterlocalgateway-certs",
                "secret": {
                "optional": true,
                "secretName": "istio-clusterlocalgateway-certs"
                }
            },
            {
                "name": "clusterlocalgateway-ca-certs",
                "secret": {
                "optional": true,
                "secretName": "istio-clusterlocalgateway-ca-certs"
                }
            }
            ]
        }
        }
    }
    },
    {
    "apiVersion": "policy/v1beta1",
    "kind": "PodDisruptionBudget",
    "metadata": {
        "labels": {
        "app": "cluster-local-gateway",
        "istio": "cluster-local-gateway",
        "kustomize.component": "cluster-local-gateway"
        },
        "name": "cluster-local-gateway",
        "namespace": istio_namespace
    },
    "spec": {
        "minAvailable": 1,
        "selector": {
        "matchLabels": {
            "app": "cluster-local-gateway",
            "istio": "cluster-local-gateway",
            "kustomize.component": "cluster-local-gateway"
        }
        }
    }
    },
    {
    "apiVersion": "autoscaling/v2beta1",
    "kind": "HorizontalPodAutoscaler",
    "metadata": {
        "labels": {
        "app": "cluster-local-gateway",
        "istio": "cluster-local-gateway",
        "kustomize.component": "cluster-local-gateway"
        },
        "name": "cluster-local-gateway",
        "namespace": istio_namespace
    },
    "spec": {
        "maxReplicas": 5,
        "metrics": [
        {
            "resource": {
            "name": "cpu",
            "targetAverageUtilization": 80
            },
            "type": "Resource"
        }
        ],
        "minReplicas": 1,
        "scaleTargetRef": {
        "apiVersion": "apps/v1",
        "kind": "Deployment",
        "name": "cluster-local-gateway"
        }
    }
    }
]    