#!/bin/bash
# Enhanced Theme Switcher for Guake Terminal and LSD
# Integrates with existing guake-colors.sh to provide synchronized theme switching

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
GUAKE_SCRIPT="${SCRIPT_DIR}/guake-colors.sh"
SCHEMES_DIR="$HOME/.config/guake-palettes"
LSD_CONFIG_DIR="$HOME/.config/lsd"
LSD_THEMES_DIR="$HOME/.config/lsd/themes"

function help() {
    echo "Enhanced Theme Switcher for Guake Terminal and LSD"
    echo "Usage:"
    echo "  $0 setup                       - Set up LSD themes for day/night"
    echo "  $0 switch day|night|system     - Switch both Guake and LSD theme"
    echo "  $0 help                        - Show this help"
    echo ""
    echo "This utility works alongside your existing guake-colors.sh script"
    echo "and adds LSD theme switching capability. The 'system' option"
    echo "attempts to match your system's light/dark preference."
}

function ensure_dirs() {
    mkdir -p "$SCHEMES_DIR"
    mkdir -p "$LSD_CONFIG_DIR"
    mkdir -p "$LSD_THEMES_DIR"
}

function create_lsd_config() {
    local config_file="$LSD_CONFIG_DIR/config.yaml"
    
    # Only create if it doesn't exist yet
    if [ ! -f "$config_file" ]; then
        cat > "$config_file" << EOF
# LSD Configuration File

# Use our custom theme
color:
  theme: custom

# Other default settings from the example config
blocks:
  - permission
  - user
  - group
  - size
  - date
  - name

icons:
  when: auto
  theme: fancy
  separator: " "

layout: grid
date: date
size: default
permission: rwx
EOF
        echo "Created default LSD configuration at $config_file"
    else
        echo "LSD config file already exists at $config_file"
        # Check if theme is set to custom
        if ! grep -q "color:" "$config_file" || ! grep -q "theme: custom" "$config_file"; then
            echo "NOTE: For this script to work, update your LSD config to use custom theme:"
            echo "color:"
            echo "  theme: custom"
        fi
    fi
}

function create_lsd_themes() {
    # Create the dark (night) theme - mostly default lsd colors
    cat > "$LSD_THEMES_DIR/night.yaml" << EOF
# Night theme for LSD - Default colors for dark terminals
user: 230
group: 187
permission:
  read: dark_green
  write: dark_yellow
  exec: dark_red
  exec-sticky: 5
  no-access: 245
  octal: 6
  acl: dark_cyan
  context: cyan
date:
  hour-old: 40
  day-old: 42
  older: 36
size:
  none: 245
  small: 229
  medium: 216
  large: 172
inode:
  valid: 13
  invalid: 245
links:
  valid: 13
  invalid: 245
tree-edge: 245
git-status:
  default: 245
  unmodified: 245
  ignored: 245
  new-in-index: dark_green
  new-in-workdir: dark_green
  typechange: dark_yellow
  deleted: dark_red
  renamed: dark_green
  modified: dark_yellow
  conflicted: dark_red
EOF

    # Create the light (day) theme with higher contrast colors
    # Note: Specifically fixing the user, group, and size colors mentioned
    cat > "$LSD_THEMES_DIR/day.yaml" << EOF
# Day theme for LSD - Higher contrast colors for light terminals
user: 18      # Dark blue instead of yellow for better contrast
group: 90     # Dark purple for contrast on light background
permission:
  read: 22    # Darker green
  write: 130  # Darker yellow/orange
  exec: 124   # Darker red
  exec-sticky: 5
  no-access: 245
  octal: 6
  acl: 23     # Darker cyan
  context: 25 # Darker cyan
date:
  hour-old: 28  # Darker blue-green
  day-old: 22   # Darker green
  older: 23     # Darker blue
size:
  none: 245
  small: 130    # Darker orange for small files
  medium: 126   # Darker magenta for medium files
  large: 124    # Darker red for large files
inode:
  valid: 18     # Dark blue
  invalid: 245
links:
  valid: 18     # Dark blue
  invalid: 245
tree-edge: 245
git-status:
  default: 245
  unmodified: 245
  ignored: 245
  new-in-index: 22      # Darker green
  new-in-workdir: 22    # Darker green
  typechange: 130       # Darker yellow
  deleted: 124          # Darker red
  renamed: 22           # Darker green
  modified: 130         # Darker yellow
  conflicted: 124       # Darker red
EOF

    # Create a symlink for the current theme that LSD will use
    ln -sf "$LSD_THEMES_DIR/night.yaml" "$LSD_CONFIG_DIR/colors.yaml"
    
    echo "Created LSD themes for day and night"
}

function setup() {
    ensure_dirs
    create_lsd_config
    create_lsd_themes
    create_shell_helpers
    
    echo "Setup complete! Add the following to your .bashrc or .zshrc:"
    echo "source $SCHEMES_DIR/enhanced-theme-aliases.sh"
}

function create_shell_helpers() {
    cat > "$SCHEMES_DIR/enhanced-theme-aliases.sh" << 'EOF'
# Enhanced theme switching for Guake Terminal and LSD
# Add this to your .bashrc or .zshrc

# Path to the theme switcher scripts
GUAKE_COLORS="guake-colors"
GUAKE_LSD_COLORS="guake-lsd-colors"

# Function to switch both Guake and LSD themes
theme-switch() {
    if [ "$1" = "day" ] || [ "$1" = "night" ] || [ "$1" = "system" ]; then
        "$GUAKE_LSD_COLORS" switch "$1"
    else
        echo "Usage: theme-switch [day|night|system]"
    fi
}

# Convenient aliases
alias day='theme-switch day'
alias night='theme-switch night'
alias auto-theme='theme-switch system'
EOF

    echo "Created shell helper file at $SCHEMES_DIR/enhanced-theme-aliases.sh"
}

function switch_theme() {
    local theme="$1"
    local lsd_theme=""
    
    # Auto-detect if system is used
    if [ "$theme" = "system" ]; then
        # Try to detect system theme. This is a simple example and might need adjustment
        # for your specific desktop environment
        if command -v gsettings &> /dev/null; then
            if gsettings get org.gnome.desktop.interface color-scheme | grep -q "prefer-dark"; then
                theme="night"
            else
                theme="day"
            fi
        else
            # Fallback to time-based if gsettings not available
            hour=$(date +%H)
            if [ "$hour" -ge 18 ] || [ "$hour" -lt 6 ]; then
                theme="night"
            else
                theme="day"
            fi
        fi
    fi
    
    # Switch Guake theme using existing script
    if [ -f "$GUAKE_SCRIPT" ]; then
        "$GUAKE_SCRIPT" load "$theme"
    else
        guake-colors load "$theme" # Try the global command if script not found
    fi
    
    # Switch LSD theme by updating the colors.yaml symlink
    if [ "$theme" = "day" ]; then
        ln -sf "$LSD_THEMES_DIR/day.yaml" "$LSD_CONFIG_DIR/colors.yaml"
    else # night or default
        ln -sf "$LSD_THEMES_DIR/night.yaml" "$LSD_CONFIG_DIR/colors.yaml"
    fi
    
    echo "Switched to $theme theme for both Guake and LSD"
}

# Main script logic
case "$1" in
    setup)
        setup
        ;;
    switch)
        if [ -z "$2" ]; then
            echo "Error: Missing theme name (day|night|system)"
            help
            exit 1
        fi
        switch_theme "$2"
        ;;
    help|--help|-h)
        help
        ;;
    *)
        echo "Error: Unknown command"
        help
        exit 1
        ;;
esac
