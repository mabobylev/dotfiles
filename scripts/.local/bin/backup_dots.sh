#!/bin/bash

# Резервное копирование ключей и конфигурации в tar.gz на /mnt/data.
# Запускается из cron (текущая строка, см. crontab -l):
#   0 20 * * 0,2,4 /home/bma/.local/bin/backup_dots.sh >/dev/null 2>&1
# (Вс, Вт, Чт, Сб в 20:00; вывод cron подавлен, ошибки и результат
# пишутся в $LOG.)
#
# В архив попадают: .ssh, .gnupg, репозиторий .dotfiles (stow),
# выборочные настройки ~/.config, шрифты и метаданные для
# восстановления (crontab, списки пакетов pacman/flatpak, схема
# stow-ссылок) — на верхнем уровне архива отдельными файлами.
#
# Хранятся $KEEP последних архивов; лог построчно ротируется.
#
# Восстановление (осторожно: распаковка перезаписывает живые файлы):
#   tar -xzpf backup_dots_<дата>.tar.gz -C /tmp/restore
# ключи и конфиги скопировать в $HOME (права сохранены в архиве),
# затем stow -d ~/.dotfiles -t ~ <пакеты>; схема старых ссылок —
# в stow-links.txt из архива.

set -euo pipefail

DEST="/mnt/data/Files/backup"
MNT="/mnt/data"
KEEP=3
LOG="$DEST/backup.log"
LOG_MAX_LINES=2000
HOME_DIR="$HOME"

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="backup_dots_${DATE}.tar.gz"
META_DIR=$(mktemp -d "${TMPDIR:-/tmp}/dots-meta_${DATE}.XXXXXX")
trap 'rm -rf "${META_DIR:-}"' EXIT

log() {
    local msg
    msg="[$(date '+%F %T')] $*"
    if [[ -w "$DEST" ]]; then
        echo "$msg" >>"$LOG"
    fi
    echo "$msg" >&2
}

# 1. Диск должен быть смонтирован: иначе mkdir -p молча создаст каталог
#    на корневой ФС, и архив уйдёт «в никуда».
if ! mountpoint -q "$MNT"; then
    echo "[$(date '+%F %T')] FAIL: $MNT не смонтирован, бэкап отменён" >&2
    exit 1
fi
mkdir -p "$DEST"

# 2. Метаданные для восстановления.
crontab -l >"$META_DIR/crontab.txt" 2>/dev/null \
    || echo "(crontab отсутствует)" >"$META_DIR/crontab.txt"
if command -v pacman >/dev/null 2>&1; then
    pacman -Qqett >"$META_DIR/pacman-Qqett.txt" 2>/dev/null || true
    pacman -Qqe >"$META_DIR/pacman-Qqe.txt" 2>/dev/null || true
fi
if command -v flatpak >/dev/null 2>&1; then
    flatpak list --app --columns=application >"$META_DIR/flatpak-apps.txt" 2>/dev/null || true
fi
find "$HOME_DIR" -maxdepth 4 -type l -lname '*dotfiles*' -printf '%p -> %l\n' 2>/dev/null \
    | sort >"$META_DIR/stow-links.txt"

# 3. Список архивируемого (имена относительно $HOME_DIR).
ITEMS=(
    .ssh
    .gnupg
    .dotfiles
    .config/gtk-2.0
    .config/gtk-3.0
    .config/gtk-4.0
    .config/dconf
    .config/yazi
    .config/foot
    .config/xsettingsd
    .config/autostart
    .local/share/fonts
)

# 4. Проверка наличия; предупреждения — в лог.
FINAL_ITEMS=()
for item in "${ITEMS[@]}"; do
    if [[ -e "$HOME_DIR/$item" ]]; then
        FINAL_ITEMS+=("$item")
    else
        log "предупреждение: $item не существует, пропускаем"
    fi
done
if [[ ${#FINAL_ITEMS[@]} -eq 0 ]]; then
    log "FAIL: нет ни одного объекта для бэкапа"
    exit 1
fi

# 5. Чистим незавершённые архивы от прерванных запусков.
find "$DEST" -maxdepth 1 -name 'backup_dots_*.tar.gz.part' \
    -mmin +60 -delete 2>/dev/null || true

# 6. Атомарная запись: пишем в .part, проверяем, переименовываем.
TMPFILE="$DEST/$BACKUP_FILE.part"
if ! tar -czf "$TMPFILE" -C "$HOME_DIR" "${FINAL_ITEMS[@]}" \
        -C "$META_DIR" .; then
    log "FAIL: tar завершился с ошибкой, архив не создаётся"
    rm -f "$TMPFILE"
    exit 1
fi
if ! tar -tzf "$TMPFILE" >/dev/null 2>&1; then
    log "FAIL: созданный архив не читается: $BACKUP_FILE"
    rm -f "$TMPFILE"
    exit 1
fi
mv "$TMPFILE" "$DEST/$BACKUP_FILE"
log "OK: $BACKUP_FILE ($(du -h "$DEST/$BACKUP_FILE" | cut -f1))"

# 7. Ротация по количеству (не по времени).
find "$DEST" -maxdepth 1 -name 'backup_dots_*.tar.gz' \
    | sort -r | tail -n +$((KEEP + 1)) | xargs -r rm -f

# 8. Ротация лога.
if [[ -f "$LOG" ]] && [[ $(wc -l <"$LOG") -gt $LOG_MAX_LINES ]]; then
    tail -n $((LOG_MAX_LINES / 2)) "$LOG" >"$LOG.tmp"
    mv "$LOG.tmp" "$LOG"
fi
