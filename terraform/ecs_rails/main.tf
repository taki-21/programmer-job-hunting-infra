locals {
  account_id = data.aws_caller_identity.user.account_id
}

# ECSタスク実行ロールの作成
module "ecs_task_execution_role" {
  source     = "../iam_role"
  name       = "ecs-task-execution"
  identifier = "ecs-tasks.amazonaws.com"
  policy     = data.aws_iam_policy_document.ecs_task_execution.json
}

resource "aws_ecs_task_definition" "task_definition" {
  family = "${var.app_name}-task"

  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  container_definitions = data.template_file.container_definitions.rendered
  execution_role_arn    = module.ecs_task_execution_role.iam_role_arn
}

resource "aws_cloudwatch_log_group" "log" {
  count = length(var.apps_name)
  name  = "/ecs/programmer-job-hunting/${var.apps_name[count.index]}"
}

resource "aws_lb_target_group" "target_group" {
  name = "${var.app_name}-tg"

  vpc_id = var.vpc_id

  # ALBからECSタスクのコンテナへトラフィックを振り分ける設定
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"

  # コンテナへの死活監視設定
  health_check {
    port = 80
    path = "/health"
  }
}
resource "aws_lb_listener_rule" "http_rule" {
  listener_arn = var.http_listener_arn

  # 受け取ったトラフィックをターゲットグループへ受け渡す
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.id
  }

  # ターゲットグループへ受け渡すトラフィックの条件
  condition {
    path_pattern {
      values = ["*"]
    }
  }
}

resource "aws_lb_listener_rule" "https_rule" {
  listener_arn = var.https_listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.id
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }
}

resource "aws_ecs_service" "ecs_service" {
  name            = "${var.app_name}-service"
  launch_type     = "FARGATE"
  desired_count   = "1"
  cluster         = var.cluster_name
  task_definition = aws_ecs_task_definition.task_definition.arn

  network_configuration {
    security_groups  = [var.alb_security_group]
    subnets          = var.public_subnet_ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "nginx"
    container_port   = 80
  }
}
