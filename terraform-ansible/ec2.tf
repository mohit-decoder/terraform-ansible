resource "aws_instance" "myec2" {
  ami                    = "ami-014d05e6b24240371" ## ubuntu instance ami
  instance_type          = "t2.micro"
  availability_zone      = "us-west-1a"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  key_name               = "id_rsa"

  tags = {
    name = "testec2"
  }
  provisioner "remote-exec" {
  inline= [
    "echo 'build ssh connection' "
  ]
  connection {
    host = aws_instance.myec2.public_ip
    type = "ssh"
    user = "ubuntu"
    private_key = file("./key.pem")  ## your private-key
  }
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.myec2.public_ip} > /home/ubuntu/terraform-ansible/hosts"
  }
  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.myec2.public_ip}, --private-key key.pem nginx.yml"
  }
}