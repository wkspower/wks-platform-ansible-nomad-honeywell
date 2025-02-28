
# **Deploying WKS Platform in a Cluster with Ansible and Nomad**

## Introduction

This guide provides a structured step-by-step approach to deploying the WKS Platform infrastructure and applications using Ansible and Nomad. It covers everything from SSH key generation, configuring hosts, deploying core services, and final application deployment. By following this guide, you will be able to set up and manage your infrastructure efficiently.

## Target Architecture

The deployment is structured as a standalone cluster using Nomad for workload orchestration and Ansible for configuration management. The key components of the cluster are:

-   **Load Balancer (**`**vmbarelb**`**)**: Handles traffic distribution across application nodes and routes requests to appropriate services.
    
-   **Master Node (**`**vmbaremaster**`**)**: Manages Nomad cluster coordination and job scheduling.
    
-   **Application Nodes (**`**vmbareapp1**`**,** `**vmbareapp2**`**)**: Hosts services and applications deployed within the cluster.
    

## Subdomain Configuration

All subdomains should point to the Load Balancer (`vmbarelb`), which will handle traffic distribution across the cluster. Replace `wkspower.dev` with your domain:

-   `camunda.wkspower.dev`
    
-   `app.wkspower.dev`
    
-   `iam.wkspower.dev`
    
-   `login.wkspower.dev`
    
-   `api.wkspower.dev`
    

Ensure that these subdomains are configured in your DNS provider to point to the IPv4 address of the Load Balancer (`vmbarelb`).

## Prerequisites

-   Ensure you have `ssh-keygen` and `Ansible` installed and properly configured on your local machine. `ssh-keygen` is required to generate secure SSH keys for authentication, and Ansible is used for automating the deployment of the infrastructure.
    
-   Ensure you have a wildcard TLS certificate for DNS setup. This certificate allows all subdomains under your main domain to be secured under a single certificate. You will need both the certificate (`.crt` file) and the corresponding private key (`.key` file). These will be used to configure secure communication for the services deployed in the cluster.
    

----------

## Step 1: Generate SSH Keys

Generate an SSH key pair for deployment:

```
ssh-keygen -t rsa -b 4096 -C "deployer" -f ~/.ssh/id_rsa_deployer
```

----------

## Step 2: Configure IPv4 Addresses

Each host in the cluster serves a specific role and must be assigned a static IPv4 address. These addresses are used for communication between the different components in the cluster.

-   **vmbaremaster (Master Node)**: The main node that orchestrates the cluster and manages workload scheduling.
    
-   **vmbareapp1, vmbareapp2 (Application Nodes)**: Hosts services and applications deployed within the cluster.
    
-   **vmbarelb (Load Balancer)**: Distributes network traffic among application nodes to ensure high availability and reliability.
    

Update the inventory files located in `./apps/inventory/hosts` and `./servers/inventory/hosts` with the assigned IPv4 addresses using your preferred text editor.

Example format:

```
[master]
vmbaremaster ansible_host=10.10.67.01

[app1]
vmbareapp1 ansible_host=10.10.67.02

[app2]
vmbareapp2 ansible_host=10.10.67.03

[lb]
vmbarelb ansible_host=10.10.67.04
```

Make sure these IP addresses match your infrastructure setup, as incorrect configurations may prevent nodes from communicating properly.

----------

## **Step 3: Configure TLS Certificates for Secure Communication**

Ensure you have the necessary TLS certificates before proceeding. The required certificates include:

-   **Wildcard SSL certificate (**`**dns_wildcard_cert.crt**`**)**: Used to secure HTTPS connections for your domain.
    
-   **Wildcard SSL private key (**`**dns_wildcard_cert.key**`**)**: Corresponding private key for the wildcard certificate.
    

Copy the wildcard certificate and key to the appropriate location:

```
cp /path/to/[dns_wildcard_cert].crt ./servers/roles/shared_cert_files/files
cp /path/to/[dns_wildcard_cert].key ./servers/roles/shared_cert_files/files
```

----------

## Step 4: System Setup and Host Preparation

This step configures all cluster nodes before deployment, ensuring connectivity, security, and service discovery. The master node runs Consul and Nomad (`server` roles), application nodes run Consul and Nomad (`client` roles), and the load balancer uses Nginx for traffic distribution.

Run the setup playbook:

```
cd ./servers
ansible-playbook -i inventory/hosts initial_setup.yml
```

----------

## Step 5: Set Up DNS Configuration

The DNS name is used to properly configure hostname resolution within the cluster. To set the DNS name, update the inventory file located at `./inventory/hosts`.

Example configuration:

```
[all:vars]
ansible_user=deployer
ansible_ssh_private_key_file=~/.ssh/id_rsa_deployer
ubuntu_distribution_codename=jammy
dns_name=wkspower.dev
```

Ensure the `dns_name` variable reflects your domain name instead of `wkspower.dev`.

----------

## Step 6: Deploy Essential Services and Infrastructure

Deploy essential services required for the cluster operation. These include databases, authentication, and networking components. Run the following Ansible playbooks in order:

```
ansible-playbook -i inventory/hosts deploy_servers.yml
```

----------

## Step 7: Deploy and Configure Applications

Deploy the final set of applications within the cluster. This step ensures that all required services and workloads are properly launched and configured to run within the Nomad-managed environment.

```
ansible-playbook -i inventory/hosts deploy_apps.yml
```

----------

## Step 8: Verify Cluster Status with Nomad Dashboard

To check the status of the deployed cluster, access the Nomad dashboard:

1.  Copy the IPv4 address of `vmbaremaster` and replace it in the following command:

```
ssh -i ~/.ssh/id_rsa_deployer -L 4646:10.10.67.01:4646 deployer@10.10.67.01
```

2.  Open a web browser and navigate to:    

```
http://localhost:4646
```

This will display the Nomad dashboard, where you can monitor jobs, allocations, and cluster health. Below is an example screenshot of the dashboard:

![image](https://github.com/user-attachments/assets/95018b87-5d44-4685-b966-c252538c7dd5)

----------

## Testing the Deployment

To verify that the deployment was successful, open a web browser and navigate to the front-end application URL:

```
https://app.wkspower.dev (Replace `wkspower.dev` with your actual domain)
```

Use the following credentials to log in:

-   **Username:** demo
    
-   **Password:** demo
    

If the login is successful and the dashboard loads correctly, the deployment has been successfully completed.
