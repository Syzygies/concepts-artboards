#!/bin/bash

cd "$(dirname "$0")"

../concepts-artboards \
  --input "Test.svg" \
  --output "Test.pdf" \
  --directory 'pdf' \
  --labels 'Labels' \
  --pdf \
  --remove 'Edges'
