#
# WEB EC2
#
/*
resource "aws_ebs_volume" "ebsvol" {
    count = var.inst-Num
    availability_zone =  aws_instance.ec2-web[count.index].availability_zone
    size = var.ebs-size
    type = var.ebs-type
    encrypted = var.ebs-encryption
    tags = {Name = "${var.ec2-name[0]}-${random_pet.petname.id}-${count.index}-vol"}
}

resource "aws_volume_attachment" "attach-ebsvol" {
    count = var.inst-Num
    device_name = "/dev/sdh"
    volume_id = aws_ebs_volume.ebsvol[count.index].id
    instance_id = aws_instance.ec2-web[count.index].id
  
}

resource "aws_instance" "ec2-web"{
    # number of instances that can be deployed
    count = var.inst-Num

    
    instance_type = var.ec2-inst-type
    ami = var.ec2-image[0]
    key_name = aws_key_pair.publickey.key_name
    user_data = <<-EOF
                #!/bin/bash
                sudo yum -y update
                sudo yum -y install httpd
                sudo yum -y install git
                sudo mkdir /home/games && sudo cd /home/games
                sudo git clone https://github.com/damatechguy27/gameapps.git
                sudo cp -rf gameapps/Glokar/* /var/www/html
                sudo chown -R apache:apache /var/www/html/*
                sudo systemctl start httpd
                sudo systemctl enable httpd
                sudo rm-rf /home/games
                EOF

    #this ensures that each ec2 instance is deploy into a different availability zone and subnet
    availability_zone = values(aws_subnet.priv-Subnets)[count.index].availability_zone
    subnet_id = values(aws_subnet.priv-Subnets)[count.index].id
    
    
    #used a for loop to store the IDs each security group in the list into a variable call sg 
    #vpc_security_group_ids = [for sg in aws_security_group.security-groups : sg.id]
    
    #this allow you to use specific security groups you want to put onto the instance
    vpc_security_group_ids = [aws_security_group.ec2-security-group.id] #[aws_security_group.security-groups[each_key].id]
    
    tags = {Name = "${var.vpc_names[0]}-${var.ec2-name[0]}-${random_pet.petname.id}-${count.index}"}

    depends_on = [ aws_instance.ec2-bastion ]
    
}
*/
#
# BASTION HOST 
#

resource "aws_instance" "ec2-bastion"{
    # number of instances that can be deployed
    count = 1

    
    instance_type = var.ec2-inst-type
    ami = var.ec2-image[1]
    key_name = aws_key_pair.publickey.key_name
    user_data = <<-EOF
                #!/bin/bash
                sudo yum -y update
                sudo yum install iptables-services -y
                sudo systemctl enable iptables
                sudo systemctl start iptables
                # Turning on IP Forwarding
                sudo touch /etc/sysctl.d/custom-ip-forwarding.conf
                sudo chmod 666 /etc/sysctl.d/custom-ip-forwarding.conf
                sudo echo "net.ipv4.ip_forward=1" >> /etc/sysctl.d/custom-ip-forwarding.conf
                sudo sysctl -p /etc/sysctl.d/custom-ip-forwarding.conf
                # Making a catchall rule for routing and masking the private IP
                sudo /sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
                sudo /sbin/iptables -F FORWARD
                sudo service iptables save
                EOF

    #this ensures that each ec2 instance is deploy into a different availability zone and subnet
    availability_zone = values(aws_subnet.pub-Subnets)[count.index].availability_zone
    subnet_id = values(aws_subnet.pub-Subnets)[count.index].id
    
    
    # Disable source/destination check
    source_dest_check = false

    #used a for loop to store the IDs each security group in the list into a variable call sg 
    #vpc_security_group_ids = [for sg in aws_security_group.security-groups : sg.id]
    
    #this allow you to use specific security groups you want to put onto the instance
    vpc_security_group_ids = [aws_security_group.bastion-security-group.id] #[aws_security_group.security-groups[each_key].id]
    
    tags = {Name = "${var.vpc_names[0]}-${var.ec2-name[2]}-${random_pet.petname.id}"}

    #provisioner "local-exec" {
    #command = "sleep 300"
    #}
    
    
}
/*
resource "aws_network_interface" "bastion_interface" {
    count =1
    source_dest_check = false
    subnet_id       = aws_instance.ec2-bastion[count.index].subnet_id
    security_groups = [aws_security_group.bastion-security-group.id]
    
}
*/