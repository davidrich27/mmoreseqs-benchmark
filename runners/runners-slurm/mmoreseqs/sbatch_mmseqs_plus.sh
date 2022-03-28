#!/bin/bash
#####################################################################
# FILE: 
# DESC:
#####################################################################
#
#SBATCH --job-name=mmseqs-plus-%A
#SBATCH --output=mmseqs-plus.%A_%a.out
##SBATCH --error=mmseqs-plus.%A_%a.err
# 
#SBATCH --partition=normal
#SBATCH --exclusive
#SBATCH --ntasks=1
#SBATCH --time=8:00:00
#
#SBATCH --array=[0-99]

JOB_ID=$SLURM_JOB_ID
TASK_ID=$SLURM_ARRAY_TASK_ID

# program
cd ../../fbpruner/
MAIN_PROGRAM=mmseqs-plus.sh

# task array size
NUM_TASKS=100

# commandline args
NUM_ARGS=$#
if (( NUM_ARGS != 4 )); then
	echo "Usage: <MY_ID> <ALPHA> <BETA> <GAMMA>"
	exit
fi
# required args
MY_ID=$1
ALPHA=$2
BETA=$3
GAMMA=$4

# start time
TIME=$(date +%D:%H:%M:%N)
echo "# ==>START_TIME=$TIME"

echo "# TASK: ($TASK_ID of $NUM_TASKS)"

# main task
time srun bash $MAIN_PROGRAM $MY_ID $JOB_ID $TASK_ID $NUM_TASKS $ALPHA $BETA $GAMMA

# end time
TIME=$(date +%D:%H:%M:%N)
echo "# ==>END_TIME=$TIME"


