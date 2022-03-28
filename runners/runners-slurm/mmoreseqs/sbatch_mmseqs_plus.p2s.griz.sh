#!/bin/bash
#####################################################################
# FILE:  sbatch_mmseqs_plus.sh
# DESC:
#####################################################################
#
#SBATCH --job-name=mmseqs-plus-%A_%a
#SBATCH --output=mmseqs-plus.%A_%a.out
# 
#SBATCH --partition=wheeler_lab_large_cpu
#SBATCH --exclusive
#SBATCH --ntasks=1
#SBATCH --time=8:00:00
#
#SBATCH --array=[0-24]

JOB_ID=$SLURM_JOB_ID
TASK_ID=$SLURM_ARRAY_TASK_ID

# program
cd ../../fbpruner/
MAIN_PROGRAM=mmseqs-plus.sh

# task array size
NUM_TASKS=25

# job id (creates datestring)
JOB_ID=$(my_date)
echo "# JOB_ID: $JOB_ID"

# commandline args
NUM_ARGS=$#
if (( NUM_ARGS < 5 )); then
	echo "Usage: <MY_ID> <JOB_ID> <ALPHA> <BETA> <GAMMA> <BENCHMARK> <opt:MMSEQS_IN>"
	exit
fi
# required args
MY_ID=$1
JOB_ID=$2
ALPHA=$3
BETA=$4
GAMMA=$5
BENCHMARK=$6
MMSEQS_IN=$7

# start time
TIME=$(date +%D:%H:%M:%N)
echo "# ==>START_TIME=$TIME"

echo "# TASK: ($TASK_ID of $NUM_TASKS)"

# main task
time srun bash $MAIN_PROGRAM $MY_ID $JOB_ID $TASK_ID $NUM_TASKS $ALPHA $BETA $GAMMA $BENCHMARK $MMSEQS_IN

# end time
TIME=$(date +%D:%H:%M:%N)
echo "# ==>END_TIME=$TIME"


