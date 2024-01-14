
variable "myregion" {
  description = "AWS region to create resources"
  default     = "us-east-1"
}
variable "app_version" {
  type    = string
  default = null
}

variable "s3_bucket" {
  type    = string
  default = null
}

variable "s3_key" {
  type    = string
  default = null
}

variable "accountId" {
  type=string
  default=null
}

//cloudwatch 
# variable "log_group_retention_in_days" {
#   description = "(Optional) Specifies the number of days you want to retain log events in the specified log group. Default to 30 days"
#   type        = number
#   default     = 1
# }
