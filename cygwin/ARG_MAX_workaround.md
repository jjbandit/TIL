In Cygwin, ARG_MAX (that is, maximum length of a single command to bash) is
32k, which is low enough to run into problems when using stuff like `grep
whatever/*.cpp "stuff"` if you've got a lot of files.

To workaround this, you can generate the list of files you want to grep, then
fire grep off with xargs:

```
find whatever/*.cpp | xargs grep "stuff"
```
