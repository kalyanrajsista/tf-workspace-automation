variable "azurerm_subscription_id" {
  type        = string
  description = "Azure Subscription ID."
}

variable "azurerm_client_id" {
  type        = string
  description = "Client ID of Azure Subscription."
}

variable "azurerm_tenant_id" {
  type        = string
  description = "Tenant ID."
}

variable "azurerm_client_secret" {
  type        = string
  description = "Client Secret."
}

variable "name_prefix" {
  type        = string
  description = "Creates a unique name beginning with the specified prefix."
}

variable "hostname" {
  type    = string
  default = "app.terraform.io"
}

variable "organization" {
  type        = string
  description = "The name of the organization."
}

variable "token" {
  type    = string
  default = ""
}

variable "region" {
  type    = string
  default = "West US"
}

variable "application" {
  type    = string
  default = "demo"
}

variable "environments" {
  type        = set(string)
  description = "A set of distinct environment names to be used in the project."
}

variable "workspaces" {
  type = list(object({
    name                    = string
    repo                    = string
    branch                  = string
    tf_variables            = map(string)
    tf_hcl_variables        = map(string)
    tf_sensitive_variables  = map(string)
    env_variables           = map(string)
    env_sensitive_variables = map(string)
  }))
  description = "A list of `workspaces` objects to be used in the project."
}

variable "custom_tags" {
  type = map(string)
  default = {
    "\"BillingIdentifier\"" = "UNA"
    "\"Department\""        = "Infrastructure"
  }
}

variable "run_triggers" {
  type        = map(list(string))
  default     = {}
  description = "A mapping from each workspace name to a list of sourceable workspace names."
}

variable "queue_runs" {
  type        = list(string)
  default     = []
  description = "A list of workspace names for which all runs should be queued."
}

variable "oauth_token_id" {
  type        = string
  description = "The token ID of the VCS Connection (OAuth Conection Token) to use in Terraform Cloud."
}
