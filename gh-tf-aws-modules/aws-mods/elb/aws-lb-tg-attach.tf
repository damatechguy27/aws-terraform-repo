
resource "aws_lb_target_group_attachment" "tf_tg_attachment" {
  target_group_arn = aws_lb_target_group.tf-tg-instance.arn #var.tg-arn-id
  target_id        = var.tg-instance-id
  port             = var.tg-ports
}

