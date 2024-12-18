resource "aws_ecr_repository" "fe_repository" {
  name                 = "frontend-repository-images"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "be_repository" {
  name                 = "backend-repository-images"
  image_tag_mutability = "MUTABLE"

}

