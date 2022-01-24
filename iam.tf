module "subscription-iam" {
  source = "github.com/mineiros-io/terraform-google-pubsub-subscription-iam?ref=v0.0.3"

  count = var.module_enabled ? 1 : 0

  project = var.project

  subscription = google_pubsub_subscription.subscription

  role          = google_pubsub_subscription_iam_member.pull_subscription_iam_member.role
  members       = try(google_pubsub_subscription_iam_member.pull_subscription_iam_member.members, [])
  authoritative = try(google_pubsub_subscription_iam_member.pull_subscription_iam_member.authoritative, true)

  module_enabled    = var.module_enabled
  module_depends_on = var.module_depends_on
}

# enable each pull subscriptions to be subscribed to by a iam member.
resource "google_pubsub_subscription_iam_member" "pull_subscription_iam_member" {
  count = var.module_enabled ? 1 : 0

  project = var.project

  subscription = google_pubsub_subscription.subscription

  role   = "roles/pubsub.subscriber"
  member = google_pubsub_subscription.subscription.iam_member

  depends_on = [var.module_depends_on, google_pubsub_subscription.subscription]
}
