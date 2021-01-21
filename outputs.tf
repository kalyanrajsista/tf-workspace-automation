output "name_prefix" {
  value       = var.name_prefix
  description = "Echoes back the `name_prefix` input variable value, for convenience if passing the result of this module elsewhere as an object."
}

output "organization" {
  value       = var.organization
  description = "Echoes back the `organization` input variable value, for convenience if passing the result of this module elsewhere as an object."
}

output "environments" {
  value       = var.environments
  description = "Echoes back the `environments` input variable value, for convenience if passing the result of this module elsewhere as an object."
}

output "workspaces" {
  value = {
    for w in local.workspaces : w.name => {
      id           = tfe_workspace.main[w.name].id
      name         = w.name
      repo         = w.repo
      tf_variables = w.tf_variables
      #tf_sensitive_variables = w.tf_sensitive_variables
      #env_variables          = w.env_variables
      #env_sensitive_variables = w.env_sensitive_variables
      tf_hcl_variables = w.tf_hcl_variables
      #custom_tags      = w.custom_tags
    }
  }
  description = "A mapping from each workspace name to an object describing the workspace and it's variables."
}

# output "hcl_vars" {
#   value = {
#     for w in local.workspaces : w.name => {
#       custom_tags = "${join("\n", [for s, t in w.custom_tags : format("%s=%s", s, t)])}"
#     }
#   }
# }
#
output "vars" {
  value = local.tf_hcl_variables
}
