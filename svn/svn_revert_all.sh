#! /bin/bash

# Svn doesn't have an equivalent of `git reset --hard` that works quickly, so this does it.

svn st -q | sed -r -e 's/^.{8}//' | ~/til/sed/wrap_lines_in_quotes.sh | xargs svn revert
