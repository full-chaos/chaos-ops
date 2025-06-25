# Chaos Atlassian Operations

Quick provisoining of Atlassian Ops tools using Terraform.

## Prerequisites

Before you can use this project, you'll need to have the following installed:

- [Terraform](https://www.terraform.io/downloads.html) (version X.X.X or later)
- [AWS CLI](https://aws.amazon.com/cli/) (if using AWS)
- [Other prerequisites, if any]

## Getting Started

### Pre-requisites

```sh
brew tap hasicorp/tab
brew install terraform awscli aws-export-credentials glab
# Or use docker if you prefer.
docker run -rm -v ./:/app -w /app hashicorp/terraform:latest <cmd>
```

1. Initialize Terraform:

```sh
terraform init
```

2. Select your workspace.

NOTE: This is important for deploy anything. They're set up for:

3. Select your workspace:

```sh
terraform workspace select <workspace_name>
# or
export TF_WORKSPACE=<workspace_name>
```

4. Plan and apply

```sh
# ENV=<environment> e.g. dev, staging, prod
terraform plan -var-file=env/${ENV}.tfvars -out=${ENV}.plan
terraform apply ${ENV}.plan
```

## TIPS AND TRICKS

### DIFFICULT TO REMOVE STATE / BLOCKED ON APPLY

#### Shared objects

There will always be a need for multiple apps to share the same objects. An example would be an Responder Team for on-call/support or a slack channel for notifications.

To remove a resource from a state file, you can use the `terraform state rm` command to avoid destroying the object that others are attached to.

Try your best to use modules and variable/dynamic objects

```sh
# remove it from the state
# ressource_class might not be needed as you can use the type e.g module.atlassian-operations.atlassian-operations_schedule
terraform state rm <resource_class.resource_type.resource_id>
```

Run `terraform plan` again, and you'll see it is gone. Then you can apply

### Blocked on apply

The opposite can happen as well. You might have an object that's in your environment and provisioned.

Normally, you don't want to use terraform 1.5 like at the time this was written. Then you can use `data` objects/resources to pull items in.

Here use import.

```sh
terraform import <resource_class.resource_type> <resource_id>
```

Re-run `plan` and `apply`.
