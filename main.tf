// This is a lab which has authenticated group as acl that means people who have aws account can view the bucket using CLI


variable "aws_region" {
  default = "us-west-2"
}
provider "aws" {
  region = var.aws_region
}
resource "random_string" "bucket_name" {
 length  = 10
 special = false
 upper   = false
}

resource "random_string" "random_name" {
 length  = 10
 special = false
 upper   = false
}
// current user

data "aws_canonical_user_id" "current" {}

// create s3 bucket

resource "aws_s3_bucket" "public_bucket" {
  bucket = "misconfiguredacl-${random_string.bucket_name.result}"
  force_destroy = true
}

//object 
resource "aws_s3_object" "conf_file" {
  bucket = aws_s3_bucket.public_bucket.bucket
  key = "confidential.txt"
  source = "confidential.txt"
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.public_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

// bucket ownership 
resource "aws_s3_bucket_ownership_controls" "owner_example" {
  bucket = aws_s3_bucket.public_bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

//bucket acl 

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.owner_example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.public_bucket.id
  acl    = "private"
}

//Authenticated group 

resource "aws_s3_bucket_acl" "auth_read_bucket_access_control_list" {
  depends_on = [aws_s3_bucket_ownership_controls.owner_example , aws_s3_bucket_public_access_block.example]

  bucket = aws_s3_bucket.public_bucket.id
  access_control_policy {

    grant {
      grantee {
        type = "CanonicalUser"
        id   = data.aws_canonical_user_id.current.id
      }
      permission = "FULL_CONTROL"
    }
    grant {
      grantee {
        type = "Group"
        uri  = "http://acs.amazonaws.com/groups/global/AuthenticatedUsers"
      }
      permission = "WRITE"
    }

    owner {
      id = data.aws_canonical_user_id.current.id
    }
  }
}

output name {
  value       = aws_s3_bucket.public_bucket.bucket
}

