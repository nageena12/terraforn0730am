resource "aws_db_instance" "name" {
  allocated_storage = 10
  identifier = "book-rds"  #instance name
  db_name = "mydb" #database name
  engine = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"
  username = data.aws_secretsmanager_secret_version.rds_secret_version.secret_string["username"]  #database username
  password =  data.aws_secretsmanager_secret_version.rds_secret_version.secret_string["password"] #database password
  db_subnet_group_name = aws_db_subnet_group.sub-grp.id 
  parameter_group_name = "default.mysql8.0"
  provider = aws.primary
  #enable backup rotation, in rds max retention period is 35days minimum 7 days, if u want more than 35 days backup 
  #use snapshots
  backup_retention_period = 7
  backup_window = "02:00-03:00" #daily backup window (UTC), if we not specify backup time it will take anytime
  
  #enabe monitoring (cloudwatch enhanced monitoring)
  #monitoring_interval = 60  #collect metrics every 60 secs
  #monitoring_role_arn = aws_iam_role.rds_monitoring.arn #while creating rds defaultly one IAM role will be created

  #maintenance window, maintenance and backup window times should not overlap
  maintenance_window = "sun:04:00-sun:05:00" #maintain every sun(UTC)

  #enable deletion protection , to prevent accidental deletion
  deletion_protection = true #if we try to delete RDS it will not allow us to delete untill we make it as false

  #skip final snapshot
  skip_final_snapshot = true #while deleting rds instance automatically one snapshot will be created. 
  #-here,true means it wont take snapshot while deleting rds instance.if i dont mention it will take defaultly snapshot. 
  depends_on = [ aws_db_subnet_group.sub-grp ]
  
  #vpc
}
resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "rds-vpc"
  }
  
}

#subnet-1
resource "aws_subnet" "subnet-1" {
  vpc_id = aws_vpc.name.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "sub-1"
  }
  
}

#subnet-2
resource "aws_subnet" "subnet-2" {
  vpc_id = aws_vpc.name.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "sub-2"
  }
  
}

#db subnetgroup
resource "aws_db_subnet_group" "sub-grp" {
  name = "mysubnetgroup"  #subnetgroup name
  subnet_ids = [aws_subnet.subnet-1.id,aws_subnet.subnet-2.id]
  #provider = aws.primary
  tags = {
    Name = "mydbsubnetgroup"
  }

}





#secret manager
resource "aws_secretsmanager_secret" "rds_secret" {
  name = "book-rds-secret"
  description = "RDS credentials for books-rds instance"
    
}

#secretmanager version
resource "aws_secretsmanager_secret_version" "rds_secret_version" {
  secret_id = aws_secretsmanager_secret.rds_secret.id 
  secret_string = jsondecode(
    {
      engine = "mysql"
      host = aws_db_instance.default.address
      username = "admin"
      password = "ashree253"
      db_name = "mydb"
      port = 3306
    }
  )
  depends_on = [ aws_db_instance.default ]
  
}
  


