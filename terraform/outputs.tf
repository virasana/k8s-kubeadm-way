output "ec2_instance_etcd1_ssh_command" {
  value = format("ssh ubuntu@etcd1 ===> %s", aws_instance.etcd1.public_ip)
}

output "ec2_instance_etcd2_ssh_command" {
  value = format("ssh ubuntu@etcd2 ===> %s", aws_instance.etcd2.public_ip)
}


output "ec2_instance_controller1_ssh_command" {
  value = format("ssh ubuntu@controller1 ==> %s", aws_instance.controller1.public_ip)
}

output "ec2_instance_controller2_ssh_command" {
  value = format("ssh ubuntu@controller2 ===> %s", aws_instance.controller2.public_ip)
}


output "ec2_instance_worker1_ssh_command" {
  value = format("ssh ubuntu@worker1 ===> %s", aws_instance.worker1.public_ip)
}

output "ec2_instance_worker2_ssh_command" {
  value = format("ssh ubuntu@worker2 ===> %s", aws_instance.worker2.public_ip)
}

output "local-hosts-file-windows" {
  value = <<EOT

${aws_instance.etcd1.public_ip}				etcd1
${aws_instance.etcd2.public_ip}				etcd2
${aws_instance.worker1.public_ip}				worker1
${aws_instance.worker2.public_ip}				worker2
${aws_instance.controller1.public_ip}				controller1
${aws_instance.controller2.public_ip}				controller2
EOT
}

