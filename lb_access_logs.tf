data "aws_elb_service_account" "main" {}

resource "aws_s3_bucket" "lb_access_logs" {
  count         = var.create_lb ? 1 : 0
  bucket        = var.lb_access_logs_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_acl" "example_bucket_acl" {
  count  = var.create_lb ? 1 : 0
  bucket = aws_s3_bucket.lb_access_logs[0].id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "this" {
  count  = var.create_lb ? 1 : 0
  bucket = aws_s3_bucket.lb_access_logs[0].id
  policy = data.aws_iam_policy_document.s3_bucket_lb_write[0].json
}

data "aws_iam_policy_document" "s3_bucket_lb_write" {
  count     = var.create_lb ? 1 : 0
  policy_id = "s3_bucket_lb_logs"

  statement {
    actions = [
      "s3:PutObject",
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.lb_access_logs[0].arn}/*",
    ]

    principals {
      identifiers = ["${data.aws_elb_service_account.main.arn}"]
      type        = "AWS"
    }
  }

  statement {
    actions = [
      "s3:PutObject"
    ]
    effect    = "Allow"
    resources = ["${aws_s3_bucket.lb_access_logs[0].arn}/*"]
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
  }
  statement {
    actions = [
      "s3:GetBucketAcl"
    ]
    effect    = "Allow"
    resources = ["${aws_s3_bucket.lb_access_logs[0].arn}"]
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
  }
}
