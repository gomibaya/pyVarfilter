#!/bin/sh
# pre-commit.sh

# Redirect output to stderr.
exec 1>&2

make build
ret=$?

exit $ret