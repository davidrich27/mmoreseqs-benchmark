#!/usr/bin/awk -f 
##########################################################
# FILE:
# DESC:
##########################################################

if (( $# != 2 ))
then
    echo 'Usage: <m3t_file> <m3t_out>'
    exit
fi

SRC=$1
DEST=$2

TMP1=${SRC}.tmp1
TMP2=${SRC}.tmp2

# sort by eval
sort -k3,3 -g -s $SRC > $TMP1
# sort by target
sort -k2,2 -s $TMP1 > $TMP2
# sort by query
sort -k1,1 -s $TMP2 > $TMP1

# temporary holdover
mv $TMP1 $DEST

# duplicates are now adjacent


# remove temp files
rm $TMP1
rm $TMP2
