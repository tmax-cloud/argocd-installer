function (
  #params = import 'params.libsonnet'
  repo_url = "https://github.com/tmax-cloud/argocd-installer",
  is_offline = "false",
  private_registry = "172.22.6.2:5000"
)

{
  "apiVersion": "argoproj.io/v1alpha1",
  "kind": "Application",
  "metadata": {
    "name": "strimzi-kafka-cluster-oprerator",
    "namespace": "argocd"
  },
  "spec": {
    "destination": {
      "name": "",
      "namespace": "kafka",
      "server": "https://kubernetes.default.svc"
    },
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
      "path": "manifest/strimzi-kafka-cluster-oprerator",
      "repoURL": repo_url,
      "targetRevision": "main"
    },
    "project": "default"
  }
}