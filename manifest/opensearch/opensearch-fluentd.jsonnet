function(
  is_offline="false",
  private_registry="172.22.6.2:5000",
  os_image_tag="1.2.3",
  busybox_image_tag="1.32.0",
  os_resource_limit_memory="8Gi",
  os_resource_request_memory="5Gi",
  os_jvm_heap="-Xms4g -Xmx4g",
  os_volume_size="50Gi",
  dashboard_image_tag="1.2.0",
  dashboard_svc_type="ClusterIP",
  opensearch_client_id="opensearch",
  tmax_client_secret="tmax_client_secret",
  hyperauth_url="172.23.4.105",
  hyperauth_realm="tmax",
  custom_domain_name="domain_name",
  fluentd_image_tag="fluentd-v1.4.2-debian-elasticsearch-1.1",
  custom_clusterissuer="tmaxcloud-issuer",
  is_master_cluster="true",
  opensearch_subdomain="opensearch-dashboard"
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";
local os_image_path = "docker.io/opensearchproject/opensearch:" + os_image_tag;
local busybox_image_path = "docker.io/busybox:" + busybox_image_tag;
local dashboard_image_path = "docker.io/opensearchproject/opensearch-dashboards:" + dashboard_image_tag;
local fluentd_image_path = "docker.io/tmaxcloudck/hypercloud:" + fluentd_image_tag;

[
  {
    "apiVersion": "apps/v1",
    "kind": "StatefulSet",
    "metadata": {
      "name": "os-cluster",
      "namespace": "kube-logging",
    },
    "spec": {
      "serviceName": "opensearch",
      "replicas": 1,
      "selector": {
        "matchLabels": {
          "app": "opensearch"
        }
      },
      "template": {
        "metadata": {
          "name": "opensearch",
          "labels": {
            "app": "opensearch"
          }
        },
        "spec": {
          "serviceAccount": "opensearch-service-account",
          "containers": [
            {
              "name": "opensearch",
              "image": std.join("", [target_registry, os_image_path]),
              "securityContext": {
                "allowPrivilegeEscalation": true,
                "privileged": true
              },
              "resources": {
                "limits": {
                  "cpu": "500m",
                  "memory": os_resource_limit_memory
                },
                "requests": {
                  "cpu": "100m",
                  "memory": os_resource_request_memory
                }
              },
              "ports": [
                {
                  "name": "http",
                  "containerPort": 9200,
                  "protocol": "TCP"
                },
                {
                  "name": "transport",
                  "containerPort": 9300,
                  "protocol": "TCP"
                }
              ],
              "volumeMounts": [
                {
                  "name": "data",
                  "mountPath": "/usr/share/opensearch/data"
                },
                {
                  "name": "config",
                  "mountPath": "/usr/share/opensearch/config/opensearch.yml",
                  "subPath": "opensearch.yml"
                },
                {
                  "name": "opensearch-cert",
                  "mountPath": "/usr/share/opensearch/config/certificates",
                  "readOnly": true
                },
                {
                  "name": "admin-cert",
                  "mountPath": "/usr/share/opensearch/config/certificates/admin",
                  "readOnly": true
                },
                {
                  "name": "role-mapping",
                  "mountPath": "/usr/share/opensearch/plugins/opensearch-security/securityconfig/roles_mapping.yml",
                  "subPath": "roles_mapping.yml"
                },
                {
                  "name": "user-role",
                  "mountPath": "/usr/share/opensearch/plugins/opensearch-security/securityconfig/internal_users.yml",
                  "subPath": "internal_users.yml"
                }
              ] + if hyperauth_url != "" then [
                {
                  "name": "security-config",
                  "mountPath": "/usr/share/opensearch/plugins/opensearch-security/securityconfig/config.yml",
                  "subPath": "config.yml",
                  "readOnly": true
                }
              ] else [],
              "env": [
                {
                  "name": "cluster.name",
                  "value": "os-cluster"
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
                  "value": "os-cluster-0.opensearch"
                },
                {
                  "name": "cluster.initial_master_nodes",
                  "value": "os-cluster-0"
                },
                {
                  "name": "OPENSEARCH_JAVA_OPTS",
                  "value": os_jvm_heap
                }
              ]
            }
          ],
          "volumes": [
            {
              "name": "config",
              "configMap": {
                "name": "opensearch-config"
              }
            },
            {
              "name": "opensearch-cert",
              "secret": {
                "secretName": "opensearch-secret"
              }
            },
            {
              "name": "admin-cert",
              "secret": {
                "secretName": "admin-secret"
              }
            },
            {
              "name": "role-mapping",
              "configMap": {
                "name": "os-role-mapping"
              }
            },
            {
              "name": "user-role",
              "configMap": {
                "name": "os-users"
              }
            }
          ] + if hyperauth_url != "" then [
            {
              "name": "security-config",
              "configMap": {
                "name": "opensearch-securityconfig"
              }
            }
          ] else [],
          "initContainers": [
            {
              "name": "fix-permissions",
              "image": std.join("", [target_registry, busybox_image_path]),
              "command": [
                "sh",
                "-c",
                "chown -R 1000:1000 /usr/share/opensearch/data"
              ],
              "securityContext": {
                "privileged": true
              },
              "volumeMounts": [
                {
                  "name": "data",
                  "mountPath": "/usr/share/opensearch/data"
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
        }
      },     
      "volumeClaimTemplates": [
        {
          "metadata": {
            "name": "data",
            "labels": {
              "app": "opensearch"
            }
          },
          "spec": {
            "accessModes": [ "ReadWriteOnce" ],
            "resources": {
              "requests": {
                "storage": os_volume_size
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
      "name": "dashboard",
      "namespace": "kube-logging",
      "labels": {
        "app": "opensearch-dashboards"
      }
    },
    "spec": {
      "replicas": 1,
      "selector": {
        "matchLabels": {
          "app": "opensearch-dashboards"
        }
      },
      "template": {
        "metadata": {
          "labels": {
            "app": "opensearch-dashboards"
          }
        },
        "spec": {
          "serviceAccount": "opensearch-service-account",
          "volumes": [
            {
              "name": "config",
              "configMap": {
                "name": "opensearch-dashboards-config"
              }
            },
            {
              "name": "settings",
              "configMap": {
                "defaultMode": 448,
                "name": "os-policy",
                "items": [
                  {
                    "key": "settings.sh",
                    "path": "settings.sh"
                  }
                ]
              }
            },
            {
              "name": "index-policy",
              "configMap": {
                "name": "os-policy",
                "items": [
                  {
                    "key": "index-policy.json",
                    "path": "index-policy.json"
                  }
                ]
              }
            },
            {
              "name": "dashboards-cert",
              "secret": {
                "secretName": "dashboards-secret"
              }
            }
          ],
          "containers": [
            {
              "name": "dashboards",
              "image": std.join("", [target_registry, dashboard_image_path]),
              "imagePullPolicy": "IfNotPresent",
              "securityContext": {
                "runAsUser": 0
              },
              "command": [
                "/bin/bash",
                "-c",
                "/usr/share/opensearch-dashboards/settings.sh && /usr/share/opensearch-dashboards/opensearch-dashboards-docker-entrypoint.sh --allow-root"
              ],
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
                  "name": "OPENSEARCH_HOSTS",
                  "value": "https://opensearch.kube-logging.svc:9200"
                },
                {
                  "name": "SERVER_HOST",
                  "value": "0.0.0.0"
                },
                {
                  "name": "NODE_TLS_REJECT_UNAUTHORIZED",
                  "value": "0"
                }
              ],
              "ports": [
                {
                  "containerPort": 5601,
                  "name": "https",
                  "protocol": "TCP"
                }
              ],
              "volumeMounts": [
                {
                  "name": "config",
                  "mountPath": "/usr/share/opensearch-dashboards/config/opensearch_dashboards.yml",
                  "subPath": "opensearch_dashboards.yml"
                },
                {
                  "name": "settings",
                  "mountPath": "/usr/share/opensearch-dashboards/settings.sh",
                  "subPath": "settings.sh"
                },
                {
                  "name": "index-policy",
                  "mountPath": "/usr/share/opensearch-dashboards/index-policy.json",
                  "subPath": "index-policy.json"
                },
                {
                  "name": "dashboards-cert",
                  "mountPath": "/usr/share/opensearch-dashboards/config/certificates",
                  "readOnly": true
                }
              ]
            }
          ]
        }
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
                  "name": "FLUENT_OPENSEARCH_HOST",
                  "value": "opensearch",
                },
                {
                  "name": "FLUENT_OPENSEARCH_PORT",
                  "value": "9200",
                },
                {
                  "name": "FLUENT_OPENSEARCH_SCHEME",
                  "value": "https",
                },
                {
                  "name": "FLUENT_OPENSEARCH_USER",
                  "value": "admin",
                },
                {
                  "name": "FLUENT_OPENSEARCH_PASSWORD",
                  "value": "admin",
                },
                {
                  "name": "FLUENTD_SYSTEMD_CONF",
                  "value": "disable",
                },
                {
                  "name": "FLUENT_ELASTICSEARCH_SED_DISABLE",
                  "value": "true",
                },
                {
                  "name": "K8S_NODE_NAME",
                  "valueFrom": {
                    "fieldRef": {
                      "fieldPath": "spec.nodeName"
                    }
                  }
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
                  "mountPath": "/fluentd/etc/fluent.conf",
                  "subPath": "fluent.conf"
                },
                {
                  "name": "gem",
                  "mountPath": "/fluentd/Gemfile",
                  "subPath": "Gemfile",
                  "readOnly": true
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
                "name": "fluentd-config"
              }
            },
            {
              "name": "gem",
              "configMap": {
                "name": "fluentd-gem"
              }
            }
          ]
        }
      }
    }
  },
  {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
      "name": "dashboards",
      "namespace": "kube-logging",
      "labels": {
        "app": "opensearch-dashboards"
      },
      "annotations": {
        "traefik.ingress.kubernetes.io/service.serverstransport": "tmaxcloud@file"
      }
    },
    "spec": {
      "type": dashboard_svc_type,
      "ports": [
        {
          "port": 5601,
          "name": "https",
          "protocol": "TCP",
          "targetPort": 5601
        }
      ],
      "selector": {
        "app": "opensearch-dashboards"
      }
    }
  },
  {
    "apiVersion": "v1",
    "kind": "ConfigMap",
    "metadata": {
      "name": "opensearch-dashboards-config",
      "namespace": "kube-logging"
    },
    "data": if hyperauth_url == "" then {
      "opensearch_dashboards.yml": std.join("\n", 
        [
          "server.name: dashboards", 
          "server.host: '0.0.0.0'",
          "opensearch.username: admin",
          "opensearch.password: admin",
          "opensearch.ssl.verificationMode: none",
          "opensearch.requestTimeout: '100000ms'"
        ]
      )
    } else {
      "opensearch_dashboards.yml": std.join("\n",
        [
          "server.name: dashboards",
          "server.host: '0.0.0.0'",
          "server.ssl.enabled: true",
          "server.ssl.certificate: /usr/share/opensearch-dashboards/config/certificates/tls.crt",
          "server.ssl.key: /usr/share/opensearch-dashboards/config/certificates/tls.key",
          "opensearch.hosts: ['https://opensearch.kube-logging.svc:9200']",
          "opensearch.username: admin",
          "opensearch.password: admin",
          "opensearch.ssl.certificateAuthorities: [/usr/share/opensearch-dashboards/config/certificates/ca.crt]",
          "opensearch.ssl.verificationMode: full",
          "opensearch.requestHeadersWhitelist: ['Authorization', 'security_tenant', 'securitytenant']",
          "opensearch_security.multitenancy.enabled: true",
          "opensearch_security.multitenancy.tenants.enable_global: true",
          "opensearch_security.multitenancy.tenants.enable_private: true",
          "opensearch_security.multitenancy.tenants.preferred: ['Private', 'Global']",
          "opensearch_security.multitenancy.enable_filter: false",
          "opensearch_security.auth.type: openid",
          std.join("", ["opensearch_security.openid.connect_url: https://", hyperauth_url, "/auth/realms/", hyperauth_realm, "/.well-known/openid-configuration"]),
          std.join("", ["opensearch_security.openid.client_id: ", opensearch_client_id]),
          std.join("", ["opensearch_security.openid.client_secret: ", tmax_client_secret]),
          std.join("", ["opensearch_security.openid.base_redirect_url: https://", opensearch_subdomain, ".", custom_domain_name]),
          "opensearch_security.openid.verify_hostnames: false",
          "opensearch_security.cookie.secure: false"
        ]
      )
    }
  },
  {
    "apiVersion": "v1",
    "kind": "ConfigMap",
    "metadata": {
      "name": "os-role-mapping",
      "namespace": "kube-logging"
    },
    "data": {
      "roles_mapping.yml": std.join("\n",
        [
          "_meta:",
          "  type: 'rolesmapping'",
          "  config_version: 2",
          " ",
          "all_access:",
          "  reserved: false",
          "  backend_roles:",
          "  - 'opensearch-admin'",
          "  description: 'Maps admin to all_access'",
          " ",
          "own_index:",
          "  reserved: false",
          "  users:",
          "  - '*'",
          "  description: 'Allow full access to an index named like the username'",
          " ",
          "logstash:",
          "  reserved: false",
          "  backend_roles:",
          "  - 'logstash'",
          " ",
          "kibana_user:",
          "  reserved: false",
          "  backend_roles:",
          "  - 'kibanauser'",
          "  description: 'Maps kibanauser to kibana_user'",
          " ",
          "readall:",
          "  reserved: false",
          "  backend_roles:",
          "  - 'readall'",
          " ",
          "manage_snapshots:",
          "  reserved: false",
          "  backend_roles:",
          "  - 'snapshotrestore'",
          " ",
          "kibana_server:",
          "  reserved: true",
          "  users:",
          "  - 'kibanaserver'"
        ]
      )
    }
  },
  {
    "apiVersion": "v1",
    "kind": "ConfigMap",
    "metadata": {
      "name": "os-users",
      "namespace": "kube-logging"
    },
    "data": {
      "internal_users.yml": std.join("\n",
        [
          "_meta:",
          "  type: 'internalusers'",
          "  config_version: 2",
          " ",
          "admin:",
          "  hash: '$2a$12$VcCDgh2NDk07JGN0rjGbM.Ad41qVR/YFJcgHp0UGns5JDymv..TOG'",
          "  reserved: true",
          "  backend_roles:",
          "  - 'opensearch-admin'",
          "  description: 'Demo admin user'",
          " ",
          "kibanaserver:",
          "  hash: '$2a$12$4AcgAt3xwOWadA5s5blL6ev39OXDNhmOesEoo33eZtrq2N0YrU3H.'",
          "  reserved: true",
          "  description: 'Demo OpenSearch Dashboards user'",
          " ",
          "kibanaro:",
          "  hash: '$2a$12$JJSXNfTowz7Uu5ttXfeYpeYE0arACvcwlPBStB1F.MI7f0U9Z4DGC'",
          "  reserved: false",
          "  backend_roles:",
          "  - 'kibanauser'",
          "  - 'readall'",
          "  attributes:",
          "    attribute1: 'value1'",
          "    attribute2: 'value2'",
          "    attribute3: 'value3'",
          "  description: 'Demo OpenSearch Dashboards read only user'",
          " ",
          "logstash:",
          "  hash: '$2a$12$u1ShR4l4uBS3Uv59Pa2y5.1uQuZBrZtmNfqB3iM/.jL0XoV9sghS2'",
          "  reserved: false",
          "  backend_roles:",
          "  - 'logstash'",
          "  description: 'Demo logstash user'",
          " ",
          "readall:",
          "  hash: '$2a$12$ae4ycwzwvLtZxwZ82RmiEunBbIPiAmGZduBAjKN0TXdwQFtCwARz2'",
          "  reserved: false",
          "  backend_roles:",
          "  - 'readall'",
          "  description: 'Demo readall user'",
          " ",
          "snapshotrestore:",
          "  hash: '$2y$12$DpwmetHKwgYnorbgdvORCenv4NAK8cPUg8AI6pxLCuWf/ALc0.v7W'",
          "  reserved: false",
          "  backend_roles:",
          "  - 'snapshotrestore'",
          "  description: 'Demo snapshotrestore user'"
        ]
      )
    }
  }
]
