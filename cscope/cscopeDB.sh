# CScope can take an input of files from a list, so let's build that list first
# wrapped in double quotes to handle spaces in filenames.

find . -type f -print | grep -E '\.(c(pp)?|h)$' | sed 's/.*/"&"/' > cscope.list

cscope -b -i cscope.list
