resource "aws_rds_cluster" "aurora_cluster" {
    for_each = toset( var.albums )
    cluster_identifier            = "wsb-${each.key}-${var.environment_name}aurora-cluster"
    database_name                 = "mydb"
    master_username               = "${var.rds_master_username}"
    master_password               = "${var.rds_master_password}"
    backup_retention_period       = 14
    preferred_backup_window       = "02:00-03:00"
    preferred_maintenance_window  = "wed:03:00-wed:04:00"
    db_subnet_group_name          = "${aws_db_subnet_group.aurora_subnet_group.name}"
    final_snapshot_identifier     = "${var.environment_name}-aurora-cluster"
    vpc_security_group_ids        = [
        "${var.vpc_rds_security_group_id}"
    ]

    tags  = {
        Name         = "${each.key}-${var.environment_name}-Aurora-DB-Cluster"
        VPC          = "${var.vpc_name}"
        ManagedBy    = "terraform"
        Environment  = "${var.environment_name}"
    }

    lifecycle {
        create_before_destroy = true
    }

}

resource "aws_rds_cluster_instance" "aurora_cluster_instance" {
    for_each = toset( var.albums )
    
    identifier            = "${var.environment_name}-aurora-instance${each.key}"
    cluster_identifier    = "${aws_rds_cluster.aurora_cluster[each.key].id}"
    instance_class        = "db.t2.small"
    db_subnet_group_name  = "${aws_db_subnet_group.aurora_subnet_group.name}"
    publicly_accessible   = true

    tags = {
        Name         = "${var.environment_name}-Aurora-DB-Instance-${each.key}"
        VPC          = "${var.vpc_name}"
        ManagedBy    = "terraform"
        Environment  = "${var.environment_name}"
    }

    lifecycle {
        create_before_destroy = true
    }

}

resource "aws_db_subnet_group" "aurora_subnet_group" {

    name          = "${var.environment_name}_aurora_db_subnet_group"
    description   = "Allowed subnets for Aurora DB cluster instances"
    subnet_ids    = var.vpc_rds_subnet_ids

    tags = {
        Name         = "${var.environment_name}-Aurora-DB-Subnet-Group"
        VPC          = "${var.vpc_name}"
        ManagedBy    = "terraform"
        Environment  = "${var.environment_name}"
    }

}
/**
resource "null_resource" "db_setup" {

  # runs after database and security group providing external access is created
  depends_on = [aws_rds_cluster.aurora_cluster, aws_db_subnet_group.aurora_subnet_group, aws_rds_cluster_instance.aurora_cluster_instance]

    provisioner "local-exec" {
        command = "${var.local-python} ../createdb.py ${aws_rds_cluster.aurora_cluster.endpoint} ${var.rds_master_username} ${var.rds_master_password} ../db.sql"
    }
}
**/