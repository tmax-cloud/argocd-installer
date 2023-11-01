{{/*
Expand the name of the chart.
*/}}
{{- define "cert-manager.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cert-manager.fullname" -}}
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
{{- define "cert-manager.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cert-manager.labels" -}}
helm.sh/chart: {{ include "cert-manager.chart" . }}
{{ include "cert-manager.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cert-manager.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cert-manager.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "cert-manager.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "cert-manager.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create duration of certificate
*/}}
{{- define "cert-manager.certDuration" -}}
{{- $duration := index .Values "cert-manager" "certDuration" }}
{{- $hours := regexFind "([0-9]+)h" $duration }}
{{- $minutes := regexFind "([0-9]+)m" $duration }}
{{- $seconds := regexFind "([0-9]+)s" $duration }}
{{- $totalSeconds := 0 }}
{{- if $hours }}
  {{- $totalSeconds = add $totalSeconds (mul (regexReplaceAll "h" $hours "") 3600) }}
{{- end }}
{{- if $minutes }}
  {{- $totalSeconds = add $totalSeconds (mul (regexReplaceAll "m" $minutes "") 60) }}
{{- end }}
{{- if $seconds }}
  {{- $totalSeconds = add $totalSeconds (regexReplaceAll "s" $seconds "") }}
{{- end }}
{{- $finalHours := div $totalSeconds 3600 -}}
{{- $finalMinutes := div (mod $totalSeconds 3600) 60 -}}
{{- $finalSeconds := mod $totalSeconds 60 -}}
duration: {{ printf "%dh%dm%ds" $finalHours $finalMinutes $finalSeconds -}}
{{- end }}
