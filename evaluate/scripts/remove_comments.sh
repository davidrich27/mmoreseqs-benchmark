#!/usr/bin/sh 
#########################################################
# FILE: remove_comments.sh
# DESC:
#########################################################
 
if [ $# != 2 ]
then 
	echo "Description: Remove comment lines."
	echo "Usage: <in_file> <out_file>"
	exit
fi

SRC=$1
DEST=$2

cat $SRC | awk '!/^#/ {print $0 }' | sort -k3,3 -g > $DEST

echo "# ...done."
