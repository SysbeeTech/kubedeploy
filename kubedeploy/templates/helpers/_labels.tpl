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
