#!/usr/bin/env bash


DIR="$HOME/.config/hypr/wallpapers"
STATE="$HOME/.cache/hyprpaper_index"
MONITOR="DP-1"
HYPRCONF="$HOME/.config/hypr/hyprland.conf"

# Build an array of image files
mapfile -t WALLS < <(ls "$DIR"/*.{jpg,jpeg,png} 2>/dev/null)

# Exit if no wallpapers
[ ${#WALLS[@]} -eq 0 ] && { echo "No wallpapers found in $DIR"; exit 1; }

count=${#WALLS[@]}

# Create state file if missing
[ ! -f "$STATE" ] && echo 0 > "$STATE"
index=$(cat "$STATE")
next=$(( (index + 1) % count ))
wall="${WALLS[$next]}"

# Preload only the selected wallpaper
hyprctl hyprpaper preload "$wall"

# Set the wallpaper
hyprctl hyprpaper wallpaper "$MONITOR","$wall"

# Apply wal to generate color palette
wal -i "$wall"
wal -i -o --saturate 4.0 "$wall"
pywalfox update
# Optional: update Hyprland window borders and background
FOCUSED=$(jq -r '.colors.color4' ~/.cache/wal/colors.json)
INACTIVE=$(jq -r '.colors.color7' ~/.cache/wal/colors.json)
BACKGROUND=$(jq -r '.special.background' ~/.cache/wal/colors.json)

# Update hyprland.conf (adjust to your variable names)
sed -i "s/^decoration:focused_border = .*/decoration:focused_border = $FOCUSED/" "$HYPRCONF"
sed -i "s/^decoration:inactive_border = .*/decoration:inactive_border = $INACTIVE/" "$HYPRCONF"
sed -i "s/^general:background_color = .*/general:background_color = $BACKGROUND/" "$HYPRCONF"

$HOME/.config/wofi/wofi-wal.sh
# Reload Hyprland to apply new border/background colors
hyprctl reload

# Save new index
echo "$next" > "$STATE"

