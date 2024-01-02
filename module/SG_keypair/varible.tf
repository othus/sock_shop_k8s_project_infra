variable "bastion_ansible_sg" {}
variable "vpc_id" {}
variable "k8s_SG" {}
variable "port_ssh" {
    default = 22
}
variable "port_proxy3" {
    default = 80
}
variable "port_proxy2" {
    default = 6443
}
variable "port_https" {
    default = 443
}
variable "port_proxy" {
    default = 8080
}
variable "port_http" {
    default = 80
}
variable "port_app" {
    default = 30001
}
variable "port_prom" {
    default = 31090
}
variable "port_graf" {
    default = 31300
}
variable "port_etcd" {
    default = 2380
}
variable "port_etcd_client" {
    default = 2379
}
variable "all-cidr" {
    default = "0.0.0.0/0"
}


