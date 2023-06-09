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
VolumeMounts for containers
*/}}
{{- define "kubedeploy.volumeMounts" -}}
{{- $fullName := include "kubedeploy.fullname" . -}}
{{- if and (.Values.persistency.enabled) (eq (toString .Values.deploymentMode) "Statefulset") }}
  - mountPath: {{ .Values.persistency.mountPath }}
    name: {{ $fullName }}
{{- else }}
  []
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
  {{- end }}
  {{- if .Values.initContainers.enabled }}
  initContainers:
    {{- range .Values.initContainers.containers }}

    - name: {{ required "Please define valid init container name" .name }}
      image: "{{ required "Please define valid init container repository" .repository }}:{{ .tag | default "latest" }}"
      command:
        {{- toYaml .command |nindent 12 }}
      args:
        {{- toYaml .args |nindent 12 }}
      securityContext:
        {{- toYaml $.Values.securityContext | nindent 12 }}
      imagePullPolicy: {{ $.Values.initContainers.pullPolicy }}
      {{- with $.Values.env }}
      env:
        {{- toYaml . | nindent 12 }}
      {{- end }}
      volumeMounts:
        {{- include "kubedeploy.volumeMounts" $ | indent 8 }}
      resources:
        {{- toYaml $.Values.initContainers.resources | nindent 12 }}
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
        {{- else }}
        {{- toYaml .Values.image.command |nindent 12 }}
        {{- end }}
      args:
        {{- if eq (toString .Values.deploymentMode) "Job" }}
        {{- toYaml .Values.jobspec.args |nindent 12 }}
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
        {{- toYaml .Values.resources | nindent 12 }}
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
  {{- if and (.Values.persistency.enabled) (eq (toString .Values.deploymentMode) "Statefulset") }}
  volumeClaimTemplates:
    - metadata:
        name: {{ $fullName }}
      spec:
        accessModes:
        {{- range .Values.persistency.accessModes }}
          - {{ . }}
        {{- end }}
        storageClassName: {{ .Values.persistency.storageClassName }}
        resources:
          requests:
            storage: {{ .Values.persistency.capacity.storage }}
  {{- end }}
{{- end }}
