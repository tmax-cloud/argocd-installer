<!--- app-name: Cert-manager -->

# Gateway 설치 가이드
- [개요](#개요)
- [사전 조건](#사전-조건-(Prerequisites))
- [요약](#요약-(TL;DR))
- [차트 설치](#차트-설치)
- [차트 삭제](#차트-삭제)
- [변수 목록](#변수-목록-(Parameters))

## 개요
Hypercloud의 x509 인증서를 발급하고 관리하는 어플리케이션 입니다. 

## 사전 조건 (Prerequisites)

## 요약 (TL;DR)
```shell
helm repo add tmax-cloud https://https://tmax-cloud.github.io/charts/
helm repo update
helm install cert-manager tmax-cloud/cert-manager --namespace cert-manager --create-namespace
```

## 차트 설치
```shell
helm repo add tmax-cloud https://https://tmax-cloud.github.io/charts/
helm repo update
helm install cert-manager tmax-cloud/cert-manager --namespace cert-manager --create-namespace
```
> **Tip**: 설치된 차트들 확인 `helm list -A`
### values.yaml 로 파라미터 설정하기
1. 차트 설치 시 values.yaml의 값을 사용하여 원하는 설정을 할 수 있습니다.
```shell
# 최신 차트의 values.yaml 가져오기: 
helm show values tmax-cloud/cert-manager > values.yaml
# 특정 버전(예, v1.0.3) 차트의 values.yaml 가져오기: 
helm show values tmax-cloud/cert-manager --version v1.1.3 > values.yaml
```
2. 에디터(vi 등)로 필요한 parameters 설정하고 저장합니다.
3. 파라미터가 설정된 values.yaml 파일로 차트를 설치합니다.
```shell
helm install cert-manager tmax-cloud/cert-manager --values values.yaml --namespace cert-manager --create-namespace
```

### (필요 시) yaml 파일을 통한 설치
```shell
helm template cert-manager tmax-cloud/cert-manager --values values.yaml --namespace cert-manager > cert-manager-template.yaml
kubectl apply -f cert-manager-template.yaml
```

## 차트 삭제
```shell
helm uninstall cert-manager -n cert-manager
```