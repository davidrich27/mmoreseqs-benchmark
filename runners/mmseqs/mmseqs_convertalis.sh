#/bin/sh -ex
###################################################################
# NAME: mmseqs_search_n1.sh
# DESC: 
###################################################################

# program name
SUITE=mmseqs
TYPE=search_n1

echo "# $SUITE $TYPE [BEGIN]"

# set environmental variables: program, database, temp, output locations
source "../set-env.sh"

# parse commandline
NUM_ARGS=$#
# optional args 
if (( $NUM_ARGS < 1 )); then
	echo "Usage: <MY_ID> <JOB_ID> <opt:E_VALUE> <opt:K_SCORE>"
	exit
elif (( $NUM_ARGS >= 2 )); then
	E_VALUE=$2
elif (( $NUM_ARGS >= 3 )); then
	K_SCORE=$3
fi
# required args
MY_ID=$1
JOB_ID=$2

# select database 
LOAD_PROFMARK
#LOAD_SOEDING 
#LOAD_TEST

# default parameters (should not override if already been set)
# job data
MY_ID="${MY_ID:-000}"
JOB_ID="${JOB_ID:-000}"
TASK_ID="${TASK_ID:-0}"
N_TASKS="${N_TASKS:-1}"
# input
TARGET="${TARGET:-test_target.fasta}"
QUERY="${QUERY:-test_query.hmm}"
# database params
KMERS="${KMER:-(7)}"
KMER="${KMER:-7}"
SPLIT="${SPLIT:-1}"
MEM_LIMIT="${MEM_LIMIT:-128000000}"
# search params
E_VALUE="${E_VALUE:-10000.0}"
K_SCORE="${K_SCORE:-95}"
SENSE="${SENSE:-5.7}"
MIN_UNGAPPED_SCORE="${MIN_UNGAPPED_SCORE:-0}"
MAX_SEQS="${MAX_SEQS:-4000}"
# iterative search params
NUM_ITERS="${NUM_ITERS:-1}"
E_PROF="${E_PROF:-0.001}"
PCA="${PCA:-1.0}"
PCB="${PCB:-1.5}"
# other params
THREADS="${THREADS:-1}"
VERBOSE="${VERBOSE:-1}"
MKDIR_V="${MKDIR_V:-3}"

# temp directory
MY_TMP_DIR=$TMP_DIR/$BENCHMARK/$SUITE/
mkdir -p -v $MY_TMP_DIR

# mmseqs db directory
MY_MMSEQS_DIR=$MY_TMP_DIR/db/
TARGET_MMSEQS=$MY_MMSEQS_DIR/target
QUERY_MMSEQS=$MY_MMSEQS_DIR/query

# results directory
MY_OUTPUT_DIR=$OUTPUT_DIR/$BENCHMARK/$SUITE/$TYPE/$JOB_ID/
ALN=$MY_OUTPUT_DIR/${TYPE}.${MY_ID}
ALNOUT=${ALN}.m8
mkdir -p -v $MY_OUTPUT_DIR

# print arguments
# job data
echo "#         MY_ID:  $MY_ID"
echo "#        JOB_ID:  $JOB_ID"
echo "#       TASK_ID:  $TASK_ID of $N_TASKS"
# program
echo "#       PROGRAM:  $SUITE $TYPE"
echo "#        TARGET:  $TARGET"
echo "#     QUERY_HMM:  $QUERY_HMM"
echo "#      QUERY_FA:  $QUERY_FA"
# input/output
echo "# TARGET_MMSEQS:  $TARGET_MMSEQS"
echo "#  QUERY_MMSEQS:  $QUERY_MMSEQS"
echo "#           ALN:  $ALN"
echo "#        ALNOUT:  $ALNOUT"
# database params
echo "#         KMERS:  ${KMERS[*]}"
echo "#          KMER:  $KMER"
echo "#         SPLIT:  $SPLIT"
echo "#     MEM_LIMIT:  $MEM_LIMIT"
# search params
echo "#       E_VALUE:  $E_VALUE"
echo "#       K_SCORE:  $K_SCORE"
echo "#         SENSE:  $SENSE"
echo "#  MIN_UNGAPPED:  $MIN_UNGAPPED_SCORE"
echo "#      MAX_SEQS:  $MAX_SEQS"
# iterative search params
echo "#     NUM_ITERS:  $NUM_ITERS"
echo "#        E_PROF:  $E_PROF"
echo "#           PCA:  $PCA"
echo "#           PCB:  $PCB"
# other params
echo "#       THREADS:  $THREADS"
echo "#       VERBOSE:  $VERBOSE"
# tmp vars
echo "#       TMP_DIR:  $MY_TMP_DIR"


# mmseqs search
time $MMSEQS search											\
	$QUERY_MMSEQS $TARGET_MMSEQS $ALN $MY_TMP_DIR 			\
	-k 						$KMER 							\
	--split 				$SPLIT 							\
	--min-ungapped-score 	$MIN_UNGAPPED_SCORE 			\
	-e 						$E_VALUE 						\
	--k-score 				$K_SCORE 						\
	--max-seqs 				$MAX_SEQS 						\
	--remove-tmp-files 		0 								\
	-v 						$VERBOSE					


# convert alignments to results
time $MMSEQS convertalis 									\
	$QUERY_MMSEQS $TARGET_MMSEQS $ALN $ALNOUT 				\
	-v 						$VERBOSE

echo "# $SUITE $TYPE [END]"

