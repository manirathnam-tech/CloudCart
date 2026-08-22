terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-mani1311"
    key            = "global/s3/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "my-terraform-state-lock-table-mani1311"
    encrypt        = true
  }
}
