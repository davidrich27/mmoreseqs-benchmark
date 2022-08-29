#!/bin/bash
#####################################################################################
# NAME: set-env.sh
# DESC: For use with SLURM job scripts. 
# 		  Sets the environmental variables for testing.
#####################################################################################

# ==> functions <==
TEST_FILE_EXITS() {
	TARGET=$1
	if test -f "${TARGET}"; then
		echo "TARGET exists."
	else
		echo "ERROR: File '${TARGET}' does not exist."
		exit
	fi
}

# ==> main <==

# get cluster-dependent vars
source "set-env_cluster.sh"

# starting directory
BENCH_DIR=$(pwd)
echo "# BENCH_DIR: $BENCH_DIR"

# script directory (location of set-env_main.sh)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo "# SCRIPT_DIR: $SCRIPT_DIR"
cd $SCRIPT_DIR

# relative paths to main directory
BENCH_DIR=${SCRIPT_DIR}/../

# output directory
OUTPUT_DIR=$BENCH_DIR/results/

# temporary directory
TMP_DIR=$BENCH_DIR/temp/

# tools
TOOLS=/home/dr120778/tools/
# fb-pruner (used for mmseqs+ search)
FBPRUNER=$TOOLS/fb-pruner/fb-pruner/bin/fb-pruner-PRODUCTION
FBPRUNER_TEST=$TOOLS/fb-pruner/fb-pruner/bin/fb-pruner-DEBUG
# hmmer root
HMMER=$TOOLS/hmmer-3.3.1/bin/
HMMER_TEST=$TOOLS/fb-pruner/more-tools/hmmer-test/build/bin/
# hmmer (for prof-to-prof)
HMMER_HMMSEARCH=$HMMER/hmmsearch
HMMER_HMMSEARCH_TEST=$TOOLS/fb-pruner/more-tools/hmmer-test/build/bin/hmmsearch
# hmmer (for seq-to-prof)
HMMER_PHMMER=$HMMER/phmmer
HMMER_PHMMER_TEST=$TOOLS/fb-pruner/more-tools/hmmer-test/build/bin/phmmer
# mmseqs
MMSEQS=$TOOLS/MMseqs2/build/bin/mmseqs
MMSEQS_TEST=$TOOLS/fb-pruner/more-tools/mmseqs-test/build/bin/mmseqs

# database directory
DATA_DIR=$BENCH_DIR/db/

source "set-env_db-profmark.sh"
source "set-env_db-soeding.sh"
source "set-env_my-benchmark.sh"
source "set-env_db-test.sh"
LOAD_PROFMARK

SELECT_BENCHMARK () 
{
	echo "# load benchmark: $1..."
	THIS_BENCHMARK=$1
	THIS_TASK=$2

	if   [[ $THIS_BENCHMARK == "soeding"  ]]; then
		LOAD_SOEDING $THIS_TASK
	elif [[ $THIS_BENCHMARK == "profmark" ]]; then
		LOAD_PROFMARK $THIS_TASK
	elif [[ $THIS_BENCHMARK == "my-benchmark" ]]; then 
		LOAD_MYBENCH $THIS_TASK
	fi
}

echo "# setting environmental variables from 'set-env_main.sh'"

cd $BENCH_DIR

