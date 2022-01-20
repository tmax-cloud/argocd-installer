# EFK

argocd에서 EFK 배포를 하기 위해서는 application/efk.yaml의 top-level arguments(tlas)를 설정해야 한다.

### efk.yaml
```yml
- name: is_offline
  value: "boolean, default is false"
  
- name: private_registry
  value: "private_registry for image pull"
  
- name: es_image_tag
  value: "ElasticSearch image"
  
- name: busybox_image_tag
  value: "Busybox image"
  
- name: es_volume_size
  value: "Volume size for ElasticSearch"
  
- name: kibana_image_tag
  value: "Kibana image"
  
- name: kibana_svc_type
  value: "type of service object, if ingress is unavailable use LoadBalancer, else ClusterIP "
  
- name: gatekeeper_image_tag
  value: "Gatekeeper image"
  
- name: kibana_client_id
  value: "Hyperauth client id for EFK Kibana"
  
- name: tmax_client_secret
  value: "Hyperauth client secret for EFK Kibana"
  
- name: hyperauth_url
  value: "Hyperauth URL"
  
- name: hyperauth_realm
  value: "Hyperauth realm name for EFK Kibana"
  
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
- name: es_image_tag
  value: docker.io/tmaxcloudck/elasticsearch:7.2.1
- name: busybox_image_tag
  value: docker.io/busybox:1.32.0
- name: es_volume_size
  value: 50Gi
- name: kibana_image_tag
  value: docker.io/kibana/kibana:7.2.0
- name: kibana_svc_type
  value: ClusterIP
- name: gatekeeper_image_tag
  value: quay.io/keycloak/keycloak-gatekeeper:10.0.0
- name: kibana_client_id
  value: kibana
- name: tmax_client_secret
  value: tmax_client_secret
- name: hyperauth_url
  value: hyperauth.tmaxcloud.org
- name: hyperauth_realm
  value: tmax
- name: custom_domain_name
  value: tmaxcloud.org
- name: fluentd_image_tag
  value: docker.io/fluent/fluentd-kubernetes-daemonset:v1.4.2-debian-elasticsearch-1.1
```
