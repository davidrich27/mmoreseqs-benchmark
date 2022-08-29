#!/bin/bash -ex
set -x
##############################################
# NAME: hmmer.p2s.sh
# DESC: 
##############################################

# program name
BENCHMARK="profmark"
SUITE="hmmer"
TYPE="hmmer_n1"
COMMAND="hmmsearch"

echo "# $SUITE $TYPE [BEGIN]"

# root folders
BENCH_DIR="$(pwd)"
DB_DIR="${BENCH_DIR}/db/profmark"
TMP_DIR="${BENCH_DIR}/temp/profmark"
RESULTS_DIR="${BENCH_DIR}/results/profmark"

# commandline args
NUM_ARGS=$#
if (( NUM_ARGS < 4 )); then
	echo "Usage ($NUM_ARGS/4): <MY_ID> <JOB_ID> <TASK_ID> <N_TASKS>"
	exit
fi

# job data
MY_ID=$1
JOB_ID=$2
TASK_ID=$3
N_TASKS=$4

# benchmark folders
MY_DB_DIR="${DB_DIR}/${BENCHMARK}"
MY_TMP_DIR="${TMP_DIR}/${BENCHMARK}/${SUITE}-${TYPE}"
MY_OUTPUT_DIR="${RESULTS_DIR}/${BENCHMARK}/${SUITE}-${TYPE}/${JOB_ID}"

# set args
TARGET_FA="${DB_DIR}/target.fa"
QUERY_FA="${DB_DIR}/query.cons.fa"
QUERY_HMM="${DB_DIR}/query.hmm"
QUERY_HMM_SPLIT="${DB_DIR}/query_hmm_split/query.${TASK_ID}.hmm"

# set options
E_VALUE="10000.0"
N_TARGETS="235456"
N_ITERS="1"
E_PROF="0.001"
N_CPUS="0"
VERBOSE="1"

# choose input
if (( N_TASKS > 1 ))
then
  MY_QUERY=${QUERY_HMM_SPLIT}
else
  MY_QUERY=${QUERY_FA}
fi
MY_TARGET=${TARGET_FA}

# make new directories
mkdir -p -v ${MY_TMP_DIR}
mkdir -p -v ${MY_OUTPUT_DIR}

# output files
STDOUT="${MY_OUTPUT_DIR}/hmmer.${TASK_ID}.stdout"
ALNOUT="${MY_OUTPUT_DIR}/hmmer.${TASK_ID}.alnout"
DOMTBLOUT="${MY_OUTPUT_DIR}/hmmer.${TASK_ID}.domtblout"

# program
echo "#   PROGRAM:  $SUITE $TYPE"
echo "#   COMMAND:  $COMMAND"
echo "#     MY_ID:  $MY_ID"
echo "#    JOB_ID:  $JOB_ID"
echo "#   TASK_ID:  $TASK_ID of $N_TASKS"
# input
echo "# BENCHMARK:  $BENCHMARK"
echo "#  MY_QUERY:  $MY_QUERY"
echo "# MY_TARGET:  $MY_TARGET"
# output
echo "#    STDOUT:  $STDOUT"
echo "#    ALNOUT:  $ALNOUT"
echo "# DOMTBLOUT:  $DOMTBLOUT"
# options
echo "#   N_ITERS:  $N_ITERS"
echo "#    N_CPUS:  $N_CPUS"
echo "#   E_VALUE:  $E_VALUE"
echo "# DOMTBLOUT:  $DOMTBLOUT"
echo "#    ALNOUT:  $ALNOUT"

# run search
time $COMMAND				          \
	--domtblout 	$DOMTBLOUT 		\
	-A 				    $ALNOUT 		  \
	--notextw 						      \
	-E 				    $E_VALUE 		  \
	--cpu 			  $N_CPUS 		  \
	$MY_QUERY     $MY_TARGET		\
# unused args:
# -Z 				    $N_TARGETS 		\
#	-o 				    $STDOUT 		  \
#	-N 				    $N_ITERS		  \

echo "# $SUITE $TYPE [END]"

