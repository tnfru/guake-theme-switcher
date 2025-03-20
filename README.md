# Guake Theme Switcher

> A utility for switching between day/night themes in Guake Terminal with LSDeluxe (LSD) integration

![image](https://github.com/user-attachments/assets/b884a456-a03d-4500-854b-ba0dd1cb5d18)
![image](https://github.com/user-attachments/assets/938fa224-f64f-45c1-9c15-8cf3482e1d7e)




## Features

- 🌓 Easily switch between light and dark terminal themes
- 🔄 Auto-detect system theme or time of day
- 🎨 Optimized colors for both Guake Terminal and LSD
- 📊 Enhanced readability for all terminal text elements
- 🛠️ Zero dependencies (uses standard gsettings)

## Installation

```bash
# Install
git clone https://github.com/your-username/guake-theme-switcher.git
cd guake-theme-switcher
chmod +x theme-switch.sh
sudo cp theme-switch.sh /usr/local/bin/theme-switch

# Setup
theme-switch setup
echo 'source ~/.config/guake-palettes/theme-aliases.sh' >> ~/.bashrc  # or ~/.zshrc
source ~/.bashrc  # or ~/.zshrc
```

## Quick Usage

```bash
# Switch themes
day       # Switch to light theme
night     # Switch to dark theme
auto-theme  # Auto-detect based on system theme

# Save your current theme
theme-switch save mytheme

# Show current palette
theme-switch show

# List saved themes
theme-switch list
```

## How It Works

The script automatically detects if LSD is installed and:

1. Manages Guake color palettes using gsettings
2. Creates optimized LSD theme files if available
3. Sets appropriate LS_COLORS for standard `ls` command
4. Provides aliases for quick switching

### Directory Structure

- Guake palettes: `~/.config/guake-palettes/*.conf` 
- LSD themes: `~/.config/lsd/themes/*.yaml`
- Shell aliases: `~/.config/guake-palettes/theme-aliases.sh`

## Creating Custom Themes

Save your current theme:
```bash
theme-switch save mytheme
```

After changing colors in Guake preferences, save another theme:
```bash
theme-switch save anothertheme
```

## Compatibility

- Requires Guake Terminal
- Works on most GNOME-based distributions
- Automatically supports LSD if installed
- Tested on Ubuntu 22.04 and Pop!_OS 22.04

## License

MIT © Lars Müller
