data "template_file" "policy" {
  template = "${file("${path.module}/policy.json")}"

  vars {
    aws_partition = "${var.aws_partition}"
    varz_bucket = "${var.varz_bucket}"
    varz_staging_bucket = "${var.varz_staging_bucket}"
    bosh_release_bucket = "${var.bosh_release_bucket}"
    stemcell_bucket = "${var.stemcell_bucket}"
    terraform_state_bucket = "${var.terraform_state_bucket}"
  }
}

module "concourse_iaas_worker" {
  source = ".."

  role_name = "${var.role_name}"

  iam_policy = "${data.template_file.policy.rendered}"
}


