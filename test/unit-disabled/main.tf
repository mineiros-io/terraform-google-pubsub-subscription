module "test" {
  source = "../.."

  module_enabled = false

  # add all required arguments

  name  = "test-name"
  topic = "test-topic"

  project = local.project_id

  # add all optional arguments that create additional/extended resources
}
