#!/bin/bash

cd ..

for com in "$@" ; do
 if [ $com  = search-todo ] ; then
	echo "Searching for #TODO's..."
	grep -r --exclude={project_analyze.sh,todo.log,README.md} '#TODO' ./ 1> ./Project01/todo.log
	echo "Check todo.log for any #TODO's"
 elif [ $com = file-count ] ; then
	echo "Computing the number of files"
	countH=$(find ./ -name '*.html' | wc -l)
	echo "HTML: $countH"
	countJ=$(find ./ -name '*.js' | wc -l)
	echo "JavaScript: $countJ"
	countC=$(find ./ -name '*.css' | wc -l)
	echo "CSS: $countC"
	countP=$(find ./ -name '*.py' | wc -l)
	echo "Python: $countP"
	countHa=$(find ./ -name '*.hs' | wc -l)
	echo "Haskell: $countHa"
	countB=$(find ./ -name '*.sh' | wc -l)
	echo "Bash Script: $countB"
 elif [ $com = help ] ; then
	printf "%s\n" "Available Features:" "search-todo" "file-count"
 fi
done
