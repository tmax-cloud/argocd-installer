function (
    clusterissuer="tmaxcloud-issuer"
)

[
  {
    "apiVersion": "cert-manager.io/v1",
    "kind": "Certificate",
    "metadata": {
      "name": kibana-cert",
      "namespace": "kube-logging"
    },
    "spec": {
      "secretName": "kibana-secret",
      "isCA": false,
      "usages": [
        {
          "digital signature",
          "key encipherment",
          "server auth",
          "client auth"
        }
      ],
      "dnsNames": [
        {
          "tmax-cloud",
          "kibana.kube-logging.svc"
        }
      ],
      "issuerRef": {
        "kind": "ClusterIssuer",
        "group": "cert-manager.io",
        "name": clusterissuer
      }
    }
  }
]
