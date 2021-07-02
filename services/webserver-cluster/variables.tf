variable "cluster_name" {
  description = "The autoscaling group slug name."
  type        = string
}

variable "instance_type" {
  description = "The type of the EC2 instances to run (e.g t2.micro)."
  type        = string
}

variable "min_size" {
  description = "The minimum number of EC2 instances in the ASG."
  type        = number
}

variable "max_size" {
  description = "The maximum number of EC2 instances in the ASG."
  type        = number
}

variable "custom_tags" {
  description = "Custom tags to set on the instances in the ASG."
  type        = map(string)
  default     = {}
}

variable "ami_code" {
  description = "The base image used for the servers."
  type        = string
  default     = "ami-05aa753c043f1dcd3"
}
