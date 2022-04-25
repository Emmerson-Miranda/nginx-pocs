# NGINX-DOCKER-CONSUL-TEMPLATE

This is a POC that integrate NGINX with Consul Template. Consul template is pulling and renewing certificates from  Hashicorp Vault.

https://github.com/hashicorp/consul-template/blob/main/examples/vault-pki.md


## Checking cert renewal
```bash
% kubectl get pods                                              
NAME                                  READY   STATUS    RESTARTS   AGE
nginxct-c56487d48-bfkpm               1/1     Running   0          7m22s
vault-0                               1/1     Running   0          140m
vault-agent-injector-58b6d499-dtww8   1/1     Running   0          140m

% kubectl exec nginxct-c56487d48-bfkpm -- ls -la /opt/poc/certs/
total 24
drwxr-xr-x 1 root root 4096 Apr 25 23:53 .
drwxr-xr-x 1 root root 4096 Apr 25 23:46 ..
-rw-r--r-- 1 root root   74 Apr 24 21:51 README.md
-rwxr-xr-x 1 root root 1335 Apr 25 23:53 cert.pem
-rwxr-xr-x 1 root root 1680 Apr 25 23:53 key.pem
```