data "aws_secretsmanager_secret" "rds" {
  name = "rds-credentials"
}

data "aws_secretsmanager_secret_version" "rds" {
  secret_id = data.aws_secretsmanager_secret.rds.id
}


resource "aws_db_instance" "db_instance" {
  identifier     = "internship-graduation-db"
  engine         = "mysql"
  engine_version = "8.0.39"
  db_name        = "fcjresbar"
  instance_class = "db.t3.medium"
  username       = jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)["username"]
  password       = jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)["password"]

  storage_encrypted = true

  multi_az                  = true
  publicly_accessible       = false
  allocated_storage         = 20
  engine_lifecycle_support  = "open-source-rds-extended-support-disabled"
  vpc_security_group_ids    = var.security_group_ids
  db_subnet_group_name      = var.subnet_group_name
  final_snapshot_identifier = true
  skip_final_snapshot       = true


}

