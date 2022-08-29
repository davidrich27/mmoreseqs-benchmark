#!/bin/sh
####################################################
# NAME: run_hmmsearch_n1.sh
# DESC: SLURM batch script for hmmsearch_n1.sh
####################################################
#
#SBATCH --job-name=hmmsearch_n1.%A_%a
#SBATCH --output=hmmsearch_n1.%A_%a.out
#SBATCH --mail-type=ALL
#
#SBATCH --partition=wheeler_lab_large_cpu
#SBATCH --exclusive
#SBATCH --ntasks=1
#SBATCH --time=3:00:00
#SBATCH --array=[0-21]
#

# slurm vars
JOB_ID="${SLURM_JOB_ID}"
TASK_ID="${SLURM_ARRAY_TASK_ID}"
N_TASKS="21"

# program location
cd ../../hmmer/
PROG="hmmer.p2s.sh" 

# commandline args
NUM_ARGS=$#
if (( NUM_ARGS < 1 ))
then
	echo "Usage: <MY_ID>"
	exit
fi
# required args
MY_ID=${1}

# job stats
echo "#     MY_ID:  $MY_ID"
echo "#    JOB_ID:  $JOB_ID"
echo "#   TASK_ID:  $TASK_ID"
echo "#   N_TASKS:  $N_TASKS"
echo "#  NODELIST:  $SLURM_JOB_NODELIST"
echo "# BENCHMARK:  $MY_BENCHMARK"

TIME=$(date +%D:%H:%M:%N)
echo ">>START_TIME: $TIME"

srun bash $PROG $MY_ID $MY_ID $TASK_ID $N_TASKS $MY_BENCHMARK

TIME=$(date +%D:%H:%M:%N)
echo ">>END_TIME: $TIME"

