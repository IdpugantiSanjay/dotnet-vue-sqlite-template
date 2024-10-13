#cloud-config


disable_root: true
package_update: true
package_upgrade: true
timezone: "Asia/Kolkata"
hostname: ${HOST_NAME}

preserved_hostname: false
ssh_pwauth: false


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

apt:
  primary:
    - arches: [default]
      uri: http://in.archive.ubuntu.com/ubuntu/

packages:
  - curl
  - git
  - fzf
  - ca-certificates
  - apt-transport-https
  - gnupg
  - dotnet-sdk-8.0
  - ufw
  - nodejs
  - npm
  - wget
  - sqlite3
  - just
  - shellcheck

write_files:
  - path: /home/${DEFAULT_USER}/.ssh/id_rsa
    content: |
      ${DEFAULT_USER_SSH_PRIVATE_KEY}
    owner: ${DEFAULT_USER}:${DEFAULT_USER}
    permissions: '0600'

bootcmd:
  - mkdir -p /home/${DEFAULT_USER}/.ssh

runcmd:
  - wget -O /usr/local/bin/sysz https://github.com/joehillen/sysz/releases/latest/download/sysz
  - chmod +x /usr/local/bin/sysz
  - sudo snap install btop scc
  - sudo snap install helix --classic


  - echo "Installing docker"
  - curl -fsSL https://get.docker.com -o get-docker.sh
  - sudo sh ./get-docker.sh
  - sudo groupadd docker
  - sudo usermod -aG docker server
  - rm ./get-docker.sh

  - echo "Installing node and npm"
  - curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
  - sudo apt-get install -y nodejs

  - echo "Installing gitleaks"
  - wget https://github.com/gitleaks/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz
  - tar -xzf gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz
  - sudo mv gitleaks /usr/local/bin/

  - echo "Installing goose"
  - curl -fsSL https://raw.githubusercontent.com/pressly/goose/master/install.sh | sudo sh
  
  - echo "Installing typos-cli"
  - curl -O https://raw.githubusercontent.com/crate-ci/gh-install/master/v1/install.sh
  - chmod +x install.sh
  - ./install.sh --git crate-ci/typos --to /usr/local/bin/ --target x86_64-unknown-linux-musl
  - rm ./install.sh

  - echo "Installing hurl"
  - echo "curl --location --remote-name https://github.com/Orange-OpenSource/hurl/releases/download/${HURL_VERSION}/hurl_${HURL_VERSION}_amd64.deb"
  - curl --location --remote-name https://github.com/Orange-OpenSource/hurl/releases/download/${HURL_VERSION}/hurl_${HURL_VERSION}_amd64.deb
  - echo "sudo apt update && sudo apt install ./hurl_${HURL_VERSION}_amd64.deb"
  - sudo apt update && sudo apt install ./hurl_${HURL_VERSION}_amd64.deb
  - echo "Done installing hurl"

  - echo "Installing dotenv-linter"
  - curl -sSfL https://git.io/JLbXn | sh -s

  - echo "Installing git-cliff"
  - wget https://github.com/orhun/git-cliff/releases/download/v${GIT_CLIFF_VERSION}/git-cliff-${GIT_CLIFF_VERSION}.deb
  - sudo apt update && sudo apt install ./git-cliff-${GIT_CLIFF_VERSION}.deb

  - echo "Installing envsubst"
  - curl -L https://github.com/a8m/envsubst/releases/download/v${ENVSUBST_VERSION}/envsubst-`uname -s`-`uname -m` -o envsubst
  - chmod +x envsubst
  - sudo mv envsubst /usr/local/bin

  - echo "Installing gobackup"
  - curl -sSL https://gobackup.github.io/install | sh

  - echo "Installing gitlab runner"
  - curl -L --output /usr/local/bin/gitlab-runner "https://s3.dualstack.us-east-1.amazonaws.com/gitlab-runner-downloads/latest/binaries/gitlab-runner-linux-amd64"
  - chmod +x /usr/local/bin/gitlab-runner
  - useradd --comment "GitLab Runner" --create-home gitlab-runner --shell /bin/bash
  - gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner
  - gitlab-runner start

  - echo "Create log directory for gitlab-runner"
  - mkdir -p /var/log/gitlab-runner
  - chown -R gitlab-runner:gitlab-runner /var/log/gitlab-runner
  - chmod -R 700 /var/log/gitlab-runner

  - chown -R ${DEFAULT_USER}:${DEFAULT_USER} /home/${DEFAULT_USER}/.ssh


final_message: "The system is finally up, after $UPTIME seconds"