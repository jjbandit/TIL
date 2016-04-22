

if [ "$1" = "run" ]; then
	devenv.exe WebSmartAll.sln /Run &> /dev/null &
fi

if [ "$#" -eq 0 ]; then
	devenv.exe WebSmartAll.sln &> /dev/null &
fi
