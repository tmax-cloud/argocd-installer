# Opensearch-Fluentd

argocd에서 Opensearch-fluentd 배포를 하기 위해서는 application/opensearch.yaml의 top-level arguments(tlas)를 설정해야 한다.

### opensearch.yaml
```yml
- name: is_offline
  value: "boolean, default is false"
  
- name: private_registry
  value: "private_registry for image pull"
  
- name: log_level
  value: "log_level settings for opensearch stack. ex) info, error, debug"
  
- name: os_image_tag
  value: "OpenSearch image"
  
- name: busybox_image_tag
  value: "Busybox image"
  
- name: os_volume_size
  value: "Volume size for OpenSearch"
  
- name: dashboard_image_tag
  value: "OpenSearch-Dashboards image"
  
- name: dashboard_svc_type
  value: "type of service object, if ingress is unavailable use LoadBalancer, else ClusterIP "
  
- name: opensearch_client_id
  value: "Hyperauth client id for OpenSearch-Dashboards"
  
- name: tmax_client_secret
  value: "Hyperauth client secret for OpenSearch-Dashboards"
  
- name: hyperauth_url
  value: "Hyperauth URL"
  
- name: hyperauth_realm
  value: "Hyperauth realm name for OpenSearch-Dashboards"
  
- name: custom_domain_name
  value: "custom domain name for ingress"
  
- name: fluentd_image_tag
  value: "Fluentd image"
```

### 예시

```yml
- name: is_offline
  value: false
- name: private_registry
  value: 172.22.6.2:5000
- name: log_level
  value: info
- name: os_image_tag
  value: 1.3.7
- name: busybox_image_tag
  value: 1.32.0
- name: os_volume_size
  value: 50Gi
- name: dashboard_image_tag
  value: 1.3.7
- name: dashboard_svc_type
  value: ClusterIP
- name: opensearch_client_id
  value: opensearch
- name: tmax_client_secret
  value: tmax_client_secret
- name: hyperauth_url
  value: hyperauth.tmaxcloud.org
- name: hyperauth_realm
  value: tmax
- name: custom_domain_name
  value: tmaxcloud.org
- name: fluentd_image_tag
  value: fluentd-v1.15.3-debian-elasticsearch-1.0
```
