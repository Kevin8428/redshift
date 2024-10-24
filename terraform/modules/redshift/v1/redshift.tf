resource "aws_redshift_cluster" "default" {
  count              = var.enabled ? 1 : 0
  cluster_identifier = var.cluster_name
  database_name      = var.cluster_name
  master_username    = var.master_username
  master_password    = var.master_password
  node_type          = var.node_type
  cluster_type       = var.cluster_type
  tags               = var.tags
}

# need datasharing enabled to do this - might need ra3 instance types first
# resource "aws_redshiftdata_statement" "s" {
#   count              = var.enabled ? 1 : 0
#   cluster_identifier = aws_redshift_cluster.default[count.index].cluster_identifier
#   database           = aws_redshift_cluster.default[count.index].database_name
#   db_user            = aws_redshift_cluster.default[count.index].master_username
#   sql                = "COPY dev.public.tickdata FROM 's3://redshift-e3j5sx/2024/10/' IAM_ROLE 'arn:aws:iam::830370670734:role/service-role/AmazonRedshift-CommandsAccessRole-20241024T114820' FORMAT AS CSV DELIMITER ',' QUOTE '\"' REGION AS 'us-west-2'"
# }

# TODO: place cluster on vpc subnet w/ security groups and az
# TODO: create redshift subnet group
# TODO: create parameter group - parameters that apply to all of the databases that you create in the cluster
# configures db settings like timeouts, date formatting
