# resource "aws_directory_service" "cloud_map_service" {
#   name = "testresbar.internal"
#   description = "Use for internal API Calls and DNS"

# }

resource "aws_service_discovery_private_dns_namespace" "private_dns_namespace" {
  name        = "testresbar.internal"
  description = "Use for internal API Calls and DNS"
  vpc         = var.vpc_id
}

resource "aws_service_discovery_service" "service" {
  name         = "backend"
  namespace_id = aws_service_discovery_private_dns_namespace.private_dns_namespace.id

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.private_dns_namespace.id
    dns_records {
      ttl  = 300
      type = "A"
    }

    routing_policy = "WEIGHTED"

  }
}
