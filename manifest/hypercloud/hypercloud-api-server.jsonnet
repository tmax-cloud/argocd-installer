function (
  is_offline="false",
  private_registry="registry.hypercloud.org",
  hypercloud_hpcd_mode="multi",
  hypercloud_kafka_enabled="\"true\"",
  hyperauth_url="hyperauth.172.22.6.18.nip.io",
  hyperauth_client_secret="tmax_client_secret",
  domain="tmaxcloud.org",
  hyperauth_subdomain="hyperauth",
  console_subdomain="console",
  hyperregistry_enabled="true",
  storageClass="default",
  aws_enabled="true",
  vsphere_enabled="true",
  kube_version="1.19"
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
              "image": std.join("", [target_registry, "docker.io/tmaxcloudck/hypercloud-api-server:b5.0.26.16"]),
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
                },
                {
                  "name": "HC_DOMAIN",
                  "value": domain
                },
                {
                  "name": "CONSOLE_SUBDOMAIN",
                  "value": console_subdomain
                },
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
                },
                {
                  "name": "hypercloud5-api-server-service-account-token",
                  "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
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
            },
            {
              "name": "hypercloud5-api-server-service-account-token",
              "secret": {
                "secretName": "hypercloud5-api-server-service-account-token",
                "defaultMode": 420
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
      "version.config": std.join("\n",
        [
          "modules:",
          "- name: Kubernetes",
          "  namespace:",
          "  selector:",
          "    matchLabels:",
          "      statusLabel:",
          "      - component=kube-apiserver",
          "      versionLabel:",
          "      - component=kube-apiserver",
          "  readinessProbe:",
          "  versionProbe:",
          "- name: HyperCloud API Server",
          "  namespace: hypercloud5-system",
          "  selector:",
          "    matchLabels:",
          "      statusLabel:",
          "      - hypercloud5=api-server",
          "      versionLabel:",
          "      - hypercloud5=api-server",
          "  readinessProbe:",
          "  versionProbe:",
          "- name: HyperCloud Single Operator",
          "  namespace: hypercloud5-system",
          "  selector:",
          "    matchLabels:",
          "      statusLabel:",
          "      - hypercloud=single-operator",
          "      versionLabel:",
          "      - hypercloud=single-operator",
          "  readinessProbe:",
          "  versionProbe:",
          "    container: manager",
          "- name: HyperCloud Multi Operator",
          "  namespace: hypercloud5-system",
          "  selector:",
          "    matchLabels:",
          "      statusLabel:",
          "      - hypercloud=multi-operator",
          "      versionLabel:",
          "      - hypercloud=multi-operator",
          "  readinessProbe:",
          "  versionProbe:",
          "    container: manager",
          "- name: HyperCloud Console",
          "  namespace: api-gateway-system",
          "  selector:",
          "    matchLabels:",
          "      statusLabel:",
          "      - app.kubernetes.io/name=console",
          "      versionLabel:",
          "      - app.kubernetes.io/name=console",
          "  readinessProbe:",
          "  versionProbe:",
          "   container: console",
          "- name: HyperAuth",
          "  namespace:",
          "  selector:",
          "    matchLabels:",
          "      statusLabel:",
          "      versionLabel:",
          "  readinessProbe:",
          "    httpGet:",
          std.join("", ["      path: https://", hyperauth_url, "/auth/realms/tmax"]),
          "- name: Calico",
          "  namespace: kube-system",
          "  selector:",
          "    matchLabels:",
          "      statusLabel:",
          "      - k8s-app=calico-node",
          "      versionLabel:",
          "      - k8s-app=calico-node",
          "  readinessProbe:",
          "  versionProbe:",
          "- name: MetalLB",
          "  namespace: metallb-system",
          "  selector:",
          "    matchLabels:",
          "      statusLabel:",
          "      - app=metallb",
          "      versionLabel:",
          "      - app=metallb",
          "  readinessProbe:",
          "  versionProbe:",
          "- name: API gateway",
          "  namespace: api-gateway-system",
          "  selector:",
          "    matchLabels:",
          "      statusLabel:",
          "      - app.kubernetes.io/name=traefik",
          "      versionLabel:",
          "      - app.kubernetes.io/name=traefik",
          "  readinessProbe:",
          "  versionProbe:",
          "- name: Prometheus",
          "  namespace: monitoring",
          "  selector:",
          "    matchLabels:",
          "      statusLabel:",
          "      - app=prometheus",
          "      versionLabel:",
          "      - app=prometheus",
          "  readinessProbe:",
          "    httpGet:",
          "      path: /-/ready",
          "      port: 9090",
          "      scheme: HTTP",
          "  versionProbe:",
          "    container: prometheus",
          "- name: Tekton",
          "  namespace: tekton-pipelines",
          "  selector:",
          "    matchLabels:",
          "      statusLabel:",
          "      - app=tekton-pipelines-controller",
          "      versionLabel:",
          "      - app=tekton-pipelines-controller",
          "  readinessProbe:",
          "  versionProbe:",
          "- name: Catalog-Controller",
          "  namespace: catalog",
          "  selector:",
          "    matchLabels:",
          "      statusLabel:",
          "      - app=catalog-catalog-controller-manager",
          "      versionLabel:",
          "      - app=catalog-catalog-controller-manager",
          "  readinessProbe:",
          "    httpGet:",
          "      path: /healthz/ready",
          "      port: 8444",
          "      scheme: HTTPS",
          "  versionProbe:",
          "- name: ClusterTemplateServiceBroker",
          "  namespace: cluster-tsb-ns",
          "  selector:",
          "    matchLabels:",
          "      statusLabel:",
          "      - app=cluster-template-service-broker",
          "      versionLabel:",
          "      - app=cluster-template-service-broker",
          "  readinessProbe:",
          "  versionProbe:",
          "- name: CAPI",
          "  namespace: capi-system",
          "  selector:",
          "    matchLabels:",
          "      statusLabel:",
          "      - cluster.x-k8s.io/provider=cluster-api",
          "      versionLabel:",
          "      - cluster.x-k8s.io/provider=cluster-api",
          "  readinessProbe:",
          "  versionProbe:",
          "    container: manager",
          "- name: KubeFed",
          "  namespace: kube-federation-system",
          "  selector:",
          "    matchLabels:",
          "      statusLabel:",
          "      - kubefed-control-plane=controller-manager",
          "      versionLabel:",
          "      - kubefed-control-plane=controller-manager",
          "  readinessProbe:",
          "  versionProbe:",
          "- name: Grafana",
          "  namespace: monitoring",
          "  selector:",
          "    matchLabels:",
          "      statusLabel:",
          "      - app=grafana",
          "      versionLabel:",
          "      - app=grafana",
          "  readinessProbe:",
          "    httpGet:",
          "      path: /api/health",
          "      port: 3000",
          "  versionProbe:",
          "- name: Kibana",
          "  namespace: kube-logging",
          "  selector:",
          "    matchLabels:",
          "      statusLabel:",
          "      - app=kibana",
          "      versionLabel:",
          "      - app=kibana",
          "  readinessProbe:",
          "  versionProbe:"
        ]
      )
    }
  }
]