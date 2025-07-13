#vpc creation
resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "test"
    }
  
}
#subnet crestion
resource "aws_subnet" "name" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.0.0/24"
    tags = {
      Name = "test-subnet"
    }
  
}
#IG
resource "aws_internet_gateway" "name" {
    vpc_id = aws_vpc.name.id
    tags = {
      Name = "test-IG"
    }
  
}
#Route Table

#subnet associations
resource "aws_route_table_association" "name" {
    subnet_id = aws_subnet.name.id
    route_table_id = aws_route_table.name.id
  
}
#sg group
resource "aws_route_table" "name" {
  vpc_id = aws_vpc.name.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.name.id
  }
}
resource "aws_security_group" "test-sg" {
    name = "test-sg"
    vpc_id = aws_vpc.name.id
    tags = {
        Name = "test-SG"
    }
 ingress  {
     description = "TLS from vpc"
     from_port = 80
     to_port = 80
     protocol = "TCP"
     cidr_blocks = ["0.0.0.0/0"]
    }
 ingress  {
     description = "TLS from vpc"
     from_port = 22
     to_port = 22
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
 egress  {
        from_port = 0
        to_port = 0
        protocol = "-1" #for all protocals
        cidr_blocks = ["0.0.0.0/0"]
        
    }
    

  
}
#ec2-instance
resource "aws_instance" "name" {
  ami = "ami-05ffe3c48a9991133"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.name.id
  vpc_security_group_ids =  [aws_security_group.test-sg.id]
}