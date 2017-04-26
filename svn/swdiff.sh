#! /bin/bash

# SVN sucks, again, and doesn't support word-level diffing.. Let's add it.

# Shamelessly stolen from: http://oscarm.org/2013/11/colorized-word-diffs

cat - | wdiff -n -w $'\033[30;41m' -x $'\033[0m' -y $'\033[30;42m' -z $'\033[0m' -d

