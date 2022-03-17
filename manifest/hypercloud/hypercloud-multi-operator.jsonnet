function (
    is_offline="false",
    private_registry="registry.hypercloud.org",
    hypercloud_hpcd_mode="multi",
    hypercloud_kafka_enabled="\"true\"",
    hyperauth_url="hyperauth.172.22.6.18.nip.io"
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";
local domain = std.strReplace(hyperauth_url, "hyperauth.", "");

[
    {
        "apiVersion": "apps/v1",
        "kind": "Deployment",
        "metadata": {
            "labels": {
                "hypercloud": "multi-operator"
            },
            "name": "hypercloud-multi-operator-controller-manager",
            "namespace": "hypercloud5-system"
        },
        "spec": {
            "replicas": 1,
            "selector": {
                "matchLabels": {
                    "hypercloud": "multi-operator"
                }
            },
            "template": {
                "metadata": {
                    "labels": {
                        "hypercloud": "multi-operator"
                    }
                },
                "spec": {
                    "containers": [
                        {
                            "args": [
                                "--metrics-addr=127.0.0.1:8080",
                                "--enable-leader-election"
                            ],
                            "command": [
                                "/manager"
                            ],
                            "env": [
                                {
                                    "name": "TZ",
                                    "value": "Asia/Seoul"
                                },
                                {
                                    "name": "HC_DOMAIN",
                                    "value": domain
                                },
                            ],
                            "image": std.join("", [target_registry, "docker.io/tmaxcloudck/hypercloud-multi-operator:b5.0.26.6"]),
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
                                    "memory": "50Mi"
                                },
                                "requests": {
                                    "cpu": "100m",
                                    "memory": "20Mi"
                                }
                            },
                            "volumeMounts": [
                                {
                                    "mountPath": "/tmp/k8s-webhook-server/serving-certs",
                                    "name": "cert",
                                    "readOnly": true
                                },
                                {
                                    "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                                    "name": "hypercloud-multi-operator-controller-manager-token",
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
                            "image": std.join("", [target_registry, "gcr.io/kubebuilder/kube-rbac-proxy:v0.5.0"]),
                            "name": "kube-rbac-proxy",
                            "ports": [
                                {
                                    "containerPort": 8443,
                                    "name": "https"
                                }
                            ],
                            "resources": {
                                "limits": {
                                    "cpu": "100m",
                                    "memory": "30Mi"
                                },
                                "requests": {
                                    "cpu": "100m",
                                    "memory": "20Mi"
                                }
                            },
                            "volumeMounts": [
                                {
                                    "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                                    "name": "hypercloud-multi-operator-controller-manager-token",
                                    "readOnly": true
                                }
                            ]
                        }
                    ],
                    "serviceAccountName": "hypercloud-multi-operator-controller-manager",
                    "terminationGracePeriodSeconds": 10,
                    "volumes": [
                        {
                            "name": "cert",
                            "secret": {
                                "defaultMode": 420,
                                "secretName": "hypercloud-multi-operator-webhook-server-cert"
                            }
                        },
                        {
                            "name": "hypercloud-multi-operator-controller-manager-token",
                            "secret": {
                                "defaultMode": 420,
                                "secretName": "hypercloud-multi-operator-controller-manager-token"
                            }
                        }
                    ]
                }
            }
        }
    }
]