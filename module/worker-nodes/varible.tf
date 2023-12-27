variable "keypair_name" {}
variable "master_worker_sg"{}
variable "ubuntu" {}
variable "instance_type" {}
variable "subnet-id" {}
variable "instance_count" {
    default = 2
}
variable "worker_instance_name" {
    default = "worker-node"
}