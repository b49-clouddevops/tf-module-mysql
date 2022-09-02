# Creating RDS Instance, a managed service for sequel db
resource "aws_db_instance" "mysql" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "dummy"
  username             = "admin1"
  password             = "RoboShop1"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}



# # Creating Elasticcache : A Managed service for Redis
# resource "aws_elasticache_cluster" "redis" {
#   cluster_id           = "roboshop-${var.ENV}"
#   engine               = "redis"
#   node_type            = "cache.t3.small"
#   num_cache_nodes      = 1
#   parameter_group_name = aws_elasticache_parameter_group.default.name
#   engine_version       = "6.x"
#   port                 = 6379
#   subnet_group_name    = aws_elasticache_subnet_group.subnet-group.name
#   security_group_ids   = [aws_security_group.allow_redis.id]
# }


# # Creating the patameter group
# resource "aws_elasticache_parameter_group" "default" {
#   name   = "roboshop-${var.ENV}"
#   family = "redis6.x"
# }

# # Creating Subnet Grouo 
# resource "aws_elasticache_subnet_group" "subnet-group" {
#   name       = "roboshop-${var.ENV}"
#   subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS

#   tags = {
#     Name = "roboshop-${var.ENV}"
#   }
# }


# SG for redis
resource "aws_security_group" "allow_redis" {
  name        = "roboshop-redisb-${var.ENV}"
  description = "roboshop-redis-${var.ENV}"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress {
    description = "TLS from VPC"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.VPC_CIDR]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "roboshop-mongodb-${var.ENV}"
  }
}