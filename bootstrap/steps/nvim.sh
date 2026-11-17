# shellcheck shell=bash
run_nvim() {
    clone_or_pull https://github.com/s3nn1k/nvim.git "$HOME/.config/nvim"
    rm -rf "$HOME/.config/zenwritten_dark"

    if [ -x "$HOME/.config/nvim/init.sh" ]; then
        echo "running: ~/.config/nvim/init.sh"
        "$HOME/.config/nvim/init.sh"
    fi
}
