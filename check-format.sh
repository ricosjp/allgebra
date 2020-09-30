#!/bin/bash
set -eu

FILES=$(git ls-files | grep -e ".*.[ch]pp")
if [[ -z "$FILES" ]]; then
  echo "No C++ codes found"
  exit 1
fi

clang-format -i $FILES
git diff --exit-code --ignore-submodules=all $FILES
