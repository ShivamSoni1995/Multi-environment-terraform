resource "aws_launch_template" "app" {
  name_prefix   = "${var.env}-lt"
  image_id      = var.ami_id
  instance_type = var.instance_type
  lifecycle { create_before_destroy = true }
}
resource "aws_autoscaling_group" "app" {
  name                = "${var.env}-asg"
  desired_capacity    = 2
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = var.subnet_ids
  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "${var.env}-ec2"
    propagate_at_launch = true
  }
}