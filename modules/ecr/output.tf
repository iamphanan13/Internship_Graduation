output "ecr_repository_url_fe" {
  value = aws_ecr_repository.fe_repository.repository_url

}

output "ecr_repository_url_be" {
  value = aws_ecr_repository.be_repository.repository_url
}