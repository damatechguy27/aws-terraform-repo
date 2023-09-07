output "vpc-sub0-az" {
    value = aws_subnet.sub0.availability_zone_id
}

output "vpc-sub0-id" {
    value = aws_subnet.sub0.id
}

output "vpc-id" {
    value = aws_vpc.vpc1.id
}

output "vpc-az" {
    value = var.avail_name[0]
}