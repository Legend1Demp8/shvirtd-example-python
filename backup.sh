#!/bin/bash

set -e

BACKUP_DIR="/opt/backup"
BACKUP_FILE="mysql_backup_$(date +%Y%m%d_%H%M%S).sql"
ENV_FILE="/opt/shvirtd-example-python/.env"

if [ -f "$ENV_FILE" ]; then
    export $(grep -v '^#' "$ENV_FILE" | xargs)
else
    echo "❌ Ошибка: Файл настроек $ENV_FILE не найден на сервере!"
    exit 1
fi

sudo mkdir -p "$BACKUP_DIR"

sudo docker run \
  --rm \
  --entrypoint "" \
  --network netology-backend \
  -v "$BACKUP_DIR":/backup \
  mysql:8.0 \
  mysqldump --opt -h "db" -u "root" -p"$MYSQL_ROOT_PASSWORD" --result-file="/backup/$BACKUP_FILE" "$MYSQL_DATABASE"
