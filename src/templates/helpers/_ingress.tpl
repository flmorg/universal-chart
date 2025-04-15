{{/*
Helper for ingress backend
*/}}
{{- define "helpers.ingress.backend" -}}
{{- $serviceName := .serviceName -}}
{{- $servicePort := .servicePort -}}
{{- $context := .context -}}
service:
  name: {{ $serviceName }}
  port:
    {{- if kindIs "string" $servicePort }}
    name: {{ $servicePort }}
    {{- else }}
    number: {{ $servicePort }}
    {{- end }}
{{- end -}}