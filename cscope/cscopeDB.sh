# CScope can take an input of files from a list, so we're going to build a list
# of all source files (wrapped in quotes) then build our database from that.

cpp_and_headers.sh > cscope.list

cscope -b -i cscope.list
