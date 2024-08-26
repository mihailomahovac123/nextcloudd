resource "aws_ebs_volume" "ebs_vol" {
  availability_zone = "eu-central-1"
  size = "${var.ebs_size}"
}