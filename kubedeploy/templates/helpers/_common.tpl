{{/* Define env for common.spec */}}
{{- define "kubedeploy.common.env" -}}
{{- with .Values.env }}
env:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end -}}

{{/* Define envFrom for common.spec */}}
{{- define "kubedeploy.common.envFrom" -}}
{{- with .Values.envFrom }}
envFrom:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end -}}

{{/* Define securityContext for common.spec */}}
{{- define "kubedeploy.common.securityContext" -}}
{{- with .Values.securityContext }}
securityContext:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end -}}
