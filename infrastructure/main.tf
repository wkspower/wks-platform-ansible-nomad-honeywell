resource "digitalocean_ssh_key" "deployer" {
  name       = "deployer"
  public_key = var.ssh_key
}

module "master" {
  source     = "./modules/droplets"
  name       = "vmbare-master"
  vmsize     = "s-1vcpu-2gb"
  volumesize = 20
  region     = var.region
  ssh_key    = var.ssh_key
  do_token   = var.do_token
  sshkey     = digitalocean_ssh_key.deployer.fingerprint
  tags       = ["bare", "master"]
}

module "app1" {
  source     = "./modules/droplets"
  name       = "vmbare-app1"
  vmsize     = "s-2vcpu-4gb"
  volumesize = 20
  region     = var.region
  ssh_key    = var.ssh_key
  do_token   = var.do_token
  sshkey     = digitalocean_ssh_key.deployer.fingerprint
  tags       = ["bare", "app1"]
}

module "app2" {
  source     = "./modules/droplets"
  name       = "vmbare-app2"
  vmsize     = "s-2vcpu-4gb"
  volumesize = 20
  region     = var.region
  ssh_key    = var.ssh_key
  do_token   = var.do_token
  sshkey     = digitalocean_ssh_key.deployer.fingerprint
  tags       = ["bare", "app2"]
}
