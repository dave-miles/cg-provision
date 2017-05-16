resource "aws_elb" "cloudfoundry_elb_main" {
  name = "${var.stack_description}-CloudFoundry-Main"
  subnets = ["${split(",", var.elb_subnets)}"]
  security_groups = ["${split(",", var.elb_security_groups)}"]

  listener {
    lb_port = 80
    lb_protocol = "HTTP"
    instance_port = 80
    instance_protocol = "HTTP"
  }

  listener {
    lb_port = 443
    lb_protocol = "HTTPS"
    instance_port = 80
    instance_protocol = "HTTP"

    ssl_certificate_id = "arn:${var.aws_partition}:iam::${var.account_id}:server-certificate/${var.elb_main_cert_name}"
  }

  health_check {
    healthy_threshold = 2
    interval = 5
    target = "HTTP:81/"
    timeout = 4
    unhealthy_threshold = 3
  }

  tags {
    Name = "${var.stack_description}-CloudFoundry-Main"
  }
}

resource "aws_lb_ssl_negotiation_policy" "policy" {
  name = "${var.stack_description}-CloudFoundry-Main-policy"
  load_balancer = "${aws_elb.cloudfoundry_elb_main.id}"
  port = 443

  attribute {
    name = "DES-CBC3-SHA"
    value = "false"
  }
}
