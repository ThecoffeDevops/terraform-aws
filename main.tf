terraform {
  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-1"
  profile = "emanuel"
}

resource "aws_instance" "app_server" {
  ami           = "ami-02f3f602d23f1659d"
  instance_type = "t2.micro"

  tags = {
    Name = "first_instance_as_code"
  }
}
