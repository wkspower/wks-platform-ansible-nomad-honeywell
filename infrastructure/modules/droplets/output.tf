output "droplet_ips" {
  value = digitalocean_droplet.nodes.*.ipv4_address
}