#cloud-config

disable_root: true
package_update: true
package_upgrade: true
timezone: "Asia/Kolkata"
hostname: ${HOST_NAME}

preserved_hostname: false
ssh_pwauth: false
ssh_deletekeys: false

ssh:
  emit_keys_to_console: false

chpasswd:
  expire: false
  users:
  - {name: $DEFAULT_USER, password: $DEFAULT_USER_PASSWORD, type: text}


system_info:
  default_user:
    name: ${DEFAULT_USER}
    shell: /bin/bash
    sudo: "ALL=(ALL) ALL"
    lock_passwd: true # Disable password login after first use
    ssh_authorized_keys:
      - ${DEFAULT_USER_SSH_PUBLIC_KEY}

write_files:
  - path: /home/${DEFAULT_USER}/.ssh/id_rsa
    content: |
      ${DEFAULT_USER_SSH_PRIVATE_KEY}
    owner: ${DEFAULT_USER}:${DEFAULT_USER}
    permissions: '0600'

packages:
  - rsync
  - dotnet-sdk-8.0
  - ufw
  - sqlite3
  - nginx


bootcmd:
  - mkdir -p /home/${DEFAULT_USER}/.ssh

runcmd:
  - sudo snap install btop

  - echo "Installing goose"
  - curl -fsSL https://raw.githubusercontent.com/pressly/goose/master/install.sh | sudo sh

  - echo "Installing gobackup"
  - curl -sSL https://gobackup.github.io/install | sh

  - mkdir -p /var/log/{{ cookiecutter.repo_name }}-api
  - chown -R ${DEFAULT_USER}:${DEFAULT_USER} /var/log/{{ cookiecutter.repo_name }}-api

  - mkdir -p /home/{{ cookiecutter.server_user }}/{{ cookiecutter.repo_name }}/publish
  - mkdir -p /home/{{ cookiecutter.server_user }}/{{ cookiecutter.repo_name }}/db/migrations
  - mkdir -p /home/{{ cookiecutter.server_user }}/{{ cookiecutter.repo_name }}/db/migrations
 
  - ufw enable
  - ufw default deny incoming
  - ufw allow 'Nginx HTTP'
  - ufw allow ssh
  - ufw reload

  - chown -R ${DEFAULT_USER}:${DEFAULT_USER} /home/${DEFAULT_USER}/.ssh

final_message: "The system is finally up, after $UPTIME seconds"