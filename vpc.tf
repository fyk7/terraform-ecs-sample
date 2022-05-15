resource "aws_vpc" "your_app_name" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "example"
  }
}

module "example_sg" {
  source      = "./security_group"
  name        = "module-sg"
  vpc_id      = aws_vpc.your_app_name.id
  port        = 80
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_internet_gateway" "your_app_name" {
  vpc_id = aws_vpc.your_app_name.id
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.your_app_name.id
  cidr_block              = "${var.publick_cidr_block}"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1a"
}

resource "aws_subnet" "public_0" {
  vpc_id                  = aws_vpc.your_app_name.id
  cidr_block              = "${var.publick_0_cidr_block}"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.your_app_name.id
  cidr_block              = "${var.publick_1_cidr_block}"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true
}


# Private Subnet
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.your_app_name.id
  cidr_block              = "${var.private_cidr_block}"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
}

resource "aws_subnet" "private_0" {
  vpc_id                  = aws_vpc.your_app_name.id
  cidr_block              = "${var.private_0_cidr_block}"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
}

resource "aws_subnet" "private_1" {
  vpc_id                  = aws_vpc.your_app_name.id
  cidr_block              = "${var.private_1_cidr_block}"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false
}
