# dotfiles-mac

Personal machine config, symlinked into `$HOME` by `scripts/bootstrap.sh`.

## Layout

- `zshrc`, `zprofile` - shell; private pieces (ssh wrapper for protected hosts) are
  sourced from `~/credentials`
- `gitconfig` - aliases + defaults; `gh` credential helpers for github/gist inline,
  private hosts and identities live in the included
  `~/.config/git/credentials.gitconfig` (linked by `scripts/unlock-gitcrypt.sh`)
- `aerospace.toml` - AeroSpace window manager
- `herdr/` - Herdr terminal workspace manager: `config.toml` (bootstrap links it to
  `~/.config/herdr/config.toml`; apply via `herdr server reload-config`) and `bin/`
  commands installed to `~/.local/bin`:
  - `herdr-ws.sh` - herdr workspace commands by sidebar position
    (`focus`/`move-ws`/`move-tab`/`new-tab`)
  - `herdr-agent-rename.sh` - herdr popup: rename the agent of the current pane
    (bound to `prefix+m`)
- `omp/prompt.omp.json` - oh-my-posh prompt theme (linked to `~/.config/omp/`)
- `iterm2.json` - iTerm2 dynamic profile (auto-reloads on save; bootstrap also sets it as
  the default profile)
- `Brewfile` - all Homebrew taps/formulae/casks; regenerate with
  `brew bundle dump --file Brewfile --force`
- `bin/` - commands installed to `~/.local/bin` by bootstrap:
  - `wt` - transcribes audio/video via whisper.cpp -> text to stdout
- `scripts/`:
  - `bootstrap.sh` - full machine setup (below)
  - `unlock-gitcrypt.sh` - unlocks git-crypt in `~/credentials` (machinery lives in
    `~/credentials/scripts/git-crypt-repo.sh`), canary check, lays out secrets, tightens
    permissions

## New machine setup

`scripts/bootstrap.sh` is self-sufficient: it waits for Xcode CLT, installs Homebrew,
applies the Brewfile (apps included), and runs `gh auth login` if needed. It stops short
of secret activation: afterwards run `scripts/unlock-gitcrypt.sh` (prompts for the
credentials key).

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

## Updating an existing machine

Run bootstrap right after every pull: until it re-runs, renamed commands leave broken
`~/.local/bin` symlinks and commits fail on the missing identity include. On a fresh
`~/credentials` clone, run `scripts/unlock-gitcrypt.sh` before committing there: it
installs the repo-local pre-commit guard that blocks committing still-encrypted files
and unsets the legacy global `core.hooksPath` that would silence that guard.

```bash
git pull
~/dotfiles-mac/scripts/bootstrap.sh
~/dotfiles-mac/scripts/unlock-gitcrypt.sh
herdr server reload-config   # herdr/config.toml is picked up only here
```

## Related public repos

Private repositories (credentials, note vaults) are also handled by bootstrap but are not
listed here.

- [nvim](https://github.com/s3nn1k/nvim) -> `~/.config/nvim` (its own `init.sh` runs
  automatically)
- [obsidian-config](https://github.com/s3nn1k/obsidian-config) -> `~/.config/obsidian`
  (shared Obsidian config, symlinked into the vaults as `.obsidian`)
- [nkp](https://github.com/s3nn1k/nkp) -> `~/projects/personal/nkp` (encrypted password
  vault tool built from source; bases live outside the public repos)
- [pi-agent](https://github.com/s3nn1k/pi-agent) -> `~/.pi/agent` (agent runtime and its
  config; cloned when missing)
- [pi-sandbox-macos](https://github.com/s3nn1k/pi-sandbox-macos) -> `~/pi-sandbox-macos`
  (its `install.sh` runs during bootstrap)
