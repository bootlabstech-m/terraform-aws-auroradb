variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "role_arn" {
    description = "role arn"
    type = string
}

variable "availability_zones" {
  description = "List of AZs"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs for Aurora"
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "Security group IDs for Aurora cluster"
  type        = list(string)
}

variable "publicly_accessible" {
  description = "Whether the Aurora DB instances should be publicly accessible"
  type        = bool
  default     = false
}

variable "environment" {
  description = "The environment for tagging resources"
  type        = string
  default     = "dev"
}

variable "aurora_details" {
  description = "Aurora cluster and instance configuration"
  type = map(object({
    cluster_identifier        = string
    engine                    = string
    engine_version            = string
    database_name             = string
    master_username           = string
    master_password           = string
    backup_retention_period   = number
    preferred_backup_window   = string
    final_snapshot_identifier = string
    skip_final_snapshot       = bool
    instance_class            = string
  }))
}
