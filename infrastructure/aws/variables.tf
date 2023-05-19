# DEFINING ALL VARIABLES
variable "aws_owner_id" {
  description = "Contains the Owner ID of the ami for amazon linux"
  type        = string
}

variable "aws_ami_name" {
  description = "Name of the ami I want for my project"
  type        = string
}

variable "aws_vpc_cidr_block" {
  description = "IP range for the vpc"
  type        = string
}

variable "aws_pub_subnet_cidr_block" {
  description = "IP range for the public subnet"
  type        = string
}

variable "aws_priv_subnet_cidr_block_1" {
  description = "IP range for the private subnet 1"
  type        = string
}

variable "aws_priv_subnet_cidr_block_2" {
  description = "IP range for the private subnet 2"
  type        = string
}

variable "aws_ec2_type" {
  description = "Type of the ec2 instance (storage size)"
  type        = string
}
variable "my_keypair" {
  description = "My SSH keypair"
  type        = string
}

variable "db_instance_class" {
  description = "Instance type for the db"
  type        = string
}

variable "db_username" {
  description = "Username to connect to the DB"
  type        = string
}

variable "db_engine" {
  description = "The DB engine to run on our RDS"
  type        = string
}

variable "db_engine_version" {
  description = "The version of the db engine"
  type        = string
}

variable "db_skip_last_snapshot" {
  description = "Before destroying the instance skip snapshot or not"
  type        = bool
  default     = true
}

variable "db_name" {
  description = "Name of the db"
}

variable "db_storage" {
  description = "Db storage"
}

variable "my_ip" {
  description = "IP for ssh"
}