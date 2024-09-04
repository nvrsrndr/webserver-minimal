# Specify the AWS provider
provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

# Create a Security Group to allow HTTP and SSH access

resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP and SSH inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an EC2 instance
variable "key_pair_name" {
  description = webserver_minimalis
  type        = string
}

resource "aws_instance" "web_server" {
  ami           = "ami-066784287e358dad1" 
  instance_type = "t2.micro"
  key_name      = "key-082342e60248ee797"  # Replace with your key pair

  # Use the security group

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # User data to install a basic web server
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              echo "Hello, Chibuzo's demo page!" > /var/www/html/index.html
            EOF

  tags = {
    Name = "Terraform-Web-Server"
  }
}

# Output the public IP of the instance

output "instance_public_ip" {
  value = aws_instance.web_server.public_ip
}
