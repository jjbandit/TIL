# CScope can take an input of files from a list, so we're going to build a list
# of all source files (wrapped in quotes) then build our database from that.

[ -f cscope.out ] && echo "Removing old cscope.out" && rm cscope.out
[ -f tags ] && echo "Removing old tags" && rm tags

cpp_and_headers.sh > cscope.files

echo "Starting index on $(cat cscope.files | wc -l) Files"

echo "Building ctags DB"
find . -type f -name \*.cpp -o -name \*.h | ctags --language-force=C++ -L -

echo "Building cscope DB"
cscope -b -i cscope.files

cat cscope.files

rm cscope.files
