#! /bin/bash

echo $(svn info | grep "Relative URL" | rev | cut -c -5 | rev)
