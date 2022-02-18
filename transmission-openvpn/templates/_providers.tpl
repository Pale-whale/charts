{{- define "provider-config" -}}
- name: OPENVPN_PROVIDER
  value: {{ .Values.provider.name | squote }}
- name: OPENVPN_USERNAME
{{- if .Values.provider.user.extraSecret }}
  valueFrom:
    secretKeyRef:
      name:  {{ .Values.provider.user.extraSecret.name }}
      key:  {{ .Values.provider.user.extraSecret.usernameKey }}
{{- else }}
  value: {{ .Values.provider.user.name | squote }}
{{- end }}
- name: OPENVPN_PASSWORD
{{- if .Values.provider.user.extraSecret }}
  valueFrom:
    secretKeyRef:
      name:  {{ .Values.provider.user.extraSecret.name }}
      key:  {{ .Values.provider.user.extraSecret.passwordKey }}
{{- else }}
  value: {{ .Values.provider.user.password | squote }}
{{- end }}
- name: OPENVPN_CONFIG
  value: {{ .Values.provider.endpoint | squote }}
{{- with .Values.provider.extraOpts }}
- name: OPENVPN_OPTS
  value: {{ . | squote }}
{{- end }}
- name: LOCAL_NETWORK
  value: {{ .Values.provider.localNetwork | squote }}
- name: CREATE_TUN_DEVICE
  value: {{ .Values.provider.create_tun_device | default true | squote }}
- name: PEER_DNS
  value: {{ .Values.peer_dns | default true | squote }}
- name: PEER_DNS_PIN_ROUTES
  value: {{ .Values.peer_dns_pin_routes | default true | squote }}
{{- if eq .Values.provider.name "nordvpn" }}
- name: NORDVPN_COUNTRY
  value: {{ .Values.provider.endpoint | squote }}
- name: NORDVPN_CATEGORY
  value: {{ .Values.provider.category | squote }}
- name: NORDVPN_PROTOCOL
  value: {{ .Values.provider.protocol | squote }}
{{- end }}
{{- end }}

{{- define "firewall-config" }}
- name: ENABLE_UFW
  value: {{ .Values.firewall.enable  | squote}}
- name: UFW_ALLOW_GW_NET
  value: {{ .Values.firewall.allowGatewayNetwork | default false | squote }}
- name: UFW_EXTRA_PORTS
  value: {{ .Values.firewall.extraPorts | squote }}
- name: UFW_DISABLE_IPTABLES_REJECT
  values {{ .Values.firewall.disableReject | squote }}
{{- end -}}

{{- define "rpc-config" -}}
- name: TRANSMISSION_RPC_ENABLED
  value: {{ .Values.rpc.enabled | squote }}
- name: TRANSMISSION_RPC_AUTH_REQUIRED
  value: {{ .Values.rpc.auth_required | squote }}
- name: TRANSMISSION_RPC_BIND_ADDRESS
  value: '0.0.0.0'
- name: TRANSMISSION_RPC_PORT
  value: '9091'
- name: TRANSMISSION_RPC_USERNAME
{{- if .Values.rpc.user.extraSecret }}
- valueFrom:
    secretKeyRef:
      name: {{ .Values.rpc.user.extraSecret.name }}
      key: {{ .Values.rpc.user.extraSecret.userKey }}
- name: TRANSMISSION_RPC_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.rpc.user.extraSecret.name }}
      key: {{ .Values.rpc.user.extraSecret.passwordKey }}
{{- else }}
  value: {{ .Values.rpc.user.name }}
- name: TRANSMISSION_RPC_PASSWORD
  value: {{ .Values.rpc.user.password }}
{{- end }}
{{- if deepEqual .Values.rpc.whitelist (list) }}
- name: TRANSMISSION_RPC_WHITELIST_ENABLED
  value: "false"
{{- else }}
- name: TRANSMISSION_RPC_WHITELIST_ENABLED
  value: "true"
- name:  TRANSMISSION_RPC_WHITELIST
  value: {{ join "," .Values.rpc.whitelist | squote }}
{{- end }}
{{- end }}
