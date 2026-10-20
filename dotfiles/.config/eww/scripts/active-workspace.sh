#!/usr/bin/env bash
# Prints the active workspace id now and on every change, for eww's deflisten
hyprctl activeworkspace -j | jq '.id'

# workspacev2 events look like "workspacev2>>ID,NAME"
nc -U "$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while IFS= read -r line; do
  case "$line" in
    workspacev2\>\>*)
      id=${line#*>>}
      echo "${id%%,*}"
      ;;
  esac
done
