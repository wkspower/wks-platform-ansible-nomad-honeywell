# wks-infra-bare

## step 1 - creating ssh-keys

Create sshkeys with name 'id_rsa_deployer'

```bash
ssh-keygen -t rsa -b 4096 -C "deployer" -f ~/.ssh/id_rsa_deployer
cd $PWD/wks-infra-bare
```

## step 2 - creating hosts barel metal in digital ocean cloud (optional)

```bash
cd ./infrastructure
terraform apply -var="do_token=${DO_PAT}" -var="ssh_key=$(cat ~/.ssh/id_rsa_deployer.pub)"
cd ..
```

## step 3 - configure ipv4 for each hosts

You must fill in the IPv4 address for each host declared in the directories 'apps' and 'servers'

```bash
code ./apps/inventory/hosts
code ./servers/inventory/hosts
```

* By example
```ansible
...
[master]
vmbaremaster ansible_host=10.10.67.01

[app1]
vmbareapp1 ansible_host=10.10.67.02

[app2]
vmbareapp2 ansible_host=10.10.67.03

[lb]
vmbarelb ansible_host=10.10.67.04
...
```

## step 4 - copy certificates tls for dns

```bash
cp $PWD/[dns_wildcard_cert].crt ./servers/roles/shared_cert_files/files
cp $PWD/[dns_wildcard_cert].key ./servers/roles/shared_cert_files/files
```

## step 5 - prepara OS for each hosts

```bash
cd ./servers
ansible-playbook -i inventory/hosts initial_setup.yml
```

## step 6 - configure dns name

* open file definitions

```bash
code ./inventory/hosts
```

* assign the DNS value to the 'dns_name' variable.

## step 7 - checking cluster info (optional)

copy ipv4 from vmbaremaster and replace by ipv4

```bash
ssh -i ~/.ssh/id_rsa_deployer -L 4646:10.10.67.01:4646 deployer@10.10.67.01
open http://localhost:4646
```

## step 8 - deploy all servers on the cluster

```bash
ansible-playbook -i inventory/hosts deploy_servers.yml
```

## step 9 - deploy all apps on the cluster

```bash
cd ../apps
ansible-playbook -i inventory/hosts deploy_apps.yml
```
