resource "aws_ecs_cluster" "cluster" {
  name = "internship_graduation_cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_cloudwatch_log_group" "fe_log_group" {
  name              = "/ecs/frontend_task_definition"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "be_log_group" {
  name              = "/ecs/backend_task_definition"
  retention_in_days = 7

}

resource "aws_ecs_task_definition" "backend_task_definition" {
  family                   = "backend_task_definition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 8192
  memory                   = 16384
  task_role_arn            = var.task_role_arn
  execution_role_arn       = var.execution_role_arn
  container_definitions = jsonencode([
    {
      name              = "backend"
      image             = "448049825151.dkr.ecr.ap-southeast-1.amazonaws.com/backend-repository-images:latest"
      cpu               = 2048
      memory            = 4096
      memoryReservation = 3072
      essential         = true
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
          protocol      = "tcp"
          name          = "backend-5000-tcp"
          appProtocol   = "http"
        }
      ]
      environment = [
        {
          name  = "MYSQL_USER"
          value = "admin"
        },
        {
          name  = "MYSQL_PASSWORD"
          value = "letmein12345"
        },
        {
          name  = "MYSQL_DATABASE"
          value = "internship_graduation_db"
        },
        {
          name  = "DB_HOST"
          value = "${var.db_host}"
        },
        {
          name  = "DB_DIALECT"
          value = "mysql"
        },
        {
          name  = "PORT"
          value = "5000"
        },
        {
          name  = "JWT_SECRET"
          value = "0bac010eca699c25c8f62ba86e319c2305beb94641b859c32518cb854addb5f4"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/backend_task_definition"
          "awslogs-region"        = "ap-southeast-1"
          "awslogs-stream-prefix" = "ecs"
          "awslogs-create-group"  = "true"
          "mode"                  = "non-blocking"
          "max-buffer-size"       = "25m"
        }
      }

    }
  ])
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}


resource "aws_ecs_task_definition" "frontend_task_definition" {
  family                   = "frontend_task_definition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 8192
  memory                   = 16384
  task_role_arn            = var.task_role_arn
  execution_role_arn       = var.execution_role_arn
  container_definitions = jsonencode([
    {
      name              = "frontend"
      image             = "448049825151.dkr.ecr.ap-southeast-1.amazonaws.com/frontend-repository-images:latest"
      cpu               = 1024
      memory            = 3072
      memoryReservation = 2048
      essential         = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
          name          = "container-http-port"
          appProtocol   = "http"
        }
      ]
      environment = [
        {
          name  = "BACKEND_HOST"
          value = "backend.testresbar.internal"
        },
        {
          name  = "BACKEND_PORT"
          value = "5000"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/frontend_task_definition"
          "awslogs-region"        = "ap-southeast-1"
          "awslogs-stream-prefix" = "ecs"
          "awslogs-create-group"  = "true"
          "mode"                  = "non-blocking"
          "max-buffer-size"       = "25m"
        }
      }
    }
  ])
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}


resource "aws_lb" "alb" {
  name               = "${var.prefix}-alb"
  load_balancer_type = "application"
  internal           = false
  ip_address_type    = "ipv4"
  subnets            = var.subnets
  security_groups    = var.security_group
}

resource "aws_lb_target_group" "fe_target_group" {
  name             = "${var.prefix}-fe-target-group"
  port             = 80
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  target_type      = "ip"
  vpc_id           = var.vpc_id

  health_check {
    protocol = "HTTP"
    path     = "/health"
  }
}

resource "aws_lb_target_group" "be_target_group_1" {
  name             = "${var.prefix}-be-target-group-1"
  port             = 5000
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  target_type      = "ip"
  vpc_id           = var.vpc_id

  health_check {
    protocol = "HTTP"
    path     = "/"
  }
}

resource "aws_lb_target_group" "be_target_group_2" {
  name             = "${var.prefix}-be-target-group-2"
  port             = 8080
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  target_type      = "ip"
  vpc_id           = var.vpc_id

  health_check {
    protocol = "HTTP"
    path     = "/"
  }
}

resource "aws_lb_listener" "be_lb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 5000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.be_target_group_1.arn
  }
}


# resource "aws_lb_listener" "alb_listener" {
#   load_balancer_arn = aws_lb.alb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.fe_target_group.arn
#   }
# }

resource "aws_lb_listener" "alb_listener_https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:ap-southeast-1:448049825151:certificate/1502c60c-452a-4aa7-8bec-88f70d704285"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fe_target_group.arn
  }
}


# This service will use Blue/Green deployment
resource "aws_ecs_service" "backend_service" {
  enable_execute_command = true
  name                   = "backend_service"
  cluster                = aws_ecs_cluster.cluster.id
  task_definition        = aws_ecs_task_definition.backend_task_definition.arn
  desired_count          = 2
  launch_type            = "FARGATE"


  deployment_controller {
    # type = "CODE_DEPLOY"
  }

  service_registries {
    registry_arn = var.cloudmap_arn
  }

  network_configuration {
    subnets          = var.be_subnets
    security_groups  = var.be_security_group
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.be_target_group_1.arn
    container_name   = "backend"
    container_port   = 5000

  }

}

resource "aws_ecs_service" "frontend_service" {
  enable_execute_command = true
  name                   = "frontend_service"
  cluster                = aws_ecs_cluster.cluster.id
  task_definition        = aws_ecs_task_definition.frontend_task_definition.arn
  desired_count          = 2
  launch_type            = "FARGATE"


  deployment_controller {
    # type = "CODE_DEPLOY"
  }


  network_configuration {
    subnets          = var.fe_subnets
    security_groups  = var.fe_security_group
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.fe_target_group.arn
    container_name   = "frontend"
    container_port   = 80

  }

}