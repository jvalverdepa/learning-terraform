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

resource "aws_s3_bucket" "bucket_demo" {
  bucket = "bucket_demo"
  acl    = "private"
}

resource "aws_s3_bucket_object" "object1" {
  for_each = fileset("uploads/", "*")
  bucket   = aws_s3_bucket.bucket_demo.id
  key      = each.value
  source   = "uploads/${each.value}"
  etag     = filemd5("uploads/${each.value}")
}
