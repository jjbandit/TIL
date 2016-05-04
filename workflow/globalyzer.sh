#! /bin/bash

previous_dir=$(pwd)
globalyzer_out="$previous_dir/globalyzer.out"

cd /cygdrive/c/Program\ Files/Globalyzer/

BAD_ARGUMENT_PASSED=false
REPORT=false
CLEAN=false
DIRECT=false
SCAN=false
RESCAN=false


while [[ $# > 0 ]]
do 
	arg="$1"

	case $arg in
		-d|--direct)
			DIRECT=true
			shift
			break
			;;
		-re|--rescan)
			RESCAN=true
			;;
		-r|--report)
			REPORT=true
			;;
		-s|--scan)
			SCAN=true
			;;
		-c|--clean)
			CLEAN=true
			;;
		*)
			echo "Unknown option: $1"
			BAD_ARGUMENT_PASSED=true
			;;
	esac

	shift
done

if $BAD_ARGUMENT_PASSED; then
	echo " -- Exiting -- "
	exit 1
fi

globalyzer_scan() {
	globalyzer.sh --direct -scn -v -pn globalyzer -sn Websmart -stdout
}

globalyzer_direct() {
	java -jar globalyzer-cli.jar "$@"
}

globalyzer_report() {

	if [ ! -f $globalyzer_out ]; then

		globalyzer_direct -rr -srep Default -pn globalyzer -sn Websmart -stdout \
			| sed 's/^[0-9a-zA-Z],//' \
			| sed '/Locale/!d' \
			| sed 's/,/ /g' \
			| LC_ALL=C sort --ignore-case > $globalyzer_out
	fi

	cat $globalyzer_out
}

globalyzer_clean() {
	globalyzer_direct -dsr -pn globalyzer -sn Websmart -stdout
	
	if [ -f $globalyzer_out ]; then
		rm $globalyzer_out
	fi
}

if $SCAN; then
	globalyzer_scan
	exit 0
fi

if $DIRECT; then
	globalyzer_direct "$@"
	exit 0
fi

if $REPORT; then
	globalyzer_report
	exit 0
fi


if $CLEAN; then
	globalyzer_clean
	exit 0
fi

if $RESCAN; then
	globalyzer_clean
	globalyzer_scan
	exit 0
fi


