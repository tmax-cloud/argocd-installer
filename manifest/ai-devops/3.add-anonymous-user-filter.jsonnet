function (
    is_offline="false",
    private_registry="172.22.6.2:5000",
    ai_devops_namespace="kubeflow",
    istio_namespace="istio-system",
    knative_namespace="knative-serving",
    custom_domain_name="tmaxcloud.org",
    notebook_svc_type="Ingress"
)

[
    {
    "apiVersion": "networking.istio.io/v1alpha3",
    "kind": "EnvoyFilter",
    "metadata": {
        "name": "add-user-filter",
        "namespace": istio_namespace
    },
    "spec": {
        "workloadLabels": {
        "app": "istio-ingressgateway"
        },
        "filters": [
        {
            "listenerMatch": {
            "listenerType": "GATEWAY"
            },
            "filterName": "envoy.lua",
            "filterType": "HTTP",
            "insertPosition": {
            "index": "FIRST"
            },
            "filterConfig": {
            "inlineCode": "function envoy_on_request(request_handle)\n    request_handle:headers():add(\"kubeflow-userid\",\"anonymous@kubeflow.org\")\nend\n"
            }
        }
        ]
    }
    }
]