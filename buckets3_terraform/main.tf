terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = "us-west-1"
}

resource "aws_s3_bucket" "bucket_example" {
  bucket = "bucket-example-${terraform.workspace}-12345"
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.bucket_example.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "acl_example" {
  depends_on = [aws_s3_bucket_ownership_controls.example]

  bucket = aws_s3_bucket.bucket_example.id
  acl    = "private"
}

resource "aws_s3_object" "object" {
  for_each = fileset("uploads/", "*")
  bucket   = aws_s3_bucket.bucket_example.id
  key      = each.value
  source   = "uploads/${each.value}"
  etag     = filemd5("uploads/${each.value}")
}
