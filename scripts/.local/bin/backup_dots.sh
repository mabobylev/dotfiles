#!/bin/bash

# Добавьте задание в cron
# crontab -e
#
# Добавьте строку для еженедельного запуска (например, в воскресенье в 3:00):
# 0 3 * * 0 /home/bma/backup_dots.sh

# Параметры резервного копирования
HOME_DIR="/home/bma"
BACKUP_DIR="/mnt/data/Files/backup/"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="backup_dots_${DATE}.tar.gz"

# Создаём директорию для бэкапов
mkdir -p "$BACKUP_DIR"

# Список файлов и директорий для резервного копирования
FILES_AND_DIRS=(
  ".ssh"
  ".gnupg"
  ".dotfiles"
)

# Формируем команду tar
TAR_CMD="tar -czvf \"$BACKUP_DIR/$BACKUP_FILE\""

pushd $HOME_DIR || exit

for item in "${FILES_AND_DIRS[@]}"; do
  if [ -e "$item" ]; then
    TAR_CMD+=" \"$item\""
  else
    echo "Предупреждение: $item не существует, пропускаем." >>"$BACKUP_DIR/backup.log"
  fi
done

popd

# Выполняем архивацию
eval "$TAR_CMD"

# Оставляем только последние 4 бэкапа (на месяц), удаляем старые
find "$BACKUP_DIR" -type f -name "backup_dots_*.tar.gz" -mtime +5 -delete

# Логирование
echo "Backup created: $BACKUP_FILE at $(date)" >>"$BACKUP_DIR/backup.log"
