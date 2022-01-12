function (
    KEYCLOAK_ADDR="hyperauth.172.22.6.18.nip.io",

)

[
  {
    apiVersion: 'v1',
    kind: 'ConfigMap',
    metadata: {
      name: 'kiali',
      namespace: 'istio-system',
      labels: {
        app: 'kiali',
        release: 'istio',
      },
    },
    data: {
      'config.yaml': "istio_component_namespaces:\n  grafana: monitoring\n  tracing: istio-system\n  pilot: istio-system\n  prometheus: monitoring\nistio_namespace: istio-system\nauth:\n  strategy: \"openid\"\n  openid:\n    client_id: \"hypercloud5\"\n    issuer_url: \"https://"+KEYCLOAK_ADDR"+:/auth/realms/tmax\"\n    authorization_endpoint: \"https://"+KEYCLOAK_ADDR+":/auth/realms/tmax/protocol/openid-connect/auth\"\ndeployment:\n  accessible_namespaces: ['**']\nlogin_token:\n  signing_key: \"wl5oStULbP\"\nserver:\n  port: 20001\n  web_root: /api/kiali\nexternal_services:\n  istio:\n    url_service_version: http://istio-pilot.istio-system:8080/version\n  tracing:\n    url:\n    in_cluster_url: http://tracing/api/jaeger\n  grafana:\n    url:\n    in_cluster_url: http://grafana.monitoring:3000\n  prometheus:\n    url: http://prometheus-k8s.monitoring:9090\n",
    },
  },
]
