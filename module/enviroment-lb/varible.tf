variable "lb_name" {
    default = "prod-LoadBalancer"
}
variable "lb-subnet1" {}
variable "lb-subnet2" {}
variable "lb-subnet3" {}
variable "sg_lb" {}
variable "prod_tg" {
    default = "prod-TargetGrp"
}
variable "lb_target-type" {
    default = "instance"
}
variable "vpc_id" {}
variable "instance" {}
variable "stg_lb_name" {
    default = "stg-LoadBalancer"
}
variable "stg_tg" {
    default = "stg-TargetGrp"
}
