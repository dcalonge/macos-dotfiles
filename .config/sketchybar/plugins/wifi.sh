#!/bin/bash

INFO=$(ipconfig getsummary en0 2>/dev/null)
SSID=$(echo "$INFO" | awk '/^  SSID /{print $3}')

if [ -z "$SSID" ]; then
  sketchybar --set wifi icon="󰤮" label=""
else
  RSSI=$(system_profiler SPAirPortDataType 2>/dev/null | awk '/Signal \/ Noise/{print $4; exit}' | tr -d '-')
  # RSSI is a positive number now (e.g. 60 for -60 dBm); lower = stronger signal
  if [ -z "$RSSI" ] || [ "$RSSI" -le 50 ]; then
    ICON="󰤨"  # excellent (>= -50)
  elif [ "$RSSI" -le 60 ]; then
    ICON="󰤥"  # good (-51 to -60)
  elif [ "$RSSI" -le 70 ]; then
    ICON="󰤢"  # fair (-61 to -70)
  elif [ "$RSSI" -le 80 ]; then
    ICON="󰤟"  # weak (-71 to -80)
  else
    ICON="󰤯"  # very weak (< -80)
  fi
  sketchybar --set wifi icon="$ICON" label="$SSID"
fi
