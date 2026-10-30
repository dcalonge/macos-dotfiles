#!/bin/bash

# Madrid coordinates (open-meteo needs no API key)
LAT="40.4165"
LON="-3.70256"

# Optional per-machine override (not in the repo), e.g.:
#   HOME_SSID="MyWifi"; HOME_LAT="41.0"; HOME_LON="-2.0"
LOCAL_CONF="${CONFIG_DIR:-$HOME/.config/sketchybar}/weather.local"
if [ -f "$LOCAL_CONF" ]; then
  . "$LOCAL_CONF"
  SSID=$(ipconfig getsummary en0 2>/dev/null | awk '/^  SSID /{print substr($0, index($0, $3))}')
  if [[ -n "$HOME_SSID" && "$SSID" == "$HOME_SSID" ]]; then
    LAT="$HOME_LAT"
    LON="$HOME_LON"
  fi
fi

WEATHER_JSON=$(curl -s -m 10 "https://api.open-meteo.com/v1/forecast?latitude=$LAT&longitude=$LON&current_weather=true&temperature_unit=celsius")

TEMP=$(echo "$WEATHER_JSON" | jq -r '.current_weather.temperature // empty | floor')
CODE=$(echo "$WEATHER_JSON" | jq -r '.current_weather.weathercode // empty')
IS_DAY=$(echo "$WEATHER_JSON" | jq -r '.current_weather.is_day // 1')

RED="0xffff0000"

# Default: Nerd Font md-help_circle_outline (unknown condition)
ICON="󰘥"
COLOR="0xffffffff"
LABEL=""

if [[ -n "$TEMP" && -n "$CODE" ]]; then
  LABEL="${TEMP}°"

  # WMO weather codes -> Nerd Font "md-weather-*" (Material Design) glyphs
  case "$CODE" in
    0) [[ "$IS_DAY" == "1" ]] && ICON="󰖙" || ICON="󰖔" ;;
    1|2) [[ "$IS_DAY" == "1" ]] && ICON="󰖕" || ICON="󰼱" ;;
    3) ICON="󰖐" ;;
    45|48) ICON="󰖑" ;;
    51|53|55|56|57) ICON="󰼳" ;;
    61|63|80|81) ICON="󰖗" ;;
    65|82) ICON="󰖖" ;;
    66|67) ICON="󰙿" ;;
    71|73|85) ICON="󰼴" ;;
    75|86) ICON="󰖘" ;;
    77) ICON="󰜗" ;;
    95) ICON="󰖓" ;;
    96|99) ICON="󰙾" COLOR="$RED" ;;
  esac
fi

# Update SketchyBar
sketchybar --set weather \
  icon="$ICON" \
  icon.color="$COLOR" \
  label="$LABEL"
