# shellcheck shell=bash
run_repos() {
    if ! gh auth status >/dev/null 2>&1; then
        echo "gh: not authenticated — browser login (protocol: HTTPS)"
        gh auth login --git-protocol https
    fi

    if [ ! -d "$HOME/.pi/agent/.git" ]; then
        git clone https://github.com/s3nn1k/pi-agent.git "$HOME/.pi/agent"
    fi
    uvx mcp-grafana --help >/dev/null 2>&1 || echo "warn: mcp-grafana prewarm failed"

    clone_or_pull https://github.com/s3nn1k/pi-sandbox-macos.git "$HOME/pi-sandbox-macos"

    bash "$HOME/pi-sandbox-macos/install.sh"
}
