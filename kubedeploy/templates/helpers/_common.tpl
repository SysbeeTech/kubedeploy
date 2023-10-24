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

{{/* Define command for common.spec */}}
{{- define "kubedeploy.common.command" -}}
{{- $top := index . 0 -}}
{{- $command := index . 1 -}}
{{- if hasKey $command "image" -}}
{{/* TODO: 2.x Deprecation start */}}
{{- if and
            (eq (toString $top.Values.deploymentMode) "Cronjob")
            $top.Values.cronjobspec.command
}}
command:
  {{- toYaml $top.Values.cronjobspec.command | nindent 2 }}
{{- else if and
                (eq (toString $top.Values.deploymentMode) "Job")
                $top.Values.jobspec.command
}}
command:
  {{- toYaml $top.Values.jobspec.command | nindent 2 }}
{{/* Deprecation end */}}
{{- else -}}
{{- with $command.image.command }}
command:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end -}}
{{- else -}}
{{- with $command.command }}
command:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end -}}
{{- end -}}

{{/* Define args for common.spec */}}
{{- define "kubedeploy.common.args" -}}
{{- $top := index . 0 -}}
{{- $args := index . 1 -}}
{{- if hasKey $args "image" -}}
{{/* TODO: 2.x Deprecation start */}}
{{- if and
            (eq (toString $top.Values.deploymentMode) "Cronjob")
            $top.Values.cronjobspec.args
}}
args:
  {{- toYaml $top.Values.cronjobspec.args | nindent 2 }}
{{- else if and
                (eq (toString $top.Values.deploymentMode) "Job")
                $top.Values.jobspec.args
}}
args:
  {{- toYaml $top.Values.jobspec.args | nindent 2 }}
{{/* Deprecation end */}}
{{- else -}}
{{- with $args.image.args }}
args:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end -}}
{{- else -}}
{{- with $args.args }}
args:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end -}}
{{- end -}}
