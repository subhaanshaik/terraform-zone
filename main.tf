resource "aws_vpc" "vpc1" {
  cidr_block = var.vpc_network_cidr
  tags = {
    name = local.name

  }
}

resource "aws_subnet" "subnets" {
  count      = var.subnet_count
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = var.subnet_cidr_ranges[count.index]
  tags = {
    name = var.subnet_names[count.index]
  }
  depends_on = [
    aws_vpc.vpc1
  ]
}