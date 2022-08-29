#!/bin/bash
###################################################################
# NAME: mmoreseqs.sh
# DESC: Runs mmore routine of mmoreseqs.
###################################################################

echo "# mmoreseqs [BEGIN]"

# program name
SUITE=mmoreseqs
TYPE=mmore

# set data locations
source "../set-env.sh"

# commandline args
NUM_ARGS=$#
if (( NUM_ARGS < 7 ))
then
	echo "USAGE: <MY_ID> <JOB_ID> <TASK_ID> <NUM_TASKS> <ALPHA> <BETA> <GAMMA> <opt:BENCHMARK> <opt:MMSEQS_IN>"
	echo "ERROR: too few args. ( Required = 7, Given = $NUM_ARGS )"
	exit
fi
# required args
MY_ID=$1			# id given by me for root folder
JOB_ID=$2 			# id of job given in slurm
TASK_ID=$3			# id of task in job array
N_TASKS=$4 			# total number of tasks in job array
ALPHA=$5 			# alpha parameter
BETA=$6 			# beta parameter
GAMMA=$7			# gamma parameter
MY_BENCHMARK=$8 	# benchmark
MY_MMSEQS_INPUT=$9 	# mmseqs name

# select database
#LOAD_SOEDING $TASK_ID
#LOAD_PROFMARK $TASK_ID
LOAD_MYBENCH $TASK_ID
SELECT_BENCHMARK $MY_BENCHMARK $TASK_ID

# verify task_id is valid
if (( TASK_ID >= N_TASKS )); then
    echo "ERROR: Invalid TASK_ID: ($TASK_ID of $N_TASKS)"
    exit
fi

# default parameters (should not override if already been set)
MY_ID="${MY_ID:-000}"
TASK_ID="${TASK_ID:-0}"
N_TASKS="${N_TASKS:-1}"
# input
BENCHMARK="${BENCHMARK:-profmark}"
QUERY="${QUERY:-test_query.hmm}"
TARGET="${TARGET:-test_target.fasta}"
MY_MMSEQS_INPUT="${MY_MMSEQS_INPUT:-input.mmseqs.m8}"
MY_MMSEQS_PLUS_INPUT="${MY_MMSEQS_PLUS_INPUT:-input.mmseqs.m8+}"
# parameters
ALPHA="${ALPHA:-12}"
BETA="${BETA:-16}"
GAMMA="${GAMMA:-5}"
VERBOSE="${VERBOSE:-1}"
# other
MKDIR_V="${MKDIR_V:--v}"

# temp directory
MY_TMP_DIR=$TMP_DIR/$BENCHMARK/$SUITE/
# make temp directory
mkdir -p -v $MY_TMP_DIR

# index location
T_INDEX=$MY_TMP_DIR/target.idx
Q_INDEX=$MY_TMP_DIR/query.idx

# mmseqs result input
MMSEQS_INPUT="$MY_TMP_DIR/mmseqs_plus/${MY_MMSEQS_INPUT}"
MMSEQS_PLUS_INPUT="$MY_TMP_DIR/mmseqs_plus/${MY_MMSEQS_PLUS_INPUT}"
# get number of entries in mmseqs result input
N_MMSEQS_INPUT=$( wc -l $MMSEQS_INPUT | awk '{ print $1 }' )
# find range of results to search given the number of jobs in array and the array id 
RANGE_BEG=$(echo "($N_MMSEQS_INPUT / $N_TASKS) * ($TASK_ID)" | bc )  
RANGE_END=$(echo "($N_MMSEQS_INPUT / $N_TASKS) * ($TASK_ID + 1)" | bc ) 

# output directories
NAME=mmseqs_plus.${BENCHMARK}.${ALPHA}.${BETA}.${GAMMA}.${MY_ID}.${TASK_ID}
MY_OUTPUT_DIR=$OUTPUT_DIR/$BENCHMARK/$SUITE/$TYPE/$JOB_ID/
OUTPUT=$MY_OUTPUT_DIR/${NAME}.out
TBLOUT=$MY_OUTPUT_DIR/${NAME}.tblout
M8OUT=$MY_OUTPUT_DIR/${NAME}.m8
# make output directories
mkdir -p -v $MY_OUTPUT_DIR

# time directory
#TIMEOUT=$MY_OUTPUT_DIR/timeout/time.${TASK_ID}.txt
# make time directory
#mkdir -p $MKDIR_V $MY_OUTPUT_DIR/timeout/

# print arguments
echo "#     MY_ID:  $MY_ID"
echo "#    JOB_ID:  $JOB_ID"
echo "#   TASK_ID:  $TASK_ID of $N_TASKS"
# input
echo "#   PROGRAM:  $SUITE $TYPE"
echo "# BENCHMARK:  $BENCHMARK"
echo "#    TARGET:  $TARGET"
echo "#     QUERY:  $QUERY"
echo "# QUERY_HMM:  $QUERY_HMM"
echo "#  QUERY_FA:  $QUERY_FA"
echo "#    MMSEQS:  $MMSEQS_INPUT"
# size
echo "#   T_INDEX:  $T_INDEX"
echo "#   Q_INDEX:  $Q_INDEX"
echo "#  N_TARGET:  $N_TARGET"
echo "#   N_QUERY:  $N_QUERY"
echo "#  N_MMSEQS:  $N_MMSEQS_INPUT"
echo "#     RANGE:  ($RANGE_BEG, $RANGE_END)"
# parameters
echo "#     ALPHA:  $ALPHA"
echo "#      BETA:  $BETA"
echo "#     GAMMA:  $GAMMA"
echo "#   VERBOSE:  $VERBOSE"
# output
echo "#   TMP_DIR:  $MY_TMP_DIR"
echo "#    OUTPUT:  $OUTPUT"
echo "#    TBLOUT:  $TBLOUT"
echo "#     M8OUT:  $M8OUT"
echo "#   TIMEOUT:  $TIMEOUT"

MY_QUERY=$QUERY_SINGLE
MY_TARGET=$TARGET_FA

# run main command
time $FBPRUNER mmseqs								      \
	$MY_QUERY $MY_TARGET							      \
	--index 				$Q_INDEX $T_INDEX 		  \
	--mmseqs-m8+ 		$MMSEQS_PLUS_INPUT 		  \
	--mmseqs-m8 		$MMSEQS_INPUT			      \
	--alpha 				$ALPHA 					        \
	--beta 					$BETA 					        \
	--gamma 				$GAMMA 					        \
	--mmseqs-range 	$RANGE_BEG $RANGE_END 	\
  --m8out         $M8OUT               	  \

echo "# mmseqs_plus [END]"

