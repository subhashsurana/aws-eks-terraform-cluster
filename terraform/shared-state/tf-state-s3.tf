resource "aws_s3_bucket" "clusters_tf_state_s3_bucket" {
  bucket        = "${var.clusters_name_prefix}-terraform-state"
  acl           = "private"
  force_destroy = true
  versioning {
    enabled = true
  }
  lifecycle {
    prevent_destroy = false
  }
  tags = {
    Name      = "${var.clusters_name_prefix} S3 Remote Terraform State Store"
    ManagedBy = "terraform"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

}

resource "aws_s3_bucket" "clusters_vpc_tf_state_s3_bucket" {
  bucket        = "${var.clusters_name_prefix}-vpc-terraform-state"
  acl           = "private"
  force_destroy = true
  versioning {
    enabled = true
  }
  lifecycle {
    prevent_destroy = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = {
    Name      = "${var.clusters_name_prefix} VPC S3 Remote Terraform State Store"
    ManagedBy = "terraform"
  }
}