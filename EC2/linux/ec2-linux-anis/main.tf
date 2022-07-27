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

  #user_data = file("userdata.tpl")


  tags = { Name = var.ec2name }

  #letting system know that private key must be present to run
  depends_on = [
    tls_private_key.keypair,
    aws_instance.awsec2
  ]

# This is to ensure SSH comes up before we run the local exec.
  
  provisioner "remote-exec" { 
    inline = ["echo 'Hello World'"]

    connection {
      type = "ssh"
      host = "${aws_instance.awsec2.public_ip}"
      user = "ec2-user"
      private_key = file(local_file.privatekey.filename)
    }
  }

#using ansible here add in the path to your private key on your local PC
#also the path your ansible playbook
  provisioner "local-exec" {
    command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${aws_instance.awsec2.public_ip}, --private-key ${var.key_path} ${var.ansible-http-playbook}"

  }


}

