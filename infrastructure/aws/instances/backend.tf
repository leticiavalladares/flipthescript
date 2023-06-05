terraform {
  backend "s3" {
    bucket         = "tfstate-bucket-27042023"
    key            = "db-flask-app/terraform.tfstate"
    dynamodb_table = "dynamodb-lock"
  }
}