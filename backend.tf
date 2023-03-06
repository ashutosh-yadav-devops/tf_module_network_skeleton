terraform {
  backend "s3" {
    bucket = "snaatak-avengers-terraform-state-locking"
    key    = "test/s3/dev_apps_attendance_terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-state-locking" 
    encrypt = true
  }
}
