# argocd-installer

# Guide for Developers

- Usage 참조([Link](https://docs.google.com/presentation/d/1vNm_wXgFcz8VW4_dZ11GOqYZBmyWuDKk/edit?usp=sharing&ouid=100684186425061538512&rtpof=true&sd=true))

# Module manifest 경로
- manifest/(모듈명)/(manifest files)
    ```
    ex) manifest/cluster-api/cluster-api-components-v0.3.16.yaml
    ```
- Manifest는 다음중 하나를 이용
    - kustomize
    - Helm
    - Jsonnet
    - Plain yaml/json files

# Module application 경로
- application/ 하위에 (모듈명).yaml로 저장
- form/ 하위 파일 참조

# Application별 공통화 변수
- 모듈 Manifest에서 모두 공통으로 선언해주어야 하는 변수는 두개입니다.
    ```
    function (
        is_offline="false"
        private_registry="registry.tmaxcloud.org"
    )
    ```
    - is_offline은 true/false의 boolean 변수입니다.
    - 기본값은 false로 넣어주시길 바랍니다.
    - private_registry는 string 변수입니다.
    - 기본값은 아무거나 넣어주셔도 됩니다.
---
- 이미지 레포별 변수는 로컬로 추가해서 샤용합니다(해당 매니페스트에서만 사용되므로 이름이 모두 통일되거나 할 필요가 없습니다.)
    ```
    local tmax_registry = if is_offline == "false" then "tmaxcloudck" else private_registry;
    local gcr_registry = if is_offline == "false" then "gcr.io" else private_registry;
    ```
    - 위의 예시에서 tmax_registry, gcr_registry는 본인이 원하는대로 명명하시면 되고, 필요한 이미지 레지스트리 수만큼 선언하시면 됩니다.
---
- Deployment.spec.template.spec.containers.image 는 다음과 같이 작성합니다.
    ```
    ...
    "image": std.join("", [tmax_registry, "/hypercloud-multi-operator:latest"])
    ...
    "image": std.join("", [gcr_registry, "/kubebuilder/kube-rbac-proxy:v0.5.0"])
    ..
    ```
    - 이미지경로및 이미지 이름과 태그도 변수화하셔도 됩니다.
---
- 자세한 예는 [hypercloud/hypercloud.jsonnet](manifest/hypercloud/hypercloud.jsonnet) 예시를 참조바랍니다.