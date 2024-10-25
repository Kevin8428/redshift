locals {
  system_id         = "redshift"
  s3_bucket         = "${local.system_id}-e3j5sx" # GUID - change if exists
  region            = "us-west-2"
  availability_zone = "us-west-2a"
  cidr_block        = "10.0.0.0/16"
  tags = {
    Env      = "dev"
    SystemId = local.system_id
    Name     = local.system_id
  }
}

# use to define schema for converting csv to parquet in firehose
# module "glue" {
#   source  = "./modules/glue/v1"
#   db_name = local.system_id
#   tags    = local.tags
# }

module "vpc" {
  source     = "./modules/vpc/v1"
  cidr_block = local.cidr_block
  tags       = local.tags
}

locals {
  vpc = { for k, v in module.vpc.vpc : k => v if !contains(["tags_all", "tags"], k) }
}

module "gateway" {
  source = "./modules/gateway/v1"
  vpc    = local.vpc
  tags   = local.tags
}

# module.public_subnet_1.nat_gateway_id

module "sg_redshift" {
  source = "./modules/security_group/redshift/v1"
  vpc    = local.vpc
}

module "sg_lambda" {
  source = "./modules/security_group/lambda/v1"
  vpc    = local.vpc
}

module "subnet_1" {
  source            = "./modules/subnets/public/v1"
  availability_zone = local.availability_zone
  cidr_block        = cidrsubnet(module.vpc.vpc.cidr_block, 4, 1)
  ipv6_cidr_block   = cidrsubnet(module.vpc.vpc.ipv6_cidr_block, 8, 1)
  internet_gateway  = module.gateway.internet_gateway
  vpc               = local.vpc
  tags              = local.tags
}

module "lambda" {
  source            = "./modules/lambda/v1"
  lambda_name       = local.system_id
  bucket_name       = local.s3_bucket
  subnet_id         = module.subnet_1.subnet_id
  security_group_id = module.sg_lambda.security_group.id
  tags              = local.tags
}

module "s3" {
  source      = "./modules/s3/v1"
  bucket_name = local.s3_bucket
  lambda_arn  = module.lambda.function.arn
  tags        = local.tags
}


module "kinesis_stream" {
  source      = "./modules/kinesis/stream/v1"
  stream_name = local.system_id
  tags        = local.tags
}

module "kinesis_firehose" {
  source = "./modules/kinesis/firehose/v1"
  # glue_catalog_table = module.glue.table
  firehose_name  = local.system_id
  s3_bucket_arn  = module.s3.bucket.arn
  kinesis_stream = module.kinesis_stream.aws_kinesis_stream
  tags           = local.tags
}

module "redshift" {
  source             = "./modules/redshift/v1"
  enabled            = true
  cluster_name       = local.system_id
  subnet_ids         = [module.subnet_1.subnet_id]
  # security_group_ids = [module.sg_lambda.security_group.id]
  security_group_ids = [module.sg_redshift.security_group.id]
  availability_zone  = local.availability_zone
  master_username    = "someone"
  master_password    = "Password1"
  node_type          = "dc2.large"
  cluster_type       = "single-node"
  tags               = local.tags
}
