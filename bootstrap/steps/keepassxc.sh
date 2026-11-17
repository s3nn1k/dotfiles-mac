# shellcheck shell=bash
run_keepassxc() {
    mkdir -p "$HOME/Library/Application Support/keepassxc"
    link keepassxc/keepassxc.ini "Library/Application Support/keepassxc/keepassxc.ini"
}
