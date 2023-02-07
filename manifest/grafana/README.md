# GRAFANA

argocd에서 grafana 배포를 하기 위해서는 application/grafana.yaml의 top-level arguments(tlas)를 설정해야 한다.

### grafana.yaml
```yml
- name: is_offline
  value: "false"
- name: private_registry
  value: "" 
- name: grafana_pvc
  value: "" --> grafana pvc 용량
- name: grafana_version
  value: ""
- name: grafana_image_repo
  value: "" 
```

### 예시

```yml
- name: is_offline
  value: "false"
- name: private_registry
  value: registry.tmaxcloud.org
- name: grafana_pvc
  value: 10Gi
- name: grafana_version
  value: 9.3.2
- name: grafana_image_repo
  value: grafana/grafana
```
