#!/bin/bash

# Called per-space: aerospace.sh <workspace_id>
sid="$1"
ACTIVE=$(aerospace list-workspaces --focused)

get_icon() {
  case "$1" in
    # Browsers
    "Arc")                  echo "" ;;
    *"Safari"*)             echo "" ;;
    "Firefox")              echo "󰈹" ;;
    "Google Chrome")        echo "" ;;
    "Chromium")             echo "" ;;
    "Brave Browser")        echo "" ;;
    "Opera")                echo "" ;;
    # Terminals
    "Terminal")             echo "" ;;
    "iTerm2")               echo "" ;;
    "Alacritty")            echo "" ;;
    "kitty")                echo "" ;;
    "WezTerm")              echo "" ;;
    "Hyper")                echo "" ;;
    # Editors & IDEs
    "Visual Studio Code")   echo "󰨞" ;;
    "Code")                 echo "󰨞" ;;
    "Xcode")                echo "" ;;
    "IntelliJ IDEA")        echo "" ;;
    "PyCharm")              echo "" ;;
    "WebStorm")             echo "" ;;
    "DataGrip")             echo "" ;;
    "GoLand")               echo "" ;;
    "Rider")                echo "" ;;
    "CLion")                echo "" ;;
    "RustRover")            echo "" ;;
    "Zed")                  echo "" ;;
    "Neovim")               echo "" ;;
    "Vim")                  echo "" ;;
    "Emacs")                echo "" ;;
    "Cursor")               echo "󰺊" ;;
    # Communication
    "Slack")                echo "" ;;
    "Discord")              echo "" ;;
    "Telegram")             echo "" ;;
    *"WhatsApp"*)           echo "󰖣" ;;
    "Signal")               echo "" ;;
    "Messages")             echo "󰵅" ;;
    "Mail")                 echo "" ;;
    "Mimestream")           echo "" ;;
    "FaceTime")             echo "" ;;
    "Microsoft Outlook")    echo "󰴢" ;;
    "Microsoft Teams")      echo "󰊻" ;;
    "zoom.us")              echo "" ;;
    # Music & Media
    "Spotify")              echo "" ;;
    "Music")                echo "" ;;
    "VLC")                  echo "" ;;
    "YT Music")             echo "󰝚" ;;
    "Plex")                 echo "" ;;
    "Podcasts")             echo "" ;;
    # Productivity & Notes
    "Notes")                echo "󰎚" ;;
    "Obsidian")             echo "󰏗" ;;
    "Notion")               echo "" ;;
    "Bear")                 echo "" ;;
    "Craft")                echo "" ;;
    "Logseq")               echo "" ;;
    "Reeder")               echo "" ;;
    "Calendar")             echo "" ;;
    "Reminders")            echo "" ;;
    "Things 3")             echo "" ;;
    "OmniFocus")            echo "" ;;
    "Linear")               echo "" ;;
    "Stocks")                echo "󰄪" ;;
    # Design & Creative
    "Figma")                echo "" ;;
    "Sketch")               echo "" ;;
    "Adobe Photoshop")      echo "" ;;
    "Adobe Illustrator")    echo "" ;;
    "Preview")              echo "" ;;
    "Photos")               echo "" ;;
    # Dev tools
    "Finder")               echo "󰀶" ;;
    "GitHub Desktop")       echo "󰊤" ;;
    "GitKraken")            echo "󰊢" ;;
    # System
    "System Preferences")   echo "" ;;
    "System Settings")      echo "" ;;
    "PingID")               echo "" ;;
    "Activity Monitor")     echo "" ;;
    "1Password")            echo "" ;;
    "Bitwarden")            echo "" ;;
    "Raycast")              echo "" ;;
    "Alfred")               echo "" ;;
    # Office
    "Microsoft Word")       echo "󱎒" ;;
    "Microsoft Excel")      echo "󱎏" ;;
    "Microsoft PowerPoint") echo "󱎐" ;;
    "Numbers")              echo "" ;;
    "Pages")                echo "" ;;
    "Keynote")              echo "" ;;
    # Fallback: show nothing for unknown apps
    *)                      echo "󰘔" ;;
  esac
}

APPS=$(aerospace list-windows --workspace "$sid" --format "%{app-name}" 2>/dev/null | sort -u)
ICONS=""
while IFS= read -r app; do
  [ -z "$app" ] && continue
  icon=$(get_icon "$app")
  [ -z "$icon" ] && continue
  ICONS="$ICONS$icon "
done <<< "$APPS"
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
