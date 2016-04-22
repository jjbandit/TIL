# Unfortunately svn doesn't provide an easy way of accessing the HEAD revision,
# so this script provides the ease-of-access that I'm looking for.

svn info | grep "Revision" | cut -d" " -f2
