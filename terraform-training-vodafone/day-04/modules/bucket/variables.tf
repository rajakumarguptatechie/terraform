variable "name" {
  description = "Bucket Name"
  type        = string
  default     = "my-test-bucket-0001"
}

variable "is_destroy" {
  description = "Destroy option"
  type        = bool
  default     = false
}