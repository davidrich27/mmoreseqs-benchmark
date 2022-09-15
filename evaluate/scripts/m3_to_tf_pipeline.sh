#!/usr/bin/bash  
##########################################################
# FILE: evaluate_pipeline.sh
# DESC: Evaluates results and output as a .tf file
##########################################################

BENCH_DIR=$(pwd)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if (( $# != 3 ))
then
	echo 'Description: Convert m3 to tf file.'
    echo 'Usage: <in:m3_file> <out:tf_file> <benchmark>'
	echo 'Opts:' 
	echo '          benchmark:   [profmark, soeding]'
    exit
fi

SRC=$1
DEST=$2
BENCHMARK=$3

# check that valid args given
ALL_BENCHMARKS=("profmark" "soeding", "my-benchmark")

if [[ " ${ALL_BENCHMARKS[@]} " =~ " ${BENCHMARK} " ]]
then
	echo "# BENCHMARK: $BENCHMARK"
else
    echo "# ERROR: benchmark $BENCHMARK is not supported."
    exit
fi

TMP1=$SRC.tmp1
TMP2=$SRC.tmp2

echo "# RESULTS_FILE: $SRC"
echo "#  OUT_TF_FILE: $DEST"

# evaluate truth
echo "# eval truth..."
if [ $BENCHMARK == 'profmark' ]
then
	python $SCRIPT_DIR/eval_profmark.py $SRC $TMP2
elif [ $BENCHMARK == 'soeding' ]
then
	python $SCRIPT_DIR/eval_soeding.py $SRC $TMP2
elif [ $BENCHMARK == 'my-benchmark' ]
then
	python $SCRIPT_DIR/eval_profmark.py $SRC $TMP2
fi

# accumulate truth and falses
echo "# aggregate results..."
# sort by eval
sort -k3,3 -g $TMP2 > $TMP1
# compute running totals of true, false, unknown
python $SCRIPT_DIR/accumulate_truths.py $TMP1 $DEST 

rm $TMP1
rm $TMP2

echo "# done."

