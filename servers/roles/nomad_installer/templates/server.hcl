data_dir  = "/opt/nomad"
bind_addr = "0.0.0.0"

server {
  enabled          = true
  bootstrap_expect = 1
}

advertise {
  http = "{{ hostvars['vmbaremaster'].ansible_host }}"
  rpc  = "{{ hostvars['vmbaremaster'].ansible_host }}"
  serf = "{{ hostvars['vmbaremaster'].ansible_host }}"
}

plugin "docker" {
  config {
    volumes {
      enabled = true
    }
  }
}