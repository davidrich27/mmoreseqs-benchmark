#!/bin/bash
#################################################################################################
# NAME: set-env_db-profmark.sh
# DESC: For use with SLURM job scripts. 
# 		Sets the environmental variables for the Profmark benchmark.
#################################################################################################

# name of benchmark for output
MYBENCH_BENCHMARK=my-benchmark
MYBENCH_BENCHMARK_NAME=my-benchmark

# databases
MYBENCH_DB=$DATA_DIR/$MYBENCH_BENCHMARK/ 
# query and target
MYBENCH_TARGET=$MYBENCH_DB/target.fasta
MYBENCH_TARGET_FA=$MYBENCH_DB/target.fasta
MYBENCH_QUERY=$MYBENCH_DB/query.hmm
MYBENCH_QUERY_ALT=$MYBENCH_DB/query2.hmm
MYBENCH_QUERY_HMM=$MYBENCH_DB/query.hmm
MYBENCH_QUERY_FA=$MYBENCH_DB/query.cons.fasta
MYBENCH_QUERY_HHM=$MYBENCH_DB/mmseqs/profileDB
MYBENCH_QUERY_SINGLE=$MYBENCH_DB/query.single.fasta
# other database resources
MYBENCH_QUERY_CONSENSUS=$MYBENCH_DB/query.cons.fasta
MYBENCH_QUERY_SPLIT_HMM_FOLDER=$MYBENCH_DB/query_hmm_split/
MYBENCH_QUERY_SPLIT_ALT_FOLDER=$MYBENCH_DB/query2_hmm_split/
# target split into true positive and true negative
MYBENCH_TARGET_POS=$MYBENCH/target.pos.fasta
MYBENCH_TARGET_NEG=$MYBENCH/target.neg.fasta

# sizes of databases
MYBENCH_N_TARGET=2011547
MYBENCH_N_QUERY=3003
MYBENCH_N_QUERY_SPLIT=31
MYBENCH_N_TARGET_POS=11547
MYBENCH_N_TARGET_NEG=2000000

# set current database
LOAD_MYBENCH ()
{
	local TASK_ID=$1
	echo "# load mybench database, TASK_ID=$TASK_ID."
	
	BENCHMARK=$MYBENCH_BENCHMARK	
	DB=$MYBENCH_DB
	QUERY=$MYBENCH_QUERY
	TARGET=$MYBENCH_TARGET
	TARGET_FA=$MYBENCH_TARGET_FA
	QUERY=$MYBENCH_QUERY
	QUERY_ALT=$MYBENCH_QUERY_ALT
	QUERY_HMM=$MYBENCH_QUERY_HMM
	QUERY_FA=$MYBENCH_QUERY_FA
	QUERY_SINGLE=$MYBENCH_QUERY_SINGLE	
	QUERY_SPLIT_HMM=$MYBENCH_QUERY_SPLIT_HMM_FOLDER/query.${TASK_ID}.hmm
	QUERY_SPLIT_ALT=$MYBENCH_QUERY_SPLIT_ALT_FOLDER/query2.${TASK_ID}.hmm
	TARGET_POS=$MYBENCH_TARGET_POS
	TARGET_NEG=$MYBENCH_TARGET_NEG
	# data sizes
	N_TARGET=$MYBENCH_N_TARGET
	N_QUERY=$MYBENCH_N_QUERY
	N_QUERY_SPLIT=$MYBENCH_N_QUERY_SPLIT
	N_TARGET_POS=$MYBENCH_N_TARGET_POS
	N_TARGET_NEG=$MYBENCH_N_TARGET_NEG
}

echo "# setting environmental variables from 'set_env-my_benchmark.sh'"

