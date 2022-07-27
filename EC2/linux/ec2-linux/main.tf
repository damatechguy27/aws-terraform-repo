resource "aws_ebs_volume" "ebsvol" {
  availability_zone = var.avail_name[0]
  size              = 20
  type              = "gp2"

  tags = {
    Name = var.ec2name
  }
}

resource "aws_volume_attachment" "attachebs" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebsvol.id
  instance_id = aws_instance.awsec2.id
}

resource "aws_instance" "awsec2" {
  instance_type          = var.inst_types.small
  ami                    = "ami-a0cfeed8"
  subnet_id              = aws_subnet.sub0.id
  vpc_security_group_ids = [aws_security_group.remotesg.id, aws_security_group.web.id]
  key_name = aws_key_pair.publickey.key_name


  tags = { Name = var.ec2name }

}




