# A security group for the Web so it is accessible via the web
resource "aws_security_group" "web" {
  name        = var.SG_name[0]
  description = "Used in the terraform"
  vpc_id      = var.sg-vpc-id
  tags        = { Name = var.SG_name[0] }

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "remotesg" {
  name        = var.SG_name[1]
  description = "Used in the terraform"
  vpc_id      = var.sg-vpc-id
  tags        = { Name = var.SG_name[1] }

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
