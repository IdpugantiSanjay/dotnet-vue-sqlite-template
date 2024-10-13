terraform {
  required_providers {
    lxd = {
      source = "terraform-lxd/lxd"
    }
  }
}


provider "lxd" {

}


# https://documentation.ubuntu.com/lxd/en/latest/reference/instance_options/
resource "lxd_profile" "build-server" {
  name        = "build-server"
  description = "Gitlab build-server profile"

  config = {
    "limits.cpu"                           = "2"
    "limits.memory"                        = "4GiB"
    "security.nesting"                     = "true"
    "security.syscalls.intercept.setxattr" = "true"
    "security.syscalls.intercept.mknod"    = "true"
    "cloud-init.user-data" = templatefile("${path.module}/cloud-init.yaml.tpl", {
      HOST_NAME                    = var.build_server_hostname
      DEFAULT_USER                 = var.default_user
      DEFAULT_USER_PASSWORD        = var.default_user_password
      DEFAULT_USER_SSH_PUBLIC_KEY  = var.default_user_ssh_public_key
      DEFAULT_USER_SSH_PRIVATE_KEY = indent(6, var.default_user_ssh_private_key)
      GITLEAKS_VERSION             = var.gitleaks_version
      HURL_VERSION                 = var.hurl_version
      GIT_CLIFF_VERSION            = var.git_cliff_version
      ENVSUBST_VERSION             = var.envsubst_version
    })
  }
}

# lxc storage show docker
# lxc storage volume list


resource "lxd_volume" "build_server-volume" {
  name = "build-server-volume"
  type = "custom"
  pool = "docker"
  config = {
    "size" = "10GB"
  }
}

resource "lxd_instance" "build-server" {
  name     = var.build_server_hostname
  image    = "ubuntu:24.04"
  profiles = ["default", "${lxd_profile.build-server.name}"]

  device {
    name = "${var.build_server_hostname}_volume"
    type = "disk"
    properties = {
      path   = "/var/lib/docker"
      source = lxd_volume.build_server-volume.name
      pool   = "docker"
    }
  }
}


# command to check if all tools are installed
# for prog in git fzf curl dotnet ufw node npm wget sqlite3 just shellcheck btop scc helix docker gitleaks typos hurl dotenv-linter git-cliff envsubst gitlab-runner gobackup; do command -v "$prog" >/dev/null 2>&1 && printf "" || echo "$prog is not installed"; done