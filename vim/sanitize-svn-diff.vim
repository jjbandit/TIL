" Sometimes looking through a large svn diff can be tedious because of the
" amount of context crap that it writes out that's impossible to turn off.
"
" .. go svn.

function SanitizeSvnDiff()

	" Delete the context cruft that we may or may not care about
	g/^[^-+@].*$/d

	" Seperate each chunck of diff by one newline (\r in this case)
	%s/\v(^\@\@.*$)/\r\1/g

	" Seperate each file chunk by two newlines
	%s/\v(^---.*$\n\+\+\+)/\r\r\1/g

endfunction
