# Genesis

Personal macOS bootstrap script for setting up a new machine with Homebrew, Node.js, fonts, App Store apps, VS Code extensions, macOS system preferences, Ghostty terminal config, browser extensions, and a preferred Dock layout. Forked from [Hayden Bleasel](https://github.com/haydenbleasel/genesis).

## Usage

Run the script from anywhere:

```bash
bash /absolute/path/to/init.sh
```

Or from the repository root:

```bash
bash ./init.sh
```

You can also run individual steps by passing function names as arguments:

```bash
bash ./init.sh configure_dock
bash ./init.sh configure_macos configure_ghostty
```

### genesis CLI

After the first run, a `genesis` shell function is registered in `~/.zshrc`. From any new terminal session you can rerun the full bootstrap or any individual step without needing to reference the script path:

```bash
genesis
genesis configure_dock
genesis configure_macos configure_ghostty
```

The script is designed to be rerun. It skips installed Homebrew formulae, casks, and App Store apps when possible.

## What it does

- Installs Homebrew if it is missing, then runs `brew update` and `brew upgrade`
- Installs `nvm`, then installs and activates Node.js `24`
- Installs the Homebrew formulae listed in [`lib/brew.sh`](lib/brew.sh)
- Installs the font casks listed in [`lib/fonts.sh`](lib/fonts.sh)
- Installs the Homebrew casks listed in [`lib/casks.sh`](lib/casks.sh)
- Installs the Mac App Store apps listed in [`lib/mas.sh`](lib/mas.sh)
- Configures the Dock order listed in [`lib/dock.sh`](lib/dock.sh)
- Updates `.zprofile` and `.zshrc` using [`lib/zsh.sh`](lib/zsh.sh), adding the VS Code `code` CLI to `$PATH`, a full-path prompt, case-insensitive tab completion, and a `genesis` shell function so you can rerun the script from any terminal
- Applies macOS system preferences via [`lib/macos.sh`](lib/macos.sh): Dock auto-hide, Finder path/status bars, Spotlight disabled (Raycast), and natural scrolling off
- Installs VS Code extensions using [`lib/code.sh`](lib/code.sh) and prompts to uninstall any extensions not in the list
- Writes VS Code `settings.json` via [`lib/vscode-settings.sh`](lib/vscode-settings.sh)
- Writes the Ghostty terminal config via [`lib/ghostty.sh`](lib/ghostty.sh)
- Installs and enforces browser extensions (Dashlane) via [`lib/browser-extensions.sh`](lib/browser-extensions.sh)

## Prerequisites

- macOS only
- An internet connection
- Sign in to the Mac App Store before running if you want `mas` installs to succeed
- Open VS Code once after install to ensure the `code` CLI is fully registered

If the App Store account is unavailable, Genesis skips those steps and prints a message.
