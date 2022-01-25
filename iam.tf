locals {
  iam_map = { for iam in var.iam : iam.role => iam }
}

module "subscription-iam" {
  source = "github.com/mineiros-io/terraform-google-pubsub-subscription-iam?ref=v0.0.3"

  for_each = var.policy_bindings == null ? local.iam_map : {}

  module_enabled    = var.module_enabled
  module_depends_on = var.module_depends_on

  subscription  = try(google_pubsub_subscription.subscription[0].name, null)
  role          = each.value.role
  members       = each.value.members
  authoritative = try(each.value.authoritative, true)

  project = var.project
}

module "policy_bindings" {
  source = "github.com/mineiros-io/terraform-google-pubsub-subscription-iam?ref=v0.0.3"

  count = var.policy_bindings != null ? 1 : 0

  module_enabled    = var.module_enabled
  module_depends_on = var.module_depends_on

  subscription    = try(google_pubsub_subscription.subscription[0].name, null)
  policy_bindings = var.policy_bindings

  project = var.project
}
