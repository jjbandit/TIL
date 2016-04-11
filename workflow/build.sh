#! /bin/bash

# By default just build Websmart
if [ $# -eq 0 ]; then
	devenv.com WebSmartAll.sln /build
fi
