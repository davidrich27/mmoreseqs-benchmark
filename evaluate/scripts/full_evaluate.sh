#!/usr/bin/bash  
##########################################################
# FILE: evaluate_pipeline.sh
# DESC: Evaluates results and output as a .tf file
##########################################################

# location called from
BENCH_DIR=$(pwd)
# location of script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if (( $# != 3 ))
then
	echo 'Description: Full evaluation pipeline.'
    echo 'Usage: <results> <file_type> <benchmark> <opt:remove_tmp>'
    exit
fi

SRC=$1
FILETYPE=$2
BENCHMARK=$3
REMOVE_TMP="${REMOVE_TMP:-0}"

# extract filename and extension
FILE=$(basename -- "$SRC")
EXT="${FILE##*.}"
NAME="${FILE%.*}"

echo "# FILE: $FILE"
echo "# EXT: $EXT"
echo "# NAME: $NAME"

# destination folders
ROOT_FOLDER=/home/dr120778/Wheeler-Labs/benchmarks/general-benchmark/evaluate/
RAW_FOLDER=${ROOT_FOLDER}/results_raw/
M3_FOLDER=${ROOT_FOLDER}/results_m3/
TF_FOLDER=${ROOT_FOLDER}/results_tf/
FINAL_FOLDER=${ROOT_FOLDER}/results_final/

RAW_FILE=${RAW_FOLDER}/${SRC}
M3_FILE=${M3_FOLDER}/${NAME}.m3
TF_FILE=${TF_FOLDER}/${NAME}.tf
FINAL_FILE=${FINAL_FOLDER}/${NAME}.tf

# convert raw results to m3 file
bash ${SCRIPT_DIR}/raw_to_m3_pipeline.sh $RAW_FILE $M3_FILE $FILETYPE $BENCHMARK

# convert m3 file to tf file
bash ${SCRIPT_DIR}/m3_to_tf_pipeline.sh $M3_FILE $TF_FILE $BENCHMARK

# downsample so results is in order of 10,000 entries
SIZE=$(wc -l ${TF_FILE} | awk '{print $1}')
ORDER=${#SIZE}

echo "#  SIZE:  $SIZE"
echo "# ORDER:  $ORDER"

if (( $ORDER > 5 ))
then
	SCALE=$(( $ORDER - 5 ))
else
	SCALE=$(( 0 ))
fi
SCALE=$(( 10**${SCALE} ))

awk -v S=$SCALE '{ if (NR % S == 0) print $0 }' ${TF_FILE} > ${FINAL_FILE}

echo "# done."

