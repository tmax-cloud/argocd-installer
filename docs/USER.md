# Guide for Users
### ArgoCD를 이용한 resource 배포
1. prerequsites
    - argocd([Install guide link](https://github.com/tmax-cloud/install-argocd))
    - yq
---
## Master cluster
1. cluster configuration
    - cluster에 필요한 정보(registry domain, hyperclou domain등)를 셋팅한다.
    - 수정해야 하는 파일은 아래와 같다.
        ```
        $ application/helm/shared-values.yaml
        $ application/helm/master-values.yaml
        ```
    - git에 push한다.
---
2. application 변수 셋팅
    - 테스트할 환경에서 바라볼 git repo url, branch를 설정
        - yq가 사용 가능한 경우
            ```
            $ bash set-master-env-yq.sh {{ git repo url }} {{ branch }}
            ```
        - yq가 사용 불가능한 경우
            - vi 등의 text editor를 통해 직접 수정
            - example with vi
                ```
                $ vi application/app_of_apps/master-applications
                ```
    - gitlab의 경우 git repo url 마지막에 .git을 추가해주어야함  
    ex) https://gitlab.com/root/argocd-installer.git
---
3. application 등록
    - 테스트할 환경에 application을 등록
        ```
        $ kubectl -n {{ argocd ns }} apply -f application/app_of_apps/master-applications.yaml
        ```
    - {{ argocd ns }} 부분을 해당 환경의 argocd 네임스페이스로 치환
---
4. resource 배포(application sync)
    - application sync 순서는 [docs/install-order.md](install-order.md)를 참조
    - 순서에 맞춰서 모듈을 sync
    - sync 방식은 아래와 같음
    1) argocd server에 접속후 로그인
        - argocd server 주소는 다음과 같이 알 수 있음
            ```
            $ kubectl get svc -n {{ argocd ns }} argocd-server
            ```
            ![img](../figure/1_main.png)
    
    2) application sync
        - sync하고자 하는 application을 찾아서 sync 버튼을 클릭  
        ![img](../figure/2_app.png)

        - option 및 sync target을 설정하고 synchronize 버튼 클릭
        ![img](../figure/3_sync.png)

    3) sync status 확인
        - sync status(health check, sync check)를 확인
        ![img](../figure/4_synced.png)

        - app card를 누르면 리소스별 status 체크 가능
        ![img](../figure/5_details.png)
---
## Single cluster
1. cluster configuration
    - cluster에 필요한 정보(registry domain, hyperclou domain등)를 셋팅한다.
    - 수정해야 하는 파일은 아래와 같다.
        ```
        $ application/helm/shared-values.yaml
        $ application/helm/single-values.yaml
        ```
    - git에 push한다.
---
2. application 변수 셋팅
    - 테스트할 환경에서 바라볼 git repo url, branch를 설정
        - yq가 사용 가능한 경우
            ```
            $ bash set-master-env-yq.sh {{ git repo url }} {{ branch }} {{ cluster name }} {{ private registry url }}
            ```
        - yq가 사용 불가능한 경우
            - vi 등의 text editor를 통해 직접 수정
            - example with vi
                ```
                $ vi application/app_of_apps/single-applications
                ```
    - gitlab의 경우 git repo url 마지막에 .git을 추가해주어야함
    ex) https://gitlab.com/root/argocd-installer.git
    - private registry를 사용하지 않는 경우에는 빈스트링("")을 입력
    ex) bash set-master-env-yq.sh {{ git repo url }} {{ branch }} {{ cluster name }} ""
---
3. application 등록
    - 테스트할 환경에 application을 등록
        ```
        $ kubectl -n {{ argocd ns }} apply -f application/app_of_apps/{{ cluster name }}-applications.yaml
        ```
    - {{ argocd ns }} 부분을 해당 환경의 argocd 네임스페이스로 치환
    - {{ cluster name }} 부분을 target cluster 이름으로 치환
---
4. resource 배포(application sync)
    - 마스터와 동일