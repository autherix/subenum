#!/usr/bin/env bash 

# Get current running file's directory and save to a var
c_path=$(dirname $0)

# Make a logs directory in current running file's directory
mkdir -p $c_path/logs

# In two upper directory, read the file h1_tgts_new_full.json , then jq it to get the list of targets' handles
target_handle_list=$(healerdb h1_targetinfo list -db bbplats -coll h1 -j | jq -r '.result[]')

# Iterate over the list of targets' handles and run subenum on each of them
for target_handle in $target_handle_list
do
    # Print seperator
    echo "----------------------------------------"
    # Print the target handle
    echo "Target handle: $target_handle"
    # Run subenum on the target handle
    # subenum -p h1 -db enum -t $target_handle
    subenum -p h1 -db enum -t $target_handle >> $c_path/logs/subenum-all-h1.log 2>&1
    wait $!
    # Check if the subenum command was successful or not
    if [ $? -eq 0 ]
    then
        echo "----------------------------------------"
    else
        echo "subenum failed on target: $target_handle" >> $c_path/logs/subenum-all-h1-targets.log
        echo "Error text: $?" >> $c_path/logs/subenum-all-h1-targets.log
        echo "----------------------------------------"
    fi
done