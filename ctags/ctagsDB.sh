#! /bin/bash

ctags -I $(find src -not -path src/GL/\*  -type f)
