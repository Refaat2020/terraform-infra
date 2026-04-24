resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "Main-vpc"
  }
}

//PUBLIC SUBNET

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  count = var.public_subnet_count
  cidr_block = element(var.public_subnet_cidrs,count.index)
  availability_zone = element(var.availability_zones,count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index +1}"
  }
}


resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-internet-gateway"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "public-route-table"
  }
}
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "a" {
  count = var.public_subnet_count

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

///PRIVATE

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.id
  count = var.private_subnet_count
  cidr_block = element(var.private_subnet_cidrs,count.index)
  availability_zone = element(var.availability_zones,count.index)

   tags = {
    Name = "private-subnet-${count.index +1}"
  }
}

resource "aws_eip" "nat" {
  count = var.private_subnet_count
  domain = "vpc"
  tags = {
    Name = "net-eip-${count.index+1}"
  }
}

resource "aws_nat_gateway" "main" {
  count = var.private_subnet_count
  allocation_id = aws_eip.nat[count.index].id
  subnet_id = aws_subnet.public[count.index].id

  tags = {
    Name = "nat-${count.index+1}"
  }
  depends_on = [ aws_internet_gateway.main ]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  count = var.private_subnet_count

  tags = {
    Name = "Private-rt-${count.index+1}"
  }
}

resource "aws_route" "private" {
  count = var.private_subnet_count
  
  route_table_id = aws_route_table.private[count.index].id
  nat_gateway_id = aws_nat_gateway.main[count.index].id
  
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "private" {
  count = var.private_subnet_count

  route_table_id = aws_route_table.private[count.index].id
  subnet_id = aws_subnet.private[count.index].id
}


