
#adding keypairs 

#creating private key
resource "tls_private_key" "keypair" {
  algorithm = "RSA"
  rsa_bits = 4096
  
}

#saving private key as a local file using a different name here
resource "local_file" "privatekey" {
  filename = var.key_path
  file_permission = "0600"
  content = tls_private_key.keypair.private_key_pem  
}

#creating the public key using the private key file created 
resource "aws_key_pair" "publickey" {
  key_name                = var.key_name
  public_key          = "${tls_private_key.keypair.public_key_openssh}"
  tags = { Name = var.key_name }
}
