{
    ### Cluster configuration
    # description: name or server
    cluster_info_type: "server",
    cluster_info:      "https://kubernetes.default.svc",
    project:           "default",

    ### Environment configuration
    network_disabled: "true",
    private_registry: "172.22.6.2:5000",
    # description: "gitlab" or "github"
    repo_provider:    "gitlab",
    repo_url:         "https://gitlab-deploy.gitlab-test-deploy.172.22.6.53.nip.io/root/argocd-installer",
    branch:           "master",

    ### Module specific configurations
    ## Shared variables
    domain:                 "ckcloud.org",
    keycloak_domain:        "hyperauth.ckcloud.org",
    keycloak_client_secret: "tmax_client_secret",
    
    ## Hyperauth variables
    hyperauth_svc_type: "Ingress",

    ## Efk variables
    es_image_tag:         "7.2.1",
    busybox_image_tag:    "docker.io/busybox:1.32.0",
    es_resource_limit_memory:       "8Gi",
    es_resource_request_memory:       "5Gi",
    es_jvm_heap:       "-Xms4g -Xmx4g",
    es_volume_size:       "50Gi",
    kibana_image_tag:     "docker.elastic.co/kibana/kibana:7.2.0",
    kibana_svc_type:      "ClusterIP",
    gatekeeper_image_tag: "quay.io/keycloak/keycloak-gatekeeper:10.0.0",
    fluentd_image_tag:    "docker.io/fluent/fluentd-kubernetes-daemonset:v1.4.2-debian-elasticsearch-1.1",

    ## Prometheus variables
    configmap_reload_version:           "v0.0.1",
    configmap_reloader_version:         "v0.34.0",
    prometheus_operator_version:        "v0.34.0",
    alertmanager_version:               "v0.20.0",
    prometheus_kube_rbac_proxy_version: "v0.4.1",
    kube_state_metrics_version:         "v1.8.0",
    prometheus_node_exporter_version:   "v0.18.1",
    prometheus_adapter_version:         "v0.5.0",
    prometheus_pvc_size:                "10Gi",
    prometheus_version:                 "v2.11.0",

    ## Grafana variables
    grafana_pvc_size:   "10Gi",
    grafana_version:    "6.4.3",
    grafana_image_repo: "grafana/grafana",

    ## Istio variables
    # None

    ## Jaeger variables
    # None
    
    ## Kiali variables
    # None

    ## Cluster-api variables
    capi_provider_aws_enabled:     "true",
    capi_provider_vsphere_enabled: "false",

    ## Cluster-api-aws variables
    # description: 아래 형식에 맞추어 파일을 생성한후 base64 encoding하여 나온값을 입력
    # [default]
    # aws_access_key_id = {{ aws-access-key }}
    # aws_secret_access_key = {{ aws-secret-access-key }}
    # region = {{ aws-region }}
    aws_credential: "",

    ## Cluster-api-provider-vsphere variables
    # description: vCenter에 로그인할때 쓰이는 계정정보를 기재
    vsphere_username: "user@vsphere.local",
    vsphere_password: "password",

    ## Template-service-broker variables
    template_operator_version: "0.2.6",
    cluster_tsb_version:       "0.1.3",
    tsb_version:               "0.1.3",

    ## Catalog-controller variables
    # None

    ## Service-broker variables
    # None

    ## Hypercloud variables
    multimode_enabled:        "true",
    hypercloud_kafka_enabled: "true",

    ## Tekton-pipeline variables
    # None

    ## Tekton-trigger variables
    # None

    ## Cicd-operator variables
    # None

    ## Ai-devops
    ai_devops_namespace: "kubeflow",
    knative_namespace:   "knative-serving",
    notebook_svc_type:   "Ingress",
}
