{{ with secret "pki/sign/example-dot-com" "ttl=30s" "common_name=example.com" "ip_sans=192.168.1.80" }}
{{ .Data.private_key }}
{{ end }}