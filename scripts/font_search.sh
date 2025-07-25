#!/usr/bin/env bash

# Searches for installed font families.
# The first argument is the search term (case-insensitive).

search_term="${1:-}"

# Obtener y procesar la lista de fuentes
fc-list | awk -F': ' '{
    split($2, families, ",");
    for (f in families) {
        gsub(/^ +| +$/, "", families[f]);
        sub(/:.*/, "", families[f]);
        if (length(families[f]) > 0) print families[f]
    }
}' | sort -u | grep -i "$search_term"
