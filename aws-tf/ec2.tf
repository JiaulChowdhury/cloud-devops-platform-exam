resource "aws_security_group" "ec2_security_group" {
  name        = "ec2-sg"
  description = "Allow SSH access to EC2 instances"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web_server" {
  ami           = "ami-0e1bed4f06a3b463d"  # Update with the correct AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.ec2_security_group.name]

  tags = {
    Name = "web-server"
  }
}
