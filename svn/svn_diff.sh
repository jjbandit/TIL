#! /bin/bash

. ~/til/colors.sh

# Svn doesn't have a useful builtin diff, so let's make one

svn info > /dev/null 2>&1
[ $? -ne 0 ] && echo "Not a Subversion working copy, exiting." && exit 1

# 10 lines of context around each change
svn diff "$@" --git -x -w --diff-cmd=diff -x -U10                          | \
# This rewrites lines starting with a single + sign to be colored green      \
sed -e 's/^+[^+].*$/'$(echo -e "$GREEN")'\0'$(echo -e "$WHITE")'/g'        | \

# This rewrites lines starting with a single - sign to be colored red        \
sed -e 's/^-[^-].*$/'$(echo -e "$RED")'\0'$(echo -e "$WHITE")'/g'          | \

# This rewrites lines starting with a single @ sign to be colored pink       \
sed -e 's/^@.*@$/'$(echo -e "$PINK")'\0'$(echo -e "$WHITE")'/g'            | \

diff-so-fancy                                                              | \

# This rewrites "modified" lines from diff-so-fancy to be yellow             \
sed -e 's/^─.*$/'$(echo -e "$YELLOW")'\0'$(echo -e "$WHITE")'/g'           | \
sed -e 's/^modified.*$/   '$(echo -e "$YELLOW")'\0'$(echo -e "$WHITE")'/g' | \

# Remove svn cruft that diff-so-fancy doesn't deal with                      \
sed -e '/^Index.*/,+1d'
