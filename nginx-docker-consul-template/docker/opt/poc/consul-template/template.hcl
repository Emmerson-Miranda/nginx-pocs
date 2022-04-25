vault {
  address      = "http://vault.vault:8200"
  ssl {
     enabled = false
   }
  # I'm using the environment variable VAULT_TOKEN instead.
  # token        = "s.xxxxxx"
  # grace        = "1s"
  unwrap_token = false
  renew_token  = false
}

log_level = "debug"

#syslog {
#  enabled  = true
#  facility = "LOCAL5"
#}

template {
  source      = "/opt/poc/consul-template/cert.tpl"
  destination = "/opt/poc/certs/cert.pem"
  perms       = 0755
  command     = "nginx reload"
}

template {
  source      = "/opt/poc/consul-template/key.tpl"
  destination = "/opt/poc/certs/key.pem"
  perms       = 0755
  command     = "nginx reload"
}