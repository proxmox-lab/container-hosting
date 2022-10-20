terraform {
  required_version = ">= 0.14"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.35.0"
    }

    external = {
      source = "hashicorp/external"
      version = "2.2.2"
    }
    template = {
      source = "hashicorp/template"
      version = "2.2.0"
    }
    null = {
      source = "hashicorp/null"
      version = "3.1.1"
    }
    proxmox = {
      source = "Telmate/proxmox"
      version = "2.9.11"
    }
  }
  backend "s3" {}
}

provider "aws" {}

provider "proxmox" {
  pm_tls_insecure = true
}
