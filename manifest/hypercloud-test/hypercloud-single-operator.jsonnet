function (
    is_offline="false",
    private_registry="registry.hypercloud.org",
    hypercloud_hpcd_mode="multi",
    hypercloud_kafka_enabled="\"true\"",
    hyperauth_url="hyperauth.172.22.6.18.nip.io"
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";

{
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
        "labels": {
            "hypercloud": "single-operator"
        },
        "name": "hypercloud-single-operator-controller-manager",
        "namespace": "hypercloud5-system"
    },
    "spec": {
        "replicas": 1,
        "selector": {
            "matchLabels": {
                "hypercloud": "single-operator"
            }
        },
        "template": {
            "metadata": {
                "labels": {
                    "hypercloud": "single-operator"
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
                        "image": std.join("", [target_registry, "docker.io/tmaxcloudck/hypercloud-single-operator:b5.0.25.16"]),
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
                                "cpu": "200m",
                                "memory": "100Mi"
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
                                "name": "hypercloud-single-operator-service-account-token",
                                "readOnly": true
                            },
                            {
                                "mountPath": "/logs",
                                "name": "operator-log-mnt"
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
                        }
                    }
                ],
                "dnsPolicy": "ClusterFirstWithHostNet",
                "serviceAccountName": "hypercloud-single-operator-service-account",
                "terminationGracePeriodSeconds": 10,
                "tolerations": [
                    {
                        "effect": "NoSchedule",
                        "key": "node-role.kubernetes.io/master",
                        "operator": "Equal"
                    }
                ],
                "volumes": [
                    {
                        "name": "cert",
                        "secret": {
                            "defaultMode": 420,
                            "secretName": "hypercloud-single-operator-webhook-server-cert"
                        }
                    },
                    {
                        "name": "hypercloud-single-operator-service-account-token",
                        "secret": {
                            "defaultMode": 420,
                            "secretName": "hypercloud-single-operator-service-account-token"
                        }
                    },
                    {
                        "name": "operator-log-mnt"
                    }
                ]
            }
        }
    }
}