job "storage_api" {
  datacenters = ["dc1"]

  group "apps" {
    network {
      port "http" {
        static = 8085
      }
    }

    task "storage_api" {
      driver = "docker"

      config {
        image = "{{ docker_registry_dest }}/storage-api:{{ tag }}"
        ports = ["http"]
      }

      resources {
        cpu    = 500
        memory = 512
      }

      env {
        OPA_URL="http://opa.service.consul:8181/v1/data/wks/authz/allow"
        KEYCLOAK_URL="http://keycloak.service.consul:8080"
        MINIO_HOST_INTERNAL="minio.service.consul"
        MINIO_ROOT_USER="minio"
        MINIO_ROOT_PASSWORD="BwiY|61P1z3("
      }      

      service {
        name = "storageapi"
        provider = "consul"
        port = "http"

        tags = [
          "traefik.enable=true",
          "traefik.http.routers.storageapi.rule=Path(`/storage`)",
          "traefik.http.routers.storageapi.entrypoints=web"
        ]
      }
    }
  }
}
