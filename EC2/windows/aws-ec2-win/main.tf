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

data "template_file" "userdata_win" {
  template = <<EOF
<script>
echo "" > _INIT_STARTED_
net user ${var.win_user} /add /y
net user ${var.win_user} ${var.win_password}
net localgroup administrators ${var.win_user} /add
</script>
<persist>false</persist>
EOF
}

resource "aws_instance" "awsec2" {
  instance_type          = var.inst_types.small
  ami                    = "ami-0e2899d6d44f14095"
  subnet_id              = aws_subnet.sub0.id
  vpc_security_group_ids = [aws_security_group.remotesg.id, aws_security_group.web.id, aws_security_group.ansiblesg.id]
  key_name = aws_key_pair.publickey.key_name
  #user_data = file("winrm_setup.ps1")
  user_data = data.template_file.userdata_win.rendered
  tags = { Name = var.ec2name }

}





