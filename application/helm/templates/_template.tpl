{{- define "argocd.syncPolicy.retry" }}
limit: 10
backoff:
  duration: "5s"
  factor: 2
  maxDuration: "3m0s"
{{ end -}}

# hyperauth.domain.com
{{- define "hyperAuth.domain" -}}
{{- if .Values.global.masterSingle.enabled -}}
{{- .Values.global.masterSingle.hyperAuthDomain -}}
{{- else -}}
{{- printf "%s.%s" .Values.modules.hyperAuth.subdomain .Values.global.domain -}}
{{- end -}}
{{- end -}}

{{- define "hyperAuth.tmaxClientSecret" -}}
{{- if .Values.global.masterSingle.enabled -}}
{{- .Values.global.masterSingle.tmaxClientSecret -}}
{{- else -}}
{{- .Values.modules.hyperAuth.tmaxClientSecret -}}
{{- end -}}
{{- end -}}

# hyperauth
{{- define "hyperAuth.subdomain" -}}
{{- if .Values.global.masterSingle.enabled -}}
{{- (split "." .Values.global.masterSingle.hyperAuthDomain)._0 -}}
{{- else -}}
{{- .Values.modules.hyperAuth.subdomain -}}
{{- end -}}
{{- end -}}

{{- define "argocd.ignoreDifference" }}
- group: cert-manager.io
  kind: Certificate
  jsonPointers:
  - /spec/isCA
{{ end -}}


