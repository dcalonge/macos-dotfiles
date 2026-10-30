#!/bin/bash

# Called per-space: aerospace.sh <workspace_id>
sid="$1"
ACTIVE=$(aerospace list-workspaces --focused)

get_icon() {
  case "$1" in
  # Browsers
  "") echo "Desktop" ;;
  *"Safari"*) echo "" ;;
  "Firefox") echo "󰈹" ;;
  "Google Chrome") echo "" ;;
  "Chromium") echo "" ;;
  "Brave Browser") echo "" ;;
  # Terminals
  "Terminal") echo "" ;;
  "iTerm2") echo "" ;;
  "Alacritty") echo "" ;;
  "kitty") echo "" ;;
  # Editors & IDEs
  "Visual Studio Code") echo "󰨞" ;;
  "Code") echo "󰨞" ;;
  "Kiro") echo "󰊠" ;;
  "IntelliJ IDEA") echo "" ;;
  "PyCharm") echo "" ;;
  "Neovim") echo "" ;;
  "Vim") echo "" ;;
  # Communication
  *"WhatsApp"*) echo "󰖣" ;;
  "Messages") echo "󰵅" ;;
  "Mail") echo "" ;;
  "FaceTime") echo "" ;;
  "Microsoft Outlook") echo "󰴢" ;;
  "Microsoft Teams") echo "󰊻" ;;
  # Music & Media
  "Music") echo "" ;;
  "VLC") echo "" ;;
  "YT Music") echo "󰝚" ;;
  "Podcasts") echo "" ;;
  # Productivity & Notes
  "Ollama") echo "󰚩" ;;
  "Calculator") echo "󰃬" ;;
  "Clock") echo "󰥔" ;;
  "Notes") echo "󰎚" ;;
  "Obsidian") echo "󰏗" ;;
  "Calendar") echo "󰃭" ;;
  "Reminders") echo "" ;;
  "Stocks") echo "󰄪" ;;
  # Design & Creative
  "Sketch") echo "" ;;
  "Preview") echo "" ;;
  "Photos") echo "" ;;
  # Dev tools
  "Finder") echo "󰀶" ;;
  "GitHub Desktop") echo "󰊤" ;;
  # System
  "System Preferences") echo "" ;;
  "System Settings") echo "" ;;
  "PingID") echo "" ;;
  "Activity Monitor") echo "" ;;
  # Office
  "Microsoft Word") echo "󱎒" ;;
  "Microsoft Excel") echo "󱎏" ;;
  "Microsoft PowerPoint") echo "󱎐" ;;
  "Numbers") echo "" ;;
  "Pages") echo "" ;;
  "Keynote") echo "" ;;
  # Fallback: show nothing for unknown apps
  *) echo "󰘔" ;;
  esac
}

APPS=$(aerospace list-windows --workspace "$sid" --format "%{app-name}" 2>/dev/null | sort -u)
ICONS=""
while IFS= read -r app; do
  [ -z "$app" ] && continue
  icon=$(get_icon "$app")
  [ -z "$icon" ] && continue
  ICONS="$ICONS$icon "
done <<<"$APPS"
# trim trailing space
ICONS="${ICONS%" "}"

HAS_WINDOWS=false
[ -n "$APPS" ] && HAS_WINDOWS=true

if [ "$sid" = "$ACTIVE" ]; then
  sketchybar --set "space.$sid" drawing=on background.drawing=on label="$ICONS"
elif [ "$HAS_WINDOWS" = true ]; then
  sketchybar --set "space.$sid" drawing=on background.drawing=off label="$ICONS"
else
  sketchybar --set "space.$sid" drawing=off
fi
