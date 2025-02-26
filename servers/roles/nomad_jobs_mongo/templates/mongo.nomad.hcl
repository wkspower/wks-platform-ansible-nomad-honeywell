job "mongo" {
  datacenters = ["dc1"]

  constraint {
    attribute = "${meta.role}"
    value     = "{{ constraint }}"
  }

  group "mongo" {
    network {
      mode = "bridge"

      port "tcp" {
        static = 27017
        to     = 27017
      }
    }

    task "mongodb" {
      driver = "docker"

      config {
        image = "mongo:6.0"
        ports = ["tcp"]
      }

      resources {
        cpu    = 500
        memory = 512
      }

      volume_mount {
        volume      = "mongo_data"
        destination = "/var/lib/mongo/data"
      }

      service {
        name = "mongodb"
        port = "tcp"
        check {
          name     = "mongo-tcp"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }

    volume "mongo_data" {
      type      = "host"
      read_only = false
      source    = "mongodata"
    }
  }
}
