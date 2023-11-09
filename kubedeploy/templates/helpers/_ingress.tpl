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
{{- $top := index . 0 -}}
{{- $ingress := index . 1 -}}
{{/* Ensure that we always have empty annotations dict ready */}}
{{- if not (hasKey $ingress "annotations") -}}
{{- $_ := set $ingress "annotations" dict -}}
{{- end -}}
{{/* set the default kubernets.io/ingress.class annotation on old kube versions */}}
{{- if and $ingress.className (not (semverCompare ">=1.18-0" (include "kubedeploy.kubeVersion" $top))) }}
{{- if not (hasKey $ingress.annotations "kubernetes.io/ingress.class") }}
{{- $_ := set $ingress.annotations "kubernetes.io/ingress.class" $ingress.className }}
{{- end -}}
{{- end -}}
{{/* Add cert-manager annotation if withSSL is enabled and annotation is not found */}}
{{- if $ingress.withSSL -}}
{{- if not (hasKey $ingress.annotations "cert-manager.io/cluster-issuer") }}
{{- $_ := set $ingress.annotations "cert-manager.io/cluster-issuer" "letsencrypt"}}
{{- end -}}
{{- end -}}
{{- with $ingress.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
{{- end -}}
{{- end }}

{{/* Ingress tls secret name */}}
{{- define "kubedeploy.ingress.tlsSecretName" -}}
{{ printf "%s-ingress-tls" (include "kubedeploy.fullname" .) }}
{{- end -}}

{{/* Ingress tls config */}}
{{- define "kubedeploy.ingress.tls" -}}
{{- $top := index . 0 -}}
{{- $ingress := index . 1 -}}
{{- if or $ingress.withSSL (gt (len $ingress.tls) 0) -}}
tls:
{{- if $ingress.tls -}}
  {{- range $ingress.tls }}
    - hosts:
    {{- range .hosts }}
        - {{ . | quote }}
    {{- end }}
      secretName: {{ .secretName | default (include "kubedeploy.ingress.tlsSecretName" $top) }}
  {{- end -}}
{{- else }}
    - hosts:
    {{- range $ingress.hosts }}
        - {{ .host |quote }}
    {{- end -}}
    {{- if $ingress.name }}
      secretName: {{ printf "%s-%s-ingress-tls" (include "kubedeploy.fullname" $top) $ingress.name }}
    {{- else }}
      secretName: {{ include "kubedeploy.ingress.tlsSecretName" $top }}
    {{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/* Detect default port for ingress */}}
{{- define "kubedeploy.ingress.defaultport" -}}
{{- $top := index . 0 -}}
{{- $ingress := index . 1 -}}
{{- if $ingress.svcPort -}}
{{- $ingress.svcPort }}
{{- else if $top.Values.service.ports -}}
{{- get ($top.Values.service.ports | first) "port" }}
{{- else if $top.Values.ports -}}
{{/*
We don't actually route traffic here. However, service object will use container
ports as values for service port in case service ports values are not defined
*/}}
{{- get ($top.Values.ports | first ) "containerPort" }}
{{- else -}}
{{/* TODO: remove in 2.x legacy chart version support */}}
{{- print "80" }}
{{- end -}}
{{- end -}}
