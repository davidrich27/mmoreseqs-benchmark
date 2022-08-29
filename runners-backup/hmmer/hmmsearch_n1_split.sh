#!/bin/bash 
##############################################
# NAME: hmmer_search_n1.sh 
# DESC: 
##############################################

# program name
SUITE=hmmer
TYPE=hmmsearch_n1

echo "# $SUITE $TYPE [BEGIN]"

# set environmental variables: program, database, temp, output locations
source "../set-env.sh"

# commandline args
NUM_ARGS=$#
if (( NUM_ARGS < 4 )); then
	echo "Usage: <MY_ID> <JOB_ID> <TASK_ID> <NUM_TASKS> <opt:BENCHMARK>"
	exit
fi
# required args
MY_ID=$1
JOB_ID=$2
TASK_ID=$3
NUM_TASKS=$4
MY_BENCHMARK=$5

# load proper benchmark
LOAD_PROFMARK "$TASK_ID" 
LOAD_SOEDING "$TASK_ID"
LOAD_TEST "$TASK_ID"
LOAD_MYBENCH "$TASK_ID"
SELECT_BENCHMARK $MY_BENCHMARK $TASK_ID

# default parameters (should not override if already been set)
# job data
MY_ID="${MY_ID:-000}"
JOB_ID="${JOB_ID:-000}"
TASK_ID="${TASK_ID:-0}"
N_TASKS="${N_TASKS:-1}"
# input
TARGET="${TARGET:-test_target.fasta}"
QUERY="${QUERY:-test_query.hmm}"
QUERY_SPLIT="${QUERY_SPLIT:-test_query.0.hmm}"
# search params
E_VALUE="${E_VALUE:-10000.0}"
# iterative search params
N_ITERS="${N_ITERS:-1}"
E_PROF="${E_PROF:-0.001}"
NONULL2="${NONULL2:---nonull2}" # test --nonull2 flag?
# other params
N_CPUS="${N_CPUS:-0}"
VERBOSE="${VERBOSE:-1}"
MKDIR_V="${MKDIR_V:--v}"

# select which query
if (( NUM_TASKS == 1 ))
then
	MY_QUERY=$QUERY_HMM
else
	MY_QUERY=$QUERY_ALT_SPLIT_HMM
fi
# select which target
MY_TARGET=$TARGET
#MY_QUERY=$QUERY_ALT

# temp directory
MY_TMP_DIR=$TMP_DIR/$BENCHMARK/$SUITE
mkdir -p $MKDIR_V $MY_TMP_DIR

# output directory
MY_OUTPUT_DIR=$OUTPUT_DIR/$BENCHMARK/$SUITE/$TYPE/$JOB_ID
mkdir -p $MKDIR_V $MY_OUTPUT_DIR
# output files
NAME=${TYPE}.${TASK_ID}
STDOUT=$MY_OUTPUT_DIR/${NAME}.stdout
ALNOUT=$MY_OUTPUT_DIR/${NAME}.alnout
DOMTBLOUT=$MY_OUTPUT_DIR/${NAME}.domtblout

# print args
# ids
echo "#   PROGRAM:  $SUITE $TYPE"
echo "#  LOCATION:  $HMM_HMMSEARCH"
echo "# BENCHMARK:  $MY_BENCHMARK"
echo "#     MY_ID:  $MY_ID"
echo "#    JOB_ID:  $JOB_ID"
echo "#   TASK_ID:  $TASK_ID"
# input
echo "#     QUERY:  $QUERY"
echo "#  QUERY_FA:  $QUERY_FA"
echo "# QUERY_HMM:  $QUERY_HMM"
echo "# QUERY_SPL:  $QUERY_SPLIT_HMM"
echo "#  MY_QUERY:  $MY_QUERY"
echo "#    TARGET:  $TARGET"
echo "# MY_TARGET:  $MY_TARGET"
# output
echo "#    STDOUT:  $STDOUT"
echo "#    ALNOUT:  $ALNOUT"
echo "# DOMTBLOUT:  $DOMTBLOUT"
# search parameters
echo "#    N_CPUS:  $N_CPUS"
echo "#   E_VALUE:  $E_VALUE"
echo "#   VERBOSE:  $VERBOSE"

# run search
time $HMMER_HMMSEARCH 			\
	--domtblout 	$DOMTBLOUT 	\
	-A 				    $ALNOUT 		\
	--notextw 						    \
	-E 				    $E_VALUE 		\
	--cpu 		  	$N_CPUS 		\
	-Z 				    $N_TARGET 	\
	$NONULL2						      \
	$MY_QUERY $MY_TARGET			\

echo "# $SUITE $TYPE [END]"

