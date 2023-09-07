

resource "aws_ebs_volume" "ebsvol" {
  availability_zone = var.ec2-az-id
  size              = var.ec2-ebs-size
  type              = var.ec2-ebs-type

  tags = {
    Name = var.ec2-name
  }
}

resource "aws_volume_attachment" "attachebs" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebsvol.id
  instance_id = aws_instance.awsec2.id
}

resource "aws_instance" "awsec2" {
  instance_type          = var.ec2-instance-size
  ami                    = "ami-a0cfeed8"
  subnet_id              = var.ec2-subnet-id
  vpc_security_group_ids = [var.ec2-sg1-id, var.ec2-sg2-id]
  key_name = aws_key_pair.publickey.key_name


  tags = { Name = var.ec2-name }

}