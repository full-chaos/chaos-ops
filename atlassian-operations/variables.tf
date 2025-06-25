# The atlassian variables are envars that are static
# ATLASSIAN_OPS_CLOUD_ID
# ATLASSIAN_OPS_API_TOKEN
# ATLASSIAN_OPS_DOMAIN_NAME
# ATLASSIAN_OPS_API_EMAIL_ADDRESS

variable "configs_url" {
  description = "The URL to fetch remote configuration from"
  type        = string
}

variable "org_id" {
  description = "Organization ID for Atlassian"
  type        = string
}
variable "team_name" {
  description = "Team name for Ops on call"
  type        = string
  default     = "Chaos Ops"
}

variable "team_id" {
  description = "Team ID for JSM on call"
  type        = string
}

variable "atlassian_ops_cloud_id" {
  description = "Cloud ID for Opsgenie"
  type        = string
}

variable "atlassian_ops_domain_name" {
  description = "Domain name for JIRA"
  type        = string
  default     = "fullchaos.atlassian.net"
}

variable "atlassian_ops_api_token" {
  description = "Jira token for Atlassian Ops"
  type        = string
  default     = ""
}

# Optional: only used if you don't use a token
variable "atlassian_ops_api_email_address" {
  description = "Email address for Atlassian Ops"
  type        = string
  default     = ""
}

variable "schedules" {
  description = "Atlassian Ops schedules"
  default     = []
  type = list(
    object({
      name     = string
      team_id  = string
      timezone = optional(string, "America/Los_Angeles")
      }
    )
  )
}

variable "api_integrations" {
  description = "Atlassian OpsAPI integrations"
  default     = []
  type = list(
    object({
      id         = string
      customerId = string
      name       = string
      teamId     = string
      type       = string
      enabled    = bool
      }
    )
  )
}

variable "members" {
  description = "Members of the team"
  type = list(object({
    account_id    = string
    display_name  = string
    email_address = string
    role          = optional(string, "MEMBER")
    timezone      = optional(string, "America/Los_Angeles")
  }))
  default = []
}
