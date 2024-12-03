# resource "aws_secretsmanager_secret" "rds_password" {
#   name = "rds_password"
#   description = "RDS password for my application"
# }

# resource "aws_secretsmanager_secret_version" "rds_password_version" {
#   secret_id = aws_secretsmanager_secret.rds_password.id
#   secret_string = jsonencode({
#     username = root
#     password = "123456789"
#   })
# }

resource "aws_kms_key" "db_kms_key" {
  description = "KMS key for encrypting RDS"
}


resource "aws_db_instance" "db_instance" {
  identifier     = "internship-graduation-db"
  engine         = "mysql"
  engine_version = "8.0.39"
  db_name        = "internship_graduation_db"
  instance_class = "db.t3.micro"
  username       = "root"
  password       = "123456789"
  # manage_master_user_password   = true
  # master_user_secret_kms_key_id = aws_kms_key.db_kms_key.key_id
  multi_az                  = true
  publicly_accessible       = false
  allocated_storage         = 20
  engine_lifecycle_support  = "open-source-rds-extended-support-disabled"
  vpc_security_group_ids    = var.security_group_ids
  db_subnet_group_name      = var.subnet_group_name
  final_snapshot_identifier = false


}

