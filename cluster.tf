# Creating RDS Instance, a managed service for sequel db
resource "aws_db_instance" "mysql" {
  identifier           = "roboshop-mysql-${var.ENV}"  
  allocated_storage    = var.RDS_MYSQL_CAPACITY
  engine               = "mysql"
  engine_version       =  var.RDS_ENGINE_VERSION
  instance_class       = var.RDS_INDTSNCE_TYPE
  username             = "admin1" MYSQL_USERNAME
  password             = "RoboShop1" MYSQL_USERNAME
  parameter_group_name = aws_db_parameter_group.mysql.name
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.mysql-sb.name 
  vpc_security_group_ids = [aws_security_group.allow_mysql.id]
    
}

# # Creating the patameter group
resource "aws_db_parameter_group" "mysql" {
  name   = "roboshop-mysql-${var.ENV}"
  family = "mysql${var.RDS_ENGINE_VERSION}"
}

# Creating Subnet Grou
resource "aws_db_subnet_group" "mysql-sb" {
  name       = "mysql"
  subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS
  tags = {
    Name = "roboshop-${var.ENV}"
  }
}

# SG for MySQL-Database
resource "aws_security_group" "allow_mysql" {
  name        = "roboshop-mysql-${var.ENV}"
  description = "roboshop-mysql-${var.ENV}"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress {
    description = "TLS from VPC"
    from_port   = var.RDS_MYSQL_PORT
    to_port     = var.RDS_MYSQL_PORT
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.VPC_CIDR, var.WORKSPATION_IP]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "roboshop-mysql-${var.ENV}"
  }
}

