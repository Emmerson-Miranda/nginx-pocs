# NGINX-DOCKER-CONSUL-TEMPLATE

This is a POC that integrate NGINX with Consul Template. Consul template is pulling and renewing certificates from  Hashicorp Vault.

https://github.com/hashicorp/consul-template/blob/main/examples/vault-pki.md

Note: Because this is a PoC you will find some secrets related to a temporal local-cluster. Upload secrets to any respository is always a bad idea.

## Create Vault Role used by the template

```bash
kubectl exec --stdin=true --tty=true vault-0 -- /bin/sh
export VAULT_ROOT_TOKEN=s.uQ4NMKx9j2lbLXkcxIFGeAFU
vault login $VAULT_ROOT_TOKEN
vault write pki/roles/pocnginx-com allowed_domains=poc-nginx.com allow_subdomains=true max_ttl=72h common_name=poc.nginx.com allow_client=true allow_any_name=true allow_bare_domains=true
```


## Checking cert renewal

```bash
% kubectl get pods                                              
NAME                                  READY   STATUS    RESTARTS   AGE
nginxct-c56487d48-bfkpm               1/1     Running   0          7m22s
vault-0                               1/1     Running   0          140m
vault-agent-injector-58b6d499-dtww8   1/1     Running   0          140m

% kubectl exec $(kubectl get pod -l app=nginxct -n default -o jsonpath={.items..metadata.name}) -- ls -la /opt/poc/certs/
total 24
drwxr-xr-x 1 root root 4096 Apr 25 23:53 .
drwxr-xr-x 1 root root 4096 Apr 25 23:46 ..
-rw-r--r-- 1 root root   74 Apr 24 21:51 README.md
-rwxr-xr-x 1 root root 1335 Apr 25 23:53 cert.pem
-rwxr-xr-x 1 root root 1680 Apr 25 23:53 key.pem
```


# Related links

https://learn.hashicorp.com/tutorials/vault/kubernetes-minikube?in=vault/kubernetes
https://github.com/hashicorp/consul-template
https://github.com/hashicorp/consul-template/blob/master/docs/templating-language.md
https://cert-manager.io/docs/installation/helm/#uninstalling-with-helm
https://medium.com/bb-tutorials-and-thoughts/practice-enough-with-these-questions-for-the-ckad-exam-2f42d1228552
https://learn.hashicorp.com/tutorials/vault/kubernetes-cert-manager?in=vault/kubernetes
https://learn.hashicorp.com/tutorials/vault/kubernetes-cert-manager?in=vault/kubernetes

https://www.youtube.com/watch?v=6pGcb9JE3vU
https://www.freecodecamp.org/news/certified-kubernetes-administrator-study-guide-cka/
https://itnext.io/practical-tips-for-passing-ckad-exam-6cbdf2d35cb1
https://medium.com/backbase/kubernetes-application-developer-certification-tips-1d82f20c0ea7
https://github.com/hashicorp/consul-template/blob/master/docs/configuration.md
https://www.vaultproject.io/docs/auth/kubernetes


