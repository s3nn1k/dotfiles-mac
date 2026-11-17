# shellcheck shell=bash
run_brew() {
    if ! xcode-select -p >/dev/null 2>&1; then
        echo "CLT: missing — installer opened, click through (waiting)…"
        xcode-select --install >/dev/null 2>&1 || true
        local waited=0
        until xcode-select -p >/dev/null 2>&1; do
            sleep 5
            waited=$((waited + 5))
            if [ "$waited" -ge 900 ]; then
                echo "CLT: not installed after 15 min — rerun bootstrap.sh" >&2
                return 1
            fi
        done
    fi

    if ! command -v brew >/dev/null 2>&1; then
        echo "brew: installing…"
        NONINTERACTIVE=1 /bin/bash -c \
          "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        local brew_bin
        for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
            [ -x "$brew_bin" ] && eval "$($brew_bin shellenv)" && break
        done
    fi

    echo "applying Brewfile…"
    local tap
    for tap in hashicorp/tap int128/kubelogin jandedobbeleer/oh-my-posh nikitabobko/tap; do
        brew trust "$tap" >/dev/null 2>&1 || true
    done
    brew bundle --file "$REPOSITORY/Brewfile"
    chmod g-w "$(brew --prefix)/share" 2>/dev/null || true
}
