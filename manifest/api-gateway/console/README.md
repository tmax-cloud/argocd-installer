<!--- app-name: Console -->

# Console 설치 가이드 
- [개요](#개요)
- [사전 조건](#사전-조건-(Prerequisites))
- [요약](#요약-(TL;DR))
- [차트 설치](#차트-설치)
- [차트 삭제](#차트-삭제)
- [변수 목록](#변수-목록-(Parameters))

## 개요
Console은 리액트로 개발된 UserInterface,UI 앱입니다. 
관리자가 클러스터를 손쉽게 관리하고 운영할 수 있는 편리한 UI 환경을 제공하며, 개발자는 편하고 안전하게 애플리케이션 배포와 운영을 도와줍니다. 
대시보드를 통해 클러스터의 상태를 한 눈에 감지할 수 있어, 장애에 빠르게 대응할 수 있습니다. 

Console은 기본적으로 gateway롤 기반으로 동작되기에 gateway가 필수로 설치되어 있어야합니다. 
또 한, Console은 Hyperauth를 통한 OIDC 기능을 통해 로그인, 로그아웃을
하기때문에 5.2 이상 버전에서 oauth2-proxy가 필수로 필요합니다. 

## 사전 조건 (Prerequisites)
- 필수 설치
  - [cert-manager](https://github.com/tmax-cloud/charts/tree/main/charts/cert-manager)
  - [gateway](https://github.com/tmax-cloud/charts/tree/main/charts/gateway)
- 콘솔 버전에 따른 설치 
  - hypercloud-console 이미지 버전이 5.2.x.x 인 경우 
    - [oauth2-proxy](https://github.com/tmax-cloud/charts/tree/main/charts/oauth2-proxy)
    - 유의 사항: api-gateway-system 네임스페이스에 oauth2-proxy 서비스로 설치되어 있어야 합니다. 
    - 설치 확인: `$ kubectl get svc -n api-gateway-system oauth2-proxy`
  - hypercloud-console 이미지 버전이 5.0.x.x 인 경우 
    - [jwt-decode-auth](https://github.com/tmax-cloud/charts/tree/main/charts/jwt-decode-auth) 
    - 유의 사항: api-gateway-system 네임스페이스에 jwt-decode-auth 서비스로 설치되어 있어야 합니다.
    - 설치 확인: `$ kubectl get svc -n api-gateway-system jwt-decode-auth`

## 요약 (TL;DR)
```shell
helm repo add tmax-cloud https://https://tmax-cloud.github.io/charts/
helm repo update
helm install console tmax-cloud/console --namespace api-gateway-system --create-namespace
```

## 차트 설치 
```shell
helm repo add tmax-cloud https://https://tmax-cloud.github.io/charts/
helm repo update
helm install console tmax-cloud/console --namespace api-gateway-system --create-namespace
```
> **Tip**: 설치된 차트들 확인 `helm list -A`
### values.yaml 로 파라미터 설정하기
1. 차트 설치 시 values.yaml의 값을 사용하여 원하는 설정을 할 수 있습니다.
```shell
# 최신 차트의 values.yaml 가져오기: 
helm show values tmax-cloud/console > values.yaml
# 특정 버전(예, v1.0.3) 차트의 values.yaml 가져오기: 
helm show values tmax-cloud/console --version 1.1.1 > values.yaml
```
2. 에디터(vi 등)로 필요한 parameters 설정하고 저장합니다. 
3. 파라미터가 설정된 values.yaml 파일로 차트를 설치합니다.
```shell
helm install console tmax-cloud/console --values values.yaml --namespace api-gateway-system --create-namespace
```

### (필요 시) yaml 파일을 통한 설치 
```shell
helm template console tmax-cloud/console --values values.yaml --namespace api-gateway-system > console-template.yaml
kubectl apply -f console-template.yaml
```

## 차트 삭제 
```shell
helm uninstall console -n api-gateway-system
```

## 변수 목록 (Parameters)

| 이름                        | 내용                                        | 기본값                                        |
|---------------------------|-------------------------------------------|--------------------------------------------|
| fullnameOverride          | 리소스 이름 지정                                 | "console"                                  |
| domain                    | 기본 도메인 지정 (예, tmaxcloud.org)              | ""                                         |
| subDomain                 | 콘솔 접속의 서브 도메인 지정 (예, console)             | "console"                                  |
| timeZone                  | 컨테이너 타임존 설정                               | UTC                                        |
| config.hyperAuth.address  | hyperauth 주소 (예, hyperauth.tmaxcloud.org) | ""                                         |
| config.hyperAuth.realm    | hyperauth realm 이름                        | tmax                                       |
| config.hyperAuth.clientID | hyperauth client id 이름                    | hypercloud5                                |
| config.mcMode             | 멀티 클러스터 화면(true), 싱글 클러스터 화면(false)       | true                                       |
| config.chatbotEmbed       | 챗봇 사용 유무                                  | true                                       |
| config.customProductName  | 제품 로고 설정 (hypercloud 혹은 supercloud)       | "hypercloud"                               |
| config.svcType            | 현재 실행 중인 Gateway의 서비스 타입 명시               | "LoadBalancer"                             |
| config.logLevel           | 로그 레벨 설정 (trace, debug, info, warn, crit) | "debug"                                    |
| config.logType            | 로그 타입 설정 (json, pretty)                   | "pretty"                                   |
| image.repository          | 도커 이미지 이름                                 | "docker.io/tmaxcloudck/hypercloud-console" |
| image.tag                 | 도커 이미지 태그                                 | "5.2.10.0"                                 |
