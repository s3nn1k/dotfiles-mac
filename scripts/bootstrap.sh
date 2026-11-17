#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=/dev/null
source "$(dirname "${BASH_SOURCE[0]}")/../bootstrap/lib.sh"

STEP_ORDER=(brew repos herdr git desktop keyboard zsh nvim credentials obsidian keepassxc)

for step_file in "$(dirname "${BASH_SOURCE[0]}")"/../bootstrap/steps/*.sh; do
    # shellcheck source=/dev/null
    source "$step_file"
done

main() {
    local arg step_name full_run=false
    local -a selected=() forwarded=()
    if (( $# == 0 )); then
        full_run=true
        selected=("${STEP_ORDER[@]}")
    elif [[ "$1" == "--list" && $# -eq 1 ]]; then
        for step_name in "${STEP_ORDER[@]}"; do
            printf '%s\n' "$step_name"
        done
        return 0
    else
        for arg in "$@"; do
            if [[ " ${STEP_ORDER[*]} " == *" $arg "* ]]; then
                if [[ ${#forwarded[@]} -gt 0 ]]; then
                    echo "bootstrap: неизвестный шаг: $arg (см. --list)" >&2
                    exit 2
                fi
                selected+=("$arg")
            elif [[ ${#selected[@]} -eq 1 ]]; then
                forwarded+=("$arg")
            else
                echo "bootstrap: неизвестный шаг: $arg (см. --list)" >&2
                exit 2
            fi
        done
    fi

    for step_name in "${selected[@]}"; do
        "run_$step_name" "${forwarded[@]}"
    done
    if [[ "$full_run" != true ]]; then
        return 0
    fi
    printf '%s\n' \
        "manual steps:
  1. Happ: логин (TUN-режим и обход локальных сетей — см. ~/credentials/README.md)
  2. AirPlay-ресивер OFF: System Settings -> General -> AirDrop & Handoff (порты 5000/7000)
  3. токены агента: ~/credentials/agents-credentials/ (git-credentials + kubeconfig/pgpass/pg_service.conf)
  4. mcp.json -> ~/.pi/agent/mcp.json (grafana-mcp; токен сервис-аккаунта из Grafana)" \
        "Если herdr/config.toml обновлялся: herdr server reload-config (сервер конфиг сам не перечитывает)."
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi
