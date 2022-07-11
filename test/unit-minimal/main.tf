module "test" {
  source = "../.."

  # add only required arguments and no optional arguments

  name  = "test-name"
  topic = "test-topic"

  project = local.project_id
}
