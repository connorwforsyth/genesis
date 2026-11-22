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
- Installs global npm packages (Vercel CLI) via [`lib/npm.sh`](lib/npm.sh)
- Installs the Homebrew formulae listed in [`lib/brew.sh`](lib/brew.sh)
- Signs in to GitHub with `gh`, then sets git defaults (`main` branch, auto-tracking pushes) and your name and GitHub noreply email via [`lib/git.sh`](lib/git.sh)
- Installs the font casks listed in [`lib/fonts.sh`](lib/fonts.sh)
- Copies the personal font library from the private `connorwforsyth/fonts` repo into `~/Library/Fonts` via [`lib/font-library.sh`](lib/font-library.sh) (needs `gh auth login` first)
- Installs the Homebrew casks listed in [`lib/casks.sh`](lib/casks.sh)
- Installs Window Management+ from its latest GitHub release via [`lib/apps.sh`](lib/apps.sh) (needs `gh auth login` first, since the repo is private)
- Installs [Pica](https://pica.joshpuckett.me) from its update feed via [`lib/apps.sh`](lib/apps.sh)
- Offers to install [DiaTweaks](https://github.com/JaceThings/DiaTweaks) for Dia via [`lib/dia-tweaks.sh`](lib/dia-tweaks.sh) (needs `xcode-select --install` first)
- Installs the Mac App Store apps listed in [`lib/mas.sh`](lib/mas.sh)
- Asks before installing the large or situational apps in [`lib/optional-apps.sh`](lib/optional-apps.sh): Docker Desktop, and Microsoft work apps (Outlook, Teams, Word, Excel, PowerPoint). Skips the question when they're already installed
- Offers to uninstall the preinstalled Apple apps listed in [`lib/uninstall.sh`](lib/uninstall.sh): GarageBand (with its sound library), iMovie, Keynote, Numbers and Pages
- Creates `~/Code` for projects outside Conductor and T3 Code via [`lib/folders.sh`](lib/folders.sh)
- Configures the Dock order listed in [`lib/dock.sh`](lib/dock.sh)
- Updates `.zprofile` and `.zshrc` using [`lib/zsh.sh`](lib/zsh.sh), adding Homebrew, `~/.local/bin` and the VS Code `code` CLI to `$PATH`, a full-path prompt, `autocd`, case-insensitive tab completion, `BIOME_THREADS=2`, and a `genesis` shell function so you can rerun the script from any terminal
- Applies macOS system preferences via [`lib/macos.sh`](lib/macos.sh): Dock auto-hide, desktop widgets hidden, the Raycast Glaze 2 wallpaper, Photos not opening when an iPhone is plugged in, Finder path/status bars, Spotlight disabled (Raycast), natural scrolling off, minimize into app icon, and no `.DS_Store` on network or USB volumes
- Adds MCP servers (Mobbin, Neon, Agentation, REA) to Claude Code and Codex via [`lib/mcp.sh`](lib/mcp.sh)
- Installs global agent skills for Claude Code and Codex via [`lib/skills.sh`](lib/skills.sh), including the private `connorwforsyth/skills` repo
- Installs VS Code extensions using [`lib/code.sh`](lib/code.sh) and prompts to uninstall any extensions not in the list
- Writes VS Code `settings.json` via [`lib/vscode-settings.sh`](lib/vscode-settings.sh)
- Writes the Ghostty terminal config and makes Ghostty open shell scripts from Finder via [`lib/ghostty.sh`](lib/ghostty.sh)
- Opens the Dashlane extension page in Dia if it isn't installed yet via [`lib/browser-extensions.sh`](lib/browser-extensions.sh)

## Prerequisites

- macOS only
- An internet connection
- Sign in to the Mac App Store before running if you want `mas` installs to succeed
- Open VS Code once after install to ensure the `code` CLI is fully registered

If the App Store account is unavailable, Genesis skips those steps and prints a message.
