{{- define "helpers.field.includeEnv" -}}
{{- $ctx := .context -}}
{{- range $index, $mainObject := .value }}
- name: {{ $mainObject.name }}
  valueFrom:
    fieldRef:
      fieldPath: {{ $mainObject.fieldPath }}
{{- end }}
{{- end }}