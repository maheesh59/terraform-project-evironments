terraform {
  backend "s3" {
    bucket       = "global-tfstate-390034075362"
    key          = "environments/test/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
    encrypt      = true
  }
}
