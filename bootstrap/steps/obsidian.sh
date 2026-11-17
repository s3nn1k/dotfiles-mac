# shellcheck shell=bash
run_obsidian() {
    local vault_name vault
    for vault_name in personal work; do
        vault="$HOME/vaults/$vault_name"
        mkdir -p "$(dirname "$vault")"
        clone_or_pull "https://github.com/s3nn1k/obsidian-$vault_name.git" "$vault"
        [[ -L "$vault/.obsidian" || ! -e "$vault/.obsidian" ]] && ln -sfn "$HOME/.config/obsidian" "$vault/.obsidian" || echo "warn: $vault/.obsidian is a real directory, not replacing" >&2
        register_vault "$vault"
    done
}
