resource "aws_lb" "tf-lb" {
  name               = var.elb-name
  internal           = var.elb-internal
  load_balancer_type = var.elb-type
  security_groups    = var.elb-sg-id
  subnets            = var.elb-subnets-id #[for subnet in aws_subnet.public : subnet.id]
  /*
  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.id
    prefix  = "test-lb"
    enabled = true
  }
*/
  tags = {
    Environment = var.elb-env
    Name        = var.elb-name
  }
}