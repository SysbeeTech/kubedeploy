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
