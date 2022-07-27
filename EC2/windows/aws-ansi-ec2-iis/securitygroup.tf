# A security group for the Web so it is accessible via the web
resource "aws_security_group" "web" {
  name        = var.SG_name[0]
  description = "Used in the terraform"
  vpc_id      = aws_vpc.vpc1.id
  tags = { Name = var.SG_name[0] }
  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
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
  vpc_id      = aws_vpc.vpc1.id
  tags = { Name = var.SG_name[1] }

  # SSH access from anywhere
  ingress {
    from_port   = 3389
    to_port     = 3389
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

resource "aws_security_group" "ansiblesg" {
  name        = var.SG_name[2]
  description = "Used in the terraform"
  vpc_id      = aws_vpc.vpc1.id
  tags = { Name = var.SG_name[2] }

  # HTTP-WINRM access from anywhere
  ingress {
    from_port   = 5985
    to_port     = 5985
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  

    # HTTPS-WINRM access from anywhere
  ingress {
    from_port   = 5986
    to_port     = 5986
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