#!/usr/bin/bash  
##########################################################
# FILE: evaluate_pipeline.sh
# DESC: Evaluates results and output as a .tf file
##########################################################

# location called from
BENCH_DIR=$(pwd)
# location of script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

RESULTS_DIR=/home/dr120778/Wheeler-Labs/benchmarks/general-benchmark/evaluate/results_raw/
cd $RESULTS_DIR

BENCHMARKS=(soeding profmark my-benchmark)
FILETYPES=(m8 domtblout)

for BENCHMARK in ${BENCHMARKS[@]}
do
	for FILETYPE in ${FILETYPES[@]}
	do

		echo "# BENCHMARK:  $BENCHMARK"
		echo "#  FILETYPE:	$FILETYPE"
		FILES=$(ls | grep ${BENCHMARK} | grep ${FILETYPE})

		for FILE in ${FILES[@]}
		do
			echo "#    FILE: $FILE"
			bash ${SCRIPT_DIR}/full_evaluate.sh $FILE $FILETYPE $BENCHMARK

		done
	done
done 

cd $BENCH_DIR
echo "# done."

