# shellcheck shell=bash
run_credentials() {
    CREDENTIALS="$HOME/credentials"
    clone_or_pull https://github.com/s3nn1k/credentials.git "$CREDENTIALS"
}
