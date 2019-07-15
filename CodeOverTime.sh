#/bin/bash

year=$(date +'%Y')
declare -A VALIDS
declare -A DATA
startyear=$(git log --reverse | head -3 | tail -n 1 | awk '{print $6}')


# For every year the project existed
for i in `seq $startyear $year`;
do    
        
    # extract the commit ID for the last commit of the year
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
for i in "${!DATA[@]}"
do
    year=$i
    lines=${DATA[$i]}
    echo "$year : $lines"
done

# Do we want JSON output?
for arg in "$@"
do
    if [ "$arg" == "--json" ] || [ "$arg" == "-j" ]
    then
	filename=${PWD##*/}
	touch $filename.json

	# Start the JSON file
	echo "{" >> $filename.json
        echo "  \"$filename\": [" >> $filename.json
        echo "    {" >> $filename.json

	for i in "${!DATA[@]}"

	# Fill in the results
	do
	    year=$i
	    lines=${DATA[$i]}
	    echo "      \"$year\":\"$lines\"," >> $filename.json
	done
	# Remove trailing comma
	sed -i '$ s/.$//' $filename.json 

	# Finish JSON file
	echo "    }" >> $filename.json
        echo "  ]" >> $filename.json
	echo "}" >> $filename.json

    fi
done

# Do we want a graph?
for arg in "$@"
do	
    if [ "$arg" == "--graph" ] || [ "$arg" == "-g" ]
    then
	
	if which gnuplot >> /dev/null;
	then
	    touch results.txt
	    for i in "${!DATA[@]}"
	    do
    		year=$i
    		lines=${DATA[$i]}
    		echo "$year $lines" >> results.txt
	    done

	    gnuplot <<- EOF
		set xlabel "Year"
	        set ylabel "Lines of Code"
	        set title "Code over time"
	        set terminal dumb
	        plot "results.txt" with points
		EOF
	    rm results.txt
	else
		echo "install gnuplot to get a graph"
	fi
    fi
done
