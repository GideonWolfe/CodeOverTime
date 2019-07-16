#!/bin/bash

# This script is meant to act as a handler for the main program.
# Use this if you wanted to preform a batch line count on multiple repositories
# RUN THIS IN A CLEAN DIRECTORY, unless you want every repo to be newly cloned.


declare -a REPOSITORIES

# Fill in your repositories here
REPOSITORIES=(
)

#Clone all the repositories
for i in "${REPOSITORIES[@]}"
do
	git clone $i
done

# For every directory calculate the lines
# and then output a JSON to the root directory
for dir in */
do
	cd "$dir"
	codeovertime -j
	mv ${dir%/}.json ..
	cd ..
done
