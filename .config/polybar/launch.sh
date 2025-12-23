#!/usr/bin/env bash

# Завершить текущие экземпляры polybar
polybar-msg cmd quit
# killall -q polybar

# Ожидание полного завершения работы процессов
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Запуск Polybar со стандартным расположением конфигурационного файла в ~/.config/polybar/config
polybar mybar &
