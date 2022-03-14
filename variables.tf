# ----------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be set when using this module.
# ----------------------------------------------------------------------------------------------------------------------

variable "name" {
  type        = string
  description = "(Required) Name of the subscription."
}

variable "topic" {
  type        = string
  description = "(Required) A reference to a Topic resource."
}

variable "project" {
  type        = string
  description = "(Required) The project in which the resource belongs. If it is not provided, the provider project is used."
}

# ----------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have defaults, but may be overridden.
# ----------------------------------------------------------------------------------------------------------------------

variable "labels" {
  type        = map(string)
  default     = {}
  description = "(Optional) A set of key/value label pairs to assign to this Subscription."
}

variable "ack_deadline_seconds" {
  type        = number
  default     = null
  description = "(Optional) This value is the maximum time after a subscriber receives a message before the subscriber should acknowledge the message."
}

variable "message_retention_duration" {
  type        = string
  default     = "604800s"
  description = "(Optional) How long to retain unacknowledged messages in the subscription's backlog, from the moment a message is published."
}

variable "retain_acked_messages" {
  type        = bool
  default     = null
  description = "Indicates whether to retain acknowledged messages."
}

variable "filter" {
  type        = string
  default     = null
  description = "The subscription only delivers the messages that match the filter."
}

variable "enable_message_ordering" {
  type        = bool
  default     = null
  description = "(Optional) Whether to order message by when it was received."
}

variable "expiration_policy_ttl" {
  type        = string
  default     = ""
  description = "(Optional) Specifies the 'time-to-live' duration for an associated resource."
}

variable "dead_letter_policy" {
  type        = any
  default     = null
  description = "(Optional) A policy that specifies the conditions for dead lettering messages in this subscription."
}

variable "retry_policy" {
  type        = any
  default     = null
  description = "(Optional) A policy that specifies how Pub/Sub retries message delivery for this subscription."
}

variable "push_config" {
  type        = any
  default     = null
  description = "(Optional) If push delivery is used with this subscription, this field is used to configure it."
}

## IAM

variable "iam" {
  description = "(Optional) A list of IAM access."
  type        = any
  default     = []

  # validate required keys in each object
  validation {
    condition     = alltrue([for x in var.iam : length(setintersection(keys(x), ["role", "members"])) == 2])
    error_message = "Each object in var.iam must specify a role and a set of members."
  }

  # validate no invalid keys are in each object
  validation {
    condition     = alltrue([for x in var.iam : length(setsubtract(keys(x), ["role", "members", "authoritative"])) == 0])
    error_message = "Each object in var.iam does only support role, members and authoritative attributes."
  }
}

variable "policy_bindings" {
  description = "(Optional) A list of IAM policy bindings."
  type        = any
  default     = null

  # validate required keys in each object
  validation {
    condition     = var.policy_bindings == null ? true : alltrue([for x in var.policy_bindings : length(setintersection(keys(x), ["role", "members"])) == 2])
    error_message = "Each object in var.policy_bindings must specify a role and a set of members."
  }

  # validate no invalid keys are in each object
  validation {
    condition     = var.policy_bindings == null ? true : alltrue([for x in var.policy_bindings : length(setsubtract(keys(x), ["role", "members", "condition"])) == 0])
    error_message = "Each object in var.policy_bindings does only support role, members and condition attributes."
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# MODULE CONFIGURATION PARAMETERS
# These variables are used to configure the module.
# ----------------------------------------------------------------------------------------------------------------------

variable "module_enabled" {
  type        = bool
  description = "(Optional) Whether or not to create resources within the module."
  default     = true
}

variable "module_depends_on" {
  type        = any
  description = "(Optional) A list of external resources the module depends on."
  default     = []
}
