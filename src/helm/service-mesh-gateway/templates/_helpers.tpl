{{/* Top level "system" name */}}
{{- define "system.name" -}}
{{- .Values.system.name | trunc 63 }}
{{- end }}

{{/* Formatted service-mesh-gateway chart name and version. */}}
{{- define "service-mesh-gateway.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* gateway name */}}
{{- define "gateway.name" -}}
{{- .Values.istio.gateway.name | trunc 63 }}
{{- end }}

{{/* Labels for the gateway */}}
{{- define "gateway.labels" -}}
helm.sh/chart: {{ include "service-mesh-gateway.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{ include "gateway.selectorLabels" . }}
{{- end }}

{{/* Gateway selector labels */}}
{{- define "gateway.selectorLabels" -}}
app.kubernetes.io/name: {{ include "gateway.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: {{ .Values.system.name }}
{{- if .Values.system.version }}
app.kubernetes.io/version: {{ .Values.system.version }}
{{- else }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{ include "gateway.simpleLabels" . }}
{{- end }}

{{/* Simple format labels for gateway */}}
{{- define "gateway.simpleLabels" -}}
app: {{ include "gateway.name" . }}
{{- if .Values.system.version }}
version: {{ .Values.system.version }}
{{- else }}
version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{- define "route.name" -}}
{{- .Values.route.name | trunc 63 }}
{{- end }}

{{/* Labels for the gateway route */}}
{{- define "route.labels" -}}
helm.sh/chart: {{ include "service-mesh-gateway.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{ include "route.selectorLabels" . }}
{{- end }}

{{/* Kubernetes recommended selector labels */}}
{{- define "route.selectorLabels" -}}
app.kubernetes.io/name: {{ include "route.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: {{ .Values.system.name }}
{{- if .Values.system.version }}
app.kubernetes.io/version: {{ .Values.system.version }}
{{- else }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{ include "route.simpleLabels" . }}
{{- end }}

{{/* Simple format labels (aka app and version) for "system" level */}}
{{- define "route.simpleLabels" -}}
app: {{ include "route.name" . }}
{{- if .Values.system.version }}
version: {{ .Values.system.version }}
{{- else }}
version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}