{{- define "helpers.secrets.includeEnv2" -}}
{{- $ctx := .context -}}
{{- $s := dict -}}
{{- if typeIs "string" .value -}}
{{- $s = fromYaml .value -}}
{{- else if kindIs "map" .value -}}
{{- $s = .value -}}
{{- end -}}
{{- range $sName, $envKeys := $s -}}
{{- range $envKey, $secretKey := $envKeys }}
{{- if kindIs "string" $secretKey }}
- name: {{ $envKey }}
  valueFrom:
    secretKeyRef:
      name: {{ include "helpers.app.fullname" (dict "name" $sName "context" $ctx) }}
      key: {{ $secretKey }}
{{- else if kindIs "map" $secretKey -}}
{{- range $keyName, $key := $secretKey }}
- name: {{ $keyName }}
  valueFrom:
    secretKeyRef:
      name: {{ include "helpers.app.fullname" (dict "name" $sName "context" $ctx) }}
      key: {{ $key }}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "helpers.secrets.includeEnv" -}}
{{- $ctx := .context -}}
{{- range $index, $mainObject := .value }}
{{- range $index, $envObject := $mainObject.envs }}
- name: {{ $envObject.name }}
  valueFrom:
    secretKeyRef:
      name: {{ include "helpers.app.fullname" (dict "name" $mainObject.secretName "context" $ctx) }}
      key: {{ $envObject.key }}
{{- end }}
{{- end }}
{{- end }}

{{- define "helpers.secrets.includeEnvSecrets" -}}
{{- $ctx := .context -}}
{{- range $i, $sName := .value }}
- secretRef:
    name: {{ include "helpers.app.fullname" (dict "name" $sName "context" $ctx) }}
{{- end -}}
{{- end -}}

{{- define "helpers.secrets.encode" -}}
{{if hasPrefix "b64:" .value}}{{trimPrefix "b64:" .value}}{{else}}{{toString .value|b64enc}}{{end}}
{{- end -}}

{{- define "helpers.secrets.render" -}}
{{- $v := dict -}}
{{- if kindIs "string" .value -}}
{{- $v = fromYaml .value }}
{{- else -}}
{{- $v = .value }}
{{- end -}}
{{- range $key, $value := $v }}
{{- if kindIs "string" $value }}
{{ printf "%s: %s" $key (include "helpers.secrets.encode" (dict "value" $value)) }}
{{- else }}
{{ $key }}: {{$value | toJson | b64enc }}
{{- end -}}
{{- end -}}
{{- end -}}