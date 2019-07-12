#!/bin/bash

# Just pull from master to revert back

year=$(date +'%Y')
declare -A VALIDS
declare -A DATA

# For every year since 2010
for i in `seq 2010 $year`;
do	
	# Check to see if repo was active yet
	if [[ $(git log --since=2010-01-01 --until=$i-12-31 | wc -l) = 0 ]]
	then
		echo "No activity for $i"
		continue
	fi
	
	# If it was, log the year and the IF of the last commit that year
	COMMIT="$(git log --oneline --since=2010-01-01 --until=$i-12-31 | awk '{print $1}' | head -2 | tail -n 1)"
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
    NUMLINES="$(cloc . --diff-timeout 0 | grep SUM | awk '{print $5}')"
    
    # Add to final data structure
    DATA+=([$year]=$NUMLINES) 
done

# Print results
for i in "${!DATA[@]}"
do
	year=$i
	lines=${DATA[$i]}
	echo "$year : $lines"
	echo "$year $lines" >> results.txt

done


# Plot results
if which gnuplot >> /dev/null;
then
	gnuplot <<- EOF
		set xlabel "Year"
		set ylabel "Lines of Code"
		set title "Code over time"
		set terminal dumb
		plot "results.txt" with lines
	EOF
else
	echo "install gnuplot to get a graph"
fi

rm results.txt
