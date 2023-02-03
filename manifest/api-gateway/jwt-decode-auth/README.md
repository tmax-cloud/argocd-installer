<!--- app-name: Jwt-decode-auth -->

# Jwt-decode-auth 설치 가이드
- [개요](#개요)
- [사전 조건](#사전-조건-(Prerequisites))
- [요약](#요약-(TL;DR))
- [차트 설치](#차트-설치)
- [차트 삭제](#차트-삭제)
- [변수 목록](#변수-목록-(Parameters))
- [추가 내용](#추가-내용)

## 개요
jwt-decode는 HyperCloud API Gateway에서 token의 검증이나 교체가 필요한 경우에 사용되는 middleware이다.
- 어떠한 상황에 이 middleware를 사용할지는 Ingress 혹은 IngressRoute를 통해 설정한다.
- middleware가 사용되는 상황이면, API Gateway의 요청이 middleware를 거쳐 가공된 후 다시 API Gateway로 되돌아간다.
- 참고 : [Traefik Proxy Middleware Overview](https://doc.traefik.io/traefik/middlewares/overview/)

## 사전 조건 (Prerequisites)
- 필수 설치
    - [cert-manager](https://github.com/tmax-cloud/charts/tree/main/charts/cert-manager)
    - [gateway](https://github.com/tmax-cloud/charts/tree/main/charts/gateway)
        - gateway 최신 chart를 사용할 것을 권장합니다.
## 요약 (TL;DR)
```shell
helm repo add tmax-cloud https://https://tmax-cloud.github.io/charts/
helm repo update
helm install jwt-decode-auth tmax-cloud/jwt-decode-auth --namespace api-gateway-system
```

## 차트 설치
```shell
helm repo add tmax-cloud https://https://tmax-cloud.github.io/charts/
helm repo update
helm install jwt-decode-auth tmax-cloud/jwt-decode-auth --namespace api-gateway-system
```
> **Tip**: 설치된 차트들 확인 `helm list -A`
### values.yaml 로 파라미터 설정하기
1. 차트 설치 시 values.yaml의 값을 사용하여 원하는 설정을 할 수 있습니다.
```shell
# 최신 차트의 values.yaml 가져오기: 
helm show values tmax-cloud/jwt-decode-auth > values.yaml
# 특정 버전(예, v1.0.3) 차트의 values.yaml 가져오기: 
helm show values tmax-cloud/jwt-decode-auth --version 1.0.1 > values.yaml
```
2. 에디터(vi 등)로 필요한 parameters 설정하고 저장합니다.
3. 파라미터가 설정된 values.yaml 파일로 차트를 설치합니다.
```shell
helm install oauth2-proxy tmax-cloud/jwt-decode-auth --values values.yaml --namespace api-gateway-system
```

### (필요 시) yaml 파일을 통한 설치
```shell
helm template jwt-decode-auth tmax-cloud/jwt-decode-auth --values values.yaml --namespace api-gateway-system > jwt-decode-auth-template.yaml
kubectl apply -f jwt-decode-auth-template.yaml
```

## 차트 삭제
```shell
helm uninstall jwt-decode-auth -n api-gateway-system
```

## 변수 목록 (Parameters)

The following table lists the configurable parameters of the oauth2-proxy chart and their default values.

| Parameter                                       | Description                                                                                                                                                | Default                                                  |
|-------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------|
| `hyperAuth.address`                             | oauth2-roxy domain (eg tmaxcloud.org)                                                                                                                      | `""`                                                     |
| `hyperAuth.realm`                               | container time zone                                                                                                                                        | `"UTC"`                                                  |
| `timeZone`                                      | oauth client ID                                                                                                                                            | `""`                                                     |
| `logInfo.logLevel`                              | oauth client secret                                                                                                                                        | `""`                                                     |
| `logInfo.logType`                               | server specific cookie for the secret; create a new one with `openssl rand -base64 32 \                                                                    | head -c 32 \                                             | base64` | `""`
| `middleware.enabled`                            | The name of the cookie that oauth2-proxy will create.                                                                                                      | `""`                                                     |
| `image.pullPolicy`                              | Image pull policy                                                                                                                                          | `IfNotPresent`                                           |
| `image.repository`                              | Image repository                                                                                                                                           | `docker.io/tmaxcloudck/oauth2-proxy`                     |
| `image.tag`                                     | Image tag                                                                                                                                                  | `v7.3.0`                                                 |
| `imagePullSecrets`                              | Specify image pull secrets                                                                                                                                 | `nil` (does not add image pull secrets to deployed pods) |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`