#!/bin/bash
set -eux
clang-format -i $(find $(pwd) -name "*.[ch]pp" -or -name "*.[ch]")
git diff --exit-code --ignore-submodule=all
