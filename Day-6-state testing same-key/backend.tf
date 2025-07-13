terraform {
  backend "s3" {
    #required_version = ">=1.10" this will allow to work same terraform version only
    bucket = "asshulovessree"
    key    = "Day-1/terraform.tfstate"
    region = "us-east-1"
     use_lockfile = true #supports latest version >=1.10
    #dynamodb_table = "test"
    #encrypt = true
  }
}
