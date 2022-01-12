function (
    hypercloud_image_repo="tmaxcloudck",
    hypercloud_image_name="hypercloud-api-server",
    hypercloud_image_tag="latest",
    hypercloud_hpcd_mode="multi",
    hypercloud_kafka_enabled="\"true\""
)

local svcType = if hyperauth_svc_type == "Ingress" then "ClusterIP" else hyperauth_svc_type;

[ 
  {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
        "name": "hypercloud5-api-server-service",
        "namespace": "hypercloud5-system"
    },
    "spec": {
        "ports": [
        {
            "port": 443,
            "targetPort": "https",
            "name": "https"
        }
        ],
        "selector": {
        "hypercloud5": "api-server"
        },
        "type": "ClusterIP"
    }
  },
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
                "image": std.join("", [hypercloud_image_repo, "/", hypercloud_image_name, ":", hypercloud_image_tag]),
                "imagePullPolicy": "IfNotPresent",
                "env": [
                {
                    "name": "TZ",
                    "value": "Asia/Seoul"
                },
                {
                    "name": "HC_MODE",
                    "value": {
                    "HPCD_MODE": hypercloud_hpcd_mode
                    }
                },
                {
                    "name": "INVITATION_TOKEN_EXPIRED_DATE",
                    "value": {
                    "INVITATION_TOKEN_EXPIRED_DATE": "7days"
                    }
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
                    "value": {
                    "KAFKA_GROUP_ID": "hypercloud-api-server"
                    }
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
    "kind": "Secret",
    "metadata": {
        "name": "smtp-secret",
        "namespace": "hypercloud5-system"
    },
    "type": "Opaque",
    "data": {
        "SMTP_USERNAME": "bm8tcmVwbHktdGNAdG1heC5jby5rcg==",
        "SMTP_PASSWORD": "IUB0Y2Ruc2R1ZHhsYTEx"
    }
  },
  {
    "apiVersion": "v1",
    "kind": "Secret",
    "metadata": {
        "name": "token-secret",
        "namespace": "hypercloud5-system"
    },
    "type": "Opaque",
    "data": {
        "ACCESS_TOKEN": "dG1heEAxMw=="
    }
  }
]
