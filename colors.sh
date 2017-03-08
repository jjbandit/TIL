function ColorOutput()
{
  REGEX="$1"

  WriteColor="$2"
  ResetColor="$3"

  sed "s/$REGEX/"$(echo -e "$WriteColor")'\0'$(echo -e "$ResetColor")"/g"
}

export  GREEN="\033[32m"
export  WHITE="\033[37m"
export    RED="\033[31m"
export   PINK="\033[35m"
export YELLOW="\033[33m"


