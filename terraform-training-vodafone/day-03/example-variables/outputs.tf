//Capturing output variable

output "name_out" {
  description = "Capture name variable output"
  value       = var.name
}

output "address_out" {
  description = "Capture address variable output"
  value       = local.address
}

output "age_out" {
  description = "Capture age variable output"
  value       = var.age
}

output "job_out" {
  description = "Capture job variable output"
  value       = var.job
}

output "hobby_out" {
  description = "Capture hobby variable output"
  value       = var.hobby[0]
}

output "property_out" {
  description = "Capture property variable output"
  value       = var.property["vehicle"]
}

output "family_out" {
  description = "Capture family variable output"
  value       = var.family["total_bro"]
}

output "service_account_id" {
  description = "Capture service account ID"
  value       = google_service_account.terraform-rajakumargupta.id
}

output "gcp_region_out" {
  description = "GCP Region selected"
  value       = var.gcp_region["DEV"] 
}

