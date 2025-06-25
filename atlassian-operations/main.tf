terraform {
  required_providers {
    atlassian-operations = {
      source  = "atlassian/atlassian-operations"
      version = ">= 1.0.1, < 2.0.0"
    }
  }
}

data "http" "remote_config" {
  url = var.configs_url

  request_headers = {
    Accept = "application/json"
  }
}

locals {
  remote_config    = jsondecode(data.http.remote_config.response_body)
  schedules        = local.remote_config.schedules
  api_integrations = local.remote_config.api_integrations
}

provider "atlassian-operations" {
  alias         = "chaos"
  token         = var.atlassian_ops_token
  email_address = var.atlassian_ops_api_email_address
  domain_name   = var.atlassian_ops_domain_name
  cloud_id      = var.atlassian_ops_cloud_id
}


data "atlassian-operations_team" "chaos" {
  organization_id = var.org_id
  id              = var.jira_team_id
  provider        = atlassian-operations.chaos
}


resource "atlassian-operations_team" "ord" {
  provider        = atlassian-operations.chaos
  organization_id = data.atlassian-operations_team.chaos.organization_id
  display_name    = data.atlassian-operations_team.chaos.display_name
  team_type       = data.atlassian-operations_team.chaos.team_type
  description     = data.atlassian-operations_team.chaos.description
  member          = data.atlassian-operations_team.chaos.member
}

data "atlassian-operations_schedule" "ord" {
  for_each = { for schedule in local.schedules : schedule.name => schedule }
  name     = each.value.name
  provider = atlassian-operations.chaos
}

resource "atlassian-operations_schedule" "ord" {
  provider    = atlassian-operations.chaos
  for_each    = { for schedule in data.atlassian-operations_schedule.chaos : schedule.name => schedule }
  name        = each.key
  team_id     = data.atlassian-operations_team.chaos.id
  description = each.value.description
  timezone    = each.value.timezone
}

resource "atlassian-operations_api_integration" "ord" {
  provider = atlassian-operations.chaos
  for_each = { for api_integration in local.api_integrations : api_integration.name => api_integration }
  name     = each.key
  team_id  = data.atlassian-operations_team.chaos.id
  type     = each.value.type
  enabled  = each.value.enabled
}

// missing: roles, heartbeats, etc

