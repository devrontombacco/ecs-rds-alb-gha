terraform {
  backend "s3" {
    bucket       = "devron-project9-tfstate-677276118863"
    key          = "project9/terraform.tfstate"
    region       = "eu-west-1"
    encrypt      = true
    use_lockfile = true
  }
}
