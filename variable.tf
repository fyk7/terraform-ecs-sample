# vpc
variable "cidr_block" {
  default = "0.0.0.0/16"
}

variable "publick_cidr_block" {
  default = "10.0.0.0/24"
}

variable "publick_0_cidr_block" {
  default = "10.0.1.0/24"
}

variable "publick_1_cidr_block" {
  default = "10.0.2.0/24"
}

variable "private_cidr_block" {
  default = "10.0.64.0/24"
}

variable "private_0_cidr_block" {
  default = "10.0.65.0/24"
}

variable "private_1_cidr_block" {
  default = "10.0.66.0/24"
}

# s3
variable "alb_bucket_name" {
  default = "alb-log-fyk7-demo"
}

variable "alb_bucket_identifiers" {
  default = [""] 
}

# rds
variable "db_param_group_name" {
  default = "example"
}

variable "db_option_group_name" {
  default = "example"
}

variable "db_identifier" {
  default = "example"
}

variable "db_instance_class" {
  default = "db.t2.small"
}

variable "db_user_name" {
  default = "root"
}

variable "db_delete_protection" {
  default = true
}

variable "db_password" {
  default = "change me"
}

# ecs
variable "ecs_cluster_name" {
  default = "example"
}

variable "ecs_task_definition_family" {
  default = "example"
}

variable "ecs_cpu" {
  default = "256"
}

variable "ecs_memory" {
  default = "512"
}

variable "ecs_service_name" {
  default = "example"
}

variable "ecs_cloud_watch_log_group_name" {
  default = "/ecs/example"
}

# alb
variable "alb_name" {
  default = "example"
}

variable "alb_target_group_name" {
  default = "example"
}

variable "enable_deletion_protection" {
  default = true 
}