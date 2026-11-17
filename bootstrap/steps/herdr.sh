# shellcheck shell=bash
run_herdr() {
    mkdir -p "$LOCAL_BIN"
    install_command "$REPOSITORY/herdr/bin/herdr-ws.sh" herdr-ws
    install_command "$REPOSITORY/herdr/bin/herdr-agent-rename.sh" herdr-agent-rename
    rm -f "$LOCAL_BIN/herdr-ws-focus"
    rm -f "$LOCAL_BIN/wt"
    rm -f "$LOCAL_BIN/git-crypt-repo" "$LOCAL_BIN/git-crypt-textconv" \
      "$LOCAL_BIN/credentials-setup" "$LOCAL_BIN/git-cred-read"
    rm -rf "$HOME/.local/share/git-crypt"

    mkdir -p "$HOME/.config/herdr"
    link herdr/config.toml .config/herdr/config.toml
    herdr integration install pi >/dev/null 2>&1 || true

    launchctl bootout "gui/$(id -u)/com.s3nn1k.herdr-bridge" >/dev/null 2>&1 || true
    launchctl bootout "gui/$(id -u)/com.pi-sandbox.herdr-bridge" >/dev/null 2>&1 || true
    launchctl bootout "gui/$(id -u)/com.pi-sandbox-macos.herdr-bridge" >/dev/null 2>&1 || true
    sed "s|__HOME__|$HOME|" "$HOME/pi-sandbox-macos/launchagents/com.pi-sandbox-macos.herdr-bridge.plist" \
      > "$HOME/Library/LaunchAgents/com.pi-sandbox-macos.herdr-bridge.plist"
    launchctl bootstrap "gui/$(id -u)" \
      "$HOME/Library/LaunchAgents/com.pi-sandbox-macos.herdr-bridge.plist" && echo "herdr-bridge: agent loaded"
}
