#!/usr/bin/env bash

REMOTE=$1
PUBLISH_PATH=${2:-'./publish/'}
REMOTE_USER=${3:-'{{ cookiecutter.server_user }}'}
REMOTE_DIR="{{ cookiecutter.backend_deploy_path }}"

echo "Deploying {{ cookiecutter.repo_name }}-api to server $REMOTE:$REMOTE_DIR"

RSYNC_OPTIONS=" \
  --archive \
  --no-o --no-g \
  --force \
  --delete \
  --progress \
  --compress \
  --checksum \
  --verbose"

rsync_command="rsync $RSYNC_OPTIONS $PUBLISH_PATH $REMOTE_USER@$REMOTE:$REMOTE_DIR"

echo "$rsync_command"
$rsync_command
echo "rsync complete"

ssh "$REMOTE_USER@$REMOTE" "sudo systemctl restart {{ cookiecutter.repo_name }}-api.service"