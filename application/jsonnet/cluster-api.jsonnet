function (
  repo_url = "https://github.com/tmax-cloud/argocd-installer",
  is_offline = "false",
  private_registry = "172.22.6.2:5000"
)

{
  "apiVersion": "argoproj.io/v1alpha1",
  "kind": "Application",
  "metadata": {
    "name": "cluster-api",
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
          ],
        },
      },
      "path": "manifest/cluster-api",
      "repoURL": repo_url,
      "targetRevision": "main"
    }
  }
}