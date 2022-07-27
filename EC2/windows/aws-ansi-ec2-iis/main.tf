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
<powershell>
echo "" > _INIT_STARTED_
net user ${var.win_user} /add /y
net user ${var.win_user} ${var.win_password}
net localgroup administrators ${var.win_user} /add
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1
wget "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1" -Outfile ConfigureRemotingForAnsible.ps1 
./ConfigureRemotingForAnsible.ps1 -EnableCredSSP -DisableBasicAuth -Verbose
</powershell>
<persist>false</persist>
EOF
}

resource "aws_instance" "awsec2" {
  instance_type          = var.inst_types.small
  ami                    = "ami-0e2899d6d44f14095"
  subnet_id              = aws_subnet.sub0.id
  vpc_security_group_ids = [aws_security_group.remotesg.id, aws_security_group.web.id, aws_security_group.ansiblesg.id]
  key_name = aws_key_pair.publickey.key_name
  user_data = data.template_file.userdata_win.rendered
  tags = { Name = var.ec2name }

}

#Creating ansible Host.ini file 
# add path to where you want the host file to be created 
resource "local_file" "terransifile" {

  filename = "/home/user1/cloudutils/ansible/winansible/inventory/aws-hosts.ini"
  file_permission = "0755"
  content = <<-DOC
  [win]
  ${aws_instance.awsec2.public_ip}

  [win:vars]
  ansible_user= ${var.win_user} 
  ansible_password= ${var.win_password}
  ansible_port=5986
  ansible_connection=winrm
  ansible_winrm_scheme=http
  ansible_winrm_scheme=https
  ansible_winrm_transport=credssp
  ansible_winrm_server_cert_validation=ignore
  #ansible_winrm_kerberos_delegation=true


  DOC
  # adding ansible playbook here add path to your host file
# also add the path for your playbook
  provisioner "local-exec" {
    
    command = "sleep 180; ansible-playbook -i /home/user1/cloudutils/ansible/winansible/inventory/aws-hosts.ini /home/user1/cloudutils/ansible/winansible/playbook/aws-iis-install.yaml"
  }
  depends_on = [
    
    aws_instance.awsec2

  ]
}



