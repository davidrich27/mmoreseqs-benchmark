#!/bin/bash -ex
#set -x
##############################################
# NAME: phmmer_n1.sh 
# DESC: 
##############################################

# program name
SUITE=hmmer
TYPE=phmmer_n1

echo "# $SUITE $TYPE [BEGIN]"

# set environmental variables: program, database, temp, output locations
source "../set-env.sh"

# commandline args
NUM_ARGS=$#
if (( NUM_ARGS < 3 )); then
	echo "Usage ($NUM_ARGS/3): <MY_ID> <JOB_ID> <TASK_ID> <N_TASKS> <opt:BENCHMARK>"
	exit
fi
# required args
MY_ID=$1
JOB_ID=$2
TASK_ID=$3
N_TASKS=$4
MY_BENCHMARK=$5

#TODO parse commandline

# load database TODO if statement
LOAD_SOEDING $TASK_ID
LOAD_PROFMARK $TASK_ID
LOAD_TEST $TASK_ID
LOAD_MYBENCH $TASK_ID
SELECT_BENCHMARK $MY_BENCHMARK $TASK_ID

# default parameters (should not override if already been set)
# job data
MY_ID="${MY_ID:-000}"
JOB_ID="${JOB_ID:-000}"
TASK_ID="${TASK_ID:-0}"
N_TASKS="${N_TASKS:-1}"
# input
BENCHMARK="${MY_BENCHMARK:-$BENCHMARK}"
TARGET="${TARGET:-test_target.fasta}"
QUERY_FA="${QUERY:-test_query.fasta}"
QUERY_HMM="${QUERY_HMM:-test_query.hmm}"
# search params
E_VALUE="${E_VALUE:-10000.0}"
# iterative search params
N_ITERS="${N_ITERS:-1}"
E_PROF="${E_PROF:-0.001}"
# other params
N_CPUS="${N_CPUS:-0}"
VERBOSE="${VERBOSE:-1}"
MKDIR_V="${MKDIR_V:--v}"

# select which query database
SELECT_BENCHMARK $BENCHMARK
#MY_QUERY=$QUERY_SPLIT
MY_QUERY=$QUERY_FA
MY_TARGET=$TARGET

# temp overwrite 
#MY_QUERY=/home/dr120778/Wheeler-Labs/benchmarks/general-benchmark/db/soeding/query_timedout/query.${TASK_ID}.fasta

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
echo "#  LOCATION:  $HMMER_PHMMER"
echo "#     MY_ID:  $MY_ID"
echo "#    JOB_ID:  $JOB_ID"
echo "#   TASK_ID:  $TASK_ID"
# input
echo "# BENCHMARK:  $BENCHMARK"
echo "#     QUERY:  $QUERY"
echo "#  QUERY_FA:  $QUERY_FA"
echo "# QUERY_HMM:  $QUERY_HMM"
echo "# QUERY_SPL:  $QUERY_SPLIT"
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
# selected database	 
echo "#  MY_QUERY:  $MY_QUERY"
echo "# MY_TARGET:  $MY_TARGET"

# run search
time $HMMER_PHMMER					\
	--domtblout 	$DOMTBLOUT 		\
	-A 				$ALNOUT 		\
	--notextw 						\
	-E 				$E_VALUE 		\
	--cpu 			$N_CPUS 		\
	-Z 				$N_TARGET 		\
	$MY_QUERY $MY_TARGET			\
# unused args:
#	-o 				$STDOUT 		\
#	-N 				$N_ITERS		\

echo "# $SUITE $TYPE [END]"

