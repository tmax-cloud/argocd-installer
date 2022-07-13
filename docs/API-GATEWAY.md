# API-GATEWAY 

Api-gateway is a HTTP reverse proxy and a ingress controller for tmax-cloud modules.

## Introduction

Api-gateway consist of a total of 4 charts.
- Cert-manager
- gateway (traefik) <-- Core Module
  - required: cert-manager
- jwt-decode-auth
  - required: hyperauth
- console 
  - required: hyperauth 

## Installing 

### Prerequisites 

With the command `helm version`, make sure that you have:
- Helm v3 [installed](https://helm.sh/docs/using_helm/#installing-helm)

### Deploying Api-Gateway (Using argocd)
1. install cert-manager (optional)
- configure cert-manager values to /manifest/api-gateway/cert-manager/values.yaml 
```shell
kubectl apply -f /application/api-gateway/cert-manager.yaml
````
2. install gateway
- configure gateway values to /manifest/api-gateway/gateway/values.yaml
```shell
kubectl apply -f /application/api-gateway/gateway.yaml
````
3. install jwt-decode-auth
- configure jwt-decode-auth values to /manifest/api-gateway/jwt-decode-auth/values.yaml
```shell
kubectl apply -f /application/api-gateway/jwt-decode-auth.yaml
````
4. install console
- configure console values to /manifest/api-gateway/console/values.yaml
```shell
kubectl apply -f /application/api-gateway/console.yaml
````

### Deploying Api-Gateway (using helm - self install)
1. Deploying cert-manager
```shell
cd cert-manager
```
- Setting the values at values.yaml
```yaml
tags:
  certManager: true

cert-manager:
  installCRDs: true
  fullnameOverride: "cert-manager"
  extraArgs:
    - "--dns01-recursive-nameservers=8.8.8.8:53"
    - "--dns01-recursive-nameservers-only"

global:
  createCA: true
  sleepyTime: 120
# kubectl create secret docker-registry regcred --docker-username=tmaxcloudck --docker-password=$PASSWD 
# imagePullSecrets:
#  - name: regcred
```
```shell
helm install cert-manager . --namespace cert-manager --create-namespace
```
2. Deploying gateway(traefik)
```shell
cd gateway
```
- Setting the values at values.yaml
```yaml
# Default values for gateway.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

tags:
  traefik: true

traefik:
  fullnameOverride: "gateway"
  additionalArguments:
    # Only use dev environment
    - "--serverstransport.insecureskipverify=true"
    - "--serverstransport.rootcas=/run/secrets/tmaxcloud/ca.crt, /run/secrets/kubernetes.io/serviceaccount/ca.crt"
    - "--entrypoints.websecure.http.middlewares=cors-header@file"
#  deployment:
#    imagePullSecrets:
#      - name: regcred
  volumes:
    - name: gateway-config
      mountPath: "/gateway-config"
      type: configMap
    - name: selfsigned-ca
      mountPath: "/run/secrets/tmaxcloud"
      type: secret

tls:
  acme: 
    enabled: false
    email: tmax@tmax.co.kr
    dns:
      type: route53
      accessKeyID: <your access key>
      accessKeySecret: <your secret key>
    domains:
#      - sunnycloud.link
      - tmaxcloud.org
    environment: staging
  selfsigned:
    createTLS: true
    useDefaultTLS: true
    commonName: tmaxcloud.local
    domains:
      - tmaxcloud.local
```
```shell
helm install api-gateway . --namespace api-gateway-system --create-namespace 
```
3. Deploying jwt-decode-auth (required hyperauth address, realm)
```shell
cd jwt-decode-auth 
```
- Setting the values at values.yaml
```yaml
hyperauth:
  address: hyperauth.org
  realm: tmax
middleware:
  enabled: true
```
```shell
helm install jwt-decode-auth . --namespace api-gateway-system
```
4. Deploying console (required hyperauth address, realm)
```shell
cd console
```
- Setting the values at values.yaml 
```yaml
nameOverride: "console"
fullnameOverride: "console"

console:
  auth:
    hyperauth: hyperauth.org
    realm: tmax
    clientid: hypercloud5
  mcMode: true
  chatbotEmbed: true

ingressroute:
  enabled: true
  domain:
    enabled: ture
    name: tmaxcloud.org
  ip:
    enabled: false
```
```shell
helm install console . --namespace api-gateway-system
```