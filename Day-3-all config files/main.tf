resource "aws_instance" "name" {
    ami = var.ami_id
    instance_type = var.instance_type
    tags = {
        name = "day-3"

    }
  
}
resource "aws_instance" "day-4" {
    ami = var.ami_id
    instance_type = var.instance_type
    tags = {
        name = "day-5"

    }
  
}