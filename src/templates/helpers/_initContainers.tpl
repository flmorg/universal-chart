{{- define "helpers.initContainers.renderDefaults" -}}
{{- $ctx := .context -}}
{{- $command := "" -}}
{{- range $ctx.containers }}
{{- range .volumeMounts }}
{{- if .subPath }}
{{- if empty $command }}
{{- $command = "sh;-c;" -}}
{{- end }}
{{- $command = printf "%s;chmod 777 %s" $command .mountPath -}}
{{- end }}
{{- end }}
{{- end }}
{{- if $command }}
{{- if not $ctx.initContainers -}}
initContainers:
{{- end }}
{{- include "helpers.initContainers.renderDefault" (dict "containers" $ctx.containers "command" $command) | nindent 2 -}}
{{- end }}
{{- end }}

{{- define "helpers.initContainers.renderDefault" -}}
{{- $containers := .containers -}}
{{- $command := .command -}}
-
  name: volume-permissions
  image: busybox:latest
  imagePullPolicy: IfNotPresent
  securityContext:
    runAsUser: 0
  command: {{ printf "[\"%s\"]" (join ("\", \"") (without (splitList ";" .command) "" )) }}
  resources:
    requests:
      cpu: 500m
      memory: 128Mi
    limits:
      cpu: 500m
      memory: 128Mi
  volumeMounts:
{{- range $containers }}
{{- .volumeMounts | toYaml | nindent 4 -}}
{{- end }}
{{- end }}