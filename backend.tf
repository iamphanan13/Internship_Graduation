terraform {
  backend "s3" {
    bucket  = "internship-bucket-20241102"
    key     = "terraform.tfstate"
    region  = "ap-southeast-1"
    encrypt = true
  }
}