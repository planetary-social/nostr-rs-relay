#!/bin/bash

# Check if the input file is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <file>"
  exit 1
fi

input_file="$1"

# Get the current month, day, and time period
current_month=$(date +%B)
current_day=$(date +%-d)
time_period=$(date +%p | tr '[:upper:]' '[:lower:]')

# Construct the comment line
date_msg="$current_month $current_day $time_period"
comment_line="  # $date_msg"

# Read the file and transform it
cat "$input_file" | while IFS= read -r line; do
  # Skip empty lines
  [ -z "$line" ] && continue
  # Extract the first string of each line
  first_string=$(echo "$line" | awk '{print $1}')
  # Decode the first string and transform it
  pubkey=$(echo "$first_string" | nak decode | jq -r .pubkey)
  echo "  \"$pubkey\", # $first_string"
done | pbcopy

# Open config.toml in vim and paste the clipboard content
vim config.toml -c '/pubkey_whitelist_readers' -c "normal o" -c "normal k" -c "normal o$comment_line" -c 'normal "+p' -c 'wq'

echo config.toml was edited with new pubkeys, verify and commit \n

git add config.toml
git commit -m "$date_msg key updates"
git show

