resource "aws_security_group" "rds_security_group" {
  name        = "rds-sg"
  description = "Allow access to RDS from EC2 instances"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.public_subnet.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "my_database" {
  allocated_storage    = 20
  storage_type         = "gp2"
  db_instance_class    = "db.t2.micro"
  engine               = "mysql"
  engine_version       = "8.0"
  name                 = "mydb"
  username             = "admin"
  password             = "adminpassword"
  db_subnet_group_name = aws_db_subnet_group.database_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
  multi_az             = false
  publicly_accessible  = false
}

resource "aws_db_subnet_group" "database_subnet_group" {
  name       = "database-subnet-group"
  subnet_ids = [aws_subnet.private_subnet.id]

  tags = {
    Name = "DatabaseSubnetGroup"
  }
}
