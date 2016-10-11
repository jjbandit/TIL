#! /bin/bash
# Svn doesn't have an equivalent of `git reset --hard` that works quickly


# Find files that have changes
filesToRevert=$(svn st -q | \
	sed -r -e 's/^.{8}//' | \
	~/til/sed/wrap_lines_in_quotes.sh )

# If there are some files that have changes try to revert just those
if [ -n "$filesToRevert" ]; then
	echo "Found Changes to revert"
	echo $filesToRevert
	echo "$filesToRevert" | xargs svn revert
else
	echo "No Changes to revert"
	exit 0
fi

# The fast version can fail if there are tree conflicts .. or ..?  SVN everybody!

# Fall back to the standard revert-the-whole-world version that SVN provides
if [ $? -ne 0 ]; then
	echo "Fast revert failed.. Reverting to slow-ass SVN version"
	svn revert --depth=infinity . > /dev/null

	# Somehow the executable bit gets unset from the svn revert --depth=infinity
	# call.. I think this is because I'm running it through cygwin.. but who knows
	chmod +x -R **/*
fi
