# shellcheck shell=bash
run_desktop() {
    link aerospace.toml .aerospace.toml

    local iterm_profiles="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
    mkdir -p "$iterm_profiles"
    ln -sfn "$REPOSITORY/iterm2.json" "$iterm_profiles/dotfiles.json"
    echo "linked:  $iterm_profiles/dotfiles.json"
    defaults write com.googlecode.iterm2 "Default Bookmark Guid" \
      -string "8F407364-0CD1-4EE5-8861-6C3FACFCC48E"
    echo "iterm2:  default profile set to 'Dotfiles'"
}
