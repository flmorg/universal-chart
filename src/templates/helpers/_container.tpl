{{- define "helpers.containers.env" -}}
{{- $ctx := .context -}}
{{- $v := .value -}}
{{- if or (or $v.envFromConfigmap $v.envFromSecret) $v.env }}
env:
{{- with $v.envFromConfigmap }}{{- include "helpers.configMap.includeEnv" ( dict "value" . "context" $ctx) }}{{- end }}
{{- with $v.envFromSecret }}{{- include "helpers.secrets.includeEnv" ( dict "value" . "context" $ctx) }}{{- end }}
{{ with $v.env }}{{- include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) }}{{- end }}
{{- end }}
{{- end }}

{{- define "helpers.containers.envFrom" -}}
{{- $ctx := .context -}}
{{- $v := .value -}}
{{- if or (or $v.envConfigmaps $v.envSecrets) $v.envFrom }}
envFrom:
{{- with $v.envConfigmaps }}{{- include "helpers.configMaps.includeEnvConfigmap" ( dict "value" . "context" $ctx) }}{{- end }}
{{- with $v.envSecrets }}{{- include "helpers.secrets.includeEnvSecrets" ( dict "value" . "context" $ctx) }}{{- end }}
{{- with $v.envFrom }}{{- include "helpers.tplvalues.render" ( dict "value" . "context" $ctx) }}{{- end }}
{{- end }}
{{- end }}