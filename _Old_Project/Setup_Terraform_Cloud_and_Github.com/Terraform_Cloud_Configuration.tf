
variable "tfe_information" {
  type = object({
    hostname                     = string #"The Terraform Cloud/Enterprise hostname to connect to"
    oauth_name                   = string
    organization                 = string #"Terraform Cloud organization"
    github_personal_access_token = string #"Github Personal Access token"
  })
  default = {
    hostname                     = "app.terraform.io"
    oauth_name                   = "terraform-cloud-github"
    organization                 = "vcloudlab"
    github_personal_access_token = ""
  }
}

########################

resource "tfe_oauth_client" "github" {
  name             = var.tfe_information.oauth_name
  organization     = var.tfe_information.organization
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = var.tfe_information.github_personal_access_token
  service_provider = "github"
}