resource "aws_instance" "haproxymain" {
  ami                         = var.ubuntu
  instance_type               = var.instance_type
  subnet_id                   = var.subnets
  vpc_security_group_ids      = [var.haproxy_sg]
  key_name                    = var.key_name

  user_data = templatefile("./module/haproxy/haproxymain.sh", {
    master1=var.master1,
    master2=var.master2,
    master3=var.master3
  })
  
  tags = {
    Name = var.haproxymain
  }
}

resource "aws_instance" "haproxybackup" {
  ami                         = var.ubuntu
  instance_type               = var.instance_type
  subnet_id                   = var.subnets2
  vpc_security_group_ids      = [var.haproxy_sg]
  key_name                    = var.key_name

  user_data = templatefile("./module/haproxy/haproxybackup.sh", {
    master1=var.master1,
    master2=var.master2,
    master3=var.master3
  })
  
  tags = {
    Name = var.haproxybackup
  }
}