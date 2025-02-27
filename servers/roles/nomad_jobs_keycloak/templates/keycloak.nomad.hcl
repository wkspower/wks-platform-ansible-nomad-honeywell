job "keycloak" {
  datacenters = ["dc1"]

  constraint {
    attribute = "${meta.role}"
    value     = "{{ constraint }}"
  }

  group "apps" {
    count = 1
    
    network {
      mode = "bridge"
      
      port "http" {
        static = 8080
        to     = 8080 
      }

      port "https" {
        static = 8443
        to     = 8443
      }
    }

    task "keycloak" {
      driver = "docker"

      config {
        image = "quay.io/keycloak/keycloak:20.0.3"
        ports = ["http", "https"]
        args  = ["start", "-b", "--http-host=0.0.0.0", "--http-port=8080", "--https-port=8443"]
      }

      env {
        KEYCLOAK_ADMIN                = "{{ keycloak_user }}"
        KEYCLOAK_ADMIN_PASSWORD       = "{{ keycloak_password }}"
        KC_PROXY                      = "edge"
        KC_LOG_LEVEL                  = "INFO"
        KC_HEALTH_ENABLED             = "true"
        KC_METRICS_ENABLED            = "true"
        KC_HOSTNAME                   = "login.{{ dns_name }}"
        KC_HOSTNAME_ADMIN             = "iam.{{ dns_name }}"
        KC_HTTPS_CERTIFICATE_KEY_FILE = "/certs/server.key"
        KC_HTTPS_CERTIFICATE_FILE     = "/certs/server.crt"
        KC_DB                         = "postgres"
        KC_DB_URL                     = "jdbc:postgresql://postgres.service.consul:5432/keycloak"
        KC_DB_USERNAME                = "keycloak"
        KC_DB_PASSWORD                = "keycloak00"
      }

      resources {
        cpu    = 500
        memory = 2024
      }

      volume_mount {
        volume      = "kc_storage"
        destination = "/certs"
      }

      service {
        name = "keycloak"
        port = "https"
      }
    }

    volume "kc_storage" {
      type      = "host"
      read_only = true
      source    = "data_storage"
    } 
  }
}
