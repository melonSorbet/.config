#!/usr/bin/env bash
DIR="$HOME/.config/hypr/wallpapers"
STATE="$HOME/.cache/hyprpaper_index"
MONITOR=$(hyprctl monitors -j | jq -r '.[].name')
HYPRCONF="$HOME/.config/hypr/hyprland.conf"

echo "$MONITOR"

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
wal -s -i "$wall" 

# Get colors IMMEDIATELY
FOCUSED=$(jq -r '.colors.color4' ~/.cache/wal/colors.json)
INACTIVE=$(jq -r '.colors.color7' ~/.cache/wal/colors.json)
BACKGROUND=$(jq -r '.special.background' ~/.cache/wal/colors.json)

# Regenerate Alacritty config RIGHT AWAY before anything else can interfere
ALACRITTY_CUSTOM="$HOME/.cache/wal/colors-alacritty-mine.toml"

cat > "$ALACRITTY_CUSTOM" << EOF
[colors.primary]
background = "$BACKGROUND"
foreground = "#dcd7ba"

[colors.cursor]
cursor = "#dcd7ba"

[colors.vi_mode_cursor]
text = "#1f1f28"
cursor = "#c0a36e"

[colors.search.matches]
foreground = "#090618"
background = "#dcd7ba"

[colors.search.focused_match]
foreground = "#1f1f28"
background = "#dcd7ba"

[colors.line_indicator]
foreground = "#727169"
background = "#1f1f28"

[colors.selection]
text = "#1f1f28"
background = "#dcd7ba"

[colors.normal]
black   = "#090618"
red     = "#c34043"
green   = "#76946a"
yellow  = "#c0a36e"
blue    = "#7e9cd8"
magenta = "#957fb8"
cyan    = "#6a9589"
white   = "#c8c093"

[colors.bright]
black   = "#727169"
red     = "#e82424"
green   = "#98bb6c"
yellow  = "#e6c384"
blue    = "#7fb4ca"
magenta = "#938aa9"
cyan    = "#7aa89f"
white   = "#dcd7ba"

[colors.dim]
black   = "#dcd7ba"
red     = "#e82424"
green   = "#938aa9"
yellow  = "#e6c384"
blue    = "#7fb4ca"
magenta = "#98bb6c"
cyan    = "#7aa89f"
white   = "#727169"
EOF



# Reload Hyprland to apply new border/background colors
hyprctl reload

# Save new index
echo "$next" > "$STATE"


