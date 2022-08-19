
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

resource "aws_instance" "awsec2" {
  count = var.ec2count  * length(aws_subnet.pubsub)
  instance_type          = var.inst_types.small
  ami                    = var.ec2ami
  subnet_id              = aws_subnet.pubsub[count.index % length(aws_subnet.pubsub)].id
  availability_zone = element(var.avail_name, count.index)
  vpc_security_group_ids = [aws_security_group.remotesg.id, aws_security_group.web.id]
  key_name = aws_key_pair.publickey.key_name
  root_block_device {
    volume_size = 20
  }

  tags = { Name = "Web-${count.index}" }

}

resource "local_file" "ansiblefile" {
  count = var.ec2count
  filename = var.ansi_hostfile_path
  file_permission = "0755"
  
  content = <<-DOC
  [lin]
  ${join("\n",aws_instance.awsec2.*.public_ip)}

  [lin:vars]
  host_key_checking= no
  ansible_user= ${var.user_name} 
  ansible_ssh_private_key_file= ${var.key_path}
  ansible_port= 22
  ansible_connection = ssh
  ansible_ssh_common_args= '-o StrictHostKeyChecking=no'
  ansible_ssh_extra_args= '-o StrictHostKeyChecking=no'
 
  DOC


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
      host = "${aws_instance.awsec2[count.index].public_ip}"
      user = "ec2-user"
      private_key = file(local_file.privatekey.filename)
    }
  }

#using ansible here add in the path to your private key on your local PC
#also the path your ansible playbook
  provisioner "local-exec" {
    command = "sleep 180; ansible-playbook -i ${var.ansi_hostfile_path} ${var.ansible-http-playbook}"
  }
}



