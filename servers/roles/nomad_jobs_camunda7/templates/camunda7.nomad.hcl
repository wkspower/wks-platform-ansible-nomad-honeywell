job "camunda7" {
  datacenters = ["dc1"]

  constraint {
    attribute = "${meta.role}"
    value     = "{{ constraint }}"
  }

  group "camunda" {
    count = 1

    network {
      mode = "bridge"
      
      port "http" {
        static = 7000
        to     = 8080 
      }
    }

    task "camunda7" {
      driver = "docker"

      config {
        image = "camunda/camunda-bpm-platform:run-7.20.0"
        args = [
          "./camunda.sh",
          "--rest",
          "--webapps"
        ]
        ports = ["http"]
      }

      env {
        DB_DRIVER="org.postgresql.Driver"
        DB_URL="jdbc:postgresql://postgres.service.consul:5432/camunda"
        DB_USERNAME="camunda"
        DB_PASSWORD="camunda00"
        DB_VALIDATE_ON_BORROW="false"
      }      

      resources {
        cpu    = 500
        memory = 720
      }

      service {
        name = "camunda7"
        port = "http"
        check {
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
