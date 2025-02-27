job "minio" {
  datacenters = ["dc1"]

  constraint {
    attribute = "${meta.role}"
    value     = "{{ constraint }}"
  }

  group "apps" {
    count  = 1

    network {
      port "minio" {
        static = 9000
        to     = 9000
      }
    }

    task "minio-server" {
      driver = "docker"

      config {
        image = "minio/minio"
        args  = ["server", "/var/lib/minio/data"]
        ports = ["minio"]
      }

      env {
        MINIO_ROOT_USER     = "{{ minio_user }}"
        MINIO_ROOT_PASSWORD = "{{ minio_password }}"
      }

      resources {
        cpu    = 500
        memory = 512
      }

      volume_mount {
        volume      = "minio_data"
        destination = "/var/lib/minio/data"
      }

      service {
        name = "minio"
        port = "minio"
        check {
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }

    volume "minio_data" {
      type      = "host"
      read_only = false
      source    = "miniodata"
    }
  }
}
