variable "keypair_name" {}
variable "master_worker_sg"{}
variable "ubuntu" {}
variable "instance_type" {}
variable "subnet-id" {}
variable "instance_count" {
    default = 3
}
variable "master_instance_name" {
  default = "Master-Node"
}