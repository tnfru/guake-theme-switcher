#!/bin/bash
# Improved Theme Switcher for Guake Terminal
# Handles LSD theming if installed and standard ls colors

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
SCHEMES_DIR="$HOME/.config/guake-palettes"
LSD_CONFIG_DIR="$HOME/.config/lsd"
LSD_THEMES_DIR="$HOME/.config/lsd/themes"

# Check if LSD is installed
HAS_LSD=false
if command -v lsd &> /dev/null; then
    HAS_LSD=true
fi

function help() {
    echo "Improved Theme Switcher for Guake Terminal"
    echo "Usage:"
    echo "  $0 save <scheme_name>   - Save current Guake color palette"
    echo "  $0 load <scheme_name>   - Load a saved color palette and apply themes"
    echo "  $0 show                 - Show current color palette"
    echo "  $0 list                 - List all saved palettes"
    echo "  $0 setup                - Set up themes for both Guake and LSD (if installed)"
    echo "  $0 help                 - Show this help"
    echo ""
    echo "Example:"
    echo "  $0 save night           - Saves current colors as 'night'"
    echo "  $0 load day             - Loads the 'day' color palette and themes"
    echo "  $0 setup                - Creates all necessary theme files"
    
    if $HAS_LSD; then
        echo ""
        echo "LSD detected: Will configure both Guake and LSD themes"
    else
        echo ""
        echo "LSD not detected: Will only configure Guake and standard LS colors"
    fi
}

function ensure_dirs() {
    mkdir -p "$SCHEMES_DIR"
    
    if $HAS_LSD; then
        mkdir -p "$LSD_CONFIG_DIR"
        mkdir -p "$LSD_THEMES_DIR"
    fi
}

function save_scheme() {
    local scheme_name="$1"
    
    # Create schemes directory if it doesn't exist
    mkdir -p "$SCHEMES_DIR"

    # Get palette and name
    local palette=$(gsettings get guake.style.font palette)
    local palette_name=$(gsettings get guake.style.font palette-name)
    
    # Save to file
    echo "# Guake color palette: $scheme_name" > "$SCHEMES_DIR/$scheme_name.conf"
    echo "# Saved on: $(date)" >> "$SCHEMES_DIR/$scheme_name.conf"
    echo "" >> "$SCHEMES_DIR/$scheme_name.conf"
    echo "palette=$palette" >> "$SCHEMES_DIR/$scheme_name.conf"
    echo "palette-name=$palette_name" >> "$SCHEMES_DIR/$scheme_name.conf"
    
    echo "Color palette '$scheme_name' saved to $SCHEMES_DIR/$scheme_name.conf"
}

function setup() {
    ensure_dirs
    create_ls_colors
    
    if $HAS_LSD; then
        create_lsd_config
        create_lsd_themes
    fi
    
    create_shell_helpers
    
    echo "Copy this script for aliases to work"
    echo "sudo cp theme-switcher.sh /usr/local/bin/theme-switch"
    echo "Setup complete! Add the following to your .bashrc or .zshrc:"
    echo "source $SCHEMES_DIR/theme-aliases.sh"
}

function create_ls_colors() {
    # Create optimized LS_COLORS for light and dark themes
    cat > "$SCHEMES_DIR/ls-colors-dark.sh" << EOF
# Dark theme LS_COLORS - optimized for dark backgrounds
export LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:"
EOF

    cat > "$SCHEMES_DIR/ls-colors-light.sh" << 'EOF'
# Light theme LS_COLORS - with enhanced contrast for light terminal backgrounds
export LS_COLORS="rs=0:di=01;34:ln=01;35:mh=00:pi=33;40:so=01;35:do=01;35:bd=33;40;01:cd=33;40;01:or=31;40;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:"
EOF

    echo "Created LS_COLORS files for light and dark themes"
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

# Other default settings
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
function create_shell_helpers() {
    local message=""
    if $HAS_LSD; then
        message="# LSD detected: Will configure both Guake and LSD themes"
    else
        message="# LSD not detected: Will only configure Guake and standard LS colors"
    fi

    cat > "$SCHEMES_DIR/theme-aliases.sh" << EOF
# Theme switching aliases for Guake Terminal
# $message
# Add this to your .bashrc or .zshrc

# Simple aliases for theme switching
alias day='theme-switch load day'
alias night='theme-switch load night'
alias auto-theme='theme-switch load system'

EOF

    echo "Created shell helper file at $SCHEMES_DIR/theme-aliases.sh"
}

function load_scheme() {
    local theme="$1"
    local scheme_file=""
    
    # Auto-detect if system is used
    if [ "$theme" = "system" ]; then
        # Try to detect system theme
        if command -v gsettings &> /dev/null; then
            if gsettings get org.gnome.desktop.interface color-scheme | grep -q "prefer-dark"; then
                theme="night"
            else
                theme="day"
            fi
        else
            # Fallback to time-based
            hour=$(date +%H)
            if [ "$hour" -ge 18 ] || [ "$hour" -lt 6 ]; then
                theme="night"
            else
                theme="day"
            fi
        fi
    fi
    
    # Load the Guake theme
    scheme_file="$SCHEMES_DIR/$theme.conf"
    if [ ! -f "$scheme_file" ]; then
        echo "Error: Palette '$theme' not found!"
        echo "Available palettes:"
        list_schemes
        exit 1
    fi
    
    # Read Guake color values from file
    local palette=""
    local palette_name=""
    
    while IFS= read -r line; do
        # Skip comments and empty lines
        [[ "$line" == \#* ]] && continue
        [[ -z "$line" ]] && continue
        
        # Parse key=value
        if [[ "$line" == palette=* ]]; then
            palette="${line#palette=}"
        elif [[ "$line" == palette-name=* ]]; then
            palette_name="${line#palette-name=}"
        fi
    done < "$scheme_file"
    
    # Apply Guake settings
    if [ -n "$palette" ]; then
        gsettings set guake.style.font palette "$palette"
    fi
    
    if [ -n "$palette_name" ]; then
        gsettings set guake.style.font palette-name "$palette_name"
    fi
    
    # Apply LS_COLORS settings
    if [ "$theme" = "day" ] && [ -f "$SCHEMES_DIR/ls-colors-light.sh" ]; then
        source "$SCHEMES_DIR/ls-colors-light.sh"
    elif [ "$theme" = "night" ] && [ -f "$SCHEMES_DIR/ls-colors-dark.sh" ]; then
        source "$SCHEMES_DIR/ls-colors-dark.sh"
    fi
    
    # Apply LSD theme if available
    if $HAS_LSD && [ -d "$LSD_THEMES_DIR" ]; then
        if [ "$theme" = "day" ] && [ -f "$LSD_THEMES_DIR/day.yaml" ]; then
            ln -sf "$LSD_THEMES_DIR/day.yaml" "$LSD_CONFIG_DIR/colors.yaml"
        elif [ "$theme" = "night" ] && [ -f "$LSD_THEMES_DIR/night.yaml" ]; then
            ln -sf "$LSD_THEMES_DIR/night.yaml" "$LSD_CONFIG_DIR/colors.yaml"
        fi
    fi
    
    # Output success message
    echo "Color palette '$theme' applied to Guake and standard LS colors"
    if $HAS_LSD; then
        echo "LSD theme also updated to match"
    fi
}

function show_current() {
    echo "Current Guake color palette:"
    echo "---------------------------"
    echo "Palette name: $(gsettings get guake.style.font palette-name)"
    echo "Palette: $(gsettings get guake.style.font palette)"
    
    if $HAS_LSD; then
        echo ""
        echo "LSD theme file:"
        if [ -L "$LSD_CONFIG_DIR/colors.yaml" ]; then
            echo "$(readlink -f "$LSD_CONFIG_DIR/colors.yaml")"
        else
            echo "No custom LSD theme linked"
        fi
    fi
}

function list_schemes() {
    if [ ! -d "$SCHEMES_DIR" ]; then
        echo "No saved palettes found."
        return
    fi
    
    echo "Available color palettes:"
    for scheme in "$SCHEMES_DIR"/*.conf; do
        if [ -f "$scheme" ]; then
            basename "$scheme" .conf
        fi
    done
}

# Main script logic
case "$1" in
    save)
        if [ -z "$2" ]; then
            echo "Error: Missing palette name"
            help
            exit 1
        fi
        save_scheme "$2"
        ;;
    load)
        if [ -z "$2" ]; then
            echo "Error: Missing palette name"
            help
            exit 1
        fi
        load_scheme "$2"
        ;;
    show)
        show_current
        ;;
    list)
        list_schemes
        ;;
    setup)
        setup
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
