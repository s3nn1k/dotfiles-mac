# dotfiles-mac

Personal machine config, symlinked into `$HOME` by `scripts/bootstrap.sh`.

## Layout

- `zshrc`, `zprofile` - shell; private pieces (ssh wrapper for protected hosts) are
  sourced from `~/credentials`
- `gitconfig` - aliases + defaults; credential helpers inline (`gh` for github/gist,
  `git-cred-read` for gitlab hosts) plus an include of
  `~/.config/git/credentials.gitconfig` (private identities, linked by `setup-secrets`)
- `aerospace.toml` - AeroSpace window manager
- `herdr.toml` - Herdr terminal workspace manager (apply via `herdr server reload-config`)
- `iterm2.json` - iTerm2 dynamic profile (auto-reloads on save; bootstrap also sets it as
  the default profile)
- `Brewfile` - all Homebrew taps/formulae/casks; regenerate with
  `brew bundle dump --file Brewfile --force`
- `bin/` - commands installed to `~/.local/bin` by bootstrap:
  - `wt` - transcribes audio/video via whisper.cpp -> text to stdout
  - `git-crypt-repo.sh` - init/unlock/lock/status/key-show for git-crypt repositories;
    also symlinked as `git-crypt-textconv` (diff driver) and the shared `pre-commit` guard
  - `credentials-setup.sh` - `link` symlinks `~/credentials` secrets into `$HOME` (ssh,
    kube, pi `auth.json`/`mcp.json`), `secure` tightens their permissions
  - `herdr-ws.sh` - herdr workspace commands by sidebar position
    (`focus`/`move-ws`/`move-tab`/`new-tab`)
  - `git-cred-read.sh` - git credential helper serving `~/.git-credentials` entries
- `scripts/`:
  - `bootstrap.sh` - full machine setup (below)
  - `setup-secrets.sh` - `unlock` decrypts the cloned git-crypt repositories and wires
    their runtime links; `link` does only the links

## New machine setup

`scripts/bootstrap.sh` is self-sufficient: it waits for Xcode CLT, installs Homebrew,
applies the Brewfile (apps included), and runs `gh auth login` if needed. It stops short
of secret activation: afterwards run `scripts/setup-secrets.sh unlock` (prompts for the
git-crypt keys).

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

Run bootstrap right after every pull: until it re-runs, renamed `bin/` commands leave
broken `~/.local/bin` symlinks and commits fail on the missing identity include.

```bash
git pull
~/dotfiles-mac/scripts/bootstrap.sh   # runs setup-secrets.sh link once ~/credentials is cloned (no-op while locked)
~/dotfiles-mac/scripts/setup-secrets.sh unlock   # no-op when already unlocked
herdr server reload-config   # herdr.toml is picked up only here
```

## Related public repos

Private repositories (credentials, note vaults) are also handled by bootstrap but are not
listed here.

- [nvim](https://github.com/s3nn1k/nvim) -> `~/.config/nvim` (its own `init.sh` runs
  automatically)
- [zenwritten_dark](https://github.com/s3nn1k/zenwritten_dark) ->
  `~/.config/zenwritten_dark`
- [obsidian-config](https://github.com/s3nn1k/obsidian-config) -> `~/.config/obsidian`
  (shared Obsidian config, symlinked into the vaults as `.obsidian`)
- [nkp](https://github.com/s3nn1k/nkp) -> `~/projects/personal/nkp` (encrypted password
  vault tool built from source; bases live outside the public repos)
- [pi-agent](https://github.com/s3nn1k/pi-agent) -> `~/.pi/agent` (agent runtime and its
  config; cloned when missing)
- [pi-sandbox](https://github.com/s3nn1k/pi-sandbox) -> `~/pi-sandbox` (its `install.sh`
  runs during bootstrap)
