data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = [
      "hvm"]
  }

  owners = [
    "099720109477"]
  # Canonical
}

resource "aws_key_pair" "ec2" {
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDe5rolPThs7BB9Us7zmdPqkJHhkeMt4k8SW16HCxdgi5hKhHCJxZBeCS7Ao+Wvymt7Mj1JrEhS0yxGl3UM/gjQfeWzPc3iWmiirX+n/Wqo0MKW1XAaT9yrzlYf8ZVESNLblfpEezZUH2DA6Mu7fSDt+Otvi8bPUyTb0jGNiAH5vYcauVWpe2JjYQ+JqpuSQf1o7PYcf+gg+69jTBu91RVAw08VtOBat7sLRXPQwKFaKkHA4OL7dEraRx5Qh8ZirrAi8TtjPnAHG4X6/2X371j4CJD6GjO4X7jdEihtrZRv5XFn9wcZwH0B41fr7pSmKW+S3YzOppgFvf/Yl8qAp/Y9 jean-pierre@LAPPIE2"
  key_name   = "ksone"
  tags       = merge(local.common_tags,
  {
    description = "key-pair-ec2"
  })

}

resource "aws_security_group" "ingress-all" {
  name   = "allow-all-sg"
  vpc_id = aws_vpc.vpc_k8s.id
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  // Terraform removes the default rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags = merge(local.common_tags,
  {
    description = "access-ssh"
  })

}