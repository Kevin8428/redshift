resource "aws_redshift_cluster" "default" {
  count              = var.enabled ? 1 : 0
  cluster_identifier = var.cluster_name
  database_name      = var.cluster_name
  master_username    = var.master_username
  master_password    = var.master_password
  node_type          = var.node_type
  cluster_type       = var.cluster_type
  tags               = module.this.tags
}

# TODO: place cluster on vpc subnet w/ security groups and az
# TODO: create redshift subnet group
# TODO: create parameter group - parameters that apply to all of the databases that you create in the cluster
# configures db settings like timeouts, date formatting
