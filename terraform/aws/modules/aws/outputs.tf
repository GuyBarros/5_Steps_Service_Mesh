output "servers" {
  value = "${formatlist("ssh -i ~/.ssh/id_rsa ubuntu@%s" ,aws_instance.consul_server.*.public_dns)}"
}

output "servers_ui" {
  value = "${formatlist("http://%s:8500" ,aws_instance.consul_server.*.public_dns)}"
}

output "workers" {
  value = "${formatlist("ssh -i ~/.ssh/id_rsa ubuntu@%s" ,aws_instance.consul_worker.*.public_dns)}"
}

output "workers_ui" {
  value = "${formatlist("http://%s:8500" ,aws_instance.consul_worker.*.public_dns)}"
}