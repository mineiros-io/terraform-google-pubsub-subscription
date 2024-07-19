[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>](https://mineiros.io/?ref=terraform-google-pubsub-subscription)

[![Build Status](https://github.com/mineiros-io/terraform-google-pubsub-subscription/workflows/Tests/badge.svg)](https://github.com/mineiros-io/terraform-google-pubsub-subscription/actions)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/terraform-google-pubsub-subscription.svg?label=latest&sort=semver)](https://github.com/mineiros-io/terraform-google-pubsub-subscription/releases)
[![Terraform Version](https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![Google Provider Version](https://img.shields.io/badge/google-4-1A73E8.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-google/releases)
[![Join Slack](https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack)](https://mineiros.io/slack)

# terraform-google-pubsub-subscription

A [Terraform](https://www.terraform.io) module for creating a
[PubSub Subscriber](https://cloud.google.com/pubsub/docs/subscriber) for
[Google Cloud Pub/Sub](https://cloud.google.com/pubsub).

**_This module supports Terraform version 1
and is compatible with the Terraform Google Provider version 5._**

This module is part of our Infrastructure as Code (IaC) framework
that enables our users and customers to easily deploy and manage reusable,
secure, and production-grade cloud infrastructure.


- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
  - [Main Resource Configuration](#main-resource-configuration)
  - [Extended Resource Configuration](#extended-resource-configuration)
  - [Module Configuration](#module-configuration)
- [Module Outputs](#module-outputs)
- [External Documentation](#external-documentation)
  - [Google Documentation](#google-documentation)
  - [Terraform GCP Provider Documentation](#terraform-gcp-provider-documentation)
- [Module Versioning](#module-versioning)
  - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [Makefile Targets](#makefile-targets)
- [License](#license)

## Module Features

This module implements the following Terraform resources

- `google_pubsub_subscription`

and supports additional features of the following modules:

- [mineiros-io/subscription-iam](https://github.com/mineiros-io/terraform-google-pubsub-subscription-iam)

## Getting Started

Most common usage of the module:

```hcl
module "terraform-google-pubsub-subscription" {
  source = "git@github.com:mineiros-io/terraform-google-pubsub-subscription.git?ref=v0.1.0"

  name    = "subscription-name"
  topic   = "topic-resource"
  project = "resource-project"
}
```

## Module Argument Reference

See [variables.tf] and [examples/] for details and use-cases.

name    = "name-of-sub"
topic   = "topic-resource"
project = "project-a"

### Main Resource Configuration

- [**`name`**](#var-name): *(**Required** `string`)*<a name="var-name"></a>

  Name of the subscription.

- [**`topic`**](#var-topic): *(**Required** `string`)*<a name="var-topic"></a>

  A reference to a Topic resource.

- [**`project`**](#var-project): *(**Required** `string`)*<a name="var-project"></a>

  The project in which the resource belongs. If it is not provided, the
  provider project is used.

- [**`labels`**](#var-labels): *(Optional `map(string)`)*<a name="var-labels"></a>

  A set of key/value label pairs to assign to this Subscription.

  Default is `{}`.

- [**`ack_deadline_seconds`**](#var-ack_deadline_seconds): *(Optional `number`)*<a name="var-ack_deadline_seconds"></a>

  This value is the maximum time after a subscriber receives a message
  before the subscriber should acknowledge the message. After message
  delivery but before the ack deadline expires and before the message is
  acknowledged, it is an outstanding message and will not be delivered
  again during that time (on a best-effort basis). For pull
  subscriptions, this value is used as the initial value for the ack
  deadline. To override this value for a given message, call
  `subscriptions.modifyAckDeadline` with the corresponding `ackId` if
  using pull. The minimum custom deadline you can specify is `10`
  seconds. The maximum custom deadline you can specify is `600` seconds
  (10 minutes). If this parameter is `0`, a default value of `10`
  seconds is used. For push delivery, this value is also used to set the
  request timeout for the call to the push endpoint. If the subscriber
  never acknowledges the message, the Pub/Sub system will eventually
  redeliver the message.

- [**`message_retention_duration`**](#var-message_retention_duration): *(Optional `string`)*<a name="var-message_retention_duration"></a>

  How long to retain unacknowledged messages in the subscription's
  backlog, from the moment a message is published. If
  `retainAckedMessages` is `true`, then this also configures the
  retention of acknowledged messages, and thus configures how far back
  in time a `subscriptions.seek` can be done. Defaults to 7 days.
  Cannot be more than 7 days (`604800s`) or less than 10 minutes
  (`600s`). A duration in seconds with up to nine fractional digits,
  terminated by `s`.

  Default is `"604800s"`.

  Example:

  ```hcl
  600.5s
  ```

- [**`retain_acked_messages`**](#var-retain_acked_messages): *(Optional `bool`)*<a name="var-retain_acked_messages"></a>

  Indicates whether to retain acknowledged messages. If `true`, then
  messages are not expunged from the subscription's backlog, even if
  they are acknowledged, until they fall out of the
  `messageRetentionDuration` window.

- [**`filter`**](#var-filter): *(Optional `string`)*<a name="var-filter"></a>

  The subscription only delivers the messages that match the filter.
  Pub/Sub automatically acknowledges the messages that don't match the
  filter. You can filter messages by their attributes. The maximum
  length of a filter is 256 bytes. After creating the subscription,
  you can't modify the filter.

- [**`enable_message_ordering`**](#var-enable_message_ordering): *(Optional `bool`)*<a name="var-enable_message_ordering"></a>

  If `true`, messages published with the same `orderingKey` in
  `PubsubMessage` will be delivered to the subscribers in the order in
  which they are received by the Pub/Sub system. Otherwise, they may be
  delivered in any order.

- [**`enable_exactly_once_delivery`**](#var-enable_exactly_once_delivery): *(Optional `bool`)*<a name="var-enable_exactly_once_delivery"></a>

  If `true`,The message sent to a subscriber is guaranteed not to be resent 
   before the message's acknowledgement deadline expires. An acknowledged 
   message will not be resent to a subscriber. Note that subscribers may 
   still receive multiple copies of a message when enable_exactly_once_delivery 
   is true if the message was published multiple times by a publisher client. 
   These copies are considered distinct by Pub/Sub and have distinct messageId values

- [**`expiration_policy_ttl`**](#var-expiration_policy_ttl): *(Optional `string`)*<a name="var-expiration_policy_ttl"></a>

  A policy that specifies the conditions for this subscription's
  expiration. A subscription is considered active as long as any
  connected subscriber is successfully consuming messages from the
  subscription or is issuing operations on the subscription. If
  `expirationPolicy` is not set, a default policy with ttl of 31 days
  will be used. If it is set but ttl is "", the resource never expires.
  The minimum allowed value for `expirationPolicy.ttl` is 1 day.
  A duration in seconds with up to nine fractional digits, terminated by 's'.

- [**`dead_letter_policy`**](#var-dead_letter_policy): *(Optional `object(dead_letter_policy)`)*<a name="var-dead_letter_policy"></a>

  A policy that specifies the conditions for dead lettering messages
  in this subscription. If `dead_letter_policy` is not set, dead
  lettering is disabled. The Cloud Pub/Sub service account associated
  with this subscription's parent project (i.e.,
  `service-{project_number}@gcp-sa-pubsub.iam.gserviceaccount.com)`
  must have permission to `Acknowledge()` messages on this
  subscription.

  The `dead_letter_policy` object accepts the following attributes:

  - [**`dead_letter_topic`**](#attr-dead_letter_policy-dead_letter_topic): *(Optional `string`)*<a name="attr-dead_letter_policy-dead_letter_topic"></a>

    The name of the topic to which dead letter messages should be
    published. Format is `projects/{project}/topics/{topic}`. The Cloud
    Pub/Sub service account associated with the enclosing subscription's
    parent project (i.e.,
    `service-{project_number}@gcp-sa-pubsub.iam.gserviceaccount.com`)
    must have permission to `Publish()` to this topic. The operation
    will fail if the topic does not exist. Users should ensure that
    there is a subscription attached to this topic since messages
    published to a topic with no subscriptions are lost.

  - [**`max_delivery_attempts`**](#attr-dead_letter_policy-max_delivery_attempts): *(Optional `number`)*<a name="attr-dead_letter_policy-max_delivery_attempts"></a>

    The maximum number of delivery attempts for any message. The value
    must be between 5 and 100. The number of delivery attempts is
    defined as 1 + (the sum of number of NACKs and number of times the
    acknowledgement deadline has been exceeded for the message). A NACK
    is any call to `ModifyAckDeadline` with a 0 deadline. Note that
    client libraries may automatically extend `ack_deadlines`. This
    field will be honored on a best effort basis. If this parameter is
    0, a default value of 5 is used.

- [**`retry_policy`**](#var-retry_policy): *(Optional `object(retry_policy)`)*<a name="var-retry_policy"></a>

  A policy that specifies how Pub/Sub retries message delivery for this
  subscription. If not set, the default retry policy is applied. This
  generally implies that messages will be retried as soon as possible
  for healthy subscribers. `RetryPolicy` will be triggered on NACKs or
  acknowledgement deadline exceeded events for a given message.

  The `retry_policy` object accepts the following attributes:

  - [**`minimum_backoff`**](#attr-retry_policy-minimum_backoff): *(Optional `string`)*<a name="attr-retry_policy-minimum_backoff"></a>

    The minimum delay between consecutive deliveries of a given message.
    Value should be between 0 and 600 seconds. A duration in seconds
    with up to nine fractional digits, terminated by `s`.

    Example:

    ```hcl
    3.5s
    ```

  - [**`maximum_backoff`**](#attr-retry_policy-maximum_backoff): *(Optional `string`)*<a name="attr-retry_policy-maximum_backoff"></a>

    The maximum delay between consecutive deliveries of a given message.
    Value should be between 0 and 600 seconds. A duration in seconds
    with up to nine fractional digits, terminated by `s`.

    Example:

    ```hcl
    3.5s
    ```

- [**`push_config`**](#var-push_config): *(Optional `object(push_config)`)*<a name="var-push_config"></a>

  If push delivery is used with this subscription, this field is used to
  configure it. An empty `pushConfig` signifies that the subscriber will
  pull and ack messages using API methods.

  The `push_config` object accepts the following attributes:

  - [**`oidc_token`**](#attr-push_config-oidc_token): *(Optional `object(oidc_token)`)*<a name="attr-push_config-oidc_token"></a>

    If specified, Pub/Sub will generate and attach an OIDC JWT token as
    an Authorization header in the HTTP request for every pushed
    message.

    The `oidc_token` object accepts the following attributes:

    - [**`service_account_email`**](#attr-push_config-oidc_token-service_account_email): *(**Required** `string`)*<a name="attr-push_config-oidc_token-service_account_email"></a>

      Service account email to be used for generating the OIDC token.
      The caller (for `subscriptions.create`, `subscriptions.patch`, and
      `subscriptions.modifyPushConfig` RPCs) must have the
      `iam.serviceAccounts.actAs` permission for the service account.

    - [**`audience`**](#attr-push_config-oidc_token-audience): *(Optional `string`)*<a name="attr-push_config-oidc_token-audience"></a>

      Audience to be used when generating OIDC token. The audience claim
      identifies the recipients that the JWT is intended for. The
      audience value is a single case-sensitive string. Having multiple
      values (array) for the audience field is not supported. More info
      about the OIDC JWT token audience here:
      https://tools.ietf.org/html/rfc7519#section-4.1.3 Note: if not
      specified, the Push endpoint URL will be used.

  - [**`no_wrapper`**](#attr-push_config-no_wrapper): *(Optional `object(no_wrapper)`)*<a name="attr-push_config-no_wrapper"></a>

    When set, the payload to the push endpoint is not wrapped. 
    Sets the data field as the HTTP body for delivery.

    The `no_wrapper` object accepts the following attributes:

    - [**`write_metadata`**](#attr-push_config-no_wrapper-write_metadata): *(**Required** `string`)*<a name="attr-push_config-no_wrapper-write_metadata"></a>

      When true, writes the Pub/Sub message metadata to 
      x-goog-pubsub-<KEY>:<VAL> headers of the HTTP request. 
      Writes the Pub/Sub message attributes to <KEY>:<VAL> 
      headers of the HTTP request.

  - [**`push_endpoint`**](#attr-push_config-push_endpoint): *(**Required** `string`)*<a name="attr-push_config-push_endpoint"></a>

    A URL locating the endpoint to which messages should be pushed. For
    example, a Webhook endpoint might use "https://example.com/push".

  - [**`attributes`**](#attr-push_config-attributes): *(**Required** `string`)*<a name="attr-push_config-attributes"></a>

    Endpoint configuration attributes. Every endpoint has a set of API
    supported attributes that can be used to control different aspects
    of the message delivery. The currently supported attribute is
    `x-goog-version`, which you can use to change the format of the
    pushed message. This attribute indicates the version of the data
    expected by the endpoint. This controls the shape of the pushed
    message (i.e., its fields and metadata). The endpoint version is
    based on the version of the Pub/Sub API. If not present during the
    `subscriptions.create` call, it will default to the version of the
    API used to make such call. If not present during a
    `subscriptions.modifyPushConfig` call, its value will not be
    changed. `subscriptions.get` calls will always return a valid
    version, even if the subscription was created without this
    attribute. The possible values for this attribute are:

    - v1beta1: uses the push format defined in the v1beta1 Pub/Sub API.
    - v1 or v1beta2: uses the push format defined in the v1 Pub/Sub API.

- [**`bigquery_config`**](#var-bigquery_config): *(Optional `object(bigquery_config)`)*<a name="var-bigquery_config"></a>

  If delivery to BigQuery is used with this subscription, this field is used to configure it.
  Either `push_config` or `bigquery_config` can be set, but not both.
  If both are empty, then the subscriber will pull and ack messages using API methods."

  The `bigquery_config` object accepts the following attributes:

  - [**`table`**](#attr-bigquery_config-table): *(**Required** `string`)*<a name="attr-bigquery_config-table"></a>

    The name of the table to which to write data, of the form `{projectId}.{datasetId}.{tableId}`

  - [**`use_topic_schema`**](#attr-bigquery_config-use_topic_schema): *(Optional `bool`)*<a name="attr-bigquery_config-use_topic_schema"></a>

    When `true`, use the topic's schema as the columns to write to in BigQuery, if it exists. Only one of use_topic_schema and use_table_schema can be set.

  - [**`use_table_schema`**](#attr-bigquery_config-use_table_schema): *(Optional `bool`)*<a name="attr-bigquery_config-use_table_schema"></a>

    When true, use the BigQuery table's schema as the columns to write to in BigQuery. Messages must be published in JSON format. Only one of use_topic_schema and use_table_schema can be set.

  - [**`write_metadata`**](#attr-bigquery_config-write_metadata): *(Optional `bool`)*<a name="attr-bigquery_config-write_metadata"></a>

    When `true`, write the subscription name, messageId, publishTime, attributes, and orderingKey to additional columns in the table. The subscription name, messageId, and publishTime fields are put in their own columns while all other message properties (other than data) are written to a JSON object in the attributes column.

  - [**`drop_unknown_fields`**](#attr-bigquery_config-drop_unknown_fields): *(Optional `bool`)*<a name="attr-bigquery_config-drop_unknown_fields"></a>

    When `true` and `use_topic_schema` is `true`, any fields that are a part of the topic schema that are not part of the BigQuery table schema are dropped when writing to BigQuery. Otherwise, the schemas must be kept in sync and any messages with extra fields are not written and remain in the subscription's backlog.

  - [**`service_account_email`**](#attr-bigquery_config-service_account_email): *(Optional `string`)*<a name="attr-bigquery_config-service_account_email"></a>

    The service account to use to write to BigQuery. If not specified, the Pub/Sub service agent, service-{project_number}@gcp-sa-pubsub.iam.gserviceaccount.com, is used.

- [**`cloud_storage_config`**](#var-cloud_storage_config): *(Optional `object(cloud_storage_config)`)*<a name="var-cloud_storage_config"></a>

  If delivery to Cloud Storage is used with this subscription, this field is used to configure it. Either pushConfig, bigQueryConfig or cloudStorageConfig can be set, but not combined. If all three are empty, then the subscriber will pull and ack messages using API methods.

  The `cloud_storage_config` object accepts the following attributes:

  - [**`bucket`**](#attr-cloud_storage_config-bucket): *(**Required** `string`)*<a name="attr-cloud_storage_config-bucket"></a>

    User-provided name for the Cloud Storage bucket. The bucket must be created by the user. 
    The bucket name must be without any prefix like "gs://".

  - [**`filename_prefix`**](#attr-cloud_storage_config-filename_prefix): *(Optional `string`)*<a name="attr-cloud_storage_config-filename_prefix"></a>

    (Optional) User-provided prefix for Cloud Storage filename.

  - [**`filename_suffix`**](#attr-cloud_storage_config-filename_suffix): *(Optional `string`)*<a name="attr-cloud_storage_config-filename_suffix"></a>

    (Optional) User-provided suffix for Cloud Storage filename. Must not end in "/".

  - [**`max_duration`**](#attr-cloud_storage_config-max_duration): *(Optional `string`)*<a name="attr-cloud_storage_config-max_duration"></a>

    (Optional) The maximum duration that can elapse before a new Cloud Storage file is created. 
    Min 1 minute, max 10 minutes, default 5 minutes. May not exceed the subscription's acknowledgement deadline. 
    A duration in seconds with up to nine fractional digits, ending with 's'. Example: "3.5s".

  - [**`max_bytes`**](#attr-cloud_storage_config-max_bytes): *(Optional `number`)*<a name="attr-cloud_storage_config-max_bytes"></a>

    (Optional) The maximum bytes that can be written to a Cloud Storage file before a new file is created. 
    Min 1 KB, max 10 GiB. The maxBytes limit may be exceeded in cases where messages are larger than the limit.

  - [**`avro_config`**](#attr-cloud_storage_config-avro_config): *(Optional `object(avro_config)`)*<a name="attr-cloud_storage_config-avro_config"></a>

    If set, message data will be written to Cloud Storage in Avro format.

    The `avro_config` object accepts the following attributes:

    - [**`write_metadata`**](#attr-cloud_storage_config-avro_config-write_metadata): *(Optional `bool`)*<a name="attr-cloud_storage_config-avro_config-write_metadata"></a>

      When true, write the subscription name, messageId, publishTime, attributes, and orderingKey as additional fields in the output.

### Extended Resource Configuration

- [**`iam`**](#var-iam): *(Optional `list(iam)`)*<a name="var-iam"></a>

  A list of IAM access.

  Default is `[]`.

  Example:

  ```hcl
  iam = [{
    role    = "roles/viewer"
    members = ["user:member@example.com"]
  }]
  ```

  Each `iam` object in the list accepts the following attributes:

  - [**`members`**](#attr-iam-members): *(Optional `set(string)`)*<a name="attr-iam-members"></a>

    Identities that will be granted the privilege in role. Each entry can have one of the following values:
    - `allUsers`: A special identifier that represents anyone who is on the internet; with or without a Google account.
    - `allAuthenticatedUsers`: A special identifier that represents anyone who is authenticated with a Google account or a service account.
    - `user:{emailid}`: An email address that represents a specific Google account. For example, alice@gmail.com or joe@example.com.
    - `serviceAccount:{emailid}`: An email address that represents a service account. For example, my-other-app@appspot.gserviceaccount.com.
    - `group:{emailid}`: An email address that represents a Google group. For example, admins@example.com.
    - `domain:{domain}`: A G Suite domain (primary, instead of alias) name that represents all the users of that domain. For example, google.com or example.com.
    - `computed:{identifier}`: An existing key from `var.computed_members_map`.

    Default is `[]`.

  - [**`role`**](#attr-iam-role): *(Optional `string`)*<a name="attr-iam-role"></a>

    The role that should be applied. Note that custom roles must be of the format `[projects|organizations]/{parent-name}/roles/{role-name}`.

  - [**`authoritative`**](#attr-iam-authoritative): *(Optional `bool`)*<a name="attr-iam-authoritative"></a>

    Whether to exclusively set (authoritative mode) or add (non-authoritative/additive mode) members to the role.

    Default is `true`.

- [**`policy_bindings`**](#var-policy_bindings): *(Optional `list(policy_binding)`)*<a name="var-policy_bindings"></a>

  A list of IAM policy bindings.

  Example:

  ```hcl
  policy_bindings = [{
    role    = "roles/viewer"
    members = ["user:member@example.com"]
  }]
  ```

  Each `policy_binding` object in the list accepts the following attributes:

  - [**`role`**](#attr-policy_bindings-role): *(**Required** `string`)*<a name="attr-policy_bindings-role"></a>

    The role that should be applied.

  - [**`members`**](#attr-policy_bindings-members): *(Optional `set(string)`)*<a name="attr-policy_bindings-members"></a>

    Identities that will be granted the privilege in `role`.

    Default is `var.members`.

  - [**`condition`**](#attr-policy_bindings-condition): *(Optional `object(condition)`)*<a name="attr-policy_bindings-condition"></a>

    An IAM Condition for a given binding.

    Example:

    ```hcl
    condition = {
      expression = "request.time < timestamp(\"2022-01-01T00:00:00Z\")"
      title      = "expires_after_2021_12_31"
    }
    ```

    The `condition` object accepts the following attributes:

    - [**`expression`**](#attr-policy_bindings-condition-expression): *(**Required** `string`)*<a name="attr-policy_bindings-condition-expression"></a>

      Textual representation of an expression in Common Expression Language syntax.

    - [**`title`**](#attr-policy_bindings-condition-title): *(**Required** `string`)*<a name="attr-policy_bindings-condition-title"></a>

      A title for the expression, i.e. a short string describing its purpose.

    - [**`description`**](#attr-policy_bindings-condition-description): *(Optional `string`)*<a name="attr-policy_bindings-condition-description"></a>

      An optional description of the expression. This is a longer text which describes the expression, e.g. when hovered over it in a UI.

- [**`computed_members_map`**](#var-computed_members_map): *(Optional `map(string)`)*<a name="var-computed_members_map"></a>

  A map of members to replace in `members` of various IAM settings to handle terraform computed values.

  Default is `{}`.

### Module Configuration

- [**`module_enabled`**](#var-module_enabled): *(Optional `bool`)*<a name="var-module_enabled"></a>

  Specifies whether resources in the module will be created.

  Default is `true`.

- [**`module_depends_on`**](#var-module_depends_on): *(Optional `list(dependency)`)*<a name="var-module_depends_on"></a>

  A list of dependencies.
  Any object can be _assigned_ to this list to define a hidden external dependency.

  Default is `[]`.

  Example:

  ```hcl
  module_depends_on = [
    null_resource.name
  ]
  ```

## Module Outputs

The following attributes are exported in the outputs of the module:

- [**`iam`**](#output-iam): *(`list(iam)`)*<a name="output-iam"></a>

  The iam resource objects that define access to the GCS bucket.

- [**`subscription`**](#output-subscription): *(`object(subscription)`)*<a name="output-subscription"></a>

  All attributes of the created subscription.

- [**`module_enabled`**](#output-module_enabled): *(`bool`)*<a name="output-module_enabled"></a>

  Whether this module is enabled.

## External Documentation

### Google Documentation

- PubSub: https://cloud.google.com/pubsub
- Subscriber Overview: https://cloud.google.com/pubsub/docs/subscriber

### Terraform GCP Provider Documentation

- https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)].

Given a version number `MAJOR.MINOR.PATCH`, we increment the:

1. `MAJOR` version when we make incompatible changes,
2. `MINOR` version when we add functionality in a backwards compatible manner, and
3. `PATCH` version when we make backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version

- Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
- Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)

## About Mineiros

[Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
that solves development, automation and security challenges in cloud infrastructure.

Our vision is to massively reduce time and overhead for teams to manage and
deploy production-grade and secure cloud infrastructure.

We offer commercial support for all of our modules and encourage you to reach out
if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
[Community Slack channel][slack].

## Reporting Issues

We use GitHub [Issues] to track community reported issues and missing features.

## Contributing

Contributions are always encouraged and welcome! For the process of accepting changes, we use
[Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].

## Makefile Targets

This repository comes with a handy [Makefile].
Run `make help` to see details on each available target.

## License

[![license][badge-license]][apache20]

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.

Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]


<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-google-pubsub-subscription
[hello@mineiros.io]: mailto:hello@mineiros.io
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[releases-aws-provider]: https://github.com/terraform-providers/terraform-provider-aws/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://mineiros.io/slack
[terraform]: https://www.terraform.io
[aws]: https://aws.amazon.com/
[semantic versioning (semver)]: https://semver.org/
[variables.tf]: https://github.com/mineiros-io/terraform-google-pubsub-subscription/blob/main/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-google-pubsub-subscription/blob/main/examples
[issues]: https://github.com/mineiros-io/terraform-google-pubsub-subscription/issues
[license]: https://github.com/mineiros-io/terraform-google-pubsub-subscription/blob/main/LICENSE
[makefile]: https://github.com/mineiros-io/terraform-google-pubsub-subscription/blob/main/Makefile
[pull requests]: https://github.com/mineiros-io/terraform-google-pubsub-subscription/pulls
[contribution guidelines]: https://github.com/mineiros-io/terraform-google-pubsub-subscription/blob/main/CONTRIBUTING.md
