#!/usr/bin/env bash

search_term="${1:-}"
fc-list | awk -F': ' '{split($2, families, ","); for (f in families) { sub(/:.*/,"",families[f]); print families[f]}}' | sort -u | grep -i "$search_term"
