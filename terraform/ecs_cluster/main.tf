resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.app_name}-cluster"
}