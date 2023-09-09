

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

data "template_file" "user_data_linux"{
  template = <<EOF
#!/bin/bash
sudo yum -y update
sudo yum -y install httpd
sudo touch /var/www/html/index.html
sudo echo "Hello World this is unit " > /var/www/html/index.html
sudo hostname >> /var/www/html/index.html
sudo chown -R apache:apache /var/www/html/*
sudo systemctl start httpd
sudo systemctl enable httpd
  EOF
}

resource "aws_instance" "awsec2" {
  instance_type          = var.ec2-instance-size
  ami                    = var.aws-ec2-image
  subnet_id              = var.ec2-subnet-id
  vpc_security_group_ids = var.ec2-sg-id
  user_data              = data.template_file.user_data_linux.rendered
  key_name               = aws_key_pair.publickey.key_name


  tags = { Name = var.ec2-name }

}