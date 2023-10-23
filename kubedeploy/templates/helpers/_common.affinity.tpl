{{/* Define affinity for common.spec */}}
{{- define "kubedeploy.common.affinity" -}}
{{- if or .Values.affinity .Values.podAntiAffinity }}
affinity:
{{- end }}
{{- if .Values.affinity }}
{{- with .Values.affinity }}
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- else }}
{{- if eq .Values.podAntiAffinity "hard" }}
  podAntiAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      - topologyKey: {{ .Values.podAntiAffinityTopologyKey }}
        labelSelector:
          matchExpressions:
            {{- include "kubedeploy.matchExpressions" . | nindent 12 }}
{{- else if eq .Values.podAntiAffinity "soft" }}
  podAntiAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 100
        podAffinityTerm:
          topologyKey: {{ .Values.podAntiAffinityTopologyKey }}
          labelSelector:
            matchExpressions:
              {{- include "kubedeploy.matchExpressions" . | nindent 14 }}
{{- end }}
{{- end }}
{{- end -}}
