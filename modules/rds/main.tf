resource "aws_db_instance" "default" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  name                 = var.db_name
  username             = var.db_user
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.default.name
  vpc_security_group_ids = [var.db_sg_id]
  skip_final_snapshot  = true
}
resource "aws_db_subnet_group" "default" {
  name       = "${var.env}-db-subnet-group"
  subnet_ids = var.subnet_ids
  tags = { Name = "${var.env}-db-subnet-group" }
}