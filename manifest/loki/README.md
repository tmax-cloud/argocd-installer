# Loki

argocd에서 loki-promtail 배포를 하기 위해서는 application/loki.yaml의 top-level arguments(tlas)를 설정해야 한다.

### loki.yaml
```yml
- name: is_offline
  value: "boolean, default is false"
  
- name: private_registry
  value: "private_registry for image pull"
  
- name: log_level
  value: "log_level settings for loki stack, ex) error, warn, info, debug"
  
- name: loki_image_tag
  value: "Loki image"
  
- name: storage_class
  value: "StorageClassName for Loki PVC" 
  
- name: loki_volume_size
  value: "Volume size for Loki"
  
- name: promtail_image_tag
  value: "Promtail image"
```

### 예시

```yml
- name: is_offline
  value: false
- name: private_registry
  value: 172.22.6.2:5000
- name: log_level
  value: info
- name: loki_image_tag
  value: 2.7.1
- name: storage_class
  value: default
- name: loki_volume_size
  value: 50Gi
- name: promtail_image_tag
  value: 2.7.1
```
