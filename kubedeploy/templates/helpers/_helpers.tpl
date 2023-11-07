{{/*
Expand the name of the chart.
*/}}
{{- define "kubedeploy.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kubedeploy.fullname" -}}
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


{{/* Allow KubeVersion to be overridden. */}}
{{- define "kubedeploy.kubeVersion" -}}
  {{- default .Capabilities.KubeVersion.Version .Values.kubeVersionOverride -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "kubedeploy.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "kubedeploy.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "kubedeploy.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Pod annotations
*/}}
{{- define "kubedeploy.annotations" -}}
{{- if or .Values.podAnnotations .Values.configMapsHash }}
annotations:
{{- with .Values.podAnnotations }}
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- if .Values.configMapsHash }}
  checksum/config: {{ include (print $.Template.BasePath "/configmaps.yaml") . | sha256sum }}
{{- end }}
{{- end }}
{{- end }}

{{/*
configmap name generator
*/}}
{{- define "kubedeploy.cfgmapname" -}}
{{- $top := index . 0 -}}
{{- $local := index . 1 -}}
{{- $name := required "Please define valid configmap name" $local.name -}}
{{- $fullName := include "kubedeploy.fullname" $top -}}
{{- printf "%s-%s" $fullName $name -}}
{{- end -}}

{{/*
extraIngress name generator
*/}}
{{- define "kubedeploy.extraIngressName" -}}
{{- $top := index . 0 -}}
{{- $local := index . 1 -}}
{{- $name := required "Please define valid Ingress name" $local.name -}}
{{- $fullName := include "kubedeploy.fullname" $top -}}
{{- printf "%s-%s" $fullName $name -}}
{{- end -}}

{{/*
secret name generator
*/}}
{{- define "kubedeploy.secretname" -}}
{{- $top := index . 0 -}}
{{- $local := index . 1 -}}
{{- $name := required "Please define valid Secret name" $local.name -}}
{{- $fullName := include "kubedeploy.fullname" $top -}}
{{- printf "%s-%s" $fullName $name -}}
{{- end -}}
