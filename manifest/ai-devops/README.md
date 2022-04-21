# AI-DEVOPS

application/ai-devops.yaml의 top-level arguments(tlas) 설정 가이드입니다.

## 참고

argocd로 ai-devops 설치시 CRD(inferenceservice, tfjob, pytorchjob) size로 인하여 Too long 에러가 발생하므로
gui로 application을 create 혹은 synchronize 할 때 REPLACE 옵션을 체크하여 apply가 아닌 create로 생성될수 있도록 한다.
synchronize시 synchronize resources에 configmap과 같은 해당 crd 이외의 리소스가 체크되면 already exist 에러가 발생할수 있으니 필요 리소스들(inferenceservice, tfjob, pytorchjob)만 체크될 수 있도록 한다.


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
