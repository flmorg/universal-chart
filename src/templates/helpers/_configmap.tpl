{{- define "helpers.configMap.renderConfigMap" -}}
{{- $v := dict -}}
{{- if typeIs "string" .value -}}
{{- $v = fromYaml .value -}}
{{- else if kindIs "map" .value -}}
{{- $v = .value -}}
{{- end -}}
{{- range $key, $value := $v }}
{{- if eq (typeOf $value) "float64" }}
{{ printf "%s: %s" $key (toString $value | quote) }}
{{- else if empty $value }}
{{ printf "%s: %s" $key ("" | quote) }}
{{- else if kindIs "string" $value }}
{{ printf "%s: %s" $key ($value | quote) }}
{{- else }}
{{ $key }}: {{$value | toJson | quote }}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "helpers.configMap.includeEnv" -}}
{{- $ctx := .context -}}
{{- range $index, $mainObject := .value }}
{{- range $index, $envObject := $mainObject.envs }}
- name: {{ $envObject.name }}
  valueFrom:
    configMapKeyRef:
      name: {{ $mainObject.configMapName }}
      key: {{ $envObject.key }}
{{- end }}
{{- end }}
{{- end }}