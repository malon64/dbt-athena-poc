resource "aws_service_discovery_private_dns_namespace" "ecs_dagster" {
  name        = "main-cluster.local"
  description = "Private DNS namespace for Dagster"
  vpc         = aws_vpc.main.id
}

resource "aws_service_discovery_service" "dagster_webserver_service" {
  name = "dagster-webserver"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.ecs_dagster.id

    dns_records {
      ttl  = 10
      type = "A"
    }
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_service_discovery_service" "dagster_daemon_service" {
  name = "dagster-daemon"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.ecs_dagster.id

    dns_records {
      ttl  = 10
      type = "A"
    }
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_service_discovery_service" "dagster_usercode_service" {
  name = "dagster-usercode"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.ecs_dagster.id

    dns_records {
      ttl  = 10
      type = "A"
    }
    dns_records {
      ttl  = 10
      type = "AAAA"
    }
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}
