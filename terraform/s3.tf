resource "aws_s3_bucket" "emr" {
  bucket        = "${local.project_name}.ehub-file.emr"
  force_destroy = true

  lifecycle {
    create_before_destroy = true
  }

  tags = local.tags
}

resource "aws_s3_bucket_object" "emr-app" {
  depends_on = [aws_s3_bucket.emr]
  bucket     = aws_s3_bucket.emr.bucket
  key        = var.emr_app_file
  source     = var.emr_app_file_source
  etag       = filemd5(var.emr_app_file_source)
}


resource "aws_s3_bucket_object" "config-script" {
  depends_on = [aws_s3_bucket.emr]
  bucket     = aws_s3_bucket.emr.bucket
  key        = var.bootstrap_script_s3_object
  source     = var.bootstrap_script_s3_object_source
  etag       = filemd5(var.bootstrap_script_s3_object_source)
}

