#! /bin/bash

echo $(svn info | grep -P "^URL:" | grep -Po "\d+" | rev | cut -c -5 | rev)
