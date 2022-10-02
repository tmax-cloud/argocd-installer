{{- define "argocd.syncPolicy.retry" }}
limit: 10
backoff:
  duration: "5s"
  factor: 2
  maxDuration: "3m0s"
{{ end -}}