#! /bin/bash

FILES=$( find $(pwd -P) -type f | grep "\.sh$" )

for file in $FILES
do
  # echo $file
  ln -fs "$file" "/home/scallywag/bin/"
done
