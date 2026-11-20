# shellcheck shell=bash
run_keepassxc() {
    mkdir -p "$HOME/Library/Application Support/keepassxc"
    seed_file keepassxc/keepassxc.ini "Library/Application Support/keepassxc/keepassxc.ini"
}
