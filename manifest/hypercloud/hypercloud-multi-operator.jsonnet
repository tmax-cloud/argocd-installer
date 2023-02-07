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
  kubectl_timeout="21600",
  storageClass="default",
  aws_enabled="true",
  vsphere_enabled="true",
  time_zone="UTC",
  multi_operator_log_level="info",
  single_operator_log_level="info",
  api_server_log_level="INFO",
  timescaledb_log_level="WARNING",
  timescaledb_audit_chunk_time_interval="7 days",
  timescaledb_audit_retention_policy="1 years",
  timescaledb_event_chunk_time_interval="1 days",
  timescaledb_event_retention_policy="1 months",
  timescaledb_metering_hour_chunk_time_interval="1 days",
  timescaledb_metering_hour_retention_policy="1 months",
  timescaledb_metering_day_chunk_time_interval="1 months",
  timescaledb_metering_day_retention_policy="1 years",
  timescaledb_metering_month_chunk_time_interval="1 years",
  timescaledb_metering_month_retention_policy="1 years",
  timescaledb_metering_year_retention_policy="10 years",
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";
local capi_aws_template = import 'hypercloud-capi-aws-template.libsonnet';
local capi_vsphere_template = import 'hypercloud-capi-vsphere-template.libsonnet';
local capi_vsphere_upgrade_template = import 'hypercloud-capi-vsphere-upgrade-template.libsonnet';
local etc_manifest = import 'hypercloud-multi-operator.libsonnet';
local deployment =  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "labels": {
        "hypercloud": "multi-operator"
      },
      "name": "hypercloud-multi-operator-controller-manager",
      "namespace": "hypercloud5-system"
    },
    "spec": {
      "replicas": 1,
      "selector": {
        "matchLabels": {
          "hypercloud": "multi-operator"
        }
      },
      "template": {
        "metadata": {
          "labels": {
            "hypercloud": "multi-operator"
          }
        },
        "spec": {
          "containers": [
            {
              "args": [
                "--metrics-addr=127.0.0.1:8080",
                "--enable-leader-election",
                std.join("", ["--zap-log-level=", multi_operator_log_level])
              ],
              "command": [
                "/manager"
              ],
              "env": [
                {
                  "name": "HC_DOMAIN",
                  "value": domain
                },
                {
                  "name": "AUTH_CLIENT_SECRET",
                  "value": hyperauth_client_secret
                },
                {
                  "name": "AUTH_SUBDOMAIN",
                  "value": hyperauth_subdomain
                },
                {
                  "name": "ARGO_APP_DELETE",
                  "value": "true"
                },
                {
                  "name": "OIDC_CLIENT_SET",
                  "value": "false"
                },
                {
                  "name": "DEV_MODE",
                  "value": "false"
                },
              ],
              "image": std.join("", [target_registry, "docker.io/tmaxcloudck/hypercloud-multi-operator:b5.1.1.0"]),
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
                  "cpu": "100m",
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
                  "name": "hypercloud-multi-operator-controller-manager-token",
                  "readOnly": true
                }
              ] + (
                if time_zone != "UTC" then [
                  {
                    "name": "timezone-config",
                    "mountPath": "/etc/localtime"
                  }
                ] else []
              )
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
              },
              "volumeMounts": [
                {
                  "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                  "name": "hypercloud-multi-operator-controller-manager-token",
                  "readOnly": true
                }
              ]
            }
          ],
          "serviceAccountName": "hypercloud-multi-operator-controller-manager",
          "terminationGracePeriodSeconds": 10,
          "volumes": [
            {
              "name": "cert",
              "secret": {
                "defaultMode": 420,
                "secretName": "hypercloud-multi-operator-webhook-server-cert"
              }
            },
            {
              "name": "hypercloud-multi-operator-controller-manager-token",
              "secret": {
                "defaultMode": 420,
                "secretName": "hypercloud-multi-operator-controller-manager-token"
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
  };
  
if hypercloud_hpcd_mode != "multi" then [] else [deployment] + 
  etc_manifest +
if aws_enabled == "true" && vsphere_enabled == "true" 
  then [capi_aws_template, capi_vsphere_template, capi_vsphere_upgrade_template]
else if aws_enabled == "true" 
  then [capi_aws_template]
else if vsphere_enabled == "true"
  then [capi_vsphere_template, capi_vsphere_upgrade_template] 
else []