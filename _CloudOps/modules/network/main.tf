# este modulo crea una VPC con subredes publicas y privadas, tablas de rutas y una gateway de internet.
# se usa la enviroment para taggear todos los recursos

#vpc
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-${var.environment}"
  }
}

#internet gateway (darle salida a internet a las subredes publicas)
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "igw-${var.environment}"
  }
}

#obtener zonas de disponibilidad
data "aws_availability_zones" "available" {}

#subnets publicas 
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-${count.index}-${var.environment}"
  }
}

#subnets privadas
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "private-${count.index}-${var.environment}"
  }
}

#route tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "public-rt-${var.environment}"
  }
}

#asociar subnets publicas a la route table publica
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

#route table privada
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "private-rt-${var.environment}"
  }
}

#asociar subnets privadas a la route table privada
resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}




#NAT Gateway para dar salida a internet a las subnets privadas

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "nat-eip-${var.environment}"
  }
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "nat-${var.environment}"
  }

  depends_on = [aws_internet_gateway.this]
}


resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}


