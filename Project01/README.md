# Project 1

### Built With
Bash


### Usage
Initiate a connection `(ssh)` to the server using your macID   
`cd` into `/home/bhavsd1/CS1XA3/Project01`  
Run the script `./project_analyze.sh` using multiple features at once, the script with applied the specified feature one at a time  
or `./project_analyze.sh help` will give you a list of available features  

Example: `./project_analyze.sh search-todo...`   


### Features
1.`search-todo`
  - Finds all the lines that contain the **#TODO** tag in the repository
  - The line and file path get added to the todo.log file in Project01
    - File path also gets added because it makes it easier to find where the **#TODO** is
  - Use `cat todo.log` to see all the **#TODO**

2.`file-count`
  - Outputs a file count for HTML, JavaScript, CSS, Python, Haskell and Bash Script files


3.`compile-check`
  - Finds all Haskell and Python files in the repository that fail to compile
  - The file name and what the errors are get added to the compile_fail.log in Project01
  - Use `cat compile_fail.log` to see the errors

4.`convert-cur` (Custom Feature)
  - Converts a specified amount of one currency to another currency
  - Prompted to enter in amount, base currency and desired currency (Enter currency shortform)
    > Which currency do you want to convert from? (eg. CAD, USD, EUR): 
    
    > Which currency do you want to convert to?: 
    > How much do you want to convert?:
  - Gets current exchange rates using [Currency Converter API](https://www.currencyconverterapi.com)
  - **Note:** this feature should be called alone without any other features and this requires an INTERNET connection



### Author
Dhruv Bhavsar
