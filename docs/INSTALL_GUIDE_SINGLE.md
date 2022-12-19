# Installation Guide for SINGLE Cluster(v1.1.0)
## Prerequisites
- Master cluster Argocd 설치
- Single cluster 생성
---
## How to install
1. Argocd 대시보드에 접속하기  
    1) hypercloud console에 접속 
    2) 좌측의 [멀티 클러스터] 탭 클릭
    3) [클러스터] 탭에서 생성한 클러스터의 상태에서 [SyncNeeded]를 클릭
        - 상태가 SyncNeeded가 아니라면, SyncNeeded가 될 때까지 기다린다
    4) argocd application 대시보드로 접속    
---
2. Argocd Application Repository 경로 설정하기
    1) application 대시보드 [SUMMARY] tab에서 [EDIT] 버튼 클릭
    2) [REPO URL]에 repository 경로 기입
        - gitlab repository의 경우 마지막에 .git을 함께 기입
        - ex) https://github.com/tmax-cloud/argocd-installer
        - ex) https://gitlab.com/tmax-cloud/argocd-installer.git
    3) [TARGET REVISION]에 사용할 revision 기입    
        - ex) main
    4) [SAVE] 버튼을 클릭해서 저장
---
3. Application 변수 세팅하기 
    1) application 대시보드 [PARAMETERS] tab에서 [EDIT] 버튼 클릭
    2) 한글로 표시되어 있는 부분 변경 
    3) [SAVE] 버튼을 클릭해서 저장 
---
4. Resource 배포하기(Application Sync)
    1) 상위 Application의 햄버거 버튼에서 [Sync] 버튼 클릭
    2) [SYNCHRONIZE] 버튼 클릭
    3) 하위 Application들이 모두 Sync될 때까지 기다린다.  
    4) 이후의 Application Sync는 마스터와 동일하므로 [마스터 설치 가이드](INSTALL_GUIDE_MASTER.md#how-to-install) 4번 항목 참조


<br/>

<br/>

# Installation Guide for SINGLE Cluster(v1.0.0 - v1.0.2)
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