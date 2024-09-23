#!/usr/bin/env bash

# Function to change the audio output
change_audio_output() {
    local sink
    sink=$(pactl list sinks | awk -F ': ' '/Name:/ {print $2}' | fzf --height 40% --reverse --preview "echo {}" --preview-window=up:1)

    if [ -z "$sink" ]; then
        echo "No sink selected. Exiting."
        exit 1
    fi

    pactl set-default-sink "$sink"
    if [ $? -eq 0 ]; then
        echo "Audio output changed to: $sink"
    else
        echo "Error changing the audio output."
    fi
}

# Initial message
echo "Select an audio sink to change the output:"
change_audio_output
