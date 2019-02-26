#!/bin/bash

cd ..

# Function for compiling files and deleting other files made in the process
function compileFile () {
  # Deletes old compile_fail.log if it exists
  if [ -f "./Project01/compile_log" ] ; then
    rm -rf ./Project01/compile_log
  fi

  # Finds files with extension .py or .hs in the current repo
  find ./ -type f \( -name "*.py" -or -name "*.hs" \) -print0 | while IFS= read -d $'\0' file
  do
       if [[ $file = *.py ]] ; then
          # Compiles the file and stores the error output in compile_fail.log, ignores the standard output
	  python -m py_compile $file 2>> ./Project01/compile_fail.log 1> /dev/null
	  # Checks if the compiling gave an error output
 	  if [ $? != "0" ] ; then
	    # Spacing out the erros for a cleaner look
	    echo " " >> ./Project01/compile_fail.log
	    echo "$file did not compile."
	  else
	    rm ${file}c  # Remove the .pyc file created if compiled successfully
	  fi

       elif [[ $file = *.hs ]] ; then
	  # Compiles the file and stores the error output in compile_fail.log, ignores the standard output
          ghc -outputdir ./Project01/extraFiles $file 2>> ./Project01/compile_fail.log 1> /dev/null # Redirects files made during this process to a folder
          if [ $? != "0" ] ; then
            echo " " >> ./Project01/compile_fail.log
            echo "$file did not compile." # Echo to let you know on screen which files did not compile
          else
            # Deletes the files made during the process
            rm ./Project01/${file%.*}
	    rm -rf ./Project01/extraFiles
	  fi
       fi
  done
}

# Function for converting currencies with real-time rates
function convertCurrency() {
 # Prompts and reads user input into a variable
 read -p "Which currency do you want to convert from? (eg. CAD, USD, EUR): " baseCur
 read -p "Which currency do you want to convert to?: " toCur

 # API call to fetch and parse the exchange rate of the two currencies into a variable
 exRate=$(curl -s "https://free.currencyconverterapi.com/api/v6/convert?q=${baseCur}_${toCur}&compact=ultra&apiKey=a2c9de06b4305107df76" | grep -Eo '[0-9,.]*')

 # Checks if the rate is empty meaning that one of the currencies entered were incorrect
 while [ -z "$exRate" ]
 do
   # Repeat the process of fetching the exchange rate
   echo "One of the currencies is incorrect please enter the currencies again"
   read -p "Which currency do you want to convert from? (eg. CAD, USD, EUR): " baseCur
   read -p "Which currency do you want to convert to?: " toCur
   exRate=$(curl -s "https://free.currencyconverterapi.com/api/v6/convert?q=${baseCur}_${toCur}&compact=ultra&apiKey=a2c9de06b4305107df76" | grep -Eo '[0-9,.]*')
 done

 read -p "How much do you want to convert?: " amount
 # Converting base currency to desired currency using python since bash does not support floating point arithmetic
 convertedA=$(python -c "print(round($exRate * $amount, 2))")

 echo " "
 # Printing out the results
 echo "| Converting $baseCur to $toCur..."
 echo "| Rate: 1 $baseCur equals $exRate $toCur"
 echo "| $amount $baseCur equals $convertedA $toCur"
 echo " "
}

# Main Script
for com in "$@" ; do # Allows for multiple commands at once
 if [ $com  = search-todo ] ; then
	# Deletes old todo.log if it exists
        if [ -f "./Project01/todo.log" ] ; then
	  rm -rf ./Project01/todo.log
	fi

	echo "Searching for #TODO's..." # Helpful echo
	grep -r --exclude={project_analyze.sh,todo.log,README.md} '#TODO' ./ 1> ./Project01/todo.log # Searches in the repo for #TODO except some files and stores it into todo.log 
	echo "Check todo.log for any #TODO's"

 elif [ $com = file-count ] ; then
	echo "Computing the number of files" # Helpful echo
	countH=$(find ./ -name '*.html' | wc -l) # Finds files that end in the corresponding extension
	echo "HTML: $countH" # Displaying the results
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

 elif [ $com = compile-check ] ; then
	echo "Running compile-check..."
	compileFile # Creates compile_fail.log with names and errors of files that cannot compile
	echo "Check compile_fail.log for information about the syntax errors" # Telling you where to see the results

 elif [ $com = convert-cur ] ; then
	convertCurrency # Runs the converting currency function

 elif [ $com = help ] ; then # Listing the commands of all of the available features
	printf "%s\n" "Available Features:" "search-todo" "file-count" "compile-check" "convert-cur"
 else # If inputed something other than the described features
	echo "Sorry that feature does not exist"
 fi
done
