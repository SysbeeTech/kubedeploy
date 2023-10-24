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
      {{- include "kubedeploy.common.command" (list $ .) | indent 6 }}
      {{- include "kubedeploy.common.args" (list $ .) | indent 6 }}
      {{- with $.Values.securityContext }}
      securityContext:
        {{- toYaml . | nindent 8 }}
      {{- end }}
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
      {{- with .Values.securityContext }}
      securityContext:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default "latest" }}"
      imagePullPolicy: {{ .Values.image.pullPolicy |default "IfNotPresent" }}
      {{- include "kubedeploy.common.command" (list $ .Values) | indent 6 }}
      {{- include "kubedeploy.common.args" (list $ .Values) | indent 6 }}
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
      {{- include "kubedeploy.common.command" (list $ .) | indent 6 }}
      {{- include "kubedeploy.common.args" (list $ .) | indent 6 }}
      {{- with $.Values.securityContext }}
      securityContext:
        {{- toYaml . | nindent 8 }}
      {{- end }}
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
