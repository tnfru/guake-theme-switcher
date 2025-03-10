#!/bin/bash
# Guake Color Palette Manager - Save and restore Guake terminal color palettes

SCHEMES_DIR="$HOME/.config/guake-palettes"

function help() {
    echo "Guake Color Palette Manager"
    echo "Usage:"
    echo "  $0 save <scheme_name>   - Save current color palette"
    echo "  $0 load <scheme_name>   - Load a saved color palette"
    echo "  $0 show                 - Show current color palette"
    echo "  $0 list                 - List all saved palettes"
    echo "  $0 export-ls-colors     - Export LS_COLORS for light/dark themes"
    echo "  $0 help                 - Show this help"
    echo ""
    echo "Example:"
    echo "  $0 save night           - Saves current colors as 'night'"
    echo "  $0 load day             - Loads the 'day' color palette"
    echo "  $0 export-ls-colors     - Creates LS_COLORS files for better visibility"
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

function load_scheme() {
    local scheme_name="$1"
    local scheme_file="$SCHEMES_DIR/$scheme_name.conf"
    
    if [ ! -f "$scheme_file" ]; then
        echo "Error: Palette '$scheme_name' not found!"
        echo "Available palettes:"
        list_schemes
        exit 1
    fi
    
    # Load values from file
    local palette=""
    local palette_name=""
    
    # Read the file line by line
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
    
    # Apply settings
    if [ -n "$palette" ]; then
        gsettings set guake.style.font palette "$palette"
    fi
    
    if [ -n "$palette_name" ]; then
        gsettings set guake.style.font palette-name "$palette_name"
    fi
    
    echo "Color palette '$scheme_name' has been applied"
}

function show_current() {
    echo "Current Guake color palette:"
    echo "---------------------------"
    echo "Palette name: $(gsettings get guake.style.font palette-name)"
    echo "Palette: $(gsettings get guake.style.font palette)"
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
    export-ls-colors)
        # Create optimized LS_COLORS for light and dark themes
        mkdir -p "$SCHEMES_DIR"
        
        # Save the user's current LS_COLORS for dark theme
        cat << EOF > "$SCHEMES_DIR/ls-colors-dark.sh"
# Dark theme LS_COLORS - your current settings
export LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:"
EOF

        cat << 'EOF' > "$SCHEMES_DIR/ls-colors-light.sh"
# Light theme LS_COLORS - with enhanced contrast for light terminal backgrounds
export LS_COLORS="rs=0:di=01;34:ln=01;35:mh=00:pi=33;40:so=01;35:do=01;35:bd=33;40;01:cd=33;40;01:or=31;40;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:"
EOF

        cat << 'EOF' > "$SCHEMES_DIR/setup-aliases.sh"
# Add these to your .bashrc or .zshrc

# Switch Guake color scheme
alias guake-day='guake-colors load day && source ~/.config/guake-palettes/ls-colors-light.sh'
alias guake-night='guake-colors load night && source ~/.config/guake-palettes/ls-colors-dark.sh'
EOF

        echo "LS_COLORS helper files created in $SCHEMES_DIR"
        echo "- ls-colors-dark.sh: Optimized colors for dark backgrounds"
        echo "- ls-colors-light.sh: High-contrast colors for light backgrounds"
        echo "- setup-aliases.sh: Sample aliases for your shell config"
        echo ""
        echo "To use them, add the suggested aliases to your .bashrc or .zshrc"
        echo "Source: cat $SCHEMES_DIR/setup-aliases.sh"
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
