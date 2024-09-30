terraform {
  cloud {
    hostname     = "app.terraform.io"
    organization = "vcloudlab"
    workspaces {
      name = "vcloud-lab-dev"
    }
  }
}

##################

variable "subscription_id" {
  type    = string
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

##################

variable "subnet" {
  type = map(object({
    name                 = string
    resource_group_name  = string
    virtual_network_name = string
    address_prefixes     = list(string)
  }))
  default = {
    subnet1 = {
      name                 = "subnet1"
      resource_group_name  = "dev"
      virtual_network_name = "dev-vnet"
      address_prefixes     = ["10.0.1.0/24"]
    }
    # subnet2 = {
    #   name                 = "subnet2"
    #   resource_group_name  = "dev"
    #   virtual_network_name = "dev-vnet"
    #   address_prefixes     = ["10.0.2.0/24"]
    # }
    # subnet3 = {
    #   name                 = "subnet2"
    #   resource_group_name  = "dev"
    #   virtual_network_name = "dev-vnet"
    #   address_prefixes     = ["10.0.3.0/24"]
    # }
  }
}

##################

resource "azurerm_subnet" "subnet" {
  for_each             = var.subnet
  name                 = each.value.name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
  address_prefixes     = each.value.address_prefixes
}

##################

output "subnet_id" {
  value = { for key, subnet in azurerm_subnet.subnet : key => subnet.id }
}