#!/bin/bash

year=$(date +'%Y')
declare -A VALIDS
declare -A DATA
startyear=$(git log --reverse | head -3 | tail -n 1 | awk '{print $6}')


# For every year the project existed
for i in `seq $startyear $year`;
do    
        
    # extrace the commit ID for the last commit of the year
    COMMIT="$(git log --oneline --until=$i-12-31 | awk '{print $1}' | head -2 | tail -n 1)"
    VALIDS+=([$i]=$COMMIT)
done

# For every end of year commit
for i in "${!VALIDS[@]}"
do
    year=$i
    commit=${VALIDS[$i]}
    
    # Checout the commit
    git checkout $commit > /dev/null
    
    # Count the lines of code
    NUMLINES="$(cloc --diff-timeout 1000 . | grep SUM | awk '{print $5}')"
    
    # Add to final data structure
    DATA+=([$year]=$NUMLINES) 
done

# Print results
rm results.txt
for i in "${!DATA[@]}"
do
    year=$i
    lines=${DATA[$i]}
    echo "$year : $lines"
    echo "$year $lines" >> results.txt
done

if which gnuplot >> /dev/null;
then
        gnuplot <<- EOF
                set xlabel "Year"
                set ylabel "Lines of Code"
                set title "Code over time"
                set terminal dumb
                plot "results.txt" with points
	EOF
else
        echo "install gnuplot to get a graph"
fi
rm results.txt
