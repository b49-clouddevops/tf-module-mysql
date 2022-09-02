# Creating RDS Instance, a managed service for sequel db
resource "aws_db_instance" "mysql" {
  identifier           = "roboshop-${var.ENV}"  
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "dummy"
  username             = "admin1"
  password             = "RoboShop1"
  parameter_group_name = aws_db_parameter_group.mysql.name
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.mysql.name 
  vpc_security_group_ids = [aws_security_group.allow_mysql.id]

}


# # Creating the patameter group
resource "aws_db_parameter_group" "mysql" {
  name   = "roboshop-${var.ENV}"
  family = "mysql5.7"
}

# Creating Subnet Grou
resource "aws_db_subnet_group" "mysql" {
  name       = "mysql"
  subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS
  tags = {
    Name = "roboshop-${var.ENV}"
  }
}

# SG for MySQL
resource "aws_security_group" "allow_mysqldb" {
  name        = "roboshop-mysqldb-${var.ENV}"
  description = "roboshop-mysqldb-${var.ENV}"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress {
    description = "TLS from VPC"
    from_port   = 3306
    to_port     = 3306
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
    Name = "roboshop-mysqldb-${var.ENV}"
  }
}

