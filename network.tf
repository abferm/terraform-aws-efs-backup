# Assert that the selected subnet has internet access
data "aws_route_table" "default" {
  subnet_id = "${data.aws_efs_mount_target.default.subnet_id}"
}

resource "null_resource" "has_internet" {
  count = "${contains(list(data.aws_route_table.default.routes.*.cidr_block), "0.0.0.0/0") == true ? 0 : 1}"
  triggers {
    always = "${uuid()}"
  }

  provisioner "local-exec" {
    command = "echo 'ERROR: datapipeline instances can only run if they have internet access'; false;"
  }
}
