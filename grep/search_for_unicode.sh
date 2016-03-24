#! /bin/bash

# Perl regex that searches for interesting unicode-related strings.

grep -Pc "\b(malloc|realloc|sizeof|memcpy|memmove|memcmp|memset|char(?! THIS_FILE)|printf)\b" "$@"
