output "master_droplet_ips" {
  value = module.master.droplet_ips
}

output "app1_droplet_ips" {
  value = module.app1.droplet_ips
}

output "app2_droplet_ips" {
  value = module.app2.droplet_ips
}

output "lb_droplet_ips" {
  value = module.lb.droplet_ips
}