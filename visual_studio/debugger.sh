SLN=$(ls | grep sln | head -1)

if [ "$1" = "run" ]; then
	devenv.exe "$SLN" /Run &> /dev/null &
fi

if [ "$#" -eq 0 ]; then
	devenv.exe "$SLN" &> /dev/null &
fi
