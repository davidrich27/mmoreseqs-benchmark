#!/usr/bin/awk -f 
##########################################################
# FILE: find_above_cutoff.sh
# DESC: 
##########################################################

if (( $# != 3 ))
then
	echo 'Description: finds all entries for which evalue is better than given threshold.'
    echo 'Usage: <m3_file> <file_type> <eval_cutoff>'
	echo 'Opts: file_type: [m3, m8, m8+]'
    exit
fi

SRC=$1
TYPE=$2
EVAL=$3

FIELD=-1

# get proper field depending on file type.
if [ $TYPE == 'm3' ]
then
	FIELD=3
elif [ $TYPE == 'm8' ]
then 
	FIELD=11
elif [ $TYPE == 'm8+' ]
then
	FIELD=16
else
	echo "ERROR: file_type '$TYPE' is not a valid file type."
	exit
fi

echo '#QUERY TARGET E-VALUE'
cat $SRC | awk -v EVAL=$EVAL -v FIELD=$FIELD '{ if ($FIELD < EVAL) print $0 }'
