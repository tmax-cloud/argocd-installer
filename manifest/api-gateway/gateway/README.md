<!--- app-name: Gateway -->

# Gateway 설치 가이드
- [개요](#개요)
- [사전 조건](#사전-조건-(Prerequisites))
- [요약](#요약-(TL;DR))
- [차트 설치](#차트-설치)
- [차트 삭제](#차트-삭제)
- [변수 목록](#변수-목록-(Parameters))

## 개요
Hypercloud console에 사용되는 API Gateway입니다. 

## 사전 조건 (Prerequisites)
- 필수 설치
    - [cert-manager](https://github.com/tmax-cloud/charts/tree/main/charts/cert-manager)

## 요약 (TL;DR)
```shell
helm repo add tmax-cloud https://https://tmax-cloud.github.io/charts/
helm repo update
helm install gateway tmax-cloud/gateway --namespace api-gateway-system --create-namespace
```

## 차트 설치
```shell
helm repo add tmax-cloud https://https://tmax-cloud.github.io/charts/
helm repo update
helm install gateway tmax-cloud/gateway --namespace api-gateway-system --create-namespace
```
> **Tip**: 설치된 차트들 확인 `helm list -A`
### values.yaml 로 파라미터 설정하기
1. 차트 설치 시 values.yaml의 값을 사용하여 원하는 설정을 할 수 있습니다.
```shell
# 최신 차트의 values.yaml 가져오기: 
helm show values tmax-cloud/gateway > values.yaml
# 특정 버전(예, v1.0.3) 차트의 values.yaml 가져오기: 
helm show values tmax-cloud/gateway --version 1.3.1 > values.yaml
```
2. 에디터(vi 등)로 필요한 parameters 설정하고 저장합니다.
3. 파라미터가 설정된 values.yaml 파일로 차트를 설치합니다.
```shell
helm install gateway tmax-cloud/gateway --values values.yaml --namespace api-gateway-system --create-namespace
```

### (필요 시) yaml 파일을 통한 설치
```shell
helm template gateway tmax-cloud/gateway --values values.yaml --namespace api-gateway-system > gateway-template.yaml
kubectl apply -f gateway-template.yaml
```

## 차트 삭제
```shell
helm uninstall gateway -n api-gateway-system
```

## 변수 목록 (Parameters)

| Parameter                      | Description                                                                                | Default             |
|--------------------------------|--------------------------------------------------------------------------------------------|---------------------|
| `tls.domain`                   | domain name                                                                                | `""`                |
| `tls.acme.enabled`             | Flag to use [ACME](https://cert-manager.io/docs/configuration/acme/) for TLS certification | `false`             |
| `tls.acme.email`               | email                                                                                      | `"temp@tmax.co.kr"` |
| `tls.acme.dns.type`            | dns type [route53](https://cert-manager.io/docs/configuration/acme/dns01/route53/)         | `"route53"`         |
| `tls.acme.dns.accessKeyID`     | route53 accessKeyID                                                                        | `"accessKeyID"`     |
| `tls.acme.dns.accessKeySecret` | route53 accessKeySecret                                                                    | `"accessKeySecret"` |
| `tls.acme.dns.hostedZoneID`    | route53 hostedZoneID                                                                       | `"hostZoneID"`      |
| `tls.acme.environment`         | "staging" for dev testing, "production" for production                                     | `"staging"`         | 
| `tls.selfsigned`               | selgsigned TLS certification                                                               | `true`              |
| `dashboard.enabled`            | enabled traefik dashboard                                                                  | `true`              |
| `dashboard.id`                 | login id of traefik dashboard (if using, should be set both id and password)               | `""`                |
| `dashboard.password`           | login password of traefik dashboard                                                        | `""`                |
| `traefik.enabled`              | Flag to install traefik                                                                    | `true`              |
| `traefik.image.name`           | image name                                                                                 | `"traefik"`         |
| `traefik.image.tag`            | image tag                                                                                  | `"v2.8.7"`          |
| `traefik.service.type`         | service type                                                                               | `"LoadBalacer"`     |                                |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install gateway . \
  --set=tls.domain=tmaxcloud.org,traefik.image.name=traefik
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install gateway . -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)
