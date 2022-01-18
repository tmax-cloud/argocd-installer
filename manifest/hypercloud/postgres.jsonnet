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
        "name": "postgres",
        "namespace": "hypercloud5-system"
    },
    "spec": {
        "selector": {
            "matchLabels": {
                "app": "postgres"
            }
        },
        "replicas": 1,
        "template": {
            "metadata": {
                "labels": {
                    "app": "postgres"
                }
            },
            "spec": {
                "containers": [
                    {
                        "name": "postgres",
                        "image": std.join("", [target_registry, "docker.io/tmaxcloudck/postgres-cron:b5.0.0.1"]),
                        "imagePullPolicy": "IfNotPresent",
                        "ports": [
                            {
                                "containerPort": 5432
                            }
                        ],
                        "env": [
                            {
                                "name": "TZ",
                                "value": "Asia/Seoul"
                            },
                            {
                                "name": "POSTGRES_USER",
                                "value": "postgres"
                            },
                            {
                                "name": "POSTGRES_PASSWORD",
                                "valueFrom": {
                                    "secretKeyRef": {
                                        "name": "postgres-secret",
                                        "key": "POSTGRES_PASSWORD"
                                    }
                                }
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
                                "mountPath": "/var/lib/postgresql/data",
                                "name": "data",
                                "subPath": "postgres"
                            },
                            {
                                "mountPath": "/docker-entrypoint-initdb.d",
                                "name": "initdbsql"
                            }
                        ]
                    }
                ],
                "serviceAccountName": "hypercloud5-admin",
                "volumes": [
                    {
                        "name": "data",
                        "persistentVolumeClaim": {
                            "claimName": "postgres-data"
                        }
                    },
                    {
                        "name": "initdbsql",
                        "configMap": {
                            "name": "postgres-init-config",
                            "items": [
                                {
                                    "key": "INIT_DB_SQL",
                                    "path": "init-db.sql"
                                }
                            ]
                        }
                    }
                ]
            }
        }
    }
}