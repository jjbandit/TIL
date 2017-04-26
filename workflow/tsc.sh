#! /bin/bash

. ~/til/colors.sh


# sed -e 's/^+[^+].*$/'$(echo -e "$GREEN")'\0'$(echo -e "$WHITE")'/g'

TSC_OPTIONS='-w --pretty --noEmitOnError'
tsc $TSC_OPTIONS | ColorOutput "\([0-9]*,[0-9]*\|[^\/]*ts\|Compilation complete\)" "$YELLOW" "$WHITE"


