#! /bin/bash

. ~/til/colors.sh

# Svn doesn't have a useful builtin diff, so let's make one

svn info > /dev/null 2>&1
[ $? -ne 0 ] && echo "Not a Subversion working copy, exiting." && exit 1

# 10 lines of context around each change
svn diff "$@" --git -x -w --diff-cmd=diff -x -U10 | \
ColorOutput "^+[^+].*$" "$GREEN" "$WHITE"         | \
ColorOutput "^-[^-].*$" "$RED"    "$WHITE"        | \
ColorOutput "^@.*@$"    "$PINK"   "$WHITE"        | \
diff-so-fancy                                     | \
ColorOutput "^─.*$"     "$YELLOW" "$WHITE"        | \
ColorOutput "^modified.*$" "$YELLOW" "$WHITE"     | \
sed -e '/^Index.*/,+1d'
