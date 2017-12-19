# Assert that the selected subnet has internet access
data "aws_route_table" "default" {
  subnet_id = "${data.aws_efs_mount_target.default.subnet_id}"
}

resource "null_resource" "has_internet" {

  triggers {
    always = "${uuid()}"
  }

  provisioner "local-exec" {
    command = "echo '\"${jsonencode(list(data.aws_route_table.default.routes))}\"'| grep '\"cidr_block\":\"0.0.0.0/0\"'"
  }
}
