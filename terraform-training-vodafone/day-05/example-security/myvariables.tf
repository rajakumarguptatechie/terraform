variable "project_name" {
  description = "GCP Project Name"
  type        = string
  default     = ""
  sensitive   = true
}


output "project_name_out" {
  value     = var.project_name
  sensitive = true
}
