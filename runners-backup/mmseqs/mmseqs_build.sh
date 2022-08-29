#/bin/sh -ex
###################################################################
# NAME:  mmseqs_build.sh
# DESC:  
###################################################################

# program name
SUITE=mmseqs
TYPE=createdb

# set environmental variables: program, database, temp, output locations
source "../set-env.sh"

# parse command line
NUM_ARGS=$#
# optional args
if (( $NUM_ARGS < 2 )); then
	echo "Usage: <MY_ID> <JOB_ID> <opt:BENCHMARK> <opt:KMER_LENGTH> <opt:SPLIT>"
	exit
elif (( $NUM_ARGS >= 3 )); then
	KMER=$2
elif (( $NUM_ARGS >= 4 )); then
	SPLIT=$3
fi
# required args
MY_ID=$1
JOB_ID=$2
MY_BENCHMARK=$3
KMER=$4
SPLIT=$5

# select database
MY_BENCHMARK="${MY_BENCHMARK:-soeding}"
#LOAD_SOEDING
#LOAD_PROFMARK
LOAD_MYBENCH
SELECT_BENCHMARK $MY_BENCHMARK

# default parameters (should not override if already been set)
MY_ID="${MY_ID:-000}"
JOB_ID="${JOB_ID:-000}"
TASK_ID="${TASK_ID:-0}"
N_TASKS="${N_TASKS:-1}"
# inputs
QUERY="${QUERY:-test_query.hmm}"
TARGET="${TARGET:-test_target.fasta}"
# parameters
KMERS="${KMERS:-(7)}"
KMER="${KMER:-7}"
SPLIT="${SPLIT:-1}"
MEM_LIMIT="${MEM_LIMIT:-128000000}"
SHUFFLE="${SHUFFLE:-1}"
VERBOSE="${VERBOSE:-3}"
# other
MKDIR_V="${MKDIR_V:--v}"

# temp directory
MY_TMP_DIR=$TMP_DIR/$BENCHMARK/$SUITE/
# make temp directory
mkdir -p -v $MY_TMP_DIR

# mmseqs db directory
MY_MMSEQS_DIR=$MY_TMP_DIR/db/
TARGET_MMSEQS=$MY_MMSEQS_DIR/target
QUERY_MMSEQS=$MY_MMSEQS_DIR/query
# make mmseqs db directory
mkdir -p -v $MKDIR_V $MY_MMSEQS_DIR

# print arguments
echo "#         MY_ID:  $MY_ID"
echo "#        JOB_ID:  $JOB_ID"
echo "#       TASK_ID:  $TASK_ID of $N_TASKS"

echo "#     BENCHMARK:  $BENCHMARK"
echo "#       PROGRAM:  $SUITE $TYPE"
echo "#      LOCATION:  $MMSEQS"
echo "#        TARGET:  $TARGET"
echo "#     QUERY_HMM:  $QUERY_HMM"
echo "#      QUERY_FA:  $QUERY_FA"

echo "# TARGET_MMSEQS:  $TARGET_MMSEQS"
echo "#  QUERY_MMSEQS:  $QUERY_MMSEQS"

echo "#         KMERS:  ${KMERS[*]}"
echo "#          KMER:  $KMER"
echo "#         SPLIT:  $SPLIT"
echo "#     MEM_LIMIT:  $MEM_LIMIT"

echo "#       VERBOSE:  $VERBOSE"
echo "#       TMP_DIR:  $MY_TMP_DIR"



# build db for target and query
echo "# create target database."
time $MMSEQS createdb 				\
	$TARGET $TARGET_MMSEQS 			\
	--shuffle   $SHUFFLE 		    \
	-v 				  $VERBOSE 		    \


echo "# create query database."
time $MMSEQS createdb 				\
	$QUERY_FA $QUERY_MMSEQS 		\
	--shuffle 		$SHUFFLE		  \
	-v 				    $VERBOSE 		  \

# build kmer index for various lengths
echo "# index target database."
time $MMSEQS createindex 		  \
	$TARGET_MMSEQS $MY_TMP_DIR  \
	-k 						$KMER					\
	-v 						$VERBOSE		  \

