# dotfiles-mac

Personal machine config, symlinked into `$HOME` by `scripts/bootstrap.sh`.

## Layout

- `zshrc`, `zprofile` - shell; private pieces (ssh wrapper for protected hosts) are
  sourced from `~/credentials`
- `gitconfig` - public part: aliases + defaults; identity routing and credential helpers
  live in `~/credentials/git/` (included, ignored when missing)
- `aerospace.toml` - AeroSpace window manager
- `herdr.toml` - Herdr terminal workspace manager (apply via `herdr server reload-config`)
- `iterm2.json` - iTerm2 dynamic profile (auto-reloads on save; bootstrap also sets it as
  the default profile)
- `Brewfile` - all Homebrew taps/formulae/casks; regenerate with
  `brew bundle dump --file Brewfile --force`
- `scripts/` - executable commands (`.sh`, self-documenting):
  - `bootstrap.sh` - full machine setup (below)
  - `git-crypt-repo.sh` - init/unlock/lock/status/key-show for git-crypt repositories
    (`~/.local/bin/git-crypt-repo`, also as `git-crypt-textconv` and the shared pre-commit
    guard)
  - `credentials-setup.sh` - link/secure `~/credentials`; pi `auth.json`/`mcp.json` ->
    `~/.pi/agent` (`~/.local/bin/credentials-setup`)
  - `wt.sh` - audio/video transcription via whisper.cpp (`wt`)

## New machine setup

`scripts/bootstrap.sh` is self-sufficient: it waits for Xcode CLT, installs Homebrew,
applies the Brewfile (apps included), runs `gh auth login` if needed, and prompts for the
vault key when a git-crypt repository is still locked.

```bash
# 1. Xcode Command Line Tools (git) - installer GUI, one click-through
xcode-select --install

# 2. Dotfiles (gh handles auth for the clone)
brew install gh && gh auth login
git clone https://github.com/s3nn1k/dotfiles-mac.git ~/dotfiles-mac

# 3. Everything else
~/dotfiles-mac/scripts/bootstrap.sh
```

### Manual steps after bootstrap

Can't be automated on macOS (require user clicks):

- Grant **Accessibility** permission to AeroSpace: _System Settings -> Privacy & Security
  -> Accessibility_
- (optional) Set iTerm2 as default in `Mission Control` if desired
- Happ: log in (TUN mode and local-network bypass - see `~/credentials/README.md`)
- AirPlay receiver OFF: _System Settings -> General -> AirDrop & Handoff_ (opens loopback
  ports 5000/7000 to the whole VM NAT range)

## Related public repos

Private repositories (credentials, note vaults) are also handled by bootstrap but are not
listed here.

- [nvim](https://github.com/s3nn1k/nvim) -> `~/.config/nvim` (its own `init.sh` runs
  automatically)
- [zenwritten_dark](https://github.com/s3nn1k/zenwritten_dark) ->
  `~/.config/zenwritten_dark`
- [obsidian-config](https://github.com/s3nn1k/obsidian-config) -> `~/.config/obsidian`
  (shared Obsidian config, symlinked into the vaults as `.obsidian`)
- [herdr-tools](https://github.com/s3nn1k/herdr-tools) ->
  `~/projects/personal/herdr-tools` (herdr-tab helper + `ws-keys` plugin for herdr)
- [nkp](https://github.com/s3nn1k/nkp) -> `~/projects/personal/nkp` (encrypted password
  vault tool built from source; bases live outside the public repos)
- [pi-agent](https://github.com/s3nn1k/pi-agent) -> `~/.pi/agent` (agent runtime and its
  config; cloned when missing)
- [pi-sandbox](https://github.com/s3nn1k/pi-sandbox) -> `~/pi-sandbox` (its `install.sh`
  runs during bootstrap)
