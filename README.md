# wks-infra-bare

## Create hosts

```bash
 terraform apply -var="do_token=${DO_PAT}" -var="ssh_key=$(cat ~/.ssh/id_rsa_deployer.pub)"
 ```

 ## Setup servers and cluster

```bash
 ansible-playbook -i inventory site.yml -e "ghcr_username=${GHCR_USER} ghcr_token=${GHCR_TOKEN}"
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