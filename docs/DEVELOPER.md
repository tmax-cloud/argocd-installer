# Guide for Developers

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