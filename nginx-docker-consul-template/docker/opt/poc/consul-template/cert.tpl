{{ with secret "mypki/issue/nginx-server" "ttl=30s" "common_name=nginx.poc" "ip_sans=192.168.1.80" }}
{{ .Data.certificate }}
{{ end }}