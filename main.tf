resource "aws_db_subnet_group" "aurora_subnet_group" {
  name       = "aurora-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "aurora-subnet-group"
  }
  lifecycle {
    ignore_changes = [ tags ]
  }
}

resource "aws_rds_cluster" "aurora" {
  for_each = { for aurora in var.aurora_details : aurora.cluster_identifier => aurora }

  cluster_identifier       = each.value.cluster_identifier
  engine                   = each.value.engine
  engine_version           = each.value.engine_version
  availability_zones       = var.availability_zones
  database_name            = each.value.database_name
  master_username          = each.value.master_username
  master_password          = each.value.master_password
  backup_retention_period  = each.value.backup_retention_period
  preferred_backup_window  = each.value.preferred_backup_window
  final_snapshot_identifier = each.value.final_snapshot_identifier
  skip_final_snapshot      = each.value.skip_final_snapshot
  db_subnet_group_name     = aws_db_subnet_group.aurora_subnet_group.name
  vpc_security_group_ids   = var.vpc_security_group_ids

  tags = {
    Environment = var.environment
    Name        = each.value.cluster_identifier
  }
  lifecycle {
    ignore_changes = [ tags ]
  }
}

resource "aws_rds_cluster_instance" "aurora_instances" {
  for_each = { for aurora in var.aurora_details : aurora.cluster_identifier => aurora }

  identifier            = "${each.value.cluster_identifier}-instance-1"
  cluster_identifier    = aws_rds_cluster.aurora[each.key].id
  instance_class        = each.value.instance_class
  engine                = each.value.engine
  publicly_accessible   = var.publicly_accessible
  db_subnet_group_name  = aws_db_subnet_group.aurora_subnet_group.name
  lifecycle {
    ignore_changes = [ tags ]
  }
}
