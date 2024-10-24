locals {
  system_id         = "redshift"
  region            = "us-west-2"
  availability_zone = "us-west-2a"
  tags = {
    Env      = "dev"
    SystemId = local.system_id
    Name     = local.system_id
  }
}

module "s3" {
  source      = "./modules/s3/v1"
  bucket_name = local.system_id
  tags        = local.tags
}

module "kinesis_stream" {
  source      = "./modules/kinesis/stream/v1"
  stream_name = local.system_id
  tags        = local.tags
}

module "kinesis_firehose" {
  source         = "./modules/kinesis/firehose/v1"
  firehose_name  = local.system_id
  s3_bucket      = module.s3.bucket
  kinesis_stream = module.kinesis_stream
  tags           = local.tags
}

module "redshift" {
  source          = "./modules/redshift/v1"
  enabled         = false
  cluster_name    = local.system_id
  master_username = "some-user"
  master_password = "password"
  node_type       = "dc2.large"
  cluster_type    = "single-node"
}
