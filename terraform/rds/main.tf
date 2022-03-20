resource "aws_security_group" "db_sg" {
  name        = "${var.app_name}-mysql"
  description = "security group on db of ${var.app_name}"

  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-sg of mysql"
  }
}

resource "aws_security_group_rule" "mysql-rule" {
  security_group_id = aws_security_group.db_sg.id

  type = "ingress"

  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = var.alb_security_group
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name        = var.db_name
  description = "db subent group of ${var.db_name}"
  subnet_ids  = var.private_subnet_ids
}

resource "aws_db_instance" "db" {
  allocated_storage = 10
  storage_type      = "gp2"
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.db_instance

  identifier          = var.db_name
  username            = var.db_username
  password            = var.db_password
  skip_final_snapshot = true

  enabled_cloudwatch_logs_exports = [
    "error",
    "general",
    "slowquery"
  ]
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
}
