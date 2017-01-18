#! /bin/bash

# Svn doesn't have a useful builtin diff, so let's make one

#  ONE MILLION LINES OF CONTEXT!

svn diff "$@" --git -x -w --diff-cmd=diff -x -U10 | \
# This rewrites lines starting with a single + sign to be colored green \
sed -e 's/^+[^+].*$/'$(echo -e "\033[32m")'\0'$(echo -e "\033[37m")'/g' | \

# This rewrites lines starting with a single - sign to be colored red \
 sed -e 's/^-[^-].*$/'$(echo -e "\033[31m")'\0'$(echo -e "\033[37m")'/g' | \

# This rewrites lines starting with a single @ sign to be colored pink \
sed -e 's/^@.*@$/'$(echo -e "\033[35m")'\0'$(echo -e "\033[37m")'/g' | \

diff-so-fancy  | \

# # This rewrites "modified" lines from diff-so-fancy to be yellow \
sed -e 's/^─.*$/'$(echo -e "\033[33m")'\0'$(echo -e "\033[37m")'/g' | \
sed -e 's/^modified.*$/   '$(echo -e "\033[33m")'\0'$(echo -e "\033[37m")'/g' | \

# # Remove svn cruft that diff-so-fancy doesn't deal with \
 sed -e '/^Index.*/,+1d' | \
less -R
