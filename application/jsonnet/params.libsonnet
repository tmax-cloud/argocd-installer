{
    ### Cluster configuration
    cluster_name: "",
    cluster_server: "https://kubernetes.default.svc",
    project: "default",

    ### Environment configuration
    network_disabled: "true",
    private_registry: "172.22.6.2:5000",
    branch:           "master",           # branch name
    repo_provider:    "gitlab",    # "gitlab" or "github"
    repo_url: "https://gitlab-deploy.gitlab-test-deploy.172.22.6.53.nip.io/root/argocd-installer",

    ### Module specific configurations
    # Shared variables
    domain: "ckcloud.org",
    keycloak_domain: "hyperauth.ckcloud.org",
    keycloak_client_secret: "tmax_client_secret",
    
    # Cluster-api-aws configuration
    aws_credential: "", 

    # Cluster-api-provider-vsphere configuration
    vsphere_username: "administrator@vsphere.local",
    vsphere_password: "Tmax@2323"
}
