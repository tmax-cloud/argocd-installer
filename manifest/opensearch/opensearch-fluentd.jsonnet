function (
  timezone="UTC",
  is_offline="false",
  private_registry="172.22.6.2:5000",
  os_image_tag="1.3.7",
  busybox_image_tag="1.32.0",
  os_resource_limit_memory="8Gi",
  os_resource_request_memory="5Gi",
  os_jvm_heap="-Xms4g -Xmx4g",
  os_volume_size="50Gi",
  dashboard_image_tag="1.3.7",
  dashboard_svc_type="ClusterIP",
  opensearch_client_id="opensearch",
  tmax_client_secret="tmax_client_secret",
  hyperauth_url="172.23.4.105",
  hyperauth_realm="tmax",
  custom_domain_name="domain_name",
  fluentd_image_tag="fluentd-v1.15.3-debian-elasticsearch-1.0",
  custom_clusterissuer="tmaxcloud-issuer",
  is_master_cluster="true",
  opensearch_subdomain="opensearch-dashboard",
  log_level="info",
  storageClass="default"
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";
local os_image_path = "docker.io/opensearchproject/opensearch:" + os_image_tag;
local busybox_image_path = "docker.io/busybox:" + busybox_image_tag;
local dashboard_image_path = "docker.io/opensearchproject/opensearch-dashboards:" + dashboard_image_tag;
local fluentd_image_path = "docker.io/tmaxcloudck/hypercloud:" + fluentd_image_tag;
local dashboards_log_level = if log_level == "error" then "quiet: true" else if log_level == "debug" then "verbose: true" else "quiet: false";
local fluentd_log_level = if log_level == "error" then "-qq " else if log_level == "debug" then "-v " else "";

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
                  "name": "log4j2",
                  "mountPath": "/usr/share/opensearch/config/log4j2.properties",
                  "subPath": "log4j2.properties"
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
              ] + (
                if timezone != "UTC" then [
                  {
                    "name": "timezone-config",
                    "mountPath": "/etc/localtime"
                  }
                ] else []
              ) + [
                {
                  "name": "roles",
                  "mountPath": "/usr/share/opensearch/plugins/opensearch-security/securityconfig/roles.yml",
                  "subPath": "roles.yml"
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
              "name": "log4j2",
              "configMap": {
                "name": "opensearch-log4j2-config"
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
            }
          ] + (
            if timezone != "UTC" then [
              {
                "name": "timezone-config",
                "hostPath": {
                  "path": std.join("", ["/usr/share/zoneinfo/", timezone])
                }
              }
            ] else []
          ) + [
            {
              "name": "roles",
              "configMap": {
                "name": "os-role"
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
          } + (
            if storageClass != "default" then {
              "storageClassName": storageClass
            } else {}
          )
        }
      ]
    }  
  },
  {
    "apiVersion": "v1",
    "kind": "ConfigMap",
    "metadata": {
      "name": "opensearch-log4j2-config",
      "namespace": "kube-logging"
    },
    "data": {
      "log4j2.properties": std.join("\n", 
        [
          "status = error", 
          "appender.console.type = Console",
          "appender.console.name = console",
          "appender.console.layout.type = PatternLayout",
          "appender.console.layout.pattern = [%d{ISO8601}][%-5p][%-25c{1.}] [%node_name]%marker %m%n",
          std.join("", ["rootLogger.level = ", log_level]),
          "rootLogger.appenderRef.console.ref = console"
        ]
      )
    }
  }
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
              ] + if timezone != "UTC" then [
                {
                  "name": "timezone-config",
                  "mountPath": "/etc/localtime"
                }
              ] else []
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
              "command": [
                "/bin/bash",
                "-c",
                std.join("", ["fluentd ", fluentd_log_level, "-c /fluentd/etc/fluent.conf -p /fluentd/plugins"])
              ],
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
                "name": "fluentd-config"
              }
            },
            {
              "name": "gem",
              "configMap": {
                "name": "fluentd-gem"
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
          std.join("", ["logging.", dashboards_log_level]),
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
          std.join("", ["logging.", dashboards_log_level]),
          "opensearch_security.openid.verify_hostnames: false",
          "opensearch_security.cookie.secure: false"
        ]
      )
    }
  }
]
