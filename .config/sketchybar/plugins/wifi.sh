#!/bin/bash

SSID=$(ipconfig getsummary en0 2>/dev/null | awk '/^  SSID /{print substr($0, index($0, $3))}')
#networksetup -listpreferredwirelessnetworks en0 | grep -v '^Preferred networks on' | head -1 | xargs

if [ -z "$SSID" ]; then
  sketchybar --set wifi icon="󰤮" label=""
else
  RSSI=$(swift -e 'import CoreWLAN; if let i=CWWiFiClient.shared().interface(){ print(i.rssiValue()) }' 2>/dev/null)
  if [ "$RSSI" -ge -50 ]; then
    ICON="󰤨" # excellent (>= -50 dBm)
  elif [ "$RSSI" -ge -60 ]; then
    ICON="󰤥" # good (-51 to -60)
  elif [ "$RSSI" -ge -70 ]; then
    ICON="󰤢" # fair (-61 to -70)
  elif [ "$RSSI" -ge -80 ]; then
    ICON="󰤟" # weak (-71 to -80)
  else
    ICON="󰤯" # very weak (< -80)
  fi
  sketchybar --set wifi icon="$ICON" label="$SSID"
fi
