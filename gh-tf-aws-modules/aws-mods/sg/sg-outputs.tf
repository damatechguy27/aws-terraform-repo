//Security Group
output "sg-web-id" {
  value = aws_security_group.web.id
}

output "sg-remotesg-id" {
  value = aws_security_group.remotesg.id
}
