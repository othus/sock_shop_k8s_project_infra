locals {
  name        = "sockshop"
prvtsub1-id = "subnet-023d394af60ba43df"
prvtsub2-id = "subnet-0b978d9500d0fd274"
prvtsub3-id = "subnet-09cd3da376ab40ef1"
pubsub1-id = "subnet-021765baed0cd354a"
pubsub2-id = "subnet-0a8722243eac42646"
pubsub3-id = "subnet-00377c1a69051a8f8"
vpc-id = "vpc-013eb9b46f2c62baf"
}

data "aws_vpc" "vpc" {
  id = local.vpc-id
}
data "aws_subnet" "pubsub1" {
  id = local.pubsub1-id
}
data "aws_subnet" "pubsub2" {
  id = local.pubsub2-id
}
data "aws_subnet" "pubsub3" {
  id = local.pubsub3-id
}
data "aws_subnet" "prvtsub1" {
  id = local.prvtsub1-id
}
data "aws_subnet" "prvtsub2" {
  id = local.prvtsub2-id
}
data "aws_subnet" "prvtsub3" {
  id = local.prvtsub3-id
}

module "bastion" {
  source        = "./module/bastion"
  ubuntu        = var.ubuntu
  instance_type = "t2.micro"
  bastion-name  = "${local.name}_bastion"
  subnets       = "data.aws_subnet.pubsub1.id"
  key_name      = module.SG_keypair.key_name
  private-key   = module.SG_keypair.key_name
  bastion-sg    = module.SG_keypair.bastion_ansible_sg
}

module "master_node" {
  source               = "./module/master_nodes"
  ubuntu               = var.ubuntu
  instance_type        = var.instance_type
  instance_count       = 3
  subnet-id            = [data.aws_subnet.prvtsub1.id, data.aws_subnet.prvtsub2.id, data.aws_subnet.prvtsub3.id]
  master_worker_sg     = module.SG_keypair.sockshop_k8s_sg
  keypair_name         = module.SG_keypair.key_name
  master_instance_name = "${local.name}_masternode"
}

module "worker_node" {
  source               = "./module/worker_nodes"
  ubuntu               = var.ubuntu
  instance_count       = 3
  instance_type        = var.instance_type
  subnet-id            = [data.aws_subnet.prvtsub1.id, data.aws_subnet.prvtsub2.id, data.aws_subnet.prvtsub3.id]
  master_worker_sg     = module.SG_keypair.sockshop_k8s_sg
  worker_instance_name = "${local.name}_workernode"
  keypair_name         = module.SG_keypair.key_name
}

module "haproxy" {
  source        = "./module/haproxy"
  ubuntu        = var.ubuntu
  instance_type = var.instance_type
  subnets       = "data.aws_subnet.pubsub2.id"
  subnets2      = "data.aws_subnet.pubsub3.id"
  key_name      = module.SG_keypair.key_name
  haproxy_sg    = module.SG_keypair.sockshop_k8s_sg
  haproxymain   = "${local.name}_haproxymain"
  haproxybackup = "${local.name}_haproxybackup"
  master1       = module.master_node.Master_Node_IP[0]
  master2       = module.master_node.Master_Node_IP[1]
  master3       = module.master_node.Master_Node_IP[2]
}

module "SG_keypair" {
  source             = "./module/SG_keypair"
  vpc_id             = data.aws_vpc.vpc.id
  bastion_ansible_sg = "${local.name}_bastion_ansble_sg"
  k8s_SG             = "${local.name}_k8s_sg"
}

module "ansible" {
  source           = "./module/ansible"
  ubuntu           = var.ubuntu
  instance_type    = var.instance_type
  subnet_id        = data.aws_subnet.prvtsub1.id
  main_master_ip   = module.master_node.Master_Node_IP[0]
  master1_ip       = module.master_node.Master_Node_IP[1]
  master2_ip       = module.master_node.Master_Node_IP[2]
  worker1_ip       = module.worker_node.Worker-Node_private_ip[0]
  worker2_ip       = module.worker_node.Worker-Node_private_ip[1]
  worker3_ip       = module.worker_node.Worker-Node_private_ip[2]
  private_key      = module.SG_keypair.key_name
  key_name         = module.SG_keypair.key_name
  ansible-SG       = module.SG_keypair.bastion_ansible_sg
  ansible-name     = "${local.name}_ansible"
  haproxybackup_ip = module.haproxy.haproxybackup_ip
  haproxymain_ip   = module.haproxy.haproxymain_ip
  bastion_host     = module.bastion.bastion_public_ip
}

module "enviroment_lb" {
  source     = "./module/enviroment_lb"
  vpc_id     = data.aws_vpc.vpc.id
  instance   = module.worker_node.Worker-Node_InstanceID
  lb-subnet1 = data.aws_subnet.prvtsub1.id
  lb-subnet2 = data.aws_subnet.prvtsub2.id
  lb-subnet3 = data.aws_subnet.prvtsub3.id
  sg_lb      = module.SG_keypair.sockshop_k8s_sg
}

module "monitoring_lb" {
  source             = "./module/monitoring_lb"
  subnet_ids         = [data.aws_subnet.pubsub1.id, data.aws_subnet.pubsub2.id, data.aws_subnet.pubsub3.id]
  grafana_lb_name    = "${local.name}-grafana-lb"
  prometheus_lb_name = "${local.name}-prometheus-lb"
  instance           = module.worker_node.Worker-Node_InstanceID
  k8s_sg             = module.SG_keypair.sockshop_k8s_sg
  vpc_id             = data.aws_vpc.vpc.id
  grafana_tg         = "${local.name}-grafana-tg"
  prometheus_tg      = "${local.name}-prometheus-tg"
}

# module "route53_ssl" {
#   source              = "./module/route53_ssl"
#   stage_zone_id       = module.enviroment_lb.stg-lb-zone_id
#   stage_dns_name      = module.enviroment_lb.stg-lb-dns
#   domain_name         = "raro.com.ng"
#   domain_name1        = "stage.raro.com.ng"
#   domain_name2        = ".prod.raro.com.ng"
#   domain_name3        = "grafana.raro.com.ng"
#   domain_name4        = "prometheus.raro.com.ng"
#   domain_name5        = "*.raro.com.ng"
#   prod_dns_name       = module.enviroment_lb.lb-dns
#   prod_zone_id        = module.enviroment_lb.lb-zone_id
#   lb_arn              = module.enviroment_lb.lb-arn
#   lb_target_arn       = module.enviroment_lb.stg-lb-arn
#   prometheus_dns_name = module.monitoring_lb.prometheus_lb_dns
#   prometheus_zone_id  = module.monitoring_lb.prometheus_zone_id
#   grafana_dns_name    = module.monitoring_lb.grafana-lb-dns
#   grafana_zone_id     = module.monitoring_lb.grafana_zone_id
# }