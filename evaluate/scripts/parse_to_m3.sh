#!/usr/bin/sh 
#########################################################
# FILE: parse_to_m3.sh
# DESC:
#########################################################
 
if [ $# != 3 ]
then 
	echo "Description: Parses results file to create an .m3 file (also removes comments)"
	echo "Usage: <in:raw_file> <file_type> <out:m3_file>"
	echo "Opts: file_type: [m8, domtblout, m3]"
	exit
fi

SRC=$1
TYPE=$2
DEST=$3

# parse if supported file format ( strips commented lines )
if [ $TYPE == 'domtblout' ]
then
	cat $SRC | awk '!/^#/ { print $4, $1, $7 }' | sort -k3,3 -g > $DEST
elif [ $TYPE == 'm8' ]
then
	cat $SRC | awk '!/^#/ { print $1, $2, $11 }' | sort -k3,3 -g > $DEST
elif [ $TYPE == 'm3' ]
then
	cp $SRC $DEST
else
	echo "ERROR: $TYPE is not a supported file format."
	exit
fi

echo "# ...done."
