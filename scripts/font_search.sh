#!/usr/bin/env bash

search_term="${1:-}"
fc-list | grep -ioE ": [^:]*$search_term[^:]*" | sed -E 's/(^: |:)//g' | tr ',' '\n' | sort -u
