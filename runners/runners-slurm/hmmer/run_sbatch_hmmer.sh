#!/bin/bash
###############################################
#  FILE:  run_sbatch_template.sh
#  DESC:  Runs sbatch with proper settings.
################################################

BENCH_DIR=$(pwd)

NUM_ARGS=$#
if (( NUM_ARGS < 1 )); then
	echo "Usage: <MY_SCRIPT> <opt:MY_BENCHMARK> <opt:MY_ID>"
	exit
fi
MY_SCRIPT=$1
MY_BENCHMARK=$2
MY_ID=$3

source "../set-env_cluster.sh"
cd $BENCH_DIR
source "../../set-env.sh"
cd $BENCH_DIR

MY_ID=$1
MY_ID="${MY_ID:-$(uuidgen)}"

JOB_NAME="test"
SBATCH_FILE=sbatch_test.sh

OUT_DIR=output/
ERR_DIR=error/

N_TASKS=5
TASK_ID_START=0
TASK_ID_END=$((TASK_ID_START + N_TASKS - 1))

if (( N_TASKS == 0 )) 
then
	ARRAY="[$TASK_ID_START]"
else
	ARRAY="[$TASK_ID_START-$TASK_ID_END]"
fi

PARTITION="${PARTITION:-}"
STDOUT=${JOB_NAME}.${MY_ID}.%a.out
STDERR=${JOB_NAME}.${MY_ID}.%a.err

mkdir -p $OUT_DIR
mkdir -p $ERR_DIR

echo "#    MY_HOST:  $MY_HOST"
echo "#  PARTITION:  $PARTITION"
echo "#      MY_ID:  $MY_ID"
echo "#   JOB_NAME:  $JOB_NAME"
echo "#     STDOUT:  $STDOUT"
echo "#     STDERR:  $STDERR"
echo "#  BENCH_DIR:  $BENCH_DIR"

sbatch  									\
	--job-name=$JOB_NAME 					\
	--output=$STDOUT 						\
	--partition=$PARTITION 					\
	--array=$ARRAY 							\
	--chdir=$BENCHDIR 						\
	$SBATCH_FILE							\
	$MY_ID									\


echo "# SBATCH job called."
