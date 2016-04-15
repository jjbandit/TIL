
If somehow you've managed to really break the permissions structure of a filetree
the following commands have worked for me in the past.

From an Administrator shell:

```
takeown /f "C:\path\to\folder" /r
icacls "C:\path\to\folder" /reset /T
```
