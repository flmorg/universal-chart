{{- define "helpers.initContainers.renderDefaults" -}}
{{- $ctx := .context -}}
{{- $command := "" -}}
{{- $hasPvc := false -}}  # Flag to check if there's any pvc volumeMount
{{- range $ctx.containers }}
{{- if .volumeMounts }}
{{- range .volumeMounts }}
{{- if eq .type "pvc" }}
  {{- $hasPvc = true -}}  # Set flag to true when a pvc volumeMount is found
  {{- if .subPath }}
    {{- if empty $command }}
      {{- $command = "sh;-c;" -}}
    {{- end }}
    {{- $uniqueMountPath := printf "%s-%s" .mountPath .name -}}
    {{- $command = printf "%s;chmod 777 %s" $command $uniqueMountPath -}}
  {{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- if $hasPvc }}  # Only append initContainer if there is a pvc volumeMount
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
      cpu: 0m
      memory: 0Mi
    limits:
      cpu: 100m
      memory: 64Mi
  volumeMounts:
  {{- range $containers }}
    {{- if .volumeMounts }}
      {{- range .volumeMounts }}
        {{- if eq .type "pvc" }}
    - name: {{ .name }}
      mountPath: {{ printf "%s-%s" .mountPath .name }}
      {{- if .subPath }}
      subPath: {{ .subPath }}
      {{- end }}
        {{- end }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}
