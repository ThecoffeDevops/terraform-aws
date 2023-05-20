resource "aws_instance" "public" {
  ami                     = "ami-06a0cd9728546d178"
  instance_type           = "t2.micro"
  vpc_security_group_ids  = [aws_security_group.public_security.id]
  subnet_id               = aws_subnet.public[0].id
  key_name                = "MyNovemberkey"

  tags  = {
   Name = "${var.environment}-public"

  }
}

resource "aws_security_group" "public_security" {
    name          = "public_security_group"
    description   = "ec2 security group for public subnets"
    vpc_id        = aws_vpc.main.id

ingress{
    description   = "ssh from public"
    from_port     = 22
    to_port       = 22
    protocol      = "tcp"
    cidr_blocks   = ["107.13.183.202/32"]

 }
egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    
 }
tags  = {
   Name = "${var.environment}-public"

  }
}

















