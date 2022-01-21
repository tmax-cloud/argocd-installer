# GRAFANA

argocd에서 grafana 배포를 하기 위해서는 application/grafana.yaml의 top-level arguments(tlas)를 설정해야 한다.

### grafana.yaml
```yml
- name: is_offline
  value: "false"
- name: private_registry
  value: "" 
- name: domain 
  value: ""--> grafana ingress주소
- name: client_id
  value: "grafana"
- name: tmax_client_secret
  value: tmax_client_secret
- name: keycloak_addr
  value: "" --> hyperauth 주소
- name: grafana_pvc
  value: "" --> grafana pvc 용량
- name: grafana_version
  value: 6.4.3
- name: grafana_image_repo
  value: "" 
- name: ingress_domain
  value: "" -- > hypercloud ingress 주소
```

### 예시

```yml
- name: is_offline
  value: "false"
- name: private_registry
  value: registry.tmaxcloud.org
- name: domain
  value: "grafana.tmaxcloud.org"
- name: client_id
  value: "grafana"
- name: tmax_client_secret
  value: tmax_client_secret
- name: keycloak_addr
  value: "hyperauth.tmaxcloud.org"
- name: grafana_pvc
  value: 10Gi
- name: grafana_version
  value: 6.4.3
- name: grafana_image_repo
  value: grafana/grafana
- name: ingress_domain
  value: "tmaxcloud.org"
```
