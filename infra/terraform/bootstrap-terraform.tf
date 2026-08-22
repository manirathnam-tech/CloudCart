provider "aws" {
    region = var.aws_region
}

variable "aws_region" {
    description = "The AWS region to deploy resources in"
    type        = string
    default     = "eu-west-1"
}

variable "bucket_name" {
    description = "The name of the S3 bucket to create"
    type        = string
    default     = "my-terraform-state-bucket-mani1311"
}

variable "dynamodb_table_name" {
    description = "The name of the DynamoDB table to create for state locking"
    type        = string
    default     = "my-terraform-state-lock-table-mani1311"
}

# Create an S3 bucket for storing Terraform state
resource "aws_s3_bucket" "terraform_state" {
    bucket = var.bucket_name
    force_destroy = false # Prevent accidental deletion of the bucket

    tags = {
        Name        = "Terraform State Bucket"
        Environment = "Bootstrap"
    }
}

# Enable versioning on the S3 bucket
resource "aws_s3_bucket_versioning" "terraform_state_versioning" { 
    bucket = aws_s3_bucket.terraform_state.id

    versioning_configuration {
        status = "Enabled"
    }
}

# Enable server-side encryption on the S3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
    bucket = aws_s3_bucket.terraform_state.id

    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}

# Block public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "terraform_state_public_access_block" {
    bucket = aws_s3_bucket.terraform_state.id

    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}

# Create a DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_state_lock" {
    name         = var.dynamodb_table_name
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }

    tags = {
        Name        = "Terraform State Lock Table"
        Environment = "Bootstrap"
    }
}

# Output the S3 bucket name and DynamoDB table name
output "s3_bucket_name" {
    value       = aws_s3_bucket.terraform_state.bucket
    description = "The name of the S3 bucket for Terraform state"
}

output "dynamodb_table_name" {
    value       = aws_dynamodb_table.terraform_state_lock.name
    description = "The name of the DynamoDB table for Terraform state locking"
}

output "aws_region" {
    value       = var.aws_region
    description = "The AWS region where resources are deployed"
}
