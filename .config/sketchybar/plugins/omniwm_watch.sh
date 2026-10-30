#!/bin/bash

# Forwards OmniWM state changes to sketchybar as the omniwm_workspace_change event.
# Restarted on every sketchybar reload, so stop any previous instance first.
pkill -f "omniwmctl watch" 2>/dev/null

nohup omniwmctl watch workspace-bar,active-workspace,windows-changed --reconnect \
  --exec sketchybar --trigger omniwm_workspace_change >/dev/null 2>&1 &
