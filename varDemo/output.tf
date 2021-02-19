//Capturing output variable

output "name_out" {
  description = "Store name variable output"
  value       = var.name
}

output "address_out" {
  description = "Store address variable output"
  value       = local.address
}
