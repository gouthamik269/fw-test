resource "aws_s3_bucket" "fw-test" {
  bucket = var.bucket_name

  tags = {
    Name = var.bucket_name
  }
}

resource "aws_s3_bucket_public_access_block" "fw-test-bucket-access-block" {
  bucket = aws_s3_bucket.fw-test.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}



resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.route_table_ids

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Principal": "*",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "$aws_s3_bucket.fw-test.arn",
        "${aws_s3_bucket.fw-test.arn}/*"
      ]
    }
  ]
}
POLICY

  tags = {
    Name = "ec2-vpc-s3-endpoint"
  }
}