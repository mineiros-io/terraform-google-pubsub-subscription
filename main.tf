resource "google_pubsub_subscription" "subscription" {
  count = var.module_enabled ? 1 : 0

  project = var.project

  name  = var.name
  topic = var.topic

  labels                       = var.labels
  ack_deadline_seconds         = var.ack_deadline_seconds
  message_retention_duration   = var.message_retention_duration
  retain_acked_messages        = var.retain_acked_messages
  filter                       = var.filter
  enable_message_ordering      = var.enable_message_ordering
  enable_exactly_once_delivery = var.enable_exactly_once_delivery

  # DEFAULT: if the variable is not set it defaults to "" unlimited expiration - (do not expire)
  # if ttl == `null` do not add the block (force default of 31d)
  # if set, use what ever has been set. (users whish is our command ;))
  dynamic "expiration_policy" {
    for_each = var.expiration_policy_ttl != null ? [1] : []

    content {
      ttl = var.expiration_policy_ttl
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
    for_each = var.retry_policy != null ? [1] : []

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

      dynamic "no_wrapper" {
        for_each = try([push_config.value.no_wrapper], [])

        content {
          write_metadata = no_wrapper.value.write_metadata
        }
      }
    }
  }

  dynamic "bigquery_config" {
    for_each = var.bigquery_config != null ? [var.bigquery_config] : []
    iterator = bqc

    content {
      table                 = bqc.value.table
      use_topic_schema      = try(bqc.value.use_topic_schema, null)
      use_table_schema      = try(bqc.value.use_table_schema, null)
      write_metadata        = try(bqc.value.write_metadata, null)
      drop_unknown_fields   = try(bqc.value.drop_unknown_fields, null)
      service_account_email = try(bqc.value.service_account_email, null)
    }
  }

  dynamic "cloud_storage_config" {
    for_each = var.cloud_storage_config != null ? [var.cloud_storage_config] : []
    iterator = csc

    content {
      bucket          = csc.value.bucket
      filename_prefix = try(csc.value.filename_prefix, null)
      filename_suffix = try(csc.value.filename_suffix, null)
      max_duration    = try(csc.value.max_duration, null)
      max_bytes       = try(csc.value.max_bytes, null)
      dynamic "avro_config" {
        for_each = try([csc.value.avro_config], [])
        content {
          write_metadata = try(avro_config.value.write_metadata, null)
        }
      }
    }
  }

  depends_on = [var.module_depends_on]
}
