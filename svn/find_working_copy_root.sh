#! /bin/bash

function FindWorkingCopyRoot()
{
  if [ "$(pwd)" == "/" ]; then
    # Break out if we're at the filesystem root
    echo "Couldn't find working copy root"

  else

    if [ -d .svn ]; then
      echo "Found Working Copy root at $(pwd)"
    else
      cd ..
      FindWorkingCopyRoot
    fi
  fi
}

