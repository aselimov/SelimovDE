#!/bin/bash

# Define the input file
 input_file="$HOME/docs/kjv.txt"

 # Generate a unique identifier based on the current date
 date=$( date +%Y%m%d )

 # Generate random data with a seed
 get_seeded_random()
{
  seed="$1"
  openssl enc -aes-256-ctr -pass pass:"$seed" -nosalt \
    </dev/zero 2>/dev/null
}

random_line=$(shuf -n 1 --random-source=<(get_seeded_random "$date") $input_file)

 # Print the randomly selected line
 echo "$random_line"
