terraform {
  required_providers {
    tfe = {
      # terraform clouid environment
      source = "hashicorp/tfe"
      #version = ">=1.0.0"
    }
    github = {
      source = "integrations/github"
      #version = "~> 6.0"
    }
  }
}


provider "github" {
}

provider "tfe" {
  # Configuration options
  hostname = var.tfe_information.hostname
}