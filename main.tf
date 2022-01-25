resource "google_pubsub_subscription" "subscription" {
  count = var.module_enabled ? 1 : 0

  project = var.project

  name  = var.name
  topic = var.topic

  labels                     = try(var.labels, {})
  ack_deadline_seconds       = try(var.ack_deadline_seconds, null)
  message_retention_duration = try(var.message_retention_duration, "604800s")
  retain_acked_messages      = try(var.retain_acked_messages, null)
  filter                     = try(var.filter, null)
  enable_message_ordering    = try(var.enable_message_ordering, null)

  # DEFAULT: if the attribute does not exist use "" unlimited expiration - (do not expire)
  # if ttl = `null` do not add the block (force default of 31d)
  # if set, use what ever has been set. (users whish is our command ;))
  dynamic "expiration_policy" {
    for_each = var.expiration_policy_ttl != null ? [1] : []

    content {
      ttl = try(var.expiration_policy_ttl, "")
    }
  }

  dynamic "dead_letter_policy" {
    for_each = can(var.dead_letter_policy.dead_letter_topic) ? [1] : []

    content {
      dead_letter_topic     = var.dead_letter_policy.dead_letter_topic
      max_delivery_attempts = try(var.dead_letter_policy.max_delivery_attempts, 5)
    }
  }

  dynamic "retry_policy" {
    for_each = can(var.retry_policy) ? [1] : []

    content {
      minimum_backoff = try(var.retry_policy.minimum_backoff, null)
      maximum_backoff = try(var.retry_policy.maximum_backoff, null)
    }
  }

  dynamic "push_config" {
    for_each = var.push_config != null ? [var.push_config] : []

    content {
      push_endpoint = push_config.value.push_endpoint
      attributes    = try(push_config.value.attributes, {})

      dynamic "oidc_token" {
        for_each = try([push_config.value.oidc_token], [])

        content {
          service_account_email = oidc_token.value.service_account_email
          audience              = try(push_config.value.oidc_token.audience, null)
        }
      }
    }
  }

  depends_on = [var.module_depends_on]
}
