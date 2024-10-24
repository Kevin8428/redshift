terraform {
  backend "s3" {
    bucket = "redshift-ew342xj" # GUID - change if exists
    key    = "tf"
    region = "us-west-2"
  }
}
