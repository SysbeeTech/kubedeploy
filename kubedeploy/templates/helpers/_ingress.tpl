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
