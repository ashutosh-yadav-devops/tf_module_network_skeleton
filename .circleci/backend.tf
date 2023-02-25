terraform {
  backend "s3" {
    bucket         = "ot-avengers-terraform-state-locking"
    key            = "test/circleci/network_skeleton/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }
}