function (
  repo_url = "https://github.com/tmax-cloud/argocd-installer",
  is_offline = "false",
  private_registry = "172.22.6.2:5000"
)

{
  "apiVersion": "argoproj.io/v1alpha1",
  "kind": "Application",
  "metadata": {
    "name": "cluster-api-provider-vsphere",
    "namespace": "argocd"
  },
  "spec": {
    "destination": {
      "namespace": "default",
      "server": "https://kubernetes.default.svc"
    },
    "project": "default",
    "source": {
      "directory": {
        "jsonnet": {
          "tlas": [
            {
              "name": "is_offline",
              "value": is_offline
            },
            {
              "name": "private_registry",
              "value": private_registry
            },
            {
              "name": "username",
              "value": "user"
            },
            {
              "name": "password",
              "value": "pwd"
            }
          ]
        },
      },
      "path": "manifest/cluster-api-provider-vsphere",
      "repoURL": repo_url,
      "targetRevision": "main"
    }
  }
}