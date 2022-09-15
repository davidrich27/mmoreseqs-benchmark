#/bin/sh -ex
# set -x
###################################################################
# NAME:  mmseqs_n1.sh
# DESC:  
###################################################################

# program name
BENCHMARK="profmark"
SUITE="mmseqs"
TYPE="mmseqs_n1"
COMMAND="mmseqs"

echo "# $SUITE $TYPE [BEGIN]"

# commandline args
REQ_ARGS=3
NUM_ARGS=$#
if (( $NUM_ARGS < $REQ_ARGS )); then
	echo "Usage: <MY_ID> <JOB_ID> <TASK_ID> <opt:K_SCORE> <opt:MAX_SEQS>"
	echo "ERROR: too few args. ( Required = $REQ_ARGS, Given = $NUM_ARGS )"
	exit
fi

# job data
MY_ID=$1
JOB_ID=$2
TASK_ID=$3
# K_SCORE=$4
# MAX_SEQS=$5

N_TASKS=1

# root folders
BENCH_DIR="$(pwd)"
DB_DIR="${BENCH_DIR}/db"
TMP_DIR="${BENCH_DIR}/temp"
RESULTS_DIR="${BENCH_DIR}/results"

# benchmark folders
MY_DB_DIR="${DB_DIR}/${BENCHMARK}"
MY_TMP_DIR="${TMP_DIR}/${BENCHMARK}/${SUITE}-${TYPE}/${JOB_ID}"
MY_OUTPUT_DIR="${RESULTS_DIR}/${BENCHMARK}/${SUITE}-${TYPE}/${JOB_ID}"

# make new directories
mkdir -p -v ${MY_TMP_DIR}
mkdir -p -v ${MY_OUTPUT_DIR}

# set args
TARGET_FA="${MY_DB_DIR}/target.fa"
QUERY_FA="${MY_DB_DIR}/query.cons.fa"
TARGET_MMDB="${MY_DB_DIR}/target.s_mmdb"
QUERY_HMM="${MY_DB_DIR}/query.hmm"
QUERY_HMM_SPLIT="${MY_DB_DIR}/query_hmm_split/query.${TASK_ID}.hmm"
QUERY_MMDB="${MY_DB_DIR}/query.p_mmdb"

# set options
KMER="6"
SPLIT="1"
MEM_LIMIT="128000000"
E_VALUE="10000.0"
K_SCORE="75" # normal: 95, sensitive: 80, mmoreseqs: 75
SENSE="5.7" # faster: 1, fast: 4, normal: 6, sensitive: 7.5 
MIN_UNGAPPED_SCORE="15"
MAX_SEQS="40000"
NUM_ITERS="1"
E_PROF="0.001"
PCA="1.0"
PCB="1.5"
THREADS="1"
VERBOSE="3"
REMOVE_TMP="0"

# choose input 
MY_QUERY=${QUERY_MMDB}
MY_TARGET=${TARGET_MMDB}

# output files
NAME_BASE="mmseqs.${TASK_ID}.k${K_SCORE}"
ALN_MMDB="${MY_OUTPUT_DIR}/${NAME_BASE}.aln_mmdb"
ALNOUT="${MY_OUTPUT_DIR}/${NAME_BASE}.m8"

# format of output 
DEFAULT_FORMAT="query,target,pident,alnlen,mismatch,gapopen,qstart,qend,tstart,tend,evalue,bits"
ALL_FORMAT="query,target,evalue,gapopen,pident,nident,qstart,qend,qlen,tstart,tend,tlen,alnlen,raw,bits,cigar,qseq,tseq,qheader,theader,qaln,taln,qframe,tframe,mismatch,qcov,tcov,qset,qsetid,tset,tsetid,taxid,taxname,taxlineage"
# select format
MY_FORMAT=${DEFAULT_FORMAT}

# program
echo "#       PROGRAM:  $SUITE $TYPE"
echo "#       COMMAND:  $COMMAND"
echo "#         MY_ID:  $MY_ID"
echo "#        JOB_ID:  $JOB_ID"
echo "#       TASK_ID:  $TASK_ID of $N_TASKS"
# input
echo "#     BENCHMARK:  $BENCHMARK"
echo "#      MY_QUERY:  $MY_QUERY"
echo "#     MY_TARGET:  $MY_TARGET"
echo "#       TMP_DIR:  $MY_TMP_DIR"
# output
echo "#      ALN_MMDB:  $ALN_MMDB"
echo "#        ALNOUT:  $ALNOUT"
# options
echo "#          KMER:  $KMER"
echo "#       K_SCORE:  $K_SCORE"
echo "#         SENSE:  $SENSE"
echo "#  MIN_UNGAPPED:  $MIN_UNGAPPED_SCORE"
echo "#       E_VALUE:  $E_VALUE"
echo "#        E_PROF:  $E_PROF"
echo "#      MAX_SEQS:  $MAX_SEQS"
echo "#     NUM_ITERS:  $NUM_ITERS"
echo "#         SPLIT:  $SPLIT"
echo "#     MEM_LIMIT:  $MEM_LIMIT"
echo "#       THREADS:  $THREADS"
echo "#    REMOVE_TMP:  $REMOVE_TMP"

# mmseqs search
FULL_COMMAND="\
  $COMMAND search \
	$MY_QUERY $MY_TARGET \
  $ALN_MMDB $MY_TMP_DIR \
	-k $KMER \
	--k-score $K_SCORE \
	--max-seqs $MAX_SEQS \
	--min-ungapped-score $MIN_UNGAPPED_SCORE \
	-e $E_VALUE \
	--remove-tmp-files $REMOVE_TMP \
	-v $VERBOSE \
	--threads $THREADS"

echo "# COMMAND: ${FULL_COMMAND}"
time ${FULL_COMMAND}

# unused opts:
# -k-score $K_SCORE \
# -s $SENSE \
# --split $SPLIT \

# mmseqs convertalis
FULL_COMMAND="\
  $COMMAND convertalis \
	$MY_QUERY $MY_TARGET \
  $ALN_MMDB $ALNOUT \
	-v $VERBOSE \
	--format-output $MY_FORMAT \
	--threads $THREADS"

echo "# COMMAND: ${FULL_COMMAND}"
time ${FULL_COMMAND}

echo "# $SUITE $TYPE [END]"

