data "aws_ami" "latest_amazon_linux" {
  owners = ["amazon"]
  most_recent = true
  filter{
    name = "name"
    values = ["amzn2-ami-*-x86_64-gp2"]
  }
}

