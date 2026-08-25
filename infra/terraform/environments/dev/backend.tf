# environments/dev/backend.tf
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-mani1311"
    key            = "env/dev/vpc/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "my-terraform-state-lock-table-mani1311"
    encrypt        = true
  }
}
