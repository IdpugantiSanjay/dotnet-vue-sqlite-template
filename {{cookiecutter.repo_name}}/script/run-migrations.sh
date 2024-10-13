#!/usr/bin/env bash

REMOTE=$1
SOURCE_MIGRATIONS_PATH=${2:-"./backend/db/migrations/"}
REMOTE_USER=${3:-'{{ cookiecutter.server_user }}'}
REMOTE_DIR="{{ cookiecutter.migrations_path }}"

echo "Backing up database"

ssh "$REMOTE_USER@$REMOTE" "cd {{ cookiecutter.database_dir }} && gobackup perform"

# shellcheck disable=SC2181
if [ $? != 0 ]; then
  echo "Running migrations canceled"
  exit 1
fi

echo "Database backup done"

echo "Running migrations"

RSYNC_OPTIONS=" \
  --archive \
  --no-o --no-g \
  --force \
  --delete \
  --progress \
  --compress \
  --checksum \
  --verbose"

rsync_command="rsync $RSYNC_OPTIONS $SOURCE_MIGRATIONS_PATH $REMOTE_USER@$REMOTE:$REMOTE_DIR"

echo "$rsync_command"

$rsync_command

echo "rsync complete"

# shellcheck disable=SC2029
ssh "$REMOTE_USER@$REMOTE" "GOOSE_MIGRATION_DIR=$REMOTE_DIR GOOSE_DRIVER=sqlite3 GOOSE_DBSTRING={{ cookiecutter.masterdb_path }} goose up"

# shellcheck disable=SC2181
if [ $? == 0 ]; then
  echo "Migrations ran successfully"
fi