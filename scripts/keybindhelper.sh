#!/bin/bash

Main() {
    local command=(
        yad --title="i3-keybindings:" --no-buttons --geometry=400x345-15-400 --list
        --column=key: --column=description: --column=command:
        "ESC" "close this app" ""
        " =  " "modkey" "(set mod Mod4)"
        " + enter" "open alacritty" ""
        "+d" "app menu" ""
        "+q" "close focused app" ""
        "+Shift+q" "logout menu" ""
        "Print-key" "screenshot with flameshot" ""
        "+F1" "open keybinding helper" ""
    )

    "${command[@]}"
}

Main "$@"

