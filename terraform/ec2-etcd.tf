resource "aws_instance" "etcd1" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  associate_public_ip_address = "true"
  key_name                    = var.ssh_key_name

  vpc_security_group_ids = [
    aws_security_group.ingress-all.id]

  user_data = templatefile("${path.module}/files/init.sh", {})

  availability_zone = var.availability_zone
  subnet_id         = aws_subnet.public_k8s.id
  private_ip        = "10.0.0.245"

  tags = merge(local.common_tags,
  {
    description = "etcd1"
  })
  depends_on = [aws_security_group.ingress-all]
}

resource "aws_instance" "etcd2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  associate_public_ip_address = "true"
  key_name                    = var.ssh_key_name

  vpc_security_group_ids = [
    aws_security_group.ingress-all.id]

  user_data = templatefile("${path.module}/files/init.sh", {})

  availability_zone = var.availability_zone
  subnet_id         = aws_subnet.public_k8s.id
  private_ip        = "10.0.0.246"

  tags = merge(local.common_tags,
  {
    description = "etcd2"
  })
  depends_on = [aws_security_group.ingress-all]
}