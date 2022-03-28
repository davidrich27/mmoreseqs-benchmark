#!/bin/bash
#set -x
###############################################
#  FILE:  sbatch_runner.sh
#  DESC:  Runs sbatch with proper settings.
################################################

# get cluster-specifics
source "set-env_cluster.sh"

# command line args
NUM_ARGS=$#
if (( NUM_ARGS < 1 )); 
then 
    echo "Usage: <SBATCH_SCRIPT> ..."
    exit
fi
# required args
ARGS=("$@":1)
SBATCH_FILENAME=$1
# job name
JOB_NAME=$( cat $SBATCH_FILENAME | cut -d '.' -f 1 )
# set task array
NTASKS=1
TASK_ID_START=0
TASK_ID_END=$((TASK_ID_START + NTASKS - 1))

NODELIST=
STDOUT=$JOB_NAME.%A_%a.out
STDERR=$JOB_NAME.%A_%a.err
TIME={

mkdir -p $OUT_DIR
mkdir -p $ERR_DIR

sbatch $SBATCH_FILE 						\
	$ARGS									\
	--job-name=$JOB_NAME 					\
	--output=$STDOUT 						\
	--error=$STDERR 						\
	--partition=$PARTITION 					\
	--array=[$TASK_ID_START,$TASK_ID_END]   \
	--time=

echo "SBATCH job called."
