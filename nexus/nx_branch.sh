#! /bin/bash

[ $# -eq 0 ] && echo "Please supply a task number!" && exit 1

TASK="$1"

cmd /c C:\\Users\\jhughes\\nexus\\utils\\createenv\\trunk\\ExecuteCreate.bat "$TASK" "http://svn.excelsystems.com/svn/nexus/nexus/trunk/" "C:\\Users\\jhughes\\nexus\\"
