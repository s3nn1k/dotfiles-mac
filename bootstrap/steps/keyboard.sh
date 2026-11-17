# shellcheck shell=bash
run_keyboard() {
    defaults write com.apple.HIToolbox AppleEnabledInputSources -array \
      '{InputSourceKind = "Keyboard Layout"; "KeyboardLayout ID" = 252; "KeyboardLayout Name" = ABC;}' \
      '{InputSourceKind = "Keyboard Layout"; "KeyboardLayout ID" = 19458; "KeyboardLayout Name" = RussianWin;}'
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add \
      60 '{enabled = 0; value = {parameters = (32, 49, 786432); type = standard;};}' \
      61 '{enabled = 1; value = {parameters = (32, 49, 262144); type = standard;};}'
}
