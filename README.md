# argocd-installer

# Guide for Developers

- Usage 참조([Link](https://docs.google.com/presentation/d/1vNm_wXgFcz8VW4_dZ11GOqYZBmyWuDKk/edit?usp=sharing&ouid=100684186425061538512&rtpof=true&sd=true))

- Module manifest 경로
    - manifest/(모듈명)/(manifest files)
        ```
        ex) manifest/cluster-api/cluster-api-components-v0.3.16.yaml
        ```
    - Manifest는 다음중 하나를 이용
        - kustomize
        - Helm
        - Jsonnet
        - Plain yaml/json files

- Module application 경로
    - application/ 하위에 (모듈명).yaml로 저장
    - form/ 하위 파일 참조

- Application별 공통화 변수
    - 이미지 레포마다 변수화를 해서 추가를 해주셔야합니다.  
        ex) image: gcr.io/kubebuilder/kube-rbac-proxy:v0.5.0  
            > 변수 선언  
            >> gcr_registry: "gcr.io"  
            > json image key value  
            >> "image": std.join("", [gcr_registry, "/kubebuilder/kube-rbac-proxy:v0.5.0"])

    - 예시
        ```
        function(
            tmax_registry: "tmaxcloudck"
        )

        [
            {
                "apiVersion": "v1",
                "kind": "Deployment",
                ...
                "spec": {
                    "template": {
                        "spec": {
                            "containers": {
                                "image": std.join("", [tmax_registry, "/image_name:image_tag"])
                                ...
                            }
                            ...
                        }
                    }
                    ...
                }
            }
            ...
        ]
        ```