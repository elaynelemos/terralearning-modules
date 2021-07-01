terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket = "elemos-terralearning-state"
    key    = "global/s3/terraform.tfstate"
    region = "sa-east-1"

    dynamodb_table = "elemos-terralearning-state-locks"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.45"
    }
  }
}

locals {
  server_port = 8080
  any_host    = ["0.0.0.0/0"]
}

data "aws_availability_zones" "all" {}

resource "aws_security_group" "instance" {
  name = var.cluster_name

  ingress {
    from_port   = local.server_port
    to_port     = local.server_port
    protocol    = "tcp"
    cidr_blocks = local.any_host
  }
}

resource "aws_launch_configuration" "example" {
  image_id        = var.ami_code
  instance_type   = var.instance_type
  security_groups = [aws_security_group.instance.id]
  user_data       = <<-EOF
              #!/bin/bash
              echo "Hello, World!" > index.html
              nohup busybox httpd -f -p ${local.server_port} &
              EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "exampe" {
  launch_configuration = aws_launch_configuration.example.id
  availability_zones   = data.aws_availability_zones.all.names

  min_size = var.min_size
  max_size = var.max_size

  load_balancers    = [aws_elb.example.name]
  health_check_type = "ELB"

  tag {
    key                 = "Name"
    value               = var.cluster_name
    propagate_at_launch = true
  }
}

resource "aws_security_group" "elb" {
  name = "${var.cluster_name}-elb"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = local.any_host
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = local.any_host
  }
}

resource "aws_elb" "example" {
  name               = var.cluster_name
  security_groups    = [aws_security_group.elb.id]
  availability_zones = data.aws_availability_zones.all.names

  health_check {
    target              = "HTTP:${local.server_port}/"
    interval            = 30
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = local.server_port
    instance_protocol = "http"
  }
}
