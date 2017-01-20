# CScope can take an input of files from a list, so we're going to build a list
# of all source files (wrapped in quotes) then build our database from that.

[ -f cscope.out ] && echo "Removing old cscope.out" && rm cscope.out
[ -f tags ] && echo "Removing old tags" && rm tags

cpp_and_headers.sh > file_list

echo "Starting index on $(cat file_list | wc -l) Files"

echo "Building ctags DB"
find . -type f -name \*.cpp -o -name \*.h | ctags --language-force=C++ -L -

echo "Building cscope DB"
cscope -b -i file_list

rm file_list
