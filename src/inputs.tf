variable GIT_REPOSITORY {
  type        = string
  description = "Unique identifier for the current code repository."
}

variable GIT_SHORT_SHA {
  type        = string
  description = "Unique identifier for the current code code revision within the current code repository."
}

variable PVE_HOST {
  type        = string
  description = "Proxmox hypervisor used for virtual machine provisioning."
}

variable PVE_NODE {
  type        = string
  description = "The name of the Proxmox Node on which to place the VM."
}

variable PVE_PASSWORD {
  type        = string
  description = "Password used to authenticate to the Proxmox hypervisor."
}

variable PVE_POOL {
  type        = string
  description = "The resource pool to which the VM will be added."
}

variable PVE_USER {
  type        = string
  description = "Username used to authenticate to the Proxmox hypervisor."
}

variable SALTMASTER {
  type        = string
  description = "Saltmaster used for virtual machine configuration management."
}
