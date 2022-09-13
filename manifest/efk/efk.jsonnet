function (
  timezone="UTC",
  is_offline="false",
  private_registry="172.22.6.2:5000",
  es_image_tag="7.2.1",
  busybox_image_tag="1.32.0",
  es_resource_limit_memory="8Gi",
  es_resource_request_memory="5Gi",
  es_jvm_heap="-Xms4g -Xmx4g",
  es_volume_size="50Gi",
  kibana_image_tag="7.2.0",
  kibana_svc_type="ClusterIP",
  gatekeeper_image_tag="10.0.0",
  kibana_client_id="kibana",
  tmax_client_secret="tmax_client_secret",
  hyperauth_url="172.23.4.105",
  hyperauth_realm="tmax",
  custom_domain_name="domain_name",
  encryption_key="AgXa7xRcoClDEU0ZDSH4X0XhL5Qy2Z2j",
  fluentd_image_tag="v1.4.2-debian-elasticsearch-1.1",
  custom_clusterissuer="tmaxcloud-issuer",
  is_master_cluster="true",
  kibana_subdomain="kibana"
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";
local busybox_image_path = "docker.io/busybox:" + busybox_image_tag;
local kibana_image_path = "docker.elastic.co/kibana/kibana:" + kibana_image_tag;
local gatekeeper_image_path = "quay.io/keycloak/keycloak-gatekeeper:" + gatekeeper_image_tag;
local fluentd_image_path = "docker.io/fluent/fluentd-kubernetes-daemonset:" + fluentd_image_tag;
local gatekeeper_enabled = if hyperauth_url != "" then true else false;

[
  {
    "apiVersion": "apps/v1",
    "kind": "StatefulSet",
    "metadata": {
      "name": "es-cluster",
      "namespace": "kube-logging"
    },
    "spec": {
      "serviceName": "elasticsearch",
      "replicas": 1,
      "selector": {
        "matchLabels": {
          "app": "elasticsearch"
        }
      },
      "template": {
        "metadata": {
          "labels": {
            "app": "elasticsearch"
          }
        },
        "spec": {
          "serviceAccount": "efk-service-account",
          "containers": [
            {
              "name": "elasticsearch",
              "image": std.join("", [target_registry, "docker.io/tmaxcloudck/elasticsearch:", es_image_tag]),
              "securityContext": {
                "allowPrivilegeEscalation": true,
                "privileged": true
              },
              "resources": {
                "limits": {
                  "cpu": "500m",
                  "memory": es_resource_limit_memory
                },
                "requests": {
                  "cpu": "100m",
                  "memory": es_resource_request_memory
                }
              },
              "ports": [
                {
                  "name": "rest",
                  "containerPort": 9200,
                  "protocol": "TCP"
                },
                {
                  "name": "inter-node",
                  "containerPort": 9300,
                  "protocol": "TCP"
                }
              ],
              "volumeMounts": [
                {
                  "name": "data",
                  "mountPath": "/usr/share/elasticsearch/data"
                }
              ] + if timezone != "UTC" then [
                {
                  "name": "timezone-config",
                  "mountPath": "/etc/localtime"
                }
              ] else [],
              "env": [
                {
                  "name": "cluster.name",
                  "value": "k8s-logs"
                },
                {
                  "name": "node.name",     
                  "valueFrom": {
                    "fieldRef": {
                      "fieldPath": "metadata.name"
                    }
                  }
                },
                {
                  "name": "discovery.seed_hosts",     
                  "value": "es-cluster-0.elasticsearch"
                },
                {
                  "name": "cluster.initial_master_nodes",     
                  "value": "es-cluster-0"
                },
                {
                  "name": "ES_JAVA_OPTS",     
                  "value": es_jvm_heap
                }
              ]
            }
          ],
          "initContainers": [
            {
              "name": "fix-permissions",
              "image": std.join("", [target_registry, busybox_image_path]),
              "command": [
                "sh",
                "-c",
                "chown -R 1000:1000 /usr/share/elasticsearch/data"
              ],
              "securityContext": {
                "privileged": true
              },
              "volumeMounts": [
                {
                  "name": "data",
                  "mountPath": "/usr/share/elasticsearch/data"
                }
              ]
            },
            {
              "name": "increase-vm-max-map",
              "image": std.join("", [target_registry, busybox_image_path]),
              "command": [
                "sysctl", 
                "-w", 
                "vm.max_map_count=262144"
              ],
              "securityContext": {
                "privileged": true
              }
            },
            {
              "name": "increase-fd-ulimit",
              "image": std.join("", [target_registry, busybox_image_path]),
              "command": [
                "sh", 
                "-c", 
                "ulimit -n 65536"
              ],
              "securityContext": {
                "privileged": true
              }
            }
          ]
        } + if timezone != "UTC" then {
          "volumes": [
              {
                "name": "timezone-config",
                "hostPath": {
                  "path": std.join("", ["/usr/share/zoneinfo/", timezone])
              }
            }
          ]
        } else {}
      },
      "volumeClaimTemplates": [
        {
          "metadata": {
            "name": "data",
            "labels": {
              "app": "elasticsearch"
            }
          },
          "spec": {
            "accessModes": [ "ReadWriteOnce" ],
            "resources": {
              "requests": {
                "storage": es_volume_size
              }
            }
          }
        }
      ]
    }  
  },
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "name": "kibana",
      "namespace": "kube-logging",
      "labels": {
        "app": "kibana"
      }
    },
    "spec": {
      "replicas": 1,
      "selector": {
        "matchLabels": {
          "app": "kibana"
        }
      },
      "template": {
        "metadata": {
          "labels": {
            "app": "kibana"
          }
        },
        "spec": {
          "serviceAccount": "efk-service-account",
          "volumes": [
            {
              "name": "secret",
              "secret": {
                "secretName": "kibana-secret"
              },
            },
            {
              "name": "config",
              "configMap": {
                "name": "kibana-config"
              }
            }
          ] + if timezone != "UTC" then [
            {
              "name": "timezone-config",
              "hostPath": {
                "path": std.join("", ["/usr/share/zoneinfo/", timezone])
              }
            }
          ] else [],
          "containers": [
            {
              "name": "kibana",
              "image": std.join("", [target_registry, kibana_image_path]),
              "resources": {
                "limits": {
                  "cpu": "500m",
                  "memory": "1000Mi"
                },
                "requests": {
                  "cpu": "500m",
                  "memory": "1000Mi"
                }
              },
              "env": [
                {
                  "name": "ELASTICSEARCH_URL",
                  "value": "http://elasticsearch.kube-logging.svc.cluster.local:9200"
                }
              ],
              "ports": [
                {
                  "containerPort": 5601
                }
              ],
              "volumeMounts": [
                {
                  "mountPath": "/usr/share/kibana/config/kibana.yml",
                  "name": "config",
                  "subPath": "kibana.yml"
                }
              ] + if timezone != "UTC" then [
                {
                  "name": "timezone-config",
                  "mountPath": "/etc/localtime"
                }
              ] else [],
            }
          ] + if gatekeeper_enabled then [
            {
              "name": "gatekeeper",
              "image": std.join("", [target_registry, gatekeeper_image_path]),
              "imagePullPolicy": "Always",
              "args": [
                std.join("", ["--client-id=", kibana_client_id]),
                std.join("", ["--client-secret=", tmax_client_secret]),
                "--listen=:3000",
                "--upstream-url=http://127.0.0.1:5601",
                std.join("", ["--discovery-url=https://", hyperauth_url, "/auth/realms/", hyperauth_realm]),
                "--secure-cookie=false",
                "--skip-openid-provider-tls-verify=true",
                "--enable-self-signed-tls=false",
                "--tls-cert=/etc/secrets/tls.crt",
                "--tls-private-key=/etc/secrets/tls.key",
                "--tls-ca-certificate=/etc/secrets/ca.crt",
                "--skip-upstream-tls-verify=true",
                "--upstream-keepalives=false",
                "--enable-default-deny=true",
                "--enable-refresh-tokens=true",
                "--enable-metrics=true",
                std.join("", ["--encryption-key=", encryption_key]),
                std.join("", ["--resources=uri=/*|roles=", kibana_client_id, ":kibana-manager"]),
                "--verbose"
              ],
              "ports": [
                {
                  "name": "service",
                  "containerPort": 3000
                }
              ],
              "volumeMounts": [
                {
                  "name": "secret",
                  "mountPath": "/etc/secrets",
                  "readOnly": true
                }
              ]
            }
          ] else [],
        }
      }
    }
  },
  {
    "apiVersion": "v1",
    "kind": "ConfigMap",
    "metadata": {
      "name": "kibana-config",
      "namespace": "kube-logging"
    },
    "data": {
      "kibana.yml": std.join("\n", 
        [
          "server.name: kibana",
          "server.host: '0'",
          "elasticsearch.hosts: [ 'http://elasticsearch:9200' ]",
          "elasticsearch.requestTimeout: '100000ms'"
        ]
      )
    }
  },
  {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
      "name": "kibana",
      "namespace": "kube-logging",
      "labels": {
        "app": "kibana"
      },
      "annotations": {
        "traefik.ingress.kubernetes.io/service.serverstransport": "tmaxcloud@file"
      }
    },
    "spec": {
      "type": kibana_svc_type,
      "ports": [
        if hyperauth_url == "" then {
          "port": 5601,
          "name": "kibana"
        } else if is_master_cluster == "false" || custom_domain_name == "" then {
          "port": 3000,
          "name": "gatekeeper"
        } else {
          "port": 443,
          "targetPort": 3000
        }
      ],
      "selector": {
        "app": "kibana"
      }
    }
  },
  {
    "apiVersion": "cert-manager.io/v1",
    "kind": "Certificate",
    "metadata": {
      "name": "kibana-cert",
      "namespace": "kube-logging"
    },
    "spec": {
      "secretName": "kibana-secret",
      "usages": [
        "digital signature",
        "key encipherment",
        "server auth",
        "client auth"
      ],
      "dnsNames": [
          "tmax-cloud",
          "kibana.kube-logging.svc"
      ],
      "issuerRef": {
        "kind": "ClusterIssuer",
        "group": "cert-manager.io",
        "name": custom_clusterissuer
      }
    }
  },
  {
    "apiVersion": "apps/v1",
    "kind": "DaemonSet",
    "metadata": {
      "name": "fluentd",
      "namespace": "kube-logging",
      "labels": {
        "app": "fluentd"
      }
    },
    "spec": {
      "selector": {
        "matchLabels": {
          "app": "fluentd"
        }
      },
      "template": {
        "metadata": {
          "labels": {
            "app": "fluentd"
          }
        },
        "spec": {
          "serviceAccount": "fluentd",
          "serviceAccountName": "fluentd",
          "tolerations": [
            {
              "operator": "Exists"
            }
          ],
          "containers": [
            {
              "name": "fluentd",
              "image": std.join("",[target_registry, fluentd_image_path]),
              "env": [
                {
                  "name": "FLUENT_ELASTICSEARCH_HOST",
                  "value": "elasticsearch.kube-logging.svc.cluster.local",
                },
                {
                  "name": "FLUENT_ELASTICSEARCH_PORT",
                  "value": "9200",
                },
                {
                  "name": "FLUENT_ELASTICSEARCH_SCHEME",
                  "value": "http",
                },
                {
                  "name": "FLUENTD_SYSTEMD_CONF",
                  "value": "disable",
                },
                {
                  "name": "FLUENT_ELASTICSEARCH_SED_DISABLE",
                  "value": "true",
                }
              ],
              "resources": {
                "limits": {
                  "cpu": "300m",
                  "memory": "512Mi"
                },
                "requests": {
                  "cpu": "50m",
                  "memory": "100Mi"
                }
              },
              "volumeMounts": [
                {
                  "name": "varlog",
                  "mountPath": "/var/log"
                },
                {
                  "name": "varlibdockercontainers",
                  "mountPath": "/var/lib/docker/containers",
                  "readOnly": true
                },
                {
                  "name": "config",
                  "mountPath": "/fluentd/etc/kubernetes.conf",
                  "subPath": "kubernetes.conf"
                },
                {
                  "name": "index-template",
                  "mountPath": "/fluentd/etc/index_template.json",
                  "subPath": "index_template.json"
                }
              ] + if timezone != "UTC" then [
                {
                  "name": "timezone-config",
                  "mountPath": "/etc/localtime"
                }
              ] else []
            }
          ],
          "terminationGracePeriodSeconds": 30,
          "volumes": [
            {
              "name": "varlog",
              "hostPath": {
                "path": "/var/log"
              }
            },
            {
              "name": "varlibdockercontainers",
              "hostPath": {
                "path": "/var/lib/docker/containers"
              }
            },
            {
              "name": "config",
              "configMap": {
                "name": "fluentd-config",
                "items": [
                  {
                    "key": "kubernetes.conf",
                    "path": "kubernetes.conf"
                  }
                ]
              }
            },
            {
              "name": "index-template",
              "configMap": {
                "name": "fluentd-config",
                "items": [
                  {
                    "key": "index_template.json",
                    "path": "index_template.json"
                  }
                ]
              }
            }
          ] + if timezone != "UTC" then [
            {
              "name": "timezone-config",
              "hostPath": {
                "path": std.join("", ["/usr/share/zoneinfo/", timezone])
              }
            }
          ] else []
        }
      }
    }
  },
  {
    "apiVersion": "networking.k8s.io/v1",
    "kind": "Ingress",
    "metadata": {
      "name": "kibana",
      "namespace": "kube-logging",
      "labels": {
        "ingress.tmaxcloud.org/name": "kibana"
      },
      "annotations": {
        "traefik.ingress.kubernetes.io/router.entrypoints": "websecure",
        "cert-manager.io/cluster-issuer": custom_clusterissuer
      }
    },
    "spec": {
      "ingressClassName": "tmax-cloud",
      "rules": [
        {
          "host": std.join("", [kibana_subdomain, ".", custom_domain_name]),
          "http": {
            "paths": [
              {
                "backend": {
                  "service": {
                    "name": "kibana",
                    "port": if hyperauth_url == "" then {
                      "number": 5601
                    } else {
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
            std.join("", [kibana_subdomain, ".", custom_domain_name])
          ]
        }
      ]
    }
  }
]
