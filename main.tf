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
  region = "us-east-1"
}

/*
terraform {
  required_providers {
    serverscom = {
      source = "serverscom/serverscom"
      version = "0.4.2"
    }
  }
}

provider "serverscom" {
  # Configuration options
}
*/

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

resource "aws_instance" "app_server" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = "jorge-ruizPuTTY"
  user_data = <<-EOF
                 #!/bin/bash
                    cd /home/ubuntu
                    echo "<h1>SITE COM TERRAFORM</h1>" > index.html
                    echo "<h1>SITE COM TERRAFORM</h1>" > index1.html
                    echo "<h1>SITE COM TERRAFORM</h1>" > index2.html
                    nohup busybox httpd -f -p 8080 &
                 EOF
  tags = {
    Name = "Terrafor AWS"
  }
}