job "postgres" {
  datacenters = ["dc1"]
  
  constraint {
    attribute = "${meta.role}"
    value     = "{{ constraint }}"
  }

  group "apps" {
    count = 1
    
    network {
      port "db" {
        static = 5432
        to     = 5432
      }
    }

    task "postgres" {
      driver = "docker"

      env = {
        POSTGRES_USER     = "{{ postgres_user }}"
        POSTGRES_PASSWORD = "{{ postgres_password }}"
        POSTGRES_DB       = "{{ postgres_database }}"
      }
            
      config {
        image = "postgres:15"
        ports = ["db"]
        volumes = [
          "local/init-db.sh:/docker-entrypoint-initdb.d/init-db.sh"
        ]        
      }

      template {
        data = <<-EOF
        #!/bin/bash
        set -e
        psql -v ON_ERROR_STOP=1 --username {{ postgres_user }} --dbname {{ postgres_database }} <<-EOSQL
          CREATE USER camunda WITH PASSWORD 'camunda00';
          CREATE USER keycloak WITH PASSWORD 'keycloak00';
          CREATE DATABASE camunda WITH OWNER camunda;
          CREATE DATABASE keycloak WITH OWNER keycloak;
        EOSQL
        EOF
        destination = "local/init-db.sh"
      }      

      resources {
        cpu    = 1000
        memory = 1000
      }

      service {
        name = "postgres"
        port = "db"
        check {
          name     = "tcp"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }

      volume_mount {
        volume      = "postgres_data"
        destination = "/var/lib/postgresql/data"
      }
    }

    volume "postgres_data" {
      type      = "host"
      read_only = false
      source    = "pgdata"
    }
  }
}
