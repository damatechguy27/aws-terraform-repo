
resource "aws_ebs_volume" "ebsvol" {
  count = var.ec2count 
  availability_zone = element(var.avail_name, count.index)
  size              = 20
  type              = "gp2"

  tags = {
    Name = "webebs-${count.index}"
  }
}

resource "aws_volume_attachment" "attachebs" {
  count = var.ec2count
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebsvol[count.index].id
  instance_id = aws_instance.awsec2[count.index].id
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
  count = var.ec2count  * length(aws_subnet.pubsub)
  instance_type          = var.inst_types.small
  ami                    = "ami-098e42ae54c764c35"
  subnet_id              = aws_subnet.pubsub[count.index % length(aws_subnet.pubsub)].id
  availability_zone = element(var.avail_name, count.index)
  vpc_security_group_ids = [aws_security_group.remotesg.id, aws_security_group.web.id]
  key_name = aws_key_pair.publickey.key_name
  user_data = data.template_file.user_data_linux.rendered
  root_block_device {
    volume_size = 20
  }

  tags = { Name = "Web-${count.index}" }

}
resource "local_file" "ansiblefile" {
  count = var.ec2count
  filename = "/home/user1/cloudutils/ansible/winansible/inventory/aws-hosts2.ini"
  file_permission = "0755"
  content = <<-DOC
  [lin]
  ${aws_instance.awsec2[count.index].public_ip}

  [linux:vars]
  ansible_user= 
  ansible_password= 
  ansible_port=5986
  ansible_connection=winrm
  ansible_winrm_scheme=http
  ansible_winrm_scheme=https
  ansible_winrm_transport=credssp
  ansible_winrm_server_cert_validation=ignore
  #ansible_winrm_kerberos_delegation=true


  DOC
}



