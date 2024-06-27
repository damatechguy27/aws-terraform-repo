resource "aws_vpc" "vpc" {

    cidr_block = var.cidr_ip
    enable_dns_hostnames = var.enable_hostnames
    tags = {Name = "VPC-${var.vpc_names[0]}"}
  
}

resource "aws_internet_gateway" "network_gateway" {

    vpc_id = aws_vpc.vpc.id
    tags = {Name = "${var.vpc_names[0]}"}
  
}

######################################################
#### Public Subnet
######################################################

# this creates a new subnet for each entry in the pub-subnet list
resource "aws_subnet" "pub-Subnets" {
    for_each = var.pub_subnets
    vpc_id = aws_vpc.vpc.id
    cidr_block = each.value.cidr_block
    availability_zone = each.value.availability_zone
    map_public_ip_on_launch = var.map_ip_enable

    tags = {
      Name = "${var.vpc_names[0]}-${each.key}"
    }
  
}

#creates the public route table 
resource "aws_route_table" "publicroute" {
    vpc_id = aws_vpc.vpc.id
    route {

        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.network_gateway.id

    }

    tags = {
      Name = "${var.vpc_names[0]}-Public-Route"
    }
  
}

# add each subnet created to the public route table 
resource "aws_route_table_association" "public_subnet_association" {
    for_each = var.pub_subnets

    subnet_id = aws_subnet.pub-Subnets[each.key].id
    route_table_id = aws_route_table.publicroute.id
  
}

######################################################
#### Private Subnet
######################################################

# this creates a new subnet for each entry in the pub-subnet list
resource "aws_subnet" "priv-Subnets" {
    for_each = var.priv_subnets
    vpc_id = aws_vpc.vpc.id
    cidr_block = each.value.cidr_block
    availability_zone = each.value.availability_zone
    map_public_ip_on_launch = false

    tags = {
      Name = "${var.vpc_names[0]}-${each.key}"
    }
  
}

#creates the public route table 
resource "aws_route_table" "privateroute" {
    vpc_id = aws_vpc.vpc.id

    tags = {
      Name = "${var.vpc_names[0]}-Private-Route"
    }
  
}


# adds the nat instance to the route table
resource "aws_route" "nat_route" {
    count =1
    route_table_id         = aws_route_table.privateroute.id
    destination_cidr_block = "0.0.0.0/0"
    network_interface_id = aws_instance.ec2-bastion[count.index].primary_network_interface_id
}

# add each subnet created to the public route table 
resource "aws_route_table_association" "private_subnet_association" {
    for_each = var.priv_subnets

    subnet_id = aws_subnet.priv-Subnets[each.key].id
    route_table_id = aws_route_table.privateroute.id
  
}




output "subnet_ids" {
    value = [for key, subnet in aws_subnet.pub-Subnets : subnet.id]
}

