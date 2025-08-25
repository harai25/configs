#!/usr/bin/env bash


# Получаем текущий sink
SINK=$(pactl info | grep 'Default Sink' | awk '{print $3}')

# Получаем список sink'ов
SINKS=($(pactl list short sinks | awk '{print $2}'))

if [ ${#SINKS[@]} -eq 0 ]; then
    exit 1
fi

# Находим индекс текущего sink
CURRENT_INDEX=-1
for i in "${!SINKS[@]}"; do
    if [[ "${SINKS[i]}" == "$SINK" ]]; then
        CURRENT_INDEX=$i
        break
    fi
done

# Если не нашли — выбираем 0
if [ $CURRENT_INDEX -eq -1 ]; then
    CURRENT_INDEX=0
fi

# Следующий sink
NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#SINKS[@]} ))
NEXT_SINK="${SINKS[NEXT_INDEX]}"

# Меняем дефолтный sink
pactl set-default-sink "$NEXT_SINK"

# Перемещаем активные потоки
pactl list short sink-inputs | while read line; do
    if [ -z "$line" ]; then
        continue
    fi
    INPUT_ID=$(echo "$line" | awk '{print $1}')
    pactl move-sink-input "$INPUT_ID" "$NEXT_SINK"
done
