#!/bin/bash -ex
###########################################################################################
# NAME: set-env_db-soeding.sh
# DESC: For use with SLURM job scripts. 
# 		Sets environmental variables for benchmarking.
###########################################################################################

# name of benchmark of output
SOEDING_BENCHMARK=soeding
SOEDING_BENCHMARK_NAME=soeding

# database location
SOEDING_DB=$DATA_DIR/$SOEDING_BENCHMARK/ 
SOEDING_QUERY=$SOEDING_DB/query.fasta
SOEDING_QUERY_FA=$SOEDING_DB/query.fasta
SOEDING_QUERY_HMM=$SOEDING_DB/query.hmm
SOEDING_QUERY_HHM=$SOEDING_DB/mmseqs/profileDB
SOEDING_QUERY_SPLIT_FOLDER=$SOEDING_DB/query_split/
SOEDING_TARGET=$SOEDING_DB/target.fasta
SOEDING_TARGET_POS=$SOEDING_DB/target.pos.fasta
SOEDING_TARGET_NEG=$SOEDING_DB/target.neg.fasta
# database size
SOEDING_N_QUERY=6370
SOEDING_N_QUERY_SPLIT=64
SOEDING_N_TARGET=29894911
SOEDING_N_TARGET_POS=3374007
SOEDING_N_TARGET_NEG=26520904

# select current database
LOAD_SOEDING ()
{
	echo '# load soeding database.'
	# database location
	BENCHMARK=$SOEDING_BENCHMARK
	DB=$SOEDING_DB
	QUERY=$SOEDING_QUERY
	QUERY_FA=$SOEDING_QUERY_FA
	QUERY_HMM=$SOEDING_QUERY_HMM
	QUERY_SPLIT=$SOEDING_QUERY_SPLIT_FOLDER/query.${TASK_ID}.fasta
	TARGET=$SOEDING_TARGET
	TARGET_POS=$SOEDING_TARGET_POS
	TARGET_NEG=$SOEDING_TARGET_NEG
	# database size
	N_QUERY=6370
	N_QUERY_SPLIT=64
	N_TARGET=29894911
	N_TARGET_POS=3374007
	N_TARGET_NEG=26520904
}

echo "# setting environmental variables from 'set_env-db_soeding.sh'"

