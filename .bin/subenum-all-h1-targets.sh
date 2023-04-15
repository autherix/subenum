#!/usr/bin/env bash 

# Get current running file's directory and save to a var
c_path=$(dirname $0)

# Find where does the file 'get_programs_h1.py' is located save to a var
get_programs_h1=$(which get_programs_h1.py)

get_programs_h1_parent_2=$(dirname $(dirname $get_programs_h1))

# Make a logs directory in current running file's directory
mkdir -p $c_path/logs

# In two upper directory, read the file h1_tgts_new_full.json , then jq it to get the list of targets' handles
target_handle_list=$(cat $get_programs_h1_parent_2/h1_tgts_new_full.json | jq -r '.[].attributes.handle') # | xargs -I {} subenum -p h1 -db enum -t {}

# Iterate over the list of targets' handles and run subenum on each of them
for target_handle in $target_handle_list
do
    # Print seperator
    echo "----------------------------------------"
    # Print the target handle
    echo "Target handle: $target_handle"
    # Run subenum on the target handle
    subenum -p h1 -db enum -t $target_handle
    # Check if the subenum command was successful or not
    if [ $? -eq 0 ]
    then
        echo "----------------------------------------"
    else
        echo "subenum failed on target handle: $target_handle" >> $c_path/logs/subenum-all-h1-targets.log
        echo "Error text: $?" >> $c_path/logs/subenum-all-h1-targets.log
        echo "----------------------------------------"
    fi
done