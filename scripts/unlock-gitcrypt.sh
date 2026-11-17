#!/usr/bin/env bash
set -euo pipefail

CREDENTIALS="$HOME/credentials"
CANARY_PATH="git/gitconfig"

fail() {
    echo "unlock-gitcrypt: $*" >&2
    exit 1
}

is_git_crypt_locked() {
    [[ -f "$1" ]] || return 1
    printf '\000GITCRYPT' | cmp -s - <(head -c 9 "$1")
}

verify_decrypted() {
    [[ -f "$CREDENTIALS/$CANARY_PATH" ]] ||
        fail "decryption canary file is missing after unlock: $CREDENTIALS/$CANARY_PATH"
    if is_git_crypt_locked "$CREDENTIALS/$CANARY_PATH"; then
        fail "$CREDENTIALS is still encrypted after unlock: $CREDENTIALS/$CANARY_PATH
probable cause: rotated git-crypt key - the installed key is stale, so 'make unlock' was a no-op
treatment: cd $CREDENTIALS && make lock && make unlock (paste the new base64 key, or run VAULT_KEY=<key> make unlock)"
    fi
}

main() {
    [[ -d "$CREDENTIALS" ]] || fail "repository is missing: $CREDENTIALS"
    chmod 700 "$CREDENTIALS"/scripts/*.sh 2>/dev/null || true
    [[ -x "$CREDENTIALS/scripts/git-crypt-repo.sh" ]] ||
        fail "нет $CREDENTIALS/scripts/git-crypt-repo.sh; обнови ~/credentials (git pull)"

    local key
    read -r -s -p "ключ credentials: " key
    echo
    export VAULT_KEY="$key"
    git -C "$CREDENTIALS" config --unset core.hooksPath 2>/dev/null || true
    (
        cd "$CREDENTIALS"
        make init
        make unlock
    )
    verify_decrypted

    make -C "$CREDENTIALS" link

    find "$CREDENTIALS" -type d -exec chmod 700 {} +
    find "$CREDENTIALS" -type f -not -path '*/scripts/*' -exec chmod 600 {} +
    chmod 700 "$CREDENTIALS"/scripts/*.sh
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main
fi
