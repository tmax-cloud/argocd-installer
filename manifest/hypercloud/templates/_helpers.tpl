{{/*
Expand the name of the chart.
*/}}
{{- define "hypercloud.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "hypercloud.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "hypercloud.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "hypercloud.labels" -}}
helm.sh/chart: {{ include "hypercloud.chart" . }}
{{ include "hypercloud.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "hypercloud.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hypercloud.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "hypercloud.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "hypercloud.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{- define "hypercloud.volumeMounts.timeZone" -}}
{{- if ne .Values.global.timeZone "UTC" -}}
- name: timezone-config
  mountPath: /etc/localtime
{{- end }}
{{- end }}

{{- define "hypercloud.volumes.timeZone" -}}
{{- if ne .Values.global.timeZone "UTC" -}}
- name: timezone-config
  hostPath:
    path: {{ printf "%s%s" "/usr/share/zoneinfo/" .Values.global.timeZone }}
{{- end }}
{{- end }}