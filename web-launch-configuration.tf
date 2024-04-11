resource "aws_launch_configuration" "web" {
  name_prefix = "web-"
  image_id = var.amiAL2023
  instance_type = "t2.small"
  key_name = aws_key_pair.terraform_key.key_name
  security_groups = [aws_security_group.web_sg.id]
  associate_public_ip_address = false
  user_data = file("user-data.sh")
  lifecycle {
    create_before_destroy = true
  }
}
