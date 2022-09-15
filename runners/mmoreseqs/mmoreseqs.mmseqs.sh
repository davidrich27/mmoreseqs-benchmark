#!/bin/bash
###################################################################
# NAME: mmoreseqs.sh
# DESC: Runs mmseqs routine of mmoreseqs.
###################################################################

echo "# mmoreseqs mmseqs-search [BEGIN]"

# program name
BENCHMARK="profmark"
SUITE="mmoreseqs"
TYPE="mmoreseqs_n1"
COMMAND="mmoreseqs"

# commandline args
REQ_ARGS=4
NUM_ARGS=$#
if (( NUM_ARGS < REQ_ARGS ))
then
	echo "USAGE: <MY_ID> <JOB_ID> <TASK_ID> <NUM_TASKS> <opt:KSCORE> <opt:KMER> <opt:MMSEQS_EVAL> <opt:MMSEQS_EVAL> <opt:MMSEQS_M8>"
	echo "ERROR: too few args. ( Required = $REQ_ARGS, Given = $NUM_ARGS )"
	exit
fi
# required args
MY_ID=$1			      # id given by me for root folder
JOB_ID=$2 			    # id of job given in slurm
TASK_ID=$3			    # id of task in job array
N_TASKS=$4 			    # total number of tasks in job array
KSCORE=$5 			    # mmseqs kscore
KMER=$6 			      # mmseqs kmer length
MMSEQS_EVAL=$7      # mmseqs e-value
# MMSEQS_M8=$7        # mmseqs output

# verify task_id is valid
if (( TASK_ID >= N_TASKS )); then
    echo "ERROR: Invalid TASK_ID: ($TASK_ID of $N_TASKS)"
    exit
fi

# root folders
BENCH_DIR="$(pwd)"
DB_DIR="${BENCH_DIR}/db"
TMP_DIR="${BENCH_DIR}/temp"
RESULTS_DIR="${BENCH_DIR}/results"

# benchmark folders
MY_DB_DIR="${DB_DIR}/${BENCHMARK}"
MY_TMP_DIR="${TMP_DIR}/${BENCHMARK}/${SUITE}-${TYPE}"
MY_OUTPUT_DIR="${RESULTS_DIR}/${BENCHMARK}/${SUITE}-${TYPE}/${JOB_ID}"

# make new directories
mkdir -p -v ${MY_TMP_DIR}
mkdir -p -v ${MY_OUTPUT_DIR}

# mmseqs files
TARGET_SMMDB="${MY_DB_DIR}/target.s_mmdb"
QUERY_PMMDB="${MY_DB_DIR}/query.p_mmdb"
QUERY_SMMDB="${MY_DB_DIR}/query.s_mmdb"
# mmore files
TARGET_FA="${MY_DB_DIR}/target.fa"
QUERY_FA="${MY_DB_DIR}/query.cons.fa"
QUERY_HMM="${MY_DB_DIR}/query.hmm"
# index files
TARGET_IDX="${MY_DB_DIR}/target.fa.idx"
QUERY_IDX="${MY_DB_DIR}/query.hmm.idx"
# mmseqs output / mmore input file
MMSEQS_M8="${MY_TMP_DIR}/mmseqs.mm_m8"

# general options
VERBOSE="1"

# mmseqs options
KMER="${KMER:-"6"}"
KSCORE="${KSCORE:-"75"}"
MMSEQS_UNGAPPED="${MMSEQS_UNGAPPED:-"0"}"
MMSEQS_MAXSEQS="${MMSEQS_MAXSEQS:-"40000"}"
MMSEQS_EVAL="${MMSEQS_EVAL:-"10000.0"}"

# mmore options
ALPHA="${ALPHA:-"12"}"
BETA="${BETA:-"16"}"
GAMMA="${GAMMA:-"5"}"
VITALN="${VITALN:-"0"}"
MMORE_EVAL="${MMORE_EVAL:-"10000.0"}"

# mmseqs output / mmore input
NAME_BASE="mmoreseqs.${BENCHMARK}.${MY_ID}.${TASK_ID}"
MMSEQS_M8="${MY_TMP_DIR}/${NAME_BASE}.mm_m8"

# output files
NAME_BASE="mmoreseqs.${BENCHMARK}.${ALPHA}.${BETA}.${GAMMA}.${MY_ID}.${TASK_ID}"
OUTPUT="${MY_OUTPUT_DIR}/${NAME_BASE}.out"
TBLOUT="${MY_OUTPUT_DIR}/${NAME_BASE}.tblout"
M8OUT="${MY_OUTPUT_DIR}/${NAME_BASE}.m8"
TIMEOUT="${MY_OUTPUT_DIR}/${NAME_BASE}.timeout"

# program
echo "#      PROGRAM:  $SUITE $TYPE"
echo "#      COMMAND:  $COMMAND"
echo "#        MY_ID:  $MY_ID"
echo "#       JOB_ID:  $JOB_ID"
echo "#      TASK_ID:  $TASK_ID of $N_TASKS"
# input 
echo "#    BENCHMARK:  $BENCHMARK"
echo "#    QUERY_HMM:  $QUERY_HMM"
echo "#    TARGET_FA:  $TARGET_FA"
echo "#  QUERY_PMMDB:  $QUERY_PMMDB"
echo "#  QUERY_SMMDB:  $QUERY_SMMDB"
echo "# TARGET_SMMDB:  $TARGET_SMMDB"
echo "#    MMSEQS_M8:  $MMSEQS_M8"
echo "#      TMP_DIR:  $MY_TMP_DIR"
echo "#      Q_INDEX:  $QUERY_IDX"
echo "#      T_INDEX:  $TARGET_IDX"
# output
echo "#       OUTPUT:  $OUTPUT"
echo "#       TBLOUT:  $TBLOUT"
echo "#        M8OUT:  $M8OUT"
echo "#      TIMEOUT:  $TIMEOUT"
# options
echo "#       KSCORE:  $KSCORE"
echo "#         KMER:  $KMER"
echo "#  MMSEQS_EVAL:  $MMSEQS_EVAL"
echo "#        RANGE:  ($RANGE_BEG, $RANGE_END)"

# mmseqs search
FULL_COMMAND="\
  mmoreseqs search \
  $QUERY_HMM $TARGET_FA \
	$QUERY_PMMDB $QUERY_SMMDB $TARGET_SMMDB \
  --tmp ${MY_TMP_DIR} \
  --verbose 3 \
  --run-mmseqs 1 \
  --run-convert 1 \
  --run-mmore 0 \
  --mmseqs-kmer $KMER \
  --mmseqs-kscore $KSCORE \
  --mmseqs-maxseqs $MMSEQS_MAXSEQS \
  --mmseqs-ungapped-score $MMSEQS_UNGAPPED \
  --mmseqs-eval $MMSEQS_EVAL \
	--mmseqs-m8out $MMSEQS_M8"

echo "# COMMAND: ${FULL_COMMAND}"
time ${FULL_COMMAND}

echo "# mmoreseqs mmseqs-search [END]"
