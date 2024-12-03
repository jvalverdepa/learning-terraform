terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  //ami = "" // NO ES ELEGANTE!
  instance_type = "t2.micro"
  key_name = "utec"

  tags = {
    Name = "web-server-demo-dev"
  }
}

resource "aws_ec2_instance_state" "web" {
  instance_id = aws_instance.web.id
  state       = "stopped"
}

output "public_ip" {
  value       = aws_instance.web.public_ip
}
