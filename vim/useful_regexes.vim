
"  Populate this with function names found in a header file to search for
"  functions that need to have the override keyword added to them.

\v(FUNCTION|OTHER_FUNCTION)(\()@=(.*override)@!

) " Ignore me, syntax highlighting..



"  Search for chars not inside single line comments

\v(\/\/.*)@<!(T)@!(char)


"  Wrap all comment bodies in delimeters

:%s/\v(\s*\/\/\s*)\zs.*$/[.[\0].]/g

" search out all single line comment boidies not containing a string, in this case '[.['
\v(.*\[.\[.*)@!(\s*\/\/\s*)\zs.*$
