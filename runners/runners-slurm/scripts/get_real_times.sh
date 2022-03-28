#!/bin/bash
######################################################################
# FILE: get_times.sh
# DESC: retrieve times from output in seconds.
######################################################################

INFILE=$1

# extract times
echo "FILE: $(pwd)"
grep "real" * | awk '{ print $2 }' | rev | cut -c 2- | rev | awk -F'm' '{ print ($1 * 60) + $2 }'
echo "============="
# sum times
grep "real" * | awk '{ print $2 }' | rev | cut -c 2- | rev | awk -F'm' '{ print ($1 * 60) + $2 }' | paste -sd+ | bc

