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

DB_HOST="db"
DB_NAME="$MYSQL_DATABASE"
DB_USER="$MYSQL_USER"
DB_PASSWORD="$MYSQL_PASSWORD"

sudo mkdir -p "$BACKUP_DIR"

sudo docker run --rm \
  --network netology-backend \
  -v "$BACKUP_DIR":/backup \
  -e MYSQL_HOST="db" \
  -e MYSQL_DATABASE="$MYSQL_DATABASE" \
  -e MYSQL_USER="$MYSQL_USER" \
  -e MYSQL_PASSWORD="$MYSQL_PASSWORD" \
  schnitzler/mysqldump \
  mysqldump --mock-arg > "$BACKUP_DIR/$BACKUP_FILE"

