#/bin/sh -ex
###################################################################
# NAME:  mmseqs_n1.sh
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
	echo "Usage: <MY_ID> <JOB_ID> <BENCHMARK> <opt:KMER> <opt:K_SCORE>"
	exit
fi
# required args
MY_ID=$1
JOB_ID=$2
BENCHMARK=$3
E_VALUE=$3
K_SCORE=$4

# select database 
LOAD_PROFMARK
SELECT_BENCHMARK $BENCHMARK

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
K_SCORE="${K_SCORE:-75}"
# normal: 95, sensitive: 80, mmseqs-plus: 75
SENSE="${SENSE:-5.7}"
MIN_UNGAPPED_SCORE="${MIN_UNGAPPED_SCORE:-15}"
MAX_SEQS="${MAX_SEQS:-4000}"
# iterative search params
NUM_ITERS="${NUM_ITERS:-1}"
E_PROF="${E_PROF:-0.001}"
PCA="${PCA:-1.0}"
PCB="${PCB:-1.5}"
# other params
THREADS="${THREADS:-1}"
VERBOSE="${VERBOSE:-3}"
REMOVE_TMP="${REMOVE_TMP:-0}"
# other
MKDIR_V="${MKDIR_V:--v}"

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

# format of output 
DEFAULT_FORMAT=query,target,pident,alnlen,mismatch,gapopen,qstart,qend,tstart,tend,evalue,bits
ALL_FORMAT=query,target,evalue,gapopen,pident,nident,qstart,qend,qlen,tstart,tend,tlen,alnlen,raw,bits,cigar,qseq,tseq,qheader,theader,qaln,taln,qframe,tframe,mismatch,qcov,tcov,qset,qsetid,tset,tsetid,taxid,taxname,taxlineage
CUSTOM_FORMAT=
# select format
MY_FORMAT=$DEFAULT_FORMAT

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
echo "#    REMOVE_TMP:  $REMOVE_TMP"
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
	--remove-tmp-files 		$REMOVE_TMP 					\
	-v 						$VERBOSE						\


# convert alignments to results
time $MMSEQS convertalis 									\
	$QUERY_MMSEQS $TARGET_MMSEQS $ALN $ALNOUT 				\
	-v 						$VERBOSE						\
	--format-output 		$MY_FORMAT						\


echo "# $SUITE $TYPE [END]"

