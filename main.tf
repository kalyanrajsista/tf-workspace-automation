resource "tfe_workspace" "main" {
  for_each     = { for w in local.workspaces : w.name => w }
  name         = each.key
  organization = var.organization

  queue_all_runs = true

  vcs_repo {
    identifier     = each.value.repo
    branch         = each.value.branch
    oauth_token_id = var.oauth_token_id
  }
}

resource "tfe_variable" "terraform" {
  for_each     = { for v in local.tf_variables : "${v.workspace}-${v.key}" => v }
  key          = each.value.key
  value        = each.value.value
  category     = "terraform"
  workspace_id = tfe_workspace.main[each.value.workspace].id
}

resource "tfe_variable" "terraform_sensitive" {
  for_each     = { for v in local.tf_sensitive_variables : "${v.workspace}-${v.key}" => v }
  key          = each.value.key
  value        = each.value.value
  category     = "terraform"
  sensitive    = true
  workspace_id = tfe_workspace.main[each.value.workspace].id
}

resource "tfe_variable" "terraform_hcl_variables" {
  for_each     = { for v in local.tf_hcl_variables : "${v.workspace}-${v.key}" => v }
  key          = each.value.key
  value        = each.value.value
  category     = "terraform"
  hcl          = true
  sensitive    = false
  workspace_id = tfe_workspace.main[each.value.workspace].id
}

resource "tfe_variable" "environment" {
  for_each     = { for v in local.env_variables : "${v.workspace}-${v.key}" => v }
  key          = each.value.key
  value        = each.value.value
  category     = "env"
  workspace_id = tfe_workspace.main[each.value.workspace].id
}

resource "tfe_variable" "environment_sensitive" {
  for_each     = { for v in local.env_sensitive_variables : "${v.workspace}-${v.key}" => v }
  key          = each.value.key
  value        = each.value.value
  category     = "env"
  sensitive    = true
  workspace_id = tfe_workspace.main[each.value.workspace].id
}
