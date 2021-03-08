#!/bin/bash

cd "$(dirname "$0")"

../concepts-artboards \
  --input "Test.svg" \
  --output "Test.pdf" \
  --labels 'Labels' \
  --directory 'pdf' \
  --pdf
