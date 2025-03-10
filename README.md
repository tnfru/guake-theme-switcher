# Guake Theme Switcher

A simple command-line tool to save, manage, and switch between custom color palettes for the Guake Terminal.

![image](https://github.com/user-attachments/assets/69f64d12-338d-45ab-b491-344b08df4874)
![image](https://github.com/user-attachments/assets/9fdaa5fb-954e-41a8-9610-ac96aa12b561)


## Problem

Guake Terminal doesn't provide a built-in way to save and quickly switch between multiple color schemes. This makes it difficult to:
- Use different color schemes for day/night usage
- Share your custom color schemes with others
- Quickly switch between different themes for different workflows

## Solution

This script allows you to save your current Guake color palette, restore saved palettes, and switch between them with a simple command.

## Features

- Save your current Guake color palette
- Load saved color palettes
- List all available saved palettes
- Show current palette settings
- Simple, focused tool that only modifies color-related settings
- Zero dependencies (uses standard gsettings)

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/guake-color-palette-manager.git
   cd guake-color-palette-manager
   ```

2. Make the script executable:
   ```bash
   chmod +x guake-colors.sh
   ```

3. Optionally, make it available system-wide:
   ```bash
   sudo cp guake-colors.sh /usr/local/bin/guake-colors
   ```

## Usage

### Save your current color palette

```bash
./guake-colors.sh save night
```

### Switch to a saved palette

```bash
./guake-colors.sh load day
```

### Show current palette settings

```bash
./guake-colors.sh show
```

### List all saved palettes

```bash
./guake-colors.sh list
```

### Get help

```bash
./guake-colors.sh help
```

## Creating Day and Night Color Schemes

A common use case is switching between a dark theme for night and a bright theme for day:

1. Set up your preferred night/dark theme in Guake preferences
2. Save it: `./guake-colors.sh save night`
3. Change colors to a bright theme in Guake preferences
4. Save it: `./guake-colors.sh save day`
5. Now you can quickly switch: `./guake-colors.sh load day` or `./guake-colors.sh load night`

## Quick Switching with Aliases

Add these lines to your `.bashrc` or `.zshrc` for even quicker switching:

```bash
alias guake-day='guake-colors load day'
alias guake-night='guake-colors load night'
```

Then you can simply type `guake-day` or `guake-night` to switch themes.

## How It Works

The script uses the GNOME GSettings API to save and restore the color palette settings for Guake. Specifically, it manages the `palette` and `palette-name` keys in the `guake.style.font` schema.

The saved palettes are stored as simple text files in `~/.config/guake-palettes/` for easy backup and sharing.

## Compatibility

- Tested on Pop!_OS 22.04
- Should work on Ubuntu and other GNOME-based distributions
- Requires Guake Terminal

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Thanks to the Guake Terminal developers for such a great terminal emulator
- Inspired by the need to easily switch between day and night color schemes
