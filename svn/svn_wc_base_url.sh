#! /bin/bash

echo $(svn info | grep --color=never ^URL: | grep --color=never "[^ ]*svn[^ ]*/" -o | sed 's/branches\///' | sed 's#/$##g' )
