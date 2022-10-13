################################# for access #####################
variable "access_key" {}

variable "secret_key" {}

variable "region" {
	default = "ap-south-1"
}

################################ VPC and  Subnet ###################
variable "vpc_cidr" {}
variable "vpc_name" {} 

variable "public_subnet_name" {}
variable "public_subnet_cidr" {}
variable  "public_subnet_availability_zone" {}

variable "private1_subnet_name" {}
variable "private1_subnet_cidr" {}
variable  "private1_subnet_availability_zone" {}


variable "private2_subnet_name" {}
variable "private2_subnet_cidr" {}
variable  "private2_subnet_availability_zone" {}

##############################################  RDS  #############################################

variable "engine_name" {
  description = "Enter the DB engine"
  type        = string
  
}
variable "db_name" {
  description = "Enter the name of the database to be created inside DB Instance"
  type        = string

}
variable "user_name" {
  description = "Enter the username for DB"
  type        = string
 
}
variable "pass" {
  description = "Enter the username for DB"
  type        = string
 
}
variable "multi_az_deployment" {
  description = "Enable or disable multi-az deployment"
  type        = bool
 
}
variable "public_access" {
  description = "Whether public access needed"
  type        = bool
 
}
variable "skip_finalSnapshot" {
  type    = bool
 
}
variable "delete_automated_backup" {
  type    = bool

}
variable "instance_class" {
  type    = string

}
