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
  description = "(Required) Name of the subscription."
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

variable "expiration_policy" {
  type        = any
  default     = null
  description = "(Optional) A policy that specifies the conditions for this subscription's expiration."
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
