terraform {
  backend "s3" {
    bucket = "asshulovessree"
    key    = "terraform.tfstate"
    region = "us-east-1"
    object_lock_enabled = true
  }
}