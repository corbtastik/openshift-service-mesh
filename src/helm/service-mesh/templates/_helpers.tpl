{{/* Top level "system" name */}}
{{- define "system.name" -}}
{{- .Values.system.name | trunc 63 }}
{{- end }}

{{/* Formatted service-mesh chart name and version. */}}
{{- define "service-mesh.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "smcp.name" -}}
{{- .Values.smcp.name | trunc 63 }}
{{- end }}

{{/* Labels for the service mesh control plane */}}
{{- define "smcp.labels" -}}
helm.sh/chart: {{ include "service-mesh.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{ include "smcp.selectorLabels" . }}
{{- end }}

{{/* Kubernetes recommended selector labels */}}
{{- define "smcp.selectorLabels" -}}
app.kubernetes.io/name: {{ include "smcp.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: {{ .Values.system.name }}
{{- if .Values.system.version }}
app.kubernetes.io/version: {{ .Values.system.version }}
{{- else }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{ include "smcp.simpleLabels" . }}
{{- end }}

{{/* Simple format labels (aka app and version) for "system" level */}}
{{- define "smcp.simpleLabels" -}}
app: {{ include "smcp.name" . }}
{{- if .Values.system.version }}
version: {{ .Values.system.version }}
{{- else }}
version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{- define "smmr.name" -}}
{{- .Values.smmr.name | trunc 63 }}
{{- end }}

{{/* Labels for the service mesh member roll */}}
{{- define "smmr.labels" -}}
helm.sh/chart: {{ include "service-mesh.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{ include "smmr.selectorLabels" . }}
{{- end }}

{{/* Kubernetes recommended selector labels */}}
{{- define "smmr.selectorLabels" -}}
app.kubernetes.io/name: {{ include "smmr.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: {{ .Values.system.name }}
{{- if .Values.system.version }}
app.kubernetes.io/version: {{ .Values.system.version }}
{{- else }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{ include "smmr.simpleLabels" . }}
{{- end }}

{{/* Simple format labels (aka app and version) for "system" level */}}
{{- define "smmr.simpleLabels" -}}
app: {{ include "smmr.name" . }}
{{- if .Values.system.version }}
version: {{ .Values.system.version }}
{{- else }}
version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}
