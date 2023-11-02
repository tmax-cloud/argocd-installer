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
  storageClass="default",
  certDuration="8760h"
)

local timeArr = [["h", 3600], ["m", 60], ["s", 1]];

local total(duration, times) = 
  local current = std.split(duration, times[0][0]);
  if std.length(times) == 0 then 0
  else if std.length(current) == 1 then total(std.strReplace(current[0], times[0][0], ""), times[1:])
  else total(std.strReplace(current[1], times[0][0], ""), times[1:]) + std.parseInt(current[0]) * times[0][1];

local parsedTime(seconds, times) =
  if std.length(times) == 0 then ""
  else std.floor(seconds/times[0][1]) + times[0][0] + parsedTime(seconds%times[0][1], times[1:]);

[
  {
    "apiVersion": "cert-manager.io/v1",
    "kind": "Certificate",
    "metadata": {
      "name": "admin-cert",
      "namespace": "kube-logging"
    },
    "spec": {
      "secretName": "admin-secret",
      "commonName": "admin",
      "duration": parsedTime(total(certDuration, timeArr), timeArr),
      "privateKey": {
        "algorithm": "RSA",
        "encoding": "PKCS8",
        "size": 2048
      },
      "usages": [
        "digital signature",
        "key encipherment",
        "server auth",
        "client auth"
      ],
      "issuerRef": {
        "kind": "ClusterIssuer",
        "group": "cert-manager.io",
        "name": "tmaxcloud-issuer"
      }
    }
  },
  {
    "apiVersion": "cert-manager.io/v1",
    "kind": "Certificate",
    "metadata": {
      "name": "opensearch-cert",
      "namespace": "kube-logging"
    },
    "spec": {
      "secretName": "opensearch-secret",
      "commonName": "opensearch",
      "duration": parsedTime(total(certDuration, timeArr), timeArr),
      "privateKey": {
        "algorithm": "RSA",
        "encoding": "PKCS8",
        "size": 2048
      },
      "usages": [
        "digital signature",
        "key encipherment",
        "server auth",
        "client auth"
      ],
      "dnsNames": [
        "tmax-cloud",
        "opensearch.kube-logging.svc"
      ],
      "issuerRef": {
        "kind": "ClusterIssuer",
        "group": "cert-manager.io",
        "name": "tmaxcloud-issuer"
      }
    }
  },
  {
    "apiVersion": "cert-manager.io/v1",
    "kind": "Certificate",
    "metadata": {
      "name": "dashboards-cert",
      "namespace": "kube-logging"
    },
    "spec": {
      "secretName": "dashboards-secret",
      "commonName": "dashboards",
      "duration": parsedTime(total(certDuration, timeArr), timeArr),
      "privateKey": {
        "algorithm": "RSA",
        "encoding": "PKCS8",
        "size": 2048
      },
      "usages": [
        "digital signature",
        "key encipherment",
        "server auth",
        "client auth"
      ],
      "dnsNames": [
        "tmax-cloud",
        "dashboards.kube-logging.svc"
      ],
      "issuerRef": {
        "kind": "ClusterIssuer",
        "group": "cert-manager.io",
        "name": "tmaxcloud-issuer"
      }
    }
  }
]