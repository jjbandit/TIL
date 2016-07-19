#! /bin/bash

sed -i -b -e's/[[:space:]]*$//' "$@"
unix2dos "$@"
