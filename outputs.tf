# ----------------------------------------------------------------------------------------------------------------------
# OUTPUT CALCULATED VARIABLES (prefer full objects)
# ----------------------------------------------------------------------------------------------------------------------

output "iam" {
  description = "The iam resource objects that define access to the GCS bucket."
  value       = { for key, iam in module.subscription-iam : key => iam.iam }
}

# ----------------------------------------------------------------------------------------------------------------------
# OUTPUT ALL RESOURCES AS FULL OBJECTS
# ----------------------------------------------------------------------------------------------------------------------

output "subscription" {
  description = "All attributes of the created subscription."
  value       = try(google_pubsub_subscription.subscription, null)
}

# ----------------------------------------------------------------------------------------------------------------------
# OUTPUT MODULE CONFIGURATION
# ----------------------------------------------------------------------------------------------------------------------

output "module_enabled" {
  description = "Whether or not the module is enabled."
  value       = var.module_enabled
}
