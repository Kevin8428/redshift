resource "aws_redshift_subnet_group" "default" {
  count       = var.enabled ? 1 : 0
  name        = var.cluster_name
  subnet_ids  = var.subnet_ids
  description = "Allowed subnets for Redshift Subnet group"
  tags        = var.tags
}

resource "aws_redshift_cluster" "default" {
  count              = var.enabled ? 1 : 0
  cluster_identifier = var.cluster_name
  database_name      = var.cluster_name
  master_username    = var.master_username
  master_password    = var.master_password
  node_type          = var.node_type
  cluster_type       = var.cluster_type
  # default_iam_role_arn = "arn:aws:iam::830370670734:role/aws-service-role/redshift.amazonaws.com/AWSServiceRoleForRedshift"
  tags                = var.tags
  skip_final_snapshot = true
  publicly_accessible = true

  vpc_security_group_ids               = var.security_group_ids
  cluster_subnet_group_name            = join("", aws_redshift_subnet_group.default[*].id)
  availability_zone                    = var.availability_zone
  availability_zone_relocation_enabled = false
}
