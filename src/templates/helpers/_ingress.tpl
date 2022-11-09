{{- define "helpers.ingress.backend" -}}
service:
  name: {{ .serviceName }}
  port:
    {{- if typeIs "string" .servicePort }}
    name: {{ .servicePort }}
    {{- else if typeIs "float64" .servicePort }}
    number: {{ .servicePort }}
    {{- else if typeIs "int64" .servicePort }}
    number: {{ .servicePort }}
    {{- end }}
{{- end -}}