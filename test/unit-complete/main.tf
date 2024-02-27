module "test-sa" {
  source = "github.com/mineiros-io/terraform-google-service-account?ref=v0.2.1"

  account_id = "service-account-id-${local.random_suffix}"
}

module "bucket" {
  source = "github.com/mineiros-io/terraform-google-storage-bucket?ref=v0.3.1"

  name = "bucket"
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

  ack_deadline_seconds         = 10
  message_retention_duration   = "600s"
  retain_acked_messages        = false
  filter                       = "*"
  enable_message_ordering      = true
  expiration_policy_ttl        = "86400s"
  enable_exactly_once_delivery = true

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

    no_wrapper = {
      write_metadata = true
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

  ack_deadline_seconds         = 10
  message_retention_duration   = "600s"
  retain_acked_messages        = false
  filter                       = "*"
  enable_message_ordering      = true
  expiration_policy_ttl        = "86400s"
  enable_exactly_once_delivery = true

  dead_letter_policy = {
    dead_letter_topic     = "projects/${local.project_id}/topics/test-topic"
    max_delivery_attempts = 6
  }

  retry_policy = {
    minimum_backoff = "10s"
    maximum_backoff = "60s"
  }

  bigquery_config = {
    table               = "my-table"
    use_topic_schema    = false
    write_metadata      = false
    drop_unknown_fields = false
  }

  # module_tags = {
  #   Environment = "unknown"
  # }

  module_depends_on = ["nothing"]
}

module "test2" {
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

  ack_deadline_seconds         = 10
  message_retention_duration   = "600s"
  retain_acked_messages        = false
  filter                       = "*"
  enable_message_ordering      = true
  expiration_policy_ttl        = "86400s"
  enable_exactly_once_delivery = true

  dead_letter_policy = {
    dead_letter_topic     = "projects/${local.project_id}/topics/test-topic"
    max_delivery_attempts = 6
  }

  retry_policy = {
    minimum_backoff = "10s"
    maximum_backoff = "60s"
  }

  cloud_storage_config = {
    bucket = module.bucket.bucket.name

    filename_prefix = "pre-"
    filename_suffix = "-post"

    max_bytes    = 1000
    max_duration = "300s"

    avro_config = {
      write_metadata = true
    }
  }

  # module_tags = {
  #   Environment = "unknown"
  # }

  module_depends_on = ["nothing"]
}
