#!/bin/bash

# Check if the input file is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <file>"
  exit 1
fi

input_file="$1"

cat $input_file | xargs nak decode | jq .pubkey | sed 's/$/,/' | sed 's/^/  /' | pbcopy
