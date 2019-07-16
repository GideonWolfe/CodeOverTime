# CodeOverTime
A bash script that logs the lines of code in a git repo over the years.

To install, simply run the installation script as root. 

`cloc` must be installed to count lines of code. It is available in most default repositories.

Run `codeovertime` from any git repository and it will find the last commit of every year in the repositories history, check it out, and count the lines of code.

Options:

-g, --graph: If gnuplot is installed, it will outplut a plot of the data to the terminal

-j, --json: The program will output a json object containing the data

## batch.sh

Use this if you want to run `codeovertime` on a series of repositories and aggregate the results.

Ideally this would be run in a clean directory for neatness. Otherwise you have to manually `git pull` all the repos back up to date. Fill in the repositories you want to use and run the script. A series of JSON files will be output to the location the script was run from.
