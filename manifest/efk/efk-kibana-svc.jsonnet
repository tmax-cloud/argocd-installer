function (
     kibana_svc_type="LoadBalancer",
     custom_clusterissuer="ck-selfsigned-clusterissuer",
     custom_domain_name="none"
)

local svcType = if kibana_svc_type == "Ingress" then "ClusterIP" else kibana_svc_type;

[
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
      "type": svcType,
      "ports": [
        if kibana_svc_type == "ClusterIP" then {
          "port": 443,
          "targetPort": 3000
        } else {
          "port": 3000,
          "name": "gatekeeper"
        }
      ],
      "selector": {
        "app": "kibana"
      }
    }
  },
  if kibana_svc_type == "Ingress" then {
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
          "host": std.join("", ["kibana.", custom_domain_name]),
          "http": {
            "paths": [
              {
                "backend": {
                  "service": {
                    "name": "kibana",
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
            std.join("", ["kibana.", custom_domain_name])
          ]
        }
      ]
    }
  }else {}
]
