source "$HOME/.zprofile"

eval "$(oh-my-posh init zsh --config "${XDG_CONFIG_HOME:-$HOME/.config}/omp/prompt.omp.json")"

BREW_PREFIX="$(brew --prefix)"

fpath=("$BREW_PREFIX/share/zsh-completions" $fpath)

autoload -Uz compinit && compinit

source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

export NKP_VAULT="$HOME/credentials/nkp"

pi() {
  "$HOME/pi-sandbox-macos/bin/pi-run" "$@"
}

[ -f "$HOME/credentials/ssh/wrapper.zsh" ] && source "$HOME/credentials/ssh/wrapper.zsh"

ssh-keychain-add() {
  local k n=0
  for k in ~/.ssh/*(N); do
    [[ -f $k ]] || continue
    head -1 "$k" 2>/dev/null | grep -q "PRIVATE KEY" || continue
    ssh-add --apple-use-keychain "$k" && n=$((n+1))
  done
  echo "ssh-keychain-add: $n key(s) now in agent"
  ssh-add -l 2>/dev/null
}
if [[ "$(uname -s)" == Darwin && -n "$SSH_AUTH_SOCK" ]] && ! ssh-add -l &>/dev/null; then
  ssh-add -A 2>/dev/null
fi

export PATH="$HOME/.pi/agent/bin:$PATH"
