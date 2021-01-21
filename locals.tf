locals {
  region       = lower(trimspace(replace(var.region, " ", "")))
  region_short = local.region == "westus" ? "WU" : "EU"

  queue_runs = [
    for p in setproduct(var.queue_runs, var.environments) :
    format("%s-%s-%s", var.name_prefix, p[0], p[1])
  ]

  # The "tfe_workspace" resource only deal with one workspace at a time,
  # so we need to flatten these.
  workspaces = flatten([
    for w in var.workspaces : [
      for e in var.environments : {
        name                   = format("%s-%s-%s-%s-%s", upper(var.name_prefix), upper(e), local.region_short, upper(var.application), upper(w.name))
        repo                   = w.repo
        branch                 = w.branch
        environment            = e
        application            = w.name
        tf_variables           = w.tf_variables
        tf_hcl_variables       = w.tf_hcl_variables
        tf_sensitive_variables = w.tf_sensitive_variables

        env_variables = merge(w.env_variables, {
          "ARM_SUBSCRIPTION_ID" = "${var.azurerm_subscription_id}"
          "ARM_CLIENT_ID"       = "${var.azurerm_client_id}"
          "ARM_TENANT_ID"       = "${var.azurerm_tenant_id}"
        })

        env_sensitive_variables = merge(w.env_sensitive_variables, {
          "ARM_CLIENT_SECRET" = "${var.azurerm_client_secret}"
        })

        # custom_tags = merge(w.tf_hcl_variables, var.custom_tags, {
        #   "\"NamePrefix\""      = "${var.name_prefix}"
        #   "\"EnvironmentType\"" = "${e}"
        #   "\"Application\""     = "${w.name}"
        #   "\"ProductType\""     = "${var.application}"
        #   }
        # )
      }
    ]
  ])

  # The "tfe_variable" resource only deal with one variable at a time,
  # so we need to flatten these.
  tf_variables = flatten([
    for w in local.workspaces : [
      for k, v in w.tf_variables : {
        workspace = w.name
        key       = k
        value     = v
      }
    ]
  ])

  # The "tfe_variable" resource only deal with one variable at a time,
  # so we need to flatten these.
  tf_sensitive_variables = flatten([
    for w in local.workspaces : [
      for k, v in w.tf_sensitive_variables : {
        workspace = w.name
        key       = k
        value     = v
      }
    ]
  ])

  tf_hcl_variables = flatten([
    for w in local.workspaces : [
      for k, v in w.tf_hcl_variables : {
        workspace = w.name
        key       = k
        value     = v
      }
    ]
  ])

  # The "tfe_variable" resource only deal with one variable at a time,
  # so we need to flatten these.
  env_variables = flatten([
    for w in local.workspaces : [
      for k, v in w.env_variables : {
        workspace = w.name
        key       = k
        value     = v
      }
    ]
  ])

  # The "tfe_variable" resource only deal with one variable at a time,
  # so we need to flatten these.
  env_sensitive_variables = flatten([
    for w in local.workspaces : [
      for k, v in w.env_sensitive_variables : {
        workspace = w.name
        key       = k
        value     = v
      }
    ]
  ])

  # The "tfe_run_trigger" resource only deal with one variable at a time,
  # so we need to flatten these.
  run_triggers = flatten([
    for k, v in var.run_triggers : [
      for p in setproduct(v, var.environments) : {
        workspace  = format("%s-%s-%s", var.name_prefix, k, p[1])
        sourceable = format("%s-%s-%s", var.name_prefix, p[0], p[1])
      }
    ]
  ])
}
