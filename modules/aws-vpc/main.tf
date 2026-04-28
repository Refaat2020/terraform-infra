resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "Main-vpc"
  }
}

//PUBLIC SUBNET

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  count = length(var.public_subnet_cidrs)
  cidr_block = var.public_subnet_cidrs[count.index]
    availability_zone       = var.azs[count.index]
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
  count = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

///PRIVATE

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.id
  count = length(var.private_subnet_cidrs)
 cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

   tags = {
    Name = "private-subnet-${count.index +1}"
  }
}

resource "aws_eip" "nat" {
  count = length(var.azs)
  domain = "vpc"
  tags = {
    Name = "net-eip-${count.index+1}"
  }
}

resource "aws_nat_gateway" "main" {
  count = length(var.azs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id = aws_subnet.public[count.index].id

  tags = {
    Name = "nat-${count.index+1}"
  }
  depends_on = [ aws_internet_gateway.main ]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  count = length(var.private_subnet_cidrs)

  tags = {
    Name = "Private-rt-${count.index+1}"
  }
}

resource "aws_route" "private" {
  count = length(var.private_subnet_cidrs)
  
  route_table_id = aws_route_table.private[count.index].id
  nat_gateway_id = aws_nat_gateway.main[count.index].id
  
  destination_cidr_block = "0.0.0.0/0"
  
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)

  route_table_id = aws_route_table.private[count.index].id
  subnet_id = aws_subnet.private[count.index].id
}


