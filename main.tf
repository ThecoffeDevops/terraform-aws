resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

locals {
 public_cidr         = ["10.0.5.0/24", "10.0.2.0/24"]
 availability_zones  = ["us-east-1a", "us-east-1b"]

 private_cidr        = ["10.0.3.0/24", "10.0.4.0/24"]

 count = 2

}

resource "aws_subnet" "public" {
  count                   = local.count

  map_public_ip_on_launch = "true" 

  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.public_cidr[count.index]

  availability_zone       = local.availability_zones[count.index] 

  tags = {
    Name                  = "${var.environment}-public${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count             = local.count 

  vpc_id            = aws_vpc.main.id
  cidr_block        = local.private_cidr[count.index]

  availability_zone = local.availability_zones[count.index]  

  tags = {
    Name            = "${var.environment}-private${count.index + 1}"
  }
}


resource "aws_internet_gateway" "main_ig" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_ig.id
  }
}

resource "aws_route_table_association" "public" {
  count = local.count
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


resource "aws_eip" "eip" {
  count = local.count 
  vpc      = true
}

resource "aws_nat_gateway" "nat" {
  count         = local.count
  allocation_id = aws_eip.eip[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  count  = local.count
  route {
    cidr_block     = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }
}


resource "aws_route_table_association" "private" {
  count          =  local.count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
 
}









