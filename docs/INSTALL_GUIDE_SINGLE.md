# Installation Guide for SINGLE Cluster
## Prerequisites
    1. ArgoCD([Install guide link](https://github.com/tmax-cloud/install-argocd))
---
## How to install
1. application file 생성
    - 아래 명령어를 통해 application file을 생성해준다.
        ```
        $ cp application/app_of_apps/single-applications.yaml application/app_of_apps/{{ cluster namespace }}-{{ cluster name }}-applications.yaml
        ```
        ex) "cluster"라는 이름의 클러스터가 default namespace에 있을 경우,  
        ```
        $ cp application/app_of_apps/single-applications.yaml application/app_of_apps/default-cluster-applications.yaml
        ```
---
2. application 변수 셋팅
    - 1번에서 생성한 파일을 수정한다.
    - 변경해야 하는 값은 파일안의 주석을 참조한다.
---
3. application 등록
    - "마스터클러스터 환경"에 application을 등록
        ```
        $ kubectl -n argocd apply -f application/app_of_apps/{{ cluster namespace }}-{{ cluster name }}-applications.yaml
        ```
---
4. resource 배포(application sync)
    - 마스터와 동일하므로 마스터 설치 가이드 4번 항목 참조([링크](INSTALL_GUIDE_MASTER.md#how-to-install))