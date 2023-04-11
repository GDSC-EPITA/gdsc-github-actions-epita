#!/bin/sh -l
pip install whispers
output=$(whispers src/)
if [ "$output" = "[]" ]
then
	exit 0
fi
echo "Whispers error: $output"
exit 1
