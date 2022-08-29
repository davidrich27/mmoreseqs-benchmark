#!/bin/sh
####################################################
# NAME: run_hmmsearch_n1.sh
# DESC: SLURM batch script for hmmsearch_n1.sh
####################################################
#
#SBATCH --job-name=hmmsearch_n1.%A_%a
#SBATCH --output=hmmsearch_n1.%A_%a.out
##SBATCH --error=hmmsearch_n1.%A_%a.err
#SBATCH --mail-type=ALL
#
#SBATCH --partition=normal
#SBATCH --exclusive
#SBATCH --ntasks=1
#SBATCH --time=5:00:00
#SBATCH --array=[0]
#

# program location
cd ../../hmmer/
PROG=hmmsearch_n1.sh 

# commandline args
NUM_ARGS=$#
if (( NUM_ARGS != 1 ))
then
	echo "Usage: <MY_ID>"
	exit
fi
# required args
MY_ID=$1

# main script
echo "#   MY_ID:  $MY_ID"
echo "#  JOB_ID:  $SLURM_JOB_ID"
echo "# TASK_ID:  $SLURM_ARRAY_TASK_ID"

srun bash $PROG $MY_ID $SLURM_JOB_ID $SLURM_ARRAY_TASK_ID

