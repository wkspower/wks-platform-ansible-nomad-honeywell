job "traefik" {
  datacenters = ["dc1"]

  group "traefik" {
    count = 1

    network {
      port "http" {
        static = 80
      }

      port "https" {
        static = 443
      }

      port "dashboard" {
        static = 8080
      }
    }

    service {
      name = "traefik"
    }

    volume "data_storage" {
      source    = "data_storage"
      read_only = false
    }

    task "traefik" {
      driver = "docker"

      config {
        image = "traefik:v2.8"
        
        ports = ["http", "https", "dashboard"]

        args = [
          "--log.level=debug",
          "--api.insecure=true",
          "--api.dashboard=true",
          "--entrypoints.web.address=:80",
          "--entrypoints.websecure.address=:443",
          "--providers.docker=true",
          "--experimental.hub=true",
          "--serversTransport.insecureSkipVerify=true",
          "--providers.consulcatalog.prefix=traefik",
          "--providers.consulcatalog.exposedbydefault=false",
          "--providers.consulcatalog.endpoint.address=http://consul.service.consul:8500"
        ]

        mounts = [
          {
            type   = "volume"
            source = "data_storage"
            target = "/etc/traefik"
          }
        ]
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
