#!/bin/bash
# Path to Pywal colors
colors_file="$HOME/.cache/wal/colors.sh"
css_file="$HOME/.config/wofi/style.css"

# Load Pywal colors
source "$colors_file"

# Generate Wofi CSS dynamically using Pywal colors
# Generate Wofi CSS dynamically using Pywal colors
cat > "$css_file" <<EOF
window {
    margin: 0px;
    border-radius: 4px;
    border: 2px solid ${color1};
    background-color: ${color0};
}

#input {
    margin: 5px;
    padding: 5px;
    border: 1px solid ${color8};
    color: ${color15};
    background-color: ${color0};
}

#inner-box {
    margin: 5px;
    border: none;
    background-color: ${color0};
}

#outer-box {
    margin: 5px;
    border: none;
    background-color: ${color0};
}

#scroll {
    margin: 0px;
    border: none;
}

#text {
    margin: 5px;
    border: none;
    color: ${color15};
}

#entry {
    padding: 4px;
    border-radius: 4px;
}

#entry:selected {
    background-color: ${color1};
    color: ${color0};
}

#entry:hover {
    background-color: ${color8};
}
EOF

