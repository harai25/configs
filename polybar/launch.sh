#!/bin/bash

# Убиваем старые экземпляры
killall -q polybar

# Ждём, пока процессы завершатся
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Получаем список мониторов
monitors=$(polybar --list-monitors | cut -d":" -f1)

# Запускаем polybar на каждом мониторе
for monitor in $monitors; do
    MONITOR="$monitor" polybar --reload main &
done

echo "Bars launched..."
