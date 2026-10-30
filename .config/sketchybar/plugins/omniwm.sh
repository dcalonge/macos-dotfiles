#!/bin/bash

# Updates all OmniWM workspace items (space.N) with a single query.
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

WS=$(omniwmctl query workspaces --format json 2>/dev/null)
WINDOWS=$(omniwmctl query windows --format json 2>/dev/null)
[ -z "$WS" ] || [ -z "$WINDOWS" ] && exit 0

ACTIVE=$(jq -r '.result.payload.workspaces[] | select(.isFocused) | .number' <<<"$WS" | head -1)

ARGS=()
for sid in 1 2 3 4 5 6 7 8 9 10; do
  ICONS=""
  while IFS= read -r app; do
    [ -z "$app" ] && continue
    icon=$(get_icon "$app")
    [ -n "$icon" ] && ICONS="$ICONS$icon "
  done < <(jq -r --argjson n "$sid" '[.result.payload.windows[] | select(.workspace.number == $n) | .app.name] | .[]' <<<"$WINDOWS")
  ICONS="${ICONS%" "}"

  if [ "$sid" = "$ACTIVE" ]; then
    ARGS+=(--set "space.$sid" drawing=on background.drawing=on label="$ICONS")
  elif [ -n "$ICONS" ]; then
    ARGS+=(--set "space.$sid" drawing=on background.drawing=off label="$ICONS")
  else
    ARGS+=(--set "space.$sid" drawing=off)
  fi
done

sketchybar "${ARGS[@]}"
