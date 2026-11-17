# shellcheck shell=bash
run_herdr() {
    local bridge_source="$HOME/pi-sandbox-macos/launchagents/com.pi-sandbox-macos.herdr-bridge.plist"
    local bridge_target="$HOME/Library/LaunchAgents/com.pi-sandbox-macos.herdr-bridge.plist"
    [[ -f "$bridge_source" ]] || {
        echo "bootstrap: нет $bridge_source — сначала запусти scripts/bootstrap.sh repos" >&2
        return 1
    }

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
    sed "s|__HOME__|$HOME|" "$bridge_source" > "$bridge_target.tmp"
    mv -f "$bridge_target.tmp" "$bridge_target"
    launchctl bootstrap "gui/$(id -u)" "$bridge_target" && echo "herdr-bridge: agent loaded"
}
