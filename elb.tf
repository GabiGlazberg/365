resource "aws_lb" "web_lb" {
  name               = "webLB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id]
  subnets            = [
      aws_subnet.public_subnet_1.id,
      aws_subnet.public_subnet_2.id
      ]

  enable_deletion_protection = false
  tags = {
    Name = "web_lb"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "HTTP"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:034362060696:certificate/b86eff50-bc86-40a7-925a-611a3612968b"

  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "HTTPS"
      status_code  = "200"
    }
  }
}
