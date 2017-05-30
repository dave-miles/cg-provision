module "cdn_broker" {
  source = "../../modules/cdn_broker"

  account_id = "${var.account_id}"
  aws_partition = "${var.aws_partition}"
  username = "${var.cdn_broker_username}"
  bucket = "${var.cdn_broker_bucket}"
  cloudfront_prefix = "${var.cdn_broker_cloudfront_prefix}"
  hosted_zone = "${var.cdn_broker_hosted_zone}"
}

module "limit_check_user" {
  source = "../../modules/iam_user/limit_check_user"
  username = "limit-check-${var.stack_description}"
}

module "operators" {
  source = "../../modules/operators"
}

resource "aws_iam_policy_attachment" "admin" {
  name = "admin"
  count = "${var.stack_description == "production" ? 1 : 0}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  roles = [
    "${concat(
      module.operators.operators,
      list("terraform-provision")
    )}"
  ]
}
