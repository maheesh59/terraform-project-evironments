terraform {
  backend "s3" {
    bucket       = "global-tfstate-010160406667"
    key          = "environments/prod/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
    encrypt      = true
  }
}
