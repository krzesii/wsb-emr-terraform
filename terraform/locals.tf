locals {
    tags  = {
        Name         = "emr-sample-app-${var.aws_region}-${var.environment_name}"
        ManagedBy    = "terraform"
        Environment  = "${var.environment_name}"
    }

  project_name = "emr-sample-app-${var.aws_region}-${var.environment_name}"

  emrjarlocation = "s3://${aws_s3_bucket_object.config-script.bucket}/${aws_s3_bucket_object.config-script.key}"
  emrbootscriptlocation = "s3://${aws_s3_bucket_object.config-script.bucket}/${aws_s3_bucket_object.config-script.key}"
  emrlogslocation = "s3://${aws_s3_bucket_object.config-script.bucket}/logs"
}


