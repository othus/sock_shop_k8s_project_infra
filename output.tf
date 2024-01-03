
output "haproxy_ip" {
  value = module.haproxy.haproxymain_ip
}

output "worker_node" {
  value = module.worker_node.Worker-Node_private_ip
}
output "Ansible_IP" {
  value = module.ansible.ansible_IP
}
output "bastion_IP" {
  value = module.bastion.bastion_public_ip
}
output "HAProxy_IP" {
  value = module.haproxy.haproxymain_ip
}
output "HAProxy_BackupIP" {
  value = module.haproxy.haproxybackup_ip
}
# output "HAproxy_Stage_IP" {
#   value = module.HAproxy-stage.stage_HAproxy_IP
# }
# output "HAproxy_Stage_BackupIP" {
#   value = module.stage-HAProxy_backup.stage_HAproxy_IP
# }
# output "Jenkins_ELB" {
#   value = module.jenkin-elb.jenkins_lb_dns
# }
# output "Stage_dns" {
#   value = module.stg-lb.lb-dns
# }
# output "Prometheus_ELB" {
#   value = module.prometheus_elb.prometheus-lb
# }
# output "Grafana_ELB" {
#   value = module.grafana_elb.grafana-lb
# }