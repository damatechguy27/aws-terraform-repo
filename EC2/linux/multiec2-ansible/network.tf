#Getting Avaliablity Zones for the Region
data "aws_availability_zones" "azs" {
  state = "available"
}

# Create a VPC to launch our instances into
resource "aws_vpc" "vpc1" {
  cidr_block           = var.CIDR_IP
  enable_dns_hostnames = true
  tags                    = { Name = var.vpc_name}
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "intgw" {
  vpc_id = aws_vpc.vpc1.id
  tags                    = { Name = var.interGW_name}
}

# Create a subnet to launch our instances into

resource "aws_subnet" "pubsub" {
  count = var.numofsubs
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = var.PUBSUB_IP[count.index]
  availability_zone = element(var.avail_name, count.index)
  map_public_ip_on_launch = true
  tags                    = { Name = "PubSubnet-${count.index}"}
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
  count = length(aws_subnet.pubsub)
  subnet_id      = aws_subnet.pubsub[count.index].id
  route_table_id = aws_default_route_table.pubroute.id
}

