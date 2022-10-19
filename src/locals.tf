locals {
  description      = "Provides hosting environment for Kubernetes and Docker."
  domain           = "home.local"
  golden_image     = "centos-2009-master-7a750ca6f"
  iam_role_name    = "salte-managed-instance"
  ip_addresses     = [
      "192.168.1.3"
  ]
  name             = terraform.workspace == "production" ? "container-host" : "container-host-${terraform.workspace}"
  salt_environment = terraform.workspace == "production" ? "base" : "development"
  salt_role        = "kubernetes"
  tags             = {
    git_repository = var.GIT_REPOSITORY
    git_short_sha  = var.GIT_SHORT_SHA
    description    = "Managed by Terraform"
  }
}
