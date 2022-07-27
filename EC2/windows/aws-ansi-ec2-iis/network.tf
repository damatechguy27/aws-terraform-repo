# Create a VPC to launch our instances into
resource "aws_vpc" "vpc1" {
  cidr_block           = var.CIDR_IP
  enable_dns_hostnames = true

  tags = { Name = var.vpc_name }
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "intgw" {
  vpc_id = aws_vpc.vpc1.id

  tags = { Name = var.interGW_name }
}

# Create a subnet to launch our instances into
resource "aws_subnet" "sub0" {
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = var.PUBSUB_IP[0]
  availability_zone = var.avail_name[0]
  map_public_ip_on_launch = true
  tags                    = { Name = var.subnet_name[0] }
}


#setting up main route table
resource "aws_default_route_table" "pubroute" {
  default_route_table_id = aws_vpc.vpc1.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.intgw.id


  }
 
  tags = {
    Name = var.pubroute_name
  }
}

#route table association
resource "aws_route_table_association" "rta-subnet" {
  subnet_id      = aws_subnet.sub0.id
  route_table_id = aws_default_route_table.pubroute.id
}
