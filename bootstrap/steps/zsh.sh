# shellcheck shell=bash
run_zsh() {
    link zshrc .zshrc
    link zprofile .zprofile

    mkdir -p "$HOME/.config/omp"
    link omp/prompt.omp.json .config/omp/prompt.omp.json
}
