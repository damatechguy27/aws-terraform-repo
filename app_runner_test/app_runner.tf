# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "example-vpc"
  }
}

# Create a subnet
resource "aws_subnet" "example" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "example-subnet"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
  tags = {
    Name = "example-igw"
  }
}

# Create a Security Group for ALB
resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.example.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

# Create an Application Load Balancer
resource "aws_lb" "example" {
  name               = "example-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.example.id]

  enable_deletion_protection = false
  enable_http2               = true
  #enable_waf                 = false
  idle_timeout               = 60

  tags = {
    Name = "example-alb"
  }
}

# Create a target group for ALB
resource "aws_lb_target_group" "example" {
  name     = "example-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.example.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold    = 2
    unhealthy_threshold  = 2
  }

  tags = {
    Name = "example-target-group"
  }
}

# Create an ALB listener
resource "aws_lb_listener" "example" {
  load_balancer_arn = aws_lb.example.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.example.arn
  }

  tags = {
    Name = "example-listener"
  }
}

# Define a simple Apache server Docker image
resource "aws_apprunner_service" "example" {
  service_name = "example-app-runner-service"

  source_configuration {
    image_repository {
      image_identifier = "988940651769.dkr.ecr.us-west-2.amazonaws.com/damtestecr27:latest"  # Using Apache HTTP server Docker image
      image_repository_type = "ECR"
    }
    
    auto_deployments_enabled = true
  }

  instance_configuration {
    cpu    = "1 vCPU"
    memory = "2 GB"
  }

  health_check_configuration {
    path                = "/"
    interval            = 10
    timeout             = 5
    healthy_threshold    = 1
    unhealthy_threshold  = 2
  }
}

# Output the URL of the App Runner service
output "app_runner_url" {
  value = aws_apprunner_service.example.service_url
}

# Output the ARN of the ALB
output "alb_arn" {
  value = aws_lb.example.arn
}
