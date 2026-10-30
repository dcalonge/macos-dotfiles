#!/bin/sh

PMSET_OUT="$(pmset -g batt)"
PERCENTAGE="$(echo "$PMSET_OUT" | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(echo "$PMSET_OUT" | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

case "${PERCENTAGE}" in
100 | 9[5-9]) ICON="󰁹" ;;
9[0-4]) ICON="󰂂" ;;
8[0-9]) ICON="󰂁" ;;
7[0-9]) ICON="󰂀" ;;
6[0-9]) ICON="󰁿" ;;
5[0-9]) ICON="󰁾" ;;
4[0-9]) ICON="󰁽" ;;
3[0-9]) ICON="󰁼" ;;
2[0-9]) ICON="󰁻" ;;
1[0-9]) ICON="󰁺" ;;
*) ICON="󰂃" ;;
esac

if [ "$CHARGING" != "" ]; then
  case "${PERCENTAGE}" in
  100 | 9[5-9]) ICON="󰂅" ;;
  9[0-4]) ICON="󰂋" ;;
  8[0-9]) ICON="󰂊" ;;
  7[0-9]) ICON="󰢞" ;;
  6[0-9]) ICON="󰂉" ;;
  5[0-9]) ICON="󰢝" ;;
  4[0-9]) ICON="󰂈" ;;
  3[0-9]) ICON="󰂇" ;;
  2[0-9]) ICON="󰂆" ;;
  1[0-9]) ICON="󰢜" ;;
  *) ICON="󰂌" ;;
  esac
fi

sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%"
