resource "aws_instance" "master" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  associate_public_ip_address = "true"
  key_name                    = var.ssh_key_name

  vpc_security_group_ids = [
    aws_security_group.ingress-all.id]

  user_data = data.cloudinit_config.master.rendered

  availability_zone = var.availability_zone
  subnet_id         = aws_subnet.public_k8s.id
  private_ip        = var.ip_master

  tags = merge(local.common_tags,
  {
    description = "k8s-master"
  })

  depends_on = [aws_security_group.ingress-all]

}



data "cloudinit_config" "master" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = <<EOF
#cloud-config
write_files:
  - content: |
      ${base64encode(file("${path.module}/files/init-master.sh"))}
    encoding: b64
    owner: root:root
    path: /usr/local/bin/init-node.sh
    permissions: '0750'
EOF
  }

  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/files/init-all.sh")
  }
}


