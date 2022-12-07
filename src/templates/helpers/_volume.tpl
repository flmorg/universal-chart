{{- define "helpers.volumes.renderVolume" -}}
{{- $ctx := .context -}}
{{- if .value -}}
{{- with .value }}{{- include "helpers.volumes.typed" (dict "volumes" . "context" $ctx) }}{{- end }}
{{- else }}
  []
{{- end }}
{{- end }}

{{- define "helpers.volumes.typed" -}}
{{- $ctx := .context -}}
{{- range .volumes -}}
{{- if eq .type "configMap" }}
- name: {{ .name }}
  configMap:
    {{- with .typeName }}
    name: {{ . }}
    {{- end }}
    {{- with .items }}
    items: {{- include "helpers.tplvalues.render" (dict "value" . "context" $ctx) | nindent 4 }}
    {{- end }}
{{- else if eq .type "secret" }}
- name: {{ .name }}
  secret:
    {{- with .typeName }}
    secretName: {{ . }}
    {{- end }}
    {{- with .items }}
    items: {{- include "helpers.tplvalues.render" (dict "value" . "context" $ctx) | nindent 4 }}
    {{- end }}
{{- else if eq .type "pvc" }}
- name: {{ .name }}
  persistentVolumeClaim:
    {{- with .typeName }}
    claimName: {{ . }}
    {{- end }}
{{- end }}
{{- end }}
{{- end }}

{{- define "helpers.volumes.renderVolumeMounts" -}}
{{- $ctx := .context -}}
{{- if .value -}}
{{- with .value }}{{- include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) }}{{- end }}
{{- else }}
  []
{{- end }}
{{- end }}