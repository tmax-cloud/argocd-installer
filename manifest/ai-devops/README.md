# AI-DEVOPS

application/ai-devops.yaml의 top-level arguments(tlas) 설정 가이드입니다.

### ai-devops.yaml
```yml
- name: is_offline
  value: "boolean, default is false"
  
- name: private_registry
  value: "private_registry for image pull"
  
- name: ai_devops_namespace
  value: "namespace for ai-devops"

##service mesh 생성 namespace와 동일해야함  
- name: istio_namespace
  value: "namespace for cluster-local-gateway"
  
- name: knative_namespace
  value: "namespace for knative-serving"

- name: custom_domain_name
  value: "custom domain name for ingress"  
  
- name: notebook_svc_type
  value: "type of service object, if ingress is unavailable use LoadBalancer, else ClusterIP "

- name: tmax_client_secret
  value: "Hyperauth client secret for AI-DEVOPS notebook-gatekeeper"
  
- name: hyperauth_url
  value: "Hyperauth URL"
  
- name: hyperauth_realm
  value: "Hyperauth realm name for AI-DEVOPS"
```

### 예시

```yml
- name: is_offline
  value: false
- name: private_registry
  value: 172.22.6.2:5000
- name: ai_devops_namespace
  value: kubeflow
- name: istio_namespace
  value: istio-system
- name: knative_namespace
  value: knative-serving
- name: custom_domain_name
  value: tmaxcloud.org
- name: notebook_svc_type
  value: Ingress
- name: tmax_client_secret
  value: tmax_client_secret
- name: hyperauth_url
  value: hyperauth.tmaxcloud.org
- name: hyperauth_realm
  value: tmax
```
