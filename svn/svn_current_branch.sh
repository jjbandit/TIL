#! /bin/bash

echo $(svn info | grep --color=never -P "^URL:" | grep --color=never -Po "(\d+|trunk)" | rev | cut -c -5 | rev)
