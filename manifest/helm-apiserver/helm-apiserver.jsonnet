function (
  is_offline = "false",
  private_registry= "registry.tmaxcloud.org",
  helm_apiserver_version = "0.0.5",
  storage_class= "default",
  helm_subdomain="helm",
  hypercloud_domain_host="tmaxcloud.org",
  time_zone= "UTC",
  log_level= "error"
  
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";

[
   {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
        "labels": {
            "app": "helm-apiserver"
        },
        "name": "helm-apiserver",
        "namespace": "helm-ns"
    },
    "spec": {
        "replicas": 1,
        "selector": {
            "matchLabels": {
                "app": "helm-apiserver"
            }
        },
        "template": {
            "metadata": {
                "labels": {
                    "app": "helm-apiserver"
                }
            },
            "spec": {
                "containers": [
                    {
                        "args": [
                            std.join("", ["log-level=", log_level])
                        ],
                        "command": [
                            "/helm-apiserver"
                        ],
                        "image": std.join("", [target_registry, "docker.io/tmaxcloudck/helm-apiserver:", helm_apiserver_version]),
                        "imagePullPolicy": "Always",
                        "name": "helm-apiserver",
                        "resources": {
                            "limits": {
                                "cpu": "300m",
                                "memory": "400Mi"
                            },
                            "requests": {
                                "cpu": "100m",
                                "memory": "150Mi"
                            }
                        },
                        "volumeMounts": [
                            {
                                "mountPath": "/tmp",
                                "name": "helm-apiserver-data"
                            },
                            {
                                "mountPath": "/tmp/cert",
                                "name": "helm-apiserver-cert"
                            }
                        ] + (
                            if time_zone != "UTC" then [
                                {
                                "name": "timezone-config",
                                "mountPath": "/etc/localtime"
                                }
                            ] else []
                        )
                    }
                ],
                "restartPolicy": "Always",
                "serviceAccount": "helm-apiserver-sa",
                "serviceAccountName": "helm-apiserver-sa",
                "volumes": [
                    {
                        "name": "helm-apiserver-data",
                        "persistentVolumeClaim": {
                            "claimName": "helm-apiserver-pvc"
                        }
                    },
                    {
                        "name": "helm-apiserver-cert",
                        "secret": {
                            "secretName": "helm-apiserver-cert"
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
    "apiVersion": "networking.k8s.io/v1",
    "kind": "Ingress",
    "metadata": {
        "name": "helm-apiserver-ingress",
        "namespace": "helm-ns",
        "annotations": {
            "traefik.ingress.kubernetes.io/router.entrypoints": "websecure"
        },
        "labels": {
            "ingress.tmaxcloud.org/name": "helm-apiserver"
        }
    },
    "spec": {
        "ingressClassName": "tmax-cloud",
        "rules": [
            {
                "host": std.join("", [helm_subdomain, ".", hypercloud_domain_host]),
                "http": {
                    "paths": [
                        {
                            "backend": {
                                "service": {
                                    "name": "helm-apiserver",
                                    "port": {
                                        "number": 443
                                    }
                                }
                            },
                            "path": "/",
                            "pathType": "Prefix"
                        }
                    ]
                }
            }
        ],
        "tls": [
            {
                "hosts": [
                    std.join("", [helm_subdomain, ".", hypercloud_domain_host])
                ]
            }
        ]
    }
},
{
    "apiVersion": "v1",
    "kind": "PersistentVolumeClaim",
    "metadata": {
        "name": "helm-apiserver-pvc",
        "namespace": "helm-ns"
    },
    "spec": {
        "resources": {
            "requests": {
                "storage": "5Gi"
            }
        },
        "volumeMode": "Filesystem",
        "accessModes": [
            "ReadWriteMany"
        ], 
    } + (
      if storage_class != "default" then {
        "storageClassName": storage_class
      } else {}
    )
}
]