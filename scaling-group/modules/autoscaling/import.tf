data "template_file" "user_data" {
  template = filebase64("${path.root}/templates/${var.user_data}")
}

data "aws_ami" "latest_amazon_linux" {
  owners = ["amazon"]
  most_recent = true
  filter{
    name = "name"
    values = ["amzn2-ami-*-x86_64-gp2"]
  }
}



