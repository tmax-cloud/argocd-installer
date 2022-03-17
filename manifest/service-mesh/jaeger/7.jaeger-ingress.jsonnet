function(
    is_offline="false",
    private_registry="registry.tmaxcloud.org",
    JAEGER_VERSION="1.9",
    cluster_name="master",
    tmax_client_secret="tmax_client_secret",
    HYPERAUTH_DOMAIN="hyperauth.domain",
    GATEKEER_VERSION="10.0.0",
    CUSTOM_DOMAIN_NAME="custom-domain",
    CUSTOM_CLUSTER_ISSUER="tmaxcloud-issuer",
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";
local REDIRECT_URL = "jaeger." + CUSTOM_DOMAIN_NAME;

if cluster_name == "master" then [
  {
    "apiVersion": "networking.k8s.io/v1",
    "kind": "Ingress",
    "metadata": {
      "name": "jaeger-ingress",
      "namespace": "istio-system",
      "labels": {
        "app": "jaeger",
        "app.kubernetes.io/name": "jaeger",
        "app.kubernetes.io/component": "query",
        "ingress.tmaxcloud.org/name": "jaeger"
      },
      "annotations": {
        "traefik.ingress.kubernetes.io/router.entrypoints": "websecure"
      }
    },
    "spec": {
      "ingressClassName": "tmax-cloud",
      "rules": [
        {
          "host": std.join("", ["jaeger.", CUSTOM_DOMAIN_NAME]),
          "http": {
            "paths": [
              {
                "backend": {
                  "service": {
                    "name": "jaeger-query",
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
            std.join("", ["jaeger.", CUSTOM_DOMAIN_NAME]),
          ]
        }
      ]
    }
  }
] else []
