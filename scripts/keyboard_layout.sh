#!/bin/bash
# setxkbmap -query | awk '/layout/{layout=$2} /variant/{variant=$2} END{if (variant) print toupper(layout) " " variant; else print toupper(layout)}'

get_layout() {
    setxkbmap -query | awk '/layout/{layout=$2} /variant/{variant=$2} END{if (variant) print toupper(layout) " " variant; else print toupper(layout)}'
}

current=$(get_layout)

if [[ "$BLOCK_BUTTON" -eq 1 ]]; then
    if [[ "$current" == "US intl" ]]; then
        setxkbmap us
    else
        setxkbmap us -variant intl
    fi
fi

# echo "<span color='#2AA198'> </span> $(get_layout)"
echo "$(get_layout)"