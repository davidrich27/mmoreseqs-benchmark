#!/bin/sh
#################################################
# NAME: phmmer_n3.sh
# DESC: SLURM batch script for phmmer
#################################################
#
#SBATCH --job-name=PHMMER_SEARCH_N1.%A_%a
#SBATCH --output=output/PHMMER_SEARCH_N1.%A_%a.out
#SBATCH --error=output/PHMMER_SEARCH_N1.%A_%a.err
#SBATCH --mail-type=ALL
#
#SBATCH --partition=normal
#SBATCH --exclusive
##SBATCH --ntask=1
#SBATCH --time=8:00:00
#SBATCH --array=[0-42]
#

# program location
cd ../../hmmer/
PROGRAM=phmmer_n3.sh

# commandline args
MY_ID=$1
JOB_ID=$SLURM_JOB_ID
TASK_ID=$SLURM_ARRAY_TASK_ID

echo "#   MY_ID:  $MY_ID"
echo "#  JOB_ID:  $JOB_ID"
echo "# TASK_ID:  $TASK_ID"

srun bash $PROGRAM $SLURM_JOB_ID $MY_ID


