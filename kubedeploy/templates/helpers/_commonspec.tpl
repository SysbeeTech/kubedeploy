{{/*
Spec: common section helper
*/}}
{{- define "kubedeploy.common.spec" -}}
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
      {{- include "kubedeploy.common.securityContext" $ | indent 6 }}
      imagePullPolicy: {{ $.Values.initContainers.pullPolicy | default "IfNotPresent"}}
      {{- include "kubedeploy.common.env" $ | indent 6 }}
      {{- include "kubedeploy.common.envFrom" $ | indent 6 }}
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
      {{- include "kubedeploy.common.securityContext" $ | indent 6 }}
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
      {{- include "kubedeploy.common.env" . | indent 6 }}
      {{- include "kubedeploy.common.envFrom" . | indent 6 }}
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
      {{- include "kubedeploy.common.securityContext" $ | indent 6 }}
      imagePullPolicy: {{ $.Values.additionalContainers.pullPolicy | default "IfNotPresent" }}
      {{- include "kubedeploy.common.env" $ | indent 6 }}
      {{- include "kubedeploy.common.envFrom" $ | indent 6 }}
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
  {{- include "kubedeploy.common.affinity" . | indent 2 }}
  {{- with .Values.image.terminationGracePeriodSeconds }}
  terminationGracePeriodSeconds: {{ . | default 30 }}
  {{- end }}
  {{- with .Values.tolerations }}
  tolerations:
    {{- toYaml . | nindent 8 }}
  {{- end }}
{{- end }}
