<!--- app-name: Oauth2-proxy -->

# Oauth2-proxy 설치 가이드
- [개요](#개요)
- [사전 조건](#사전-조건-(Prerequisites))
- [요약](#요약-(TL;DR))
- [차트 설치](#차트-설치)
- [차트 삭제](#차트-삭제)
- [변수 목록](#변수-목록-(Parameters))
- [추가 내용](#추가-내용)

## 개요
tmax전용 Oauth2-proxy는 HyperAuth를 ID Provider로 사용하는 OIDC 인증 Client입니다. 


## 사전 조건 (Prerequisites)
- 필수 설치
    - [cert-manager](https://github.com/tmax-cloud/charts/tree/main/charts/cert-manager)
    - [gateway](https://github.com/tmax-cloud/charts/tree/main/charts/gateway)
      - gateway chart 1.3.1 이상 사용을 권장
## 요약 (TL;DR)
```shell
helm repo add tmax-cloud https://https://tmax-cloud.github.io/charts/
helm repo update
helm install oauth2-proxy tmax-cloud/oauth2-proxy --namespace api-gateway-system --create-namespace
```

## 차트 설치
```shell
helm repo add tmax-cloud https://https://tmax-cloud.github.io/charts/
helm repo update
helm install oauth2-proxy tmax-cloud/oauth2-proxy --namespace api-gateway-system --create-namespace
```
> **Tip**: 설치된 차트들 확인 `helm list -A`
### values.yaml 로 파라미터 설정하기
1. 차트 설치 시 values.yaml의 값을 사용하여 원하는 설정을 할 수 있습니다.
```shell
# 최신 차트의 values.yaml 가져오기: 
helm show values tmax-cloud/oauth2-proxy > values.yaml
# 특정 버전(예, v1.0.3) 차트의 values.yaml 가져오기: 
helm show values tmax-cloud/oauth2-proxy --version v1.0.1 > values.yaml
```
2. 에디터(vi 등)로 필요한 parameters 설정하고 저장합니다.
3. 파라미터가 설정된 values.yaml 파일로 차트를 설치합니다.
```shell
helm install oauth2-proxy tmax-cloud/oauth2-proxy --values values.yaml --namespace api-gateway-system --create-namespace
```

### (필요 시) yaml 파일을 통한 설치
```shell
helm template oauth2-proxy tmax-cloud/oauth2-proxy --values values.yaml --namespace api-gateway-system > oauth2-proxy-template.yaml
kubectl apply -f oauth2-proxy-template.yaml
```

## 차트 삭제
```shell
helm uninstall oauth2-proxy -n api-gateway-system
```

## 변수 목록 (Parameters)

The following table lists the configurable parameters of the oauth2-proxy chart and their default values.

| Parameter                                       | Description                                                                                                                                                | Default                                                  |
|-------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------|
| `domain`                                        | oauth2-roxy domain (eg tmaxcloud.org)                                                                                                                      | `""`                                                     |
| `timeZone`                                      | container time zone                                                                                                                                        | `"UTC"`                                                  |
| `config.clientID`                               | oauth client ID                                                                                                                                            | `""`                                                     |
| `config.clientSecret`                           | oauth client secret                                                                                                                                        | `""`                                                     |
| `config.cookieSecret`                           | server specific cookie for the secret; create a new one with `openssl rand -base64 32 \                                                                    | head -c 32 \                                             | base64` | `""`
| `config.cookieName`                             | The name of the cookie that oauth2-proxy will create.                                                                                                      | `""`                                                     |
| `extraArgs`                                     | key:value list of extra arguments to give the binary                                                                                                       | `{}`                                                     |
| `image.pullPolicy`                              | Image pull policy                                                                                                                                          | `IfNotPresent`                                           |
| `image.repository`                              | Image repository                                                                                                                                           | `docker.io/tmaxcloudck/oauth2-proxy`                     |
| `image.tag`                                     | Image tag                                                                                                                                                  | `v7.3.0`                                                 |
| `imagePullSecrets`                              | Specify image pull secrets                                                                                                                                 | `nil` (does not add image pull secrets to deployed pods) |
| `sessionStorage.type`                           | Session storage type which can be one of the following: cookie or redis                                                                                    | `cookie`                                                 |
| `sessionStorage.redis.existingSecret`           | existing Kubernetes secret to use for redis-password and redis-sentinel-password                                                                           | `""`                                                     |
| `sessionStorage.redis.password`                 | Redis password. Applicable for all Redis configurations. Taken from redis subchart secret if not set. sessionStorage.redis.existingSecret takes precedence | `nil`                                                    |
| `sessionStorage.redis.clientType`               | Allows the user to select which type of client will be used for redis instance. Possible options are: `sentinel`, `cluster` or `standalone`                | `standalone`                                             |
| `sessionStorage.redis.standalone.connectionUrl` | URL of redis standalone server for redis session storage (e.g. redis://HOST[:PORT]). Automatically generated if not set.                                   | `""`                                                     |
| `sessionStorage.redis.cluster.connectionUrls`   | List of Redis cluster connection URLs (e.g. redis://HOST[:PORT])                                                                                           | `[]`                                                     |
| `sessionStorage.redis.sentinel.password`        | Redis sentinel password. Used only for sentinel connection; any redis node passwords need to use `sessionStorage.redis.password`                           | `nil`                                                    |
| `sessionStorage.redis.sentinel.masterName`      | Redis sentinel master name                                                                                                                                 | `nil`                                                    |
| `sessionStorage.redis.sentinel.connectionUrls`  | List of Redis sentinel connection URLs (e.g. redis://HOST[:PORT])                                                                                          | `[]`                                                     |
| `redis.enabled`                                 | Enable the redis subchart deployment                                                                                                                       | `false`                                                  |
| `checkDeprecation`                              | Enable deprecation checks                                                                                                                                  | `true`                                                   |
| `metrics.enabled`                               | Enable Prometheus metrics endpoint                                                                                                                         | `true`                                                   |
| `metrics.port`                                  | Serve Prometheus metrics on this port                                                                                                                      | `44180`                                                  |
| `metrics.servicemonitor.enabled`                | Enable Prometheus Operator ServiceMonitor                                                                                                                  | `false`                                                  |
| `metrics.servicemonitor.namespace`              | Define the namespace where to deploy the ServiceMonitor resource                                                                                           | `""`                                                     |
| `metrics.servicemonitor.prometheusInstance`     | Prometheus Instance definition                                                                                                                             | `default`                                                |
| `metrics.servicemonitor.interval`               | Prometheus scrape interval                                                                                                                                 | `60s`                                                    |
| `metrics.servicemonitor.scrapeTimeout`          | Prometheus scrape timeout                                                                                                                                  | `30s`                                                    |
| `metrics.servicemonitor.labels`                 | Add custom labels to the ServiceMonitor resource                                                                                                           | `{}`                                                     |
| `extraObjects`                                  | Extra K8s manifests to deploy                                                                                                                              | `[]`                                                     |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`

## 추가 내용
### self-signed 인증서 마운트 (optional)
- 인증서가 self-signed 인 경우, 아래와 같이 인증서를 마운트해야 합니다.
- 아래 값을 values.yaml에 추가합니다. 
```yaml
extraVolumes:
  - name: ca-certificates
    secret:
      secretName: [self-signed 시크릿명]
extraVolumeMounts:
    - name: ca-certificates
      mountPath: /etc/ssl/certs/
```
