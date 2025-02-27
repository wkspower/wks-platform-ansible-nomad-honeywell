# wks-infra-bare

## Create ssh keys 

```bash
ssh-keygen -t rsa -b 4096 -C "deployer" -f ~/.ssh/id_rsa_deployer
```

## Create hosts

```bash
 terraform apply -var="do_token=${DO_PAT}" -var="ssh_key=$(cat ~/.ssh/id_rsa_deployer.pub)"
 ```

 ## Setup servers and cluster

```bash
 ansible-playbook -i inventory site.yml
```

## Deploy server to cluster

```bash
ansible-playbook -i inventory/hosts playbooks/deploy_camunda7.yml
ansible-playbook -i inventory/hosts playbooks/deploy_keycloak.yml
ansible-playbook -i inventory/hosts playbooks/deploy_minio.yml
ansible-playbook -i inventory/hosts playbooks/deploy_mongodb.yml
ansible-playbook -i inventory/hosts playbooks/deploy_postgres.yml
```

## Deploy apps to cluster

```bash
ansible-playbook -i inventory/hosts playbooks/deploy_storage_api.yml
```

## Access to cluster dashboard 

```bash
ssh -i ~/.ssh/id_rsa_deployer -L 4646:104.248.57.30:4646  deployer@104.248.57.30
ssh -i ~/.ssh/id_rsa_deployer deployer@159.223.173.235
```

## How to validate open policy pules before commit

```bash
docker run --rm -ti -v $PWD/roles/nomad_jobs_open_policy/files:/etc/rules openpolicyagent/opa:edge-static eval -i /etc/rules/wks_policy_rules.rego 'data.wks.authz.allow'
```

## Exposing service ports from cluster

```bash
# only
ssh -i ~/.ssh/id_rsa_deployer -L 7000:postgres.service.consul:5432  deployer@104.248.57.30
ssh -i ~/.ssh/id_rsa_deployer -L 7001:camunda7.service.consul:8080  deployer@104.248.57.30
ssh -i ~/.ssh/id_rsa_deployer -L 7002:keycloak.service.consul:8080  deployer@104.248.57.30
ssh -i ~/.ssh/id_rsa_deployer -L 7003:mongodb.service.consul:27017  deployer@104.248.57.30
ssh -i ~/.ssh/id_rsa_deployer -L 7004:minio.service.consul:9000  deployer@104.248.57.30
ssh -i ~/.ssh/id_rsa_deployer -L 7005:traefik.service.consul:8080  deployer@104.248.57.30
```

```bash
# all
ssh -i ~/.ssh/id_rsa_deployer -L 4646:104.248.57.30:4646 -L 7005:traefik.service.consul:8080 deployer@104.248.57.30
```

## Configure configue 'org' namespace assigned to subdomain

### Example

```bash
[demo-mb].wkspower.dev
     => org
```

### Credencials

```bash
https://demo-bm.wkspower.dev/
user: victor
password: victor00

https://camunda.wkspower.dev/
user: demo
password: demo00

https://iam.wkspower.dev/
user: admin
password: admin00
```