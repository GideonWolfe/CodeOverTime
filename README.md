# CodeOverTime
A bash script that logs the lines of code in a git repo over the years.

To install, simply run the installation script as root.

Run `codeovertime` from any git repository and it will find the last commit of every year in the repositories history, check it out, and count the lines of code.

Options:

-g, --graph: If gnuplot is installed, it will outplut a plot of the data to the terminal
-j, --json: The program will output a json object containing the data
