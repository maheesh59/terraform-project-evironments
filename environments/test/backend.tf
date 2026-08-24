terraform {
  backend "s3" {
    bucket       = "global-tfstate-463200133372"
    key          = "environments/test/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
    encrypt      = true
  }
}
