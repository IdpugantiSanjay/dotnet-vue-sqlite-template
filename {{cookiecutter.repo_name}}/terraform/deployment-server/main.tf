terraform {
  required_providers {
    lxd = {
      source = "terraform-lxd/lxd"
    }
  }
}


provider "lxd" {

}

locals {
  cloud-init = templatefile("${path.module}/cloud-init.yaml.tpl", {
    HOST_NAME                    = var.deployment_server_hostname
    DEFAULT_USER                 = var.default_user
    DEFAULT_USER_PASSWORD        = var.default_user_password
    DEFAULT_USER_SSH_PUBLIC_KEY  = var.default_user_ssh_public_key
    DEFAULT_USER_SSH_PRIVATE_KEY = indent(6, var.default_user_ssh_private_key)
  })
}

resource "lxd_profile" "deployment-server" {
  name        = "deployment-server"
  description = "deployment-server profile"

  config = {
    "limits.cpu"           = "4"
    "limits.memory"        = "8GiB"
    "security.nesting"                     = "true"
    "security.syscalls.intercept.setxattr" = "true"
    "security.syscalls.intercept.mknod"    = "true"
    "cloud-init.user-data" = local.cloud-init
  }
}

resource "lxd_instance" "deployment-server" {
  name     = var.deployment_server_hostname
  image    = "ubuntu:24.04"
  profiles = ["default", "${lxd_profile.deployment-server.name}"]
}