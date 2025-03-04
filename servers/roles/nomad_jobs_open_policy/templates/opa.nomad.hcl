job "opa" {
  datacenters = ["dc1"]

  constraint {
    attribute = "${meta.role}"
    value     = "{{ constraint }}"
  }

  group "apps" {
    count = 1
    
    network {
      mode = "bridge"
      
      port "opa" {
        static = 8181
        to     = 8181
      }
    }

    task "opa-server" {
      driver = "docker"

      config {
        image = "openpolicyagent/opa:0.49.2-static"
        args  = ["run", "--server", "/etc/rules/wks_policy_rules.rego"]
        ports = ["opa"]
      }

      resources {
        cpu    = 500
        memory = 256
      }

      volume_mount {
        volume      = "opa_storage"
        destination = "/etc/rules"
      }

      service {
        name = "opa"
        provider = "consul"
        port = "opa"
        check {
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }

    volume "opa_storage" {
      type      = "host"
      read_only = false
      source    = "data_storage"
    }

  }
}
