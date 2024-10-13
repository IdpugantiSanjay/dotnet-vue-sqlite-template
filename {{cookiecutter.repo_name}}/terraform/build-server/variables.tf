variable "default_user" {
  default     = "{{ cookiecutter.server_user }}"
  type        = string
  description = "Default system user"
  nullable    = false
  sensitive   = true
}

variable "default_user_password" {
  type      = string
  sensitive = true
}

variable "default_user_ssh_public_key" {
  type      = string
  sensitive = true
}

variable "build_server_hostname" {
  type        = string
  default     = "build-server"
  description = "hostname of the system"
}


variable "default_user_ssh_private_key" {
  type      = string
  sensitive = true
}

# https://github.com/orhun/git-cliff/releases
variable "git_cliff_version" {
  default     = "2.6.1"
  type        = string
  description = "git-cliff tool version to download"
}


# https://github.com/Orange-OpenSource/hurl/releases
variable "hurl_version" {
  default     = "5.0.1"
  type        = string
  description = "hurl tool version to download"
}

# https://github.com/gitleaks/gitleaks/releases
variable "gitleaks_version" {
  default     = "8.20.0"
  type        = string
  description = "gitleaks tool version to download"
}

# https://github.com/a8m/envsubst/releases
variable "envsubst_version" {
  default     = "1.4.2"
  type        = string
  description = "envsubst tool version to download"
}