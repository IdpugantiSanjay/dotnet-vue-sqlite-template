#!/usr/bin/env bash

# deploying to nginx in ubuntu 24.04

REMOTE=$1
DIST_PATH=${2:-'./dist/'}
REMOTE_USER=${3:-'{{ cookiecutter.server_user }}'}
REMOTE_DIR="{{ cookiecutter.web_deploy_path }}"

echo "Deploying {{ cookiecutter.repo_name }}-web to server $REMOTE:$REMOTE_DIR"

RSYNC_OPTIONS=" \
  --archive \
  --no-o --no-g \
  --force \
  --delete \
  --progress \
  --compress \
  --checksum \
  --verbose"

rsync_command="rsync $RSYNC_OPTIONS $DIST_PATH $REMOTE_USER@$REMOTE:$REMOTE_DIR"

echo "$rsync_command"
$rsync_command
echo "rsync complete"

# shellcheck disable=SC2029
ssh "$REMOTE_USER@$REMOTE" "chown -R $REMOTE_USER:$REMOTE_USER /home/$REMOTE_USER && sudo nginx -s reload"