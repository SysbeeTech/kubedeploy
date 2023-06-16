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

{{/* Get Policy API Version */}}
{{- define "kubedeploy.pdb.apiVersion" -}}
  {{- if and (.Capabilities.APIVersions.Has "policy/v1") (semverCompare ">= 1.21-0" (include "kubedeploy.kubeVersion" .)) -}}
      {{- print "policy/v1" -}}
  {{- else -}}
    {{- print "policy/v1beta1" -}}
  {{- end -}}
  {{- end -}}

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
Common labels
*/}}
{{- define "kubedeploy.labels" -}}
helm.sh/chart: {{ include "kubedeploy.chart" . }}
{{ include "kubedeploy.selectorLabels" . }}
{{- if .Values.image.tag }}
app.kubernetes.io/version: {{ .Values.image.tag | quote }}
{{- else }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "kubedeploy.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kubedeploy.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
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
VolumeMounts for containers
*/}}
{{- define "kubedeploy.volumeMounts" -}}
{{- $fullName := include "kubedeploy.fullname" . -}}
{{- /* Iterate over confiMaps mounts to count how many should be mounted */ -}}
{{- $cfgmountcount := 0 }}
{{- range .Values.configMaps }}
    {{- if eq (toString .mount |lower) "true" }}
    {{- $cfgmountcount = add $cfgmountcount 1 }}
    {{- end }}
{{- end }}
{{- /* Define which volumes should be mounted */ -}}
{{- if and (.Values.persistency.enabled) (eq (toString .Values.deploymentMode) "Statefulset") }}
  - mountPath: {{ .Values.persistency.mountPath }}
    name: {{ $fullName }}
{{- else if gt $cfgmountcount 0 }}
{{- /*skip adding anything if there are cfgmounts to be added */ -}}
{{- else }}
  []
{{- end }}
{{- /* Now process configmap mounts */ -}}
{{- if gt $cfgmountcount 0 }}
{{- range .Values.configMaps }}
    {{- $name := include "kubedeploy.cfgmapname" (list $ .) -}}
    {{- if eq (toString .mount | lower) "true" }}
  - mountPath: {{ required "You need to define .Values.configMaps[].mountPath if .Values.configMaps[].mount is set to True" .mountPath }}
    name: {{ $name }}
    {{- end }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Volumees for containers
*/}}
{{- define "kubedeploy.volumes" -}}
{{- $fullName := include "kubedeploy.fullname" . -}}
{{- /* Iterate over confiMaps mounts to count how many should be mounted */ -}}
{{- $cfgmountcount := 0 }}
{{- range .Values.configMaps }}
    {{- if eq (toString .mount |lower) "true" }}
    {{- $cfgmountcount = add $cfgmountcount 1 }}
    {{- end }}
{{- end }}
{{- /* Define volumes */ -}}
{{- if gt $cfgmountcount 0 }}
volumes:
{{- range .Values.configMaps }}
    {{- $name := include "kubedeploy.cfgmapname" (list $ .) -}}
    {{- if eq (toString .mount | lower) "true" }}
  - name: {{ $name }}
    configMap:
      name: {{ $name }}
    {{- end }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Spec: common section helper
*/}}
{{- define "kubedeploy.specSection" -}}
{{- $fullName := include "kubedeploy.fullname" . -}}
spec:
  {{- with .Values.imagePullSecrets }}
  imagePullSecrets:
    {{- toYaml . | nindent 8 }}
  {{- end }}
  serviceAccountName: {{ include "kubedeploy.serviceAccountName" . }}
  securityContext:
    {{- toYaml .Values.podSecurityContext | nindent 8 }}
  {{- if eq (toString .Values.deploymentMode) "Job" }}
  restartPolicy: {{ .Values.jobspec.restartPolicy }}
  {{- else if eq (toString .Values.deploymentMode) "Cronjob"}}
  restartPolicy: {{ .Values.cronjobspec.restartPolicy }}
  {{- end }}
  {{- with .Values.topologySpreadConstraints }}
  topologySpreadConstraints:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- if .Values.initContainers.enabled }}
  initContainers:
    {{- range .Values.initContainers.containers }}
    - name: {{ required "Please define valid init container name" .name }}
      image: "{{ required "Please define valid init container repository" .repository }}:{{ .tag | default "latest" }}"
      {{- with .command }}
      command:
        {{- toYaml . |nindent 12 }}
      {{- end }}
      {{- with .args }}
      args:
        {{- toYaml . |nindent 12 }}
      {{- end }}
      {{- with $.Values.securityContext }}
      securityContext:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      imagePullPolicy: {{ $.Values.initContainers.pullPolicy }}
      {{- with $.Values.env }}
      env:
        {{- toYaml . | nindent 12 }}
      {{- end }}
      volumeMounts:
        {{- include "kubedeploy.volumeMounts" $ | indent 6 }}
      resources:
        {{- if not .resources }}
        {{- toYaml $.Values.initContainers.resources | nindent 8 }}
        {{- else }}
        {{- if or .resources.limits .resources.requests }}
        {{- toYaml .resources | nindent 8 }}
        {{- else }}
        {{- toYaml $.Values.initContainers.resources | nindent 8 }}
        {{- end }}
        {{- end }}
    {{- end }}
  {{- end }}

  containers:
    - name: {{ include "kubedeploy.fullname" . }}
      securityContext:
        {{- toYaml .Values.securityContext | nindent 12 }}
      image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
      imagePullPolicy: {{ .Values.image.pullPolicy }}
      command:
        {{- if eq (toString .Values.deploymentMode) "Job" }}
        {{- toYaml .Values.jobspec.command |nindent 12 }}
        {{- else if eq (toString .Values.deploymentMode) "Cronjob"}}
        {{- toYaml .Values.cronjobspec.command |nindent 12 }}
        {{- else }}
        {{- toYaml .Values.image.command |nindent 12 }}
        {{- end }}
      args:
        {{- if eq (toString .Values.deploymentMode) "Job" }}
        {{- toYaml .Values.jobspec.args |nindent 12 }}
        {{- else if eq (toString .Values.deploymentMode) "Cronjob"}}
        {{- toYaml .Values.cronjobspec.args |nindent 12 }}
        {{- else }}
        {{- toYaml .Values.image.args |nindent 12 }}
        {{- end }}
      {{- with .Values.env }}
      env:
        {{- toYaml . | nindent 12 }}
      {{- end }}
      {{- with .Values.ports }}
      ports:
        {{- toYaml . | nindent 12 }}
      {{- end }}

      {{- if .Values.healthcheck.enabled }}
        {{- with .Values.healthcheck.probes }}
      {{- toYaml . | nindent 10 }}
        {{- end }}
      {{- else if not .Values.healthcheck.disableAutomatic }}
        {{- range .Values.ports }}
          {{- if eq (toString .name) "http" }}
      livenessProbe:
        httpGet:
          path: /
          port: http
      readinessProbe:
        httpGet:
          path: /
          port: http
          {{- end }}
        {{- end }}
      {{- end }}
      volumeMounts:
        {{- include "kubedeploy.volumeMounts" . | indent 8 }}
      resources:
        {{- toYaml .Values.resources | nindent 8 }}
    {{- if .Values.additionalContainers.enabled }}
    {{- range .Values.additionalContainers.containers }}
    - name: {{ required "Please define valid additional container name" .name }}
      image: "{{ required "Please define valid additional container repository" .repository }}:{{ .tag | default "latest" }}"
      {{- with .command }}
      command:
        {{- toYaml . |nindent 12 }}
      {{- end }}
      {{- with .args }}
      args:
        {{- toYaml . |nindent 12 }}
      {{- end }}
      {{- with $.Values.securityContext }}
      securityContext:
        {{- toYaml . | nindent 12 }}
      {{- end }}
      imagePullPolicy: {{ $.Values.additionalContainers.pullPolicy }}
      {{- with $.Values.env }}
      env:
        {{- toYaml . | nindent 12 }}
      {{- end }}
      {{- with .ports }}
      ports:
        {{- toYaml . | nindent 12 }}
      {{- end }}

      {{- if .healthcheck.enabled }}
      {{- with .healthcheck.probes }}
      {{- toYaml . | nindent 6 }}
      {{- end }}
      {{- end }}

      volumeMounts:
        {{- include "kubedeploy.volumeMounts" $ | indent 8 }}
      resources:
        {{- if not .resources }}
        {{- toYaml $.Values.additionalContainers.resources | nindent 8 }}
        {{- else }}
        {{- if or .resources.limits .resources.requests }}
        {{- toYaml .resources | nindent 8 }}
        {{- else }}
        {{- toYaml $.Values.additionalContainers.resources | nindent 8 }}
        {{- end }}
        {{- end }}
    {{- end }}
    {{- end }}
  {{- include "kubedeploy.volumes" . | indent 2 }}
  {{- with .Values.nodeSelector }}
  nodeSelector:
    {{- toYaml . | nindent 8 }}
  {{- end }}
  {{- with .Values.affinity }}
  affinity:
    {{- toYaml . | nindent 8 }}
  {{- end }}
  {{- with .Values.tolerations }}
  tolerations:
    {{- toYaml . | nindent 8 }}
  {{- end }}
{{- end }}
