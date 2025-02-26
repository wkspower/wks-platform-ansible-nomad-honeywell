data_dir  = "/opt/nomad"

bind_addr = "0.0.0.0"

consul {
  address = "127.0.0.1:8500"
}

client {
  enabled = true

  servers = ["{{ master_address }}:4647"]
  
  host_volume "data_storage" {
    path      = "/mnt/data_storage"
    read_only = false
  }

  host_volume "pgdata" {
    path      = "/mnt/data_storage/pgdata"
    read_only = false
  }

  host_volume "miniodata" {
    path      = "/mnt/data_storage/minio"
    read_only = false
  }

  host_volume "mongodata" {
    path      = "/mnt/data_storage/mongo"
    read_only = false
  }  

  meta {
    role = "{{ nomad_meta_role }}"
  }
}

plugin "docker" {
  config {
    volumes {
      enabled = true
    }
  }
}