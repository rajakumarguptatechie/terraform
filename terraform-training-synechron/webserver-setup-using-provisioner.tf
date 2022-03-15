/*
Setting up web server using terraform
1. VM should be created
2. Configure VM for web server (provisioners)
a. Creating script to configure wer server locally at terraform folder
b. Copy this script to remote node (provisioner->file)
c. Run that script to configure web server(provisioner->remote-exec)
3. Firewall rules
*/

## Terraform block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}

## Provider block
provider "aws" {
  profile    = "default"
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

## Input variables for access_key and secret_key
variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
}
variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
}

## Local variables for SSH key pair file
locals {
  aws_ssh_user         = "ec2-user"
  aws_ssh_pub_key_file = "/home/ec2-user/.ssh/id_rsa.pub"
  aws_ssh_pri_key_file = "/home/ec2-user/.ssh/id_rsa"
}

## Resource definition: EC2
resource "aws_instance" "test_server" {
  ami                    = "ami-048ff3da02834afdc"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.my-key.key_name
  vpc_security_group_ids = [aws_security_group.my-sg.id]

  tags = {
    Name = "TestServerInstance"
  }
  # Provisioner: File
  provisioner "file" {
    source      = "apache-setup-script.sh"
    destination = "/tmp/apache-setup-script.sh"
    connection {
      type        = "ssh"
      user        = local.aws_ssh_user
      private_key = file(local.aws_ssh_pri_key_file)
      host        = self.public_ip
    }
  }
  # Provisioner: Remote-exec
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = local.aws_ssh_user
      private_key = file(local.aws_ssh_pri_key_file)
      host        = self.public_ip
    }
    inline = [
      "chmod +x /tmp/apache-setup-script.sh",
      "/tmp/apache-setup-script.sh",
    ]
  }
  # Provisioner: Local-exec
  provisioner "local-exec" {
    command = "echo SetUpDone >> web-server-response.txt"
  }
}

## Output variable to capture EC2 Public IP where webserver is running
output "webserver-ip" {
  description = "Capture ec2 instance IP"
  value       = aws_instance.test_server.public_ip
}

## SSH Public key placing on AWS
resource "aws_key_pair" "my-key" {
  key_name   = "my-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDD5cwK17eO1pPdZkoknkFLi1kJ+LB/nTOXguUJ/rIgc18flBfMWPhYC9wVsSPUuelHGQ/aPghlWbVGb+ytbhb4oxXX4qBioiPqjuAD84Xkfa31ams+05CTJbhHGCLTve+gFlvEZ/phc6zDWW6rM76gLbJQh7q2BzVh47hgqFBak+uD0VlDkG3YL6Reeq4kNRCUQcoGAu+lq5ki02wb85W026GM/jHl6Jnt+xeMmvxHCoEOhTC16TO7q5W0sckqwK3vrOJCWMjmrH4sEraew3TQu1qNJ9Lo6RhhtEADZqMnHA0lz2/k8y1ZxEznJiWe6+Nx0VOfDPya7EOxPBC7VrcN"
}

## Security groups with ingress (22,80) and egress (80,443) rules
resource "aws_security_group" "my-sg" {
  name        = "my-custom-sg"
  description = "My Custom Rules"
}
resource "aws_security_group_rule" "ingress-ssh-rule" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  #source_security_group_id = aws_security_group.my-sg.id
  security_group_id = aws_security_group.my-sg.id
}
resource "aws_security_group_rule" "ingress-http-rule" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  #source_security_group_id = aws_security_group.my-sg.id
  security_group_id = aws_security_group.my-sg.id
}
resource "aws_security_group_rule" "egress-http-rule" {
  type        = "egress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  #source_security_group_id = aws_security_group.my-sg.id
  security_group_id = aws_security_group.my-sg.id
}
resource "aws_security_group_rule" "egress-https-rule" {
  type        = "egress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  #source_security_group_id = aws_security_group.my-sg.id
  security_group_id = aws_security_group.my-sg.id
}