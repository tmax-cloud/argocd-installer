function (
    is_offline="false",
    private_registry="172.22.6.2:5000",
    es_image_tag="docker.io/tmaxcloudck/elasticsearch:7.2.1",
    busybox_image_tag="docker.io/busybox:1.32.0",
    es_volume_size="50Gi",
    kibana_image_tag="docker.elastic.co/kibana/kibana:7.2.0",
    kibana_svc_type="ClusterIP",
    gatekeeper_image_tag="quay.io/keycloak/keycloak-gatekeeper:10.0.0",
    kibana_client_id="kibana",
    kibana_client_secret="23077707-908e-4633-956d-5adcaed4caa7",
    hyperauth_url="172.23.4.105",
    hyperauth_realm="tmax",
    custom_domain_name="domain_name",
    encryption_key="AgXa7xRcoClDEU0ZDSH4X0XhL5Qy2Z2j",
    fluentd_image_tag="docker.io/fluent/fluentd-kubernetes-daemonset:v1.4.2-debian-elasticsearch-1.1",
    custom_clusterissuer="tmaxcloud-issuer"
)

local es_registry = if is_offline == "false" then "" else private_registry + "/";
local busybox_registry = if is_offline == "false" then "" else private_registry + "/";
local kibana_registry = if is_offline == "false" then "" else private_registry + "/";
local gatekeeper_registry = if is_offline == "false" then "" else private_registry + "/";
local fluentd_registry = if is_offline == "false" then "" else private_registry + "/";

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
              "image": std.join("", [es_registry, es_image_tag]),
              "securityContext": {
                "allowPrivilegeEscalation": true,
                "privileged": true
              },
              "resources": {
                "limits": {
                  "cpu": "500m",
                  "memory": "3000Mi"
                },
                "requests": {
                  "cpu": "100m",
                  "memory": "100Mi"
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
              ],
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
                  "value": "-Xms2g -Xmx2g"
                }
              ]
            }
          ],
          "initContainers": [
            {
              "name": "fix-permissions",
              "image": std.join("", [busybox_registry, busybox_image_tag]),
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
              "image": std.join("", [busybox_registry, busybox_image_tag]),
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
              "image": std.join("", [busybox_registry, busybox_image_tag]),
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
        }
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
          ],
          "containers": if hyperauth_url != "" then [
            {
              "name": "gatekeeper",
              "image": std.join("", [gatekeeper_registry, gatekeeper_image_tag]),
              "imagePullPolicy": "Always",
              "args": [
                std.join("", ["--client-id=", kibana_client_id]),
                std.join("", ["--client-secret=", kibana_client_secret]),
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
                "--resources=uri=/*|roles=kibana:kibana-manager",
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
            },
            {
              "name": "kibana",
              "image": std.join("",[kibana_registry, kibana_image_tag]),
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
              ]
            }
          ] else [
            {
              "name": "kibana",
              "image": std.join("",[kibana_registry, kibana_image_tag]),
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
              ]
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
      "name": "kibana-config",
      "namespace": "kube-logging"
    },
    "data": {
      "kibana.yml": std.join("", ["server.name: kibana", "\nserver.host: '0'", "\nelasticsearch.hosts: [ 'http://elasticsearch:9200' ]", "\nelasticsearch.requestTimeout: '100000ms'"])
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
       }
    },
    "spec": {
      "type": kibana_svc_type,
      "ports": [
        if hyperauth_url == "" then {
          "port": 5601,
          "name": "kibana"
        } else if custom_domain_name == ""  then {
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
              "image": std.join("",[fluentd_registry, fluentd_image_tag]),
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
              ]
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
          ]
        }
      }
    }
  }
]
