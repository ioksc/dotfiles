#!/usr/bin/env bash


if [ -z "$1" ]; then
    echo "Usage: $0 <search_term>"
    exit 1
fi

# Search for fonts containing the search term and list unique matches
fc-list | grep -ioE ": [^:]*$1[^:]*" | sed -E 's/(^: |:)//g' | tr ',' '\n' | sort -u
