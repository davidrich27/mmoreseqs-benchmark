#!/usr/bin/bash  
##########################################################
# FILE: evaluate_pipeline.sh
# DESC: Evaluates results and output as a .tf file
##########################################################

BENCH_DIR=$(pwd)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if (( $# != 4 ))
then
	echo 'Description: Evaluate .'
    echo 'Usage: <i:raw_file> <o:m3_file> <results_type> <benchmark>'
	echo 'Opts:' 
	echo '       results_type:   [m8, domtblout, m3, myout]'
	echo '          benchmark:   [profmark, soeding]'
    exit
fi

SRC=$1
DEST=$2
TYPE=$3

# check that valid args given
ALL_TYPES=("m8" "domtblout" "m3")

if [[ " ${ALL_TYPES[@]} " =~ " ${TYPE} " ]]
then
	echo "# TYPE: $TYPE"
else
    echo "# ERROR: results_type $TYPE is not supported."
    exit
fi

TMP1=${SRC}.tmp1
TMP2=${SRC}.tmp2

echo "#        TEMPS:  $TMP1, $TMP2"
echo "# RESULTS_FILE:  $SRC"
echo "#  OUT_M3_FILE:  $DEST"

# parse into .m3 file
echo "# parse to m3..."
bash $SCRIPT_DIR/parse_to_m3.sh $SRC $TYPE $TMP1

# remove duplicates
echo "# remove dupes..."
bash $SCRIPT_DIR/remove_duplicates_prep.sh $TMP1 $TMP2
python $SCRIPT_DIR/remove_duplicates_sorted.py $TMP2 $TMP1

# end of pipeline 
mv $TMP1 $DEST

rm $TMP1
rm $TMP2

echo "# done."

