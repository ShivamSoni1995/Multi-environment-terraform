resource "aws_lb" "app" {
  name               = "${var.env}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  tags = { Name = "${var.env}-alb" }
}
resource "aws_lb_target_group" "app" {
  name     = "${var.env}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}
resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}