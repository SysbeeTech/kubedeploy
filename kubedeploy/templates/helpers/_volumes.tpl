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
      {{- if .chartName }}
      secretName: {{ printf "%s-%s" $fullName .secretName }}
      {{- else }}
      secretName: {{ .secretName }}
      {{- end }}
      {{- with .items }}
      items:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- if .optional }}
      optional: {{ .optional }}
      {{- end }}
    {{- else if .configMapName }}
    configMap:
      {{- if .chartName }}
      name: {{ printf "%s-%s" $fullName .configMapName }}
      {{- else }}
      name: {{ .configMapName }}
      {{- end }}
      {{- with .items }}
      items:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- if .optional }}
      optional: {{ .optional }}
      {{- end }}
    {{- else }}
    emptyDir: {}
    {{- end }}
{{- end -}}
{{- end -}}
{{- end -}}
