function (
    is_offline="false",
    private_registry="registry.hypercloud.org",
    hypercloud_hpcd_mode="multi",
    hypercloud_kafka_enabled="\"true\"",
    hyperauth_url="hyperauth.172.22.6.18.nip.io"
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";

[
    {
        "apiVersion": "apps/v1",
        "kind": "Deployment",
        "metadata": {
            "name": "hypercloud5-api-server",
            "namespace": "hypercloud5-system",
            "labels": {
                "hypercloud5": "api-server",
                "name": "hypercloud5-api-server"
            }
        },
        "spec": {
            "replicas": 1,
            "selector": {
                "matchLabels": {
                    "hypercloud5": "api-server"
                }
            },
            "template": {
                "metadata": {
                    "name": "hypercloud5-api-server",
                    "namespace": "hypercloud5-system",
                    "labels": {
                        "hypercloud5": "api-server"
                    }
                },
                "spec": {
                    "serviceAccount": "hypercloud5-admin",
                    "containers": [
                        {
                            "name": "hypercloud5-api-server",
                            "image": std.join("", [target_registry, "docker.io/tmaxcloudck/hypercloud-api-server:b5.0.26.6"]),
                            "imagePullPolicy": "IfNotPresent",
                            "env": [
                                {
                                    "name": "TZ",
                                    "value": "Asia/Seoul"
                                },
                                {
                                    "name": "HC_MODE",
                                    "value": hypercloud_hpcd_mode
                                },
                                {
                                    "name": "INVITATION_TOKEN_EXPIRED_DATE",
                                    "value": "7days"
                                },
                                {
                                    "name": "GODEBUG",
                                    "value": "x509ignoreCN=0"
                                },
                                {
                                    "name": "SIDECAR_IMAGE",
                                    "value": "fluent/fluent-bit:1.5-debug"
                                },
                                {
                                    "name": "KAFKA_ENABLED",
                                    "value": hypercloud_kafka_enabled
                                },
                                {
                                    "name": "KAFKA_GROUP_ID",
                                    "value":"hypercloud-api-server"
                                }
                            ],
                            "ports": [
                                {
                                    "containerPort": 443,
                                    "name": "https"
                                }
                            ],
                            "resources": {
                                "limits": {
                                    "cpu": "500m",
                                    "memory": "500Mi"
                                },
                                "requests": {
                                    "cpu": "300m",
                                    "memory": "100Mi"
                                }
                            },
                            "volumeMounts": [
                                {
                                    "name": "version-config",
                                    "mountPath": "/go/src/version/version.config",
                                    "subPath": "version.config"
                                },
                                {
                                    "name": "kafka",
                                    "mountPath": "/go/src/etc/ssl",
                                    "readOnly": true
                                },
                                {
                                    "name": "hypercloud5-api-server-certs",
                                    "mountPath": "/run/secrets/tls",
                                    "readOnly": true
                                },
                                {
                                    "name": "token-secret",
                                    "mountPath": "/run/secrets/token",
                                    "readOnly": true
                                },
                                {
                                    "name": "smtp-secret",
                                    "mountPath": "/run/secrets/smtp",
                                    "readOnly": true
                                },
                                {
                                    "name": "html",
                                    "mountPath": "/run/configs/html",
                                    "readOnly": true
                                }
                            ]
                        }
                    ],
                    "volumes": [
                        {
                            "name": "html",
                            "configMap": {
                                "name": "html-config"
                            }
                        },
                        {
                            "name": "version-config",
                            "configMap": {
                                "name": "version-config"
                            }
                        },
                        {
                            "name": "hypercloud5-api-server-certs",
                            "secret": {
                                "secretName": "hypercloud5-api-server-certs"
                            }
                        },
                        {
                            "name": "smtp-secret",
                            "secret": {
                                "secretName": "smtp-secret",
                                "items": [
                                    {
                                        "key": "SMTP_USERNAME",
                                        "path": "username"
                                    },
                                    {
                                        "key": "SMTP_PASSWORD",
                                        "path": "password"
                                    }
                                ]
                            }
                        },
                        {
                            "name": "kafka",
                            "secret": {
                                "secretName": "hypercloud-kafka-secret"
                            }
                        },
                        {
                            "name": "token-secret",
                            "secret": {
                                "secretName": "token-secret",
                                "items": [
                                    {
                                        "key": "ACCESS_TOKEN",
                                        "path": "accessSecret"
                                    }
                                ]
                            }
                        }
                    ]
                }
            }
        }
    },
    {
        "apiVersion": "v1",
        "kind": "ConfigMap",
        "metadata": {
            "name": "version-config",
            "namespace": "hypercloud5-system"
        },
        "data": {
            "version.config": std.join("",
                [
                    "modules:\n",
                    "- name: Kubernetes\n",
                    "  namespace:\n",
                    "  selector:\n",
                    "    matchLabels:\n",
                    "      statusLabel:\n",
                    "      - component=kube-apiserver\n",
                    "      versionLabel:\n",
                    "      - component=kube-apiserver\n",
                    "  readinessProbe:\n\n",
                    "  versionProbe:\n\n",
                    "- name: HyperCloud API Server\n",
                    "  namespace: hypercloud5-system\n",
                    "  selector:\n",
                    "    matchLabels:\n",
                    "      statusLabel:\n",
                    "      - hypercloud5=api-server\n",
                    "      versionLabel:\n",
                    "      - hypercloud5=api-server\n",
                    "  readinessProbe:\n\n",
                    "  versionProbe:          \n\n",
                    "- name: HyperCloud Single Operator\n",
                    "  namespace: hypercloud5-system\n",
                    "  selector:\n",
                    "    matchLabels:\n",
                    "      statusLabel:\n",
                    "      - hypercloud=single-operator\n",
                    "      versionLabel:\n",
                    "      - hypercloud=single-operator\n",
                    "  readinessProbe:\n\n",
                    "  versionProbe:\n",
                    "    container: manager\n\n",
                    "- name: HyperCloud Multi Operator\n",
                    "  namespace: hypercloud5-system\n",
                    "  selector:\n",
                    "    matchLabels:\n",
                    "      statusLabel:\n",
                    "      - hypercloud=multi-operator\n",
                    "      versionLabel:\n",
                    "      - hypercloud=multi-operator\n",
                    "  readinessProbe:\n\n",
                    "  versionProbe:\n",
                    "    container: manager\n\n",
                    "- name: HyperCloud Console\n",
                    "  namespace: api-gateway-system\n",
                    "  selector:\n",
                    "    matchLabels:\n",
                    "      statusLabel:\n",
                    "      - app.kubernetes.io/name=console\n",
                    "      versionLabel:\n",
                    "      - app.kubernetes.io/name=console\n",
                    "  readinessProbe:\n\n",
                    "  versionProbe:\n",
                    "   container: console\n\n",
                    "- name: HyperAuth\n",
                    "  namespace:\n",
                    "  selector:\n",
                    "    matchLabels:\n",
                    "      statusLabel:\n",
                    "      versionLabel:\n",
                    "  readinessProbe:\n",
                    "    httpGet:\n",
                    "      path: ", hyperauth_url, "\n\n",
                    "- name: Calico\n",
                    "  namespace: kube-system\n",
                    "  selector:\n",
                    "    matchLabels:\n",
                    "      statusLabel:\n",
                    "      - k8s-app=calico-node\n",
                    "      versionLabel:\n",
                    "      - k8s-app=calico-node\n",
                    "  readinessProbe:\n\n",
                    "  versionProbe:\n\n",
                    "- name: MetalLB\n",
                    "  namespace: metallb-system\n",
                    "  selector:\n",
                    "    matchLabels:\n",
                    "      statusLabel:\n",
                    "      - app=metallb\n",
                    "      versionLabel:\n",
                    "      - app=metallb\n",
                    "  readinessProbe:\n\n",
                    "  versionProbe:\n\n",
                    "- name: API gateway\n",
                    "  namespace: api-gateway-system\n",
                    "  selector:\n",
                    "    matchLabels:\n",
                    "      statusLabel:\n",
                    "      - app.kubernetes.io/name=traefik\n",
                    "      versionLabel:\n",
                    "      - app.kubernetes.io/name=traefik\n",
                    "  readinessProbe:\n\n",
                    "  versionProbe:\n",
                    "    container: traefik\n\n",
                    "- name: Prometheus\n",
                    "  namespace: monitoring\n",
                    "  selector:\n",
                    "    matchLabels:\n",
                    "      statusLabel:\n",
                    "      - app=prometheus\n",
                    "      versionLabel:\n",
                    "      - app=prometheus\n",
                    "  readinessProbe:\n",
                    "    httpGet:\n",
                    "      path: /-/ready\n",
                    "      port: 9090\n",
                    "      scheme: HTTP\n",
                    "  versionProbe:\n",
                    "    container: prometheus\n\n",
                    "- name: Tekton\n",
                    "  namespace: tekton-pipelines\n",
                    "  selector:\n",
                    "    matchLabels:\n",
                    "      statusLabel:\n",
                    "      - app=tekton-pipelines-controller\n",
                    "      versionLabel:\n",
                    "      - app=tekton-pipelines-controller\n",
                    "  readinessProbe:\n\n",
                    "  versionProbe:\n\n",
                    "- name: Catalog-Controller\n",
                    "  namespace: catalog\n",
                    "  selector:\n",
                    "    matchLabels:\n",
                    "      statusLabel:\n",
                    "      - app=catalog-catalog-controller-manager\n",
                    "      versionLabel:\n",
                    "      - app=catalog-catalog-controller-manager\n",
                    "  readinessProbe:\n",
                    "    httpGet:\n",
                    "      path: /healthz/ready\n",
                    "      port: 8444\n",
                    "      scheme: HTTPS\n",
                    "  versionProbe:\n\n",
                    "- name: ClusterTemplateServiceBroker\n",
                    "  namespace: cluster-tsb-ns\n",
                    "  selector:\n",
                    "    matchLabels:\n",
                    "      statusLabel:\n",
                    "      - app=cluster-template-service-broker\n",
                    "      versionLabel:\n",
                    "      - app=cluster-template-service-broker\n",
                    "  readinessProbe:\n\n",
                    "  versionProbe:\n\n",
                    "- name: CAPI\n",
                    "  namespace: capi-system\n",
                    "  selector:\n",
                    "    matchLabels:\n",
                    "      statusLabel:\n",
                    "      - cluster.x-k8s.io/provider=cluster-api\n",
                    "      versionLabel:\n",
                    "      - cluster.x-k8s.io/provider=cluster-api\n",
                    "  readinessProbe:\n\n",
                    "  versionProbe:\n",
                    "    container: manager\n\n",
                    "- name: KubeFed\n",
                    "  namespace: kube-federation-system\n",
                    "  selector:\n",
                    "    matchLabels:\n",
                    "      statusLabel:\n",
                    "      - kubefed-control-plane=controller-manager\n",
                    "      versionLabel:\n",
                    "      - kubefed-control-plane=controller-manager\n",
                    "  readinessProbe:\n\n",
                    "  versionProbe:\n\n",
                    "- name: Grafana\n",
                    "  namespace: monitoring\n",
                    "  selector:\n",
                    "    matchLabels:\n",
                    "      statusLabel:\n",
                    "      - app=grafana\n",
                    "      versionLabel:\n",
                    "      - app=grafana\n",
                    "  readinessProbe:\n",
                    "    httpGet:\n",
                    "      path: /api/health\n",
                    "      port: 3000\n",
                    "  versionProbe:\n\n",
                    "- name: Kibana\n",
                    "  namespace: kube-logging\n",
                    "  selector:\n    matchLabels:\n",
                    "      statusLabel:\n",
                    "      - app=kibana\n",
                    "      versionLabel:\n",
                    "      - app=kibana\n",
                    "  readinessProbe:\n\n",
                    "  versionProbe:\n"
                ]
            )
        }
    }
]