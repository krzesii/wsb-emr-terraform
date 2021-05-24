variable "environment_name" {
    description = "The name of the environment"
}

variable "vpc_id" {
  description = "The ID of the VPC that the RDS cluster will be created in"
}

variable "vpc_name" {
  description = "The name of the VPC that the RDS cluster will be created in"
}

variable "vpc_rds_subnet_ids" {
  description = "The ID's of the VPC subnets that the RDS cluster instances will be created in"
}

variable "vpc_rds_security_group_id" {
    description = "The ID of the security group that should be used for the RDS cluster instances"
}

variable "rds_master_username" {
  description = "The ID's of the VPC subnets that the RDS cluster instances will be created in"
}

variable "rds_master_password" {
  description = "The ID's of the VPC subnets that the RDS cluster instances will be created in"
}

variable "aws_region" {
  default = "eu-central-1"
}

variable "local-python" {
  default = "python"
}

variable "albums" {
  type    = list(string)
  default = ["krzesi"]
}

variable "master_sg" {
   description = "EMR master security group"
   default = "test_master_sg"
}

variable "worker_sg" {
   description = "EMR worker security group"
   default = "test_worker_sg"
}

variable "service_access_sg" {
  description = "EMR service security group"
  default = "test_service_sg"
}

variable "emr_app_file" {
  description = "EMR app S3 key"
  default = "helloworld.py"
}

variable "emr_app_file_source" {
  description = "EMR app local name"
  default = "../helloworld.py"
}

variable "bootstrap_script_s3_object" {
  description = "EMR config script S3 key"
  default = "config.sh"
}

variable "bootstrap_script_s3_object_source" {
  description = "EMR config script local name"
  default = "../config.sh"
}