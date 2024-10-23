{{/*
Expand the name of the chart.
*/}}
{{- define "lab-virtualmachine.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "lab-virtualmachine.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "lab-virtualmachine.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "lab-virtualmachine.labels" -}}
helm.sh/chart: {{ include "lab-virtualmachine.chart" . }}
{{ include "lab-virtualmachine.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "lab-virtualmachine.selectorLabels" -}}
app.kubernetes.io/name: {{ include "lab-virtualmachine.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "lab-virtualmachine.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "lab-virtualmachine.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Secret name storing cloud-init configuration
*/}}
{{- define "lab-virtualmachine.cloud-init-secret" -}}
{{- printf "%s-cloud-init" .Release.Name | trunc 63 }}
{{- end }}


{{/*
Config map name storing script customizing libvirt domain
*/}}
{{- define "lab-virtualmachine.hook-sidecar-cm" -}}
{{- printf "%s-hook-sidecar-script" .Release.Name | trunc 63 }}
{{- end }}

{{/*
Config map key storing script customizing libvirt domain
*/}}
{{- define "lab-virtualmachine.hook-sidecar-cm-key" -}}
script.sh
{{- end }}

{{/*

{{/*
Create hook sidecar annotation for injecting script customizing libvirt domain
*/}}
{{- define "lab-virtualmachine.hook-sidecar-annotation" -}}
{{- if .Values.hookSidecarScript }}
{{- $dict := dict
    "args" (list "--version" "v1alpha2")
    "image" "quay.io/kubevirt/sidecar-shim:latest"
    "configMap" (dict
        "name" (include "lab-virtualmachine.hook-sidecar-cm" .)
        "key" (include "lab-virtualmachine.hook-sidecar-cm-key" .)
        "hookPath" "/usr/bin/onDefineDomain")
-}}
{{- toJson (list $dict) -}}
{{- end }}
{{- end }}
