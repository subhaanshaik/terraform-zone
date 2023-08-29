resource "aws_vpc" "vpc1" {
  cidr_block = var.vpc_network_cidr
  tags = {
    name = local.name

  }
}

resource "aws_subnet" "subnets" {
  count             = var.subnet_count
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = var.subnet_cidr_ranges[count.index]
  availability_zone = var.subnet_azs[count.index]
  tags = {
    Name = var.subnet_names[count.index]
  }
  depends_on = [
    aws_vpc.vpc1
  ]
}


data "aws_route_table" "default" {
  vpc_id = aws_vpc.vpc1.id

  depends_on = [
    aws_vpc.vpc1
  ]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "igw"
  }
  depends_on = [
    aws_vpc.vpc1
  ]

}

resource "aws_route" "igwroute" {
  route_table_id         = data.aws_route_table.default.id
  destination_cidr_block = local.anywhere
  gateway_id             = aws_internet_gateway.igw.id

  depends_on = [
    aws_vpc.vpc1,
    aws_internet_gateway.igw
  ]

}
