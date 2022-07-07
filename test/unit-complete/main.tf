module "test-sa" {
  source = "github.com/mineiros-io/terraform-google-service-account?ref=v0.0.10"

  account_id = "service-account-id-${local.random_suffix}"
}

module "test0" {
  source = "../.."

  module_enabled = true

  # add all required arguments
  name  = "test-name"
  topic = "test-topic"

  # add all optional arguments that create additional resources
  iam = [
    {
      role          = "roles/viewer"
      members       = ["domain:mineiros.io"]
      authoritative = true
    },
    {
      role    = "roles/editor"
      members = ["computed:myserviceaccount"]
    }
  ]

  computed_members_map = {
    myserviceaccount = "serviceAccount:${module.test-sa.service_account.email}"
  }

  # add most/all other optional arguments
  project = local.project_id
  labels = {
    "test" = "test"
  }

  ack_deadline_seconds       = 10
  message_retention_duration = "600s"
  retain_acked_messages      = false
  filter                     = "*"
  enable_message_ordering    = true
  expiration_policy_ttl      = "86400s"

  dead_letter_policy = {
    dead_letter_topic     = "projects/${local.project_id}/topics/test-topic"
    max_delivery_attempts = 6
  }

  retry_policy = {
    minimum_backoff = "10s"
    maximum_backoff = "60s"
  }

  push_config = {
    oidc_token = {
      service_account_email = module.test-sa.service_account.email
      audience              = "test"
    }
    push_endpoint = "https://example.com/push"
    attributes = {
      x-goog-version = "v1"
    }
  }

  # module_tags = {
  #   Environment = "unknown"
  # }

  module_depends_on = ["nothing"]
}


module "test1" {
  source = "../.."

  module_enabled = true

  # add all required arguments
  name  = "test-name"
  topic = "test-topic"

  # add all optional arguments that create additional resources
  policy_bindings = [
    {
      role    = "roles/viewer"
      members = ["domain:mineiros.io"]
    },
    {
      role    = "roles/editor"
      members = ["computed:myserviceaccount"]
    }
  ]

  computed_members_map = {
    myserviceaccount = "serviceAccount:${module.test-sa.service_account.email}"
  }

  # add most/all other optional arguments
  project = local.project_id
  labels = {
    "test" = "test"
  }

  ack_deadline_seconds       = 10
  message_retention_duration = "600s"
  retain_acked_messages      = false
  filter                     = "*"
  enable_message_ordering    = true
  expiration_policy_ttl      = "86400s"

  dead_letter_policy = {
    dead_letter_topic     = "projects/${local.project_id}/topics/test-topic"
    max_delivery_attempts = 6
  }

  retry_policy = {
    minimum_backoff = "10s"
    maximum_backoff = "60s"
  }

  push_config = {
    oidc_token = {
      service_account_email = module.test-sa.service_account.email
      audience              = "test"
    }
    push_endpoint = "https://example.com/push"
    attributes = {
      x-goog-version = "v1"
    }
  }

  # module_tags = {
  #   Environment = "unknown"
  # }

  module_depends_on = ["nothing"]
}
