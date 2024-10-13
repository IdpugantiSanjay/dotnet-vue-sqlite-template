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


variable "default_user_ssh_private_key" {
  type      = string
  sensitive = true
}

variable "deployment_server_hostname" {
  type        = string
  default     = "{{ cookiecutter.repo_name }}-server"
  description = "hostname of the system"
}