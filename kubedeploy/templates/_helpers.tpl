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

{{/* Get Ingres API Version */}}
{{- define "kubedeploy.ingress.apiVersion" -}}
{{- if (semverCompare ">=1.19-0" (include "kubedeploy.kubeVersion" .)) -}}
  {{- print "networking.k8s.io/v1" -}}
{{- else if (semverCompare ">=1.14-0" (include "kubedeploy.kubeVersion" .)) -}}
  {{- print "networking.k8s.io/v1beta1" -}}
{{- else -}}
  {{- print "extensions/v1beta1" -}}
{{- end -}}
{{- end -}}

{{/* Ingress annotations */}}
{{- define "kubedeploy.ingress.annotations" -}}
{{/* set the default kubernets.io/ingress.class annotation on old kube versions */}}
{{- if and .Values.ingress.className (not (semverCompare ">=1.18-0" (include "kubedeploy.kubeVersion" .))) }}
{{- if not (hasKey .Values.ingress.annotations "kubernetes.io/ingress.class") }}
{{- $_ := set .Values.ingress.annotations "kubernetes.io/ingress.class" .Values.ingress.className}}
{{- end }}
{{- end -}}
{{- with .Values.ingress.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
{{- end }}
{{- end -}}

{{/* Ingress tls secret name */}}
{{- define "kubedeploy.ingress.tlsSecretName" -}}
{{ printf "%s-ingress-tls" (include "kubedeploy.fullname" .) }}
{{- end -}}

{{/* Ingress tls config */}}
{{- define "kubedeploy.ingress.tls" -}}

{{- if or .Values.ingress.withSSL (gt (len .Values.ingress.tls) 0) -}}
tls:
{{- if .Values.ingress.tls -}}
  {{- range .Values.ingress.tls }}
    - hosts:
    {{- range .hosts }}
        - {{ . | quote }}
    {{- end }}
      secretName: {{ .secretName | default (include "kubedeploy.ingress.tlsSecretName" $) }}
  {{- end }}
{{- else }}
    - hosts:
    {{- range .Values.ingress.hosts }}
        - {{ .host |quote }}
    {{- end }}
      secretName: {{ include "kubedeploy.ingress.tlsSecretName" . }}
{{- end -}}
{{- end -}}

{{- end -}}

{{/* Detect default port for ingress */}}
{{- define "kubedeploy.ingress.defaultport" -}}
{{- if .Values.ingress.svcPort -}}
{{- .Values.ingress.svcPort }}
{{- else if .Values.service.ports -}}
{{- get (.Values.service.ports | first) "port" }}
{{- else if .Values.ports -}}
{{/*
We don't actually route traffic here. However, service object will use container
ports as values for service port in case service ports values are not defined
*/}}
{{- get (.Values.ports | first ) "containerPort" }}
{{- else -}}
{{/* TODO: remove in 2.x legacy chart version support */}}
{{- print "80" }}
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
{{- with .Values.podExtraLabels }}
{{ toYaml .}}
{{- end }}
{{- end }}

{{/*
MatchExpressions
*/}}
{{- define "kubedeploy.matchExpressions" -}}
- key: app.kubernetes.io/name
  operator: In
  values:
    - {{ include "kubedeploy.fullname" . }}
- key: app.kubernetes.io/instance
  operator: In
  values:
    - {{ .Release.Name }}
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
secret name generator
*/}}
{{- define "kubedeploy.secretname" -}}
{{- $top := index . 0 -}}
{{- $local := index . 1 -}}
{{- $name := required "Please define valid Secret name" $local.name -}}
{{- $fullName := include "kubedeploy.fullname" $top -}}
{{- printf "%s-%s" $fullName $name -}}
{{- end -}}

{{/*
VolumeMounts for containers
*/}}
{{- define "kubedeploy.volumeMounts" -}}
{{- $fullName := include "kubedeploy.fullname" . -}}

{{/* Iterate over confiMaps mounts to count how many should be mounted */}}

{{- $cfgmountcount := 0 -}}
{{- range .Values.configMaps -}}
{{- if eq (toString .mount |lower) "true" -}}
{{- $cfgmountcount = add $cfgmountcount 1 -}}
{{- end -}}
{{- end -}}

{{/* Iterate over extraSecret mounts to count how many should be mounted */}}

{{- $secretmountcount := 0 -}}
{{- range .Values.extraSecrets -}}
{{- if eq (toString .mount |lower) "true" -}}
{{- $secretmountcount = add $secretmountcount 1 -}}
{{- end -}}
{{- end -}}

{{/* Define which volumes should be mounted */}}
{{- if or (gt $cfgmountcount 0) (gt $secretmountcount 0) .Values.extraVolumeMounts (and (.Values.persistency.enabled) (eq (toString .Values.deploymentMode) "Statefulset")) }}
volumeMounts:

{{- if and (.Values.persistency.enabled) (eq (toString .Values.deploymentMode) "Statefulset") }}
  - mountPath: {{ .Values.persistency.mountPath }}
    name: {{ $fullName }}
{{- end -}}

{{/* Now process extraVolumeMounts, configmap and secret mounts */}}

{{- if or (gt $cfgmountcount 0) (gt $secretmountcount 0) .Values.extraVolumeMounts -}}
{{- range .Values.configMaps -}}
{{- $name := include "kubedeploy.cfgmapname" (list $ .) -}}
{{- if eq (toString .mount | lower) "true" }}
  - mountPath: {{ required "You need to define .Values.configMaps[].mountPath if .Values.configMaps[].mount is set to True" .mountPath }}
    name: {{ $name }}
{{- end }}
{{- end }}
{{- range .Values.extraSecrets -}}
{{- $name := include "kubedeploy.secretname" (list $ .) -}}
{{- if eq (toString .mount | lower) "true" }}
  - mountPath: {{ required "You need to define .Values.extraSecrets[].mountPath if .Values.extraSecrets[].mount is set to True" .mountPath }}
    name: {{ $name }}
{{- end }}
{{- end }}
{{- range .Values.extraVolumeMounts }}
  - mountPath: {{ .mountPath }}
    name: {{ .name }}
    {{- if .subPath }}
    subPath: {{ .subPath }}
    {{- end }}
    {{- if .readOnly }}
    readOnly: {{ .readOnly }}
    {{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Volumes for containers
*/}}
{{- define "kubedeploy.volumes" -}}
{{- $fullName := include "kubedeploy.fullname" . -}}
{{/* Iterate over confiMaps mounts to count how many should be mounted */}}
{{- $cfgmountcount := 0 -}}
{{- range .Values.configMaps -}}
{{- if eq (toString .mount |lower) "true" -}}
{{- $cfgmountcount = add $cfgmountcount 1 -}}
{{- end -}}
{{- end -}}
{{/* Iterate over extraSecrets mounts to count how many should be mounted */}}
{{- $secretmountcount := 0 -}}
{{- range .Values.extraSecrets -}}
{{- if eq (toString .mount |lower) "true" -}}
{{- $secretmountcount = add $secretmountcount 1 -}}
{{- end -}}
{{- end -}}
{{/* Define volumes */}}
{{- if or (gt $cfgmountcount 0) (gt $secretmountcount 0) .Values.extraVolumeMounts -}}
volumes:
{{- /* configmap mounts */ -}}
{{- range .Values.configMaps -}}
{{- $name := include "kubedeploy.cfgmapname" (list $ .) -}}
{{- if eq (toString .mount | lower) "true" }}
  - name: {{ $name }}
    configMap:
      name: {{ $name }}
{{- end -}}
{{- end -}}
{{- /* secret mounts */ -}}
{{- range .Values.extraSecrets -}}
{{- $name := include "kubedeploy.secretname" (list $ .) -}}
{{- if eq (toString .mount | lower) "true" }}
  - name: {{ $name }}
    secret:
      secretName: {{ $name }}
{{- end -}}
{{- end -}}
{{- /* extraVolumeMounts */ -}}
{{- range .Values.extraVolumeMounts }}
  - name: {{ .name }}
    {{- if .existingClaim }}
    persistentVolumeClaim:
      claimName: {{ .existingClaim }}
    {{- else if .hostPath }}
    hostPath:
      path: {{ .hostPath }}
    {{- else if .csi }}
    csi:
      {{- toYaml .data | nindent 6 }}
    {{- else if .secretName }}
    secret:
      secretName: {{ .secretName }}
      {{- if .optional }}
      optional: {{ .optional }}
      {{- end }}
    {{- else }}
    emptyDir: {}
    {{- end }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Healthcheck probe helper
*/}}
{{- define "kubedeploy.healthchecks" -}}
{{- $top := index . 0 -}}
{{- $hc := index . 1 -}}
{{- if $hc.enabled -}}
{{- with $hc.probes -}}
{{- with .livenessProbe }}
livenessProbe:
{{ toYaml . |indent 2 -}}
{{- end -}}
{{- with .readinessProbe }}
readinessProbe:
{{ toYaml . |indent 2 }}
{{- end -}}
{{- with .startupProbe }}
startupProbe:
{{ toYaml . |indent 2 -}}
{{- end -}}
{{- end -}}
{{- end }}
{{- end -}}

{{/*
Spec: common section helper
*/}}
{{- define "kubedeploy.specSection" -}}
{{- $fullName := include "kubedeploy.fullname" . -}}
spec:
  {{- with .Values.imagePullSecrets }}
  imagePullSecrets:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  serviceAccountName: {{ include "kubedeploy.serviceAccountName" . }}
  {{- with .Values.podSecurityContext }}
  securityContext:
    {{- toYaml . | nindent 4 }}
  {{- end }}
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
        {{- toYaml . |nindent 8 }}
      {{- end }}
      {{- with .args }}
      args:
        {{- toYaml . |nindent 8 }}
      {{- end }}
      {{- with $.Values.securityContext }}
      securityContext:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      imagePullPolicy: {{ $.Values.initContainers.pullPolicy | default "IfNotPresent"}}
      {{- with $.Values.env }}
      env:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with $.Values.envFrom }}
      envFrom:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- include "kubedeploy.volumeMounts" $ | indent 6 }}
      resources:
        {{- if not .resources }}
        {{- toYaml $.Values.initContainers.resources | nindent 8 -}}
        {{- else }}
        {{- if or .resources.limits .resources.requests }}
        {{- toYaml .resources | nindent 8 -}}
        {{- else }}
        {{- toYaml $.Values.initContainers.resources | nindent 8 -}}
        {{- end }}
        {{- end }}
    {{- end }}
  {{- end }}
  containers:
    - name: {{ include "kubedeploy.fullname" . }}
      {{- with .Values.securityContext }}
      securityContext:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default "latest" }}"
      imagePullPolicy: {{ .Values.image.pullPolicy |default "IfNotPresent" }}
      {{- if eq (toString .Values.deploymentMode) "Job" }}
      {{- with .Values.jobspec.command }}
      command:
      {{- toYaml . |nindent 8 }}
      {{- end }}
      {{- else if eq (toString .Values.deploymentMode) "Cronjob"}}
      {{- with .Values.cronjobspec.command }}
      command:
      {{- toYaml . |nindent 8 }}
      {{- end }}
      {{- else }}
      {{- with .Values.image.command }}
      command:
      {{- toYaml . |nindent 8 }}
      {{- end }}
      {{- end }}
      {{- if eq (toString .Values.deploymentMode) "Job" }}
      {{- with .Values.jobspec.args}}
      args:
      {{- toYaml . |nindent 8 }}
      {{- end }}
      {{- else if eq (toString .Values.deploymentMode) "Cronjob"}}
      {{- with .Values.cronjobspec.args }}
      args:
      {{- toYaml . |nindent 8 }}
      {{- end }}
      {{- else }}
      {{- with .Values.image.args }}
      args:
      {{- toYaml . |nindent 8 }}
      {{- end }}
      {{- end }}
      {{- with .Values.env }}
      env:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with $.Values.envFrom }}
      envFrom:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.ports }}
      ports:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.image.lifecycle }}
      lifecycle:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- if .Values.healthcheck.enabled }}
      {{- include "kubedeploy.healthchecks" (list .Values .Values.healthcheck) | indent 6 }}
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
      {{- include "kubedeploy.volumeMounts" . | indent 6 }}
      {{- with .Values.resources }}
      resources:
        {{- toYaml . | nindent 8 }}
      {{- end }}
    {{- if .Values.additionalContainers.enabled }}
    {{- range .Values.additionalContainers.containers }}
    - name: {{ required "Please define valid additional container name" .name }}
      image: "{{ required "Please define valid additional container repository" .repository }}:{{ .tag | default "latest" }}"
      {{- with .command }}
      command:
        {{- toYaml . |nindent 8 }}
      {{- end }}
      {{- with .args }}
      args:
        {{- toYaml . |nindent 8 }}
      {{- end }}
      {{- with $.Values.securityContext }}
      securityContext:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      imagePullPolicy: {{ $.Values.additionalContainers.pullPolicy | default "IfNotPresent" }}
      {{- with $.Values.env }}
      env:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with $.Values.envFrom }}
      envFrom:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .ports }}
      ports:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- include "kubedeploy.healthchecks" (list . .healthcheck) | indent 6 }}
      {{- include "kubedeploy.volumeMounts" $ | indent 6 }}
      resources:
        {{- if not .resources -}}
        {{- toYaml $.Values.additionalContainers.resources | nindent 8 -}}
        {{- else }}
        {{- if or .resources.limits .resources.requests }}
        {{- toYaml .resources | nindent 8 -}}
        {{- else }}
        {{- toYaml $.Values.additionalContainers.resources | nindent 8 -}}
        {{- end }}
        {{- end }}
    {{- end }}
    {{- end }}
  {{- include "kubedeploy.volumes" . | nindent 2 }}
  {{- with .Values.nodeSelector }}
  nodeSelector:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- if or .Values.affinity .Values.podAntiAffinity }}
  affinity:
  {{- end }}
  {{- if .Values.affinity }}
  {{- with .Values.affinity }}
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- else }}
  {{- if eq .Values.podAntiAffinity "hard" }}
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        - topologyKey: {{ .Values.podAntiAffinityTopologyKey }}
          labelSelector:
            matchExpressions:
              {{- include "kubedeploy.matchExpressions" . | nindent 14 }}
  {{- else if eq .Values.podAntiAffinity "soft" }}
    podAntiAffinity:
      preferredDuringSchedulingIgnoredDuringExecution:
        - weight: 100
          podAffinityTerm:
            topologyKey: {{ .Values.podAntiAffinityTopologyKey }}
            labelSelector:
              matchExpressions:
                {{- include "kubedeploy.matchExpressions" . | nindent 16 }}
  {{- end }}
  {{- end }}
  {{- with .Values.image.terminationGracePeriodSeconds }}
  terminationGracePeriodSeconds: {{ . | default 30 }}
  {{- end }}
  {{- with .Values.tolerations }}
  tolerations:
    {{- toYaml . | nindent 8 }}
  {{- end }}
{{- end }}
