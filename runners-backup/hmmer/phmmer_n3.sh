#!/bin/bash -ex
##############################################
# NAME: phmmer_n2.sh 
# DESC: 
##############################################

# program name
SUITE=hmmer
TYPE=phmmer_n2

echo "# $SUITE $TYPE [BEGIN]"

# set environmental variables: program, database, temp, output locations
source "../set-env.sh"

# commandline args
NUM_ARGS=$#
if (( NUM_ARGS != 3 )); then
	echo "Usage: <MY_ID> <JOB_ID> <TASK_ID>"
	exit
fi
# required args
MY_ID=$1
JOB_ID=$2
TASK_ID=$3

# default parameters (should not override if already been set)
# job data
MY_ID="${MY_ID:-000}"
JOB_ID="${JOB_ID:-000}"
TASK_ID="${TASK_ID:-0}"
N_TASKS="${N_TASKS:-1}"
# input
TARGET="${TARGET:-test_target.fasta}"
QUERY_FA="${QUERY_FA:-test_query.fasta}"
QUERY_HMM="${QUERY_HMM:-test_query.hmm}"
QUERY_SPLIT="${QUERY_SPLIT:-query_split/query.${TASK_ID}.hmm}"
# search params
E_VALUE="${E_VALUE:-10000.0}"
# iterative search params
N_ITERS="${N_ITERS:-2}"
E_PROF="${E_PROF:-0.001}"
# other params
N_CPUS="${N_CPUS:-0}"
VERBOSE="${VERBOSE:-1}"
MKDIR_V="${MKDIR_V:-v}"


# select type of query
MY_QUERY=

# temp directory
MY_TMP_DIR=$TMP_DIR/$BENCHMARK/$SUITE
mkdir -p $MKDIR_V $MY_TMP_DIR

# output directory
MY_OUTPUT_DIR=$OUTPUT_DIR/$BENCHMARK/$SUITE/$TYPE/$JOB_ID
mkdir -p $MKDIR_V $MY_OUTPUT_DIR
# output files
STDOUT=$MY_OUTPUT_DIR/results.${TASK_ID}.stdout
ALNOUT=$MY_OUTPUT_DIR/results.${TASK_ID}.alnout
DOMTBLOUT=$MY_OUTPUT_DIR/results.${TASK_ID}.domtblout

# print args
# ids
echo "#   PROGRAM:  $SUITE $TYPE"
echo "#     MY_ID:  $MY_ID"
echo "#    JOB_ID:  $JOB_ID"
echo "#   TASK_ID:  $TASK_ID"
# input
echo "#  QUERY_FA:  $QUERY_FA"
echo "# QUERY_HMM:  $QUERY_HMM"
echo "# QUERY_SPL: 	$QUERY_SPLIT"
echo "#    TARGET:  $TARGET"
# output
echo "#    STDOUT:  $STDOUT"
echo "#    ALNOUT:  $ALNOUT"
echo "# DOMTBLOUT:  $DOMTBLOUT"
# search parameters
echo "#   N_ITERS:  $N_ITERS"
echo "#    N_CPUS:  $N_CPUS"
echo "#   E_VALUE:  $E_VALUE"
echo "#   VERBOSE:  $VERBOSE"

# run search
time jackhmmer 						\
	--domtblout 	$DOMTBLOUT 		\
	-A 				$ALNOUT 		\
	-N 				$N_ITERS		\
	--notextw 						\
	-E 				$E_VALUE 		\
	--cpu 			$N_CPUS 		\
	-Z 				$N_TARGET 		\
	$QUERY $TARGET					
# unused opts:
#	-o 				$STDOUT 		\

echo "# $SUITE $TYPE [END]"

