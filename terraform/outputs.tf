output "cloud_init" {
  value = data.cloudinit_config.master.rendered
}

output "ec2_instance_master_ssh_command" {
  value = format("ssh ubuntu@master ==> %s", aws_instance.master.public_ip)
}

output "ec2_instance_worker1_ssh_command" {
  value = format("ssh ubuntu@worker1 ===> %s", aws_instance.worker1.public_ip)
}

output "ec2_instance_worker2_ssh_command" {
  value = format("ssh ubuntu@worker2 ===> %s", aws_instance.worker2.public_ip)
}

output "local-hosts-file-windows" {
  value = <<EOT

${aws_instance.master.public_ip}				master
${aws_instance.worker1.public_ip}				worker1
${aws_instance.worker2.public_ip}				worker2
EOT
}