#!/bin/bash
#################################################################################################
# NAME: set-env_db-profmark.sh
# DESC: For use with SLURM job scripts. 
# 		Sets the environmental variables for the Profmark benchmark.
#################################################################################################

# name of benchmark for output
PMARK_BENCHMARK=profmark
PMARK_BENCHMARK_NAME=profmark

# databases
PMARK_DB=$DATA_DIR/$PMARK_BENCHMARK/ 
# query and target
PMARK_TARGET=$PMARK_DB/target.fasta
PMARK_TARGET_FA=$PMARK_DB/target.fasta
PMARK_QUERY=$PMARK_DB/query.hmm
PMARK_QUERY_HMM=$PMARK_DB/query.hmm
PMARK_QUERY_ALT=$PMARK_DB/query2.hmm
PMARK_QUERY_FA=$PMARK_DB/query.cons.fasta
PMARK_QUERY_SINGLE=$PMARK_DB/query.single.hmm
PMARK_QUERY_HHM=$PMARK_DB/mmseqs/profileDB
# other database resources
PMARK_QUERY_CONSENSUS=$PMARK_DB/query.cons.fasta
PMARK_QUERY_SPLIT_HMM_FOLDER=$PMARK_DB/query_hmm_split/
PMARK_QUERY_SPLIT_ALT_FOLDER=$PMARK_DB/query2_hmm_split/
# target split into true positive and true negative
PMARK_TARGET_POS=$PMARK/target.pos.fasta
PMARK_TARGET_NEG=$PMARK/target.neg.fasta

# sizes of databases
PMARK_N_TARGET=211547
PMARK_N_QUERY=2141
PMARK_N_QUERY_SPLIT=21
PMARK_N_TARGET_POS=11547
PMARK_N_TARGET_NEG=200000

# set current database
LOAD_PROFMARK ()
{
	local TASK_ID=$1
	echo "# load profmark database, TASK_ID=$TASK_ID."
	
	BENCHMARK=$PMARK_BENCHMARK	
	DB=$PMARK_DB
	QUERY=$PMARK_QUERY
	TARGET=$PMARK_TARGET
	TARGET_FA=$PMARK_TARGET_FA
	QUERY_HMM=$PMARK_QUERY
	QUERY_ALT=$PMARK_QUERY_ALT
	QUERY_FA=$PMARK_QUERY_CONSENSUS
	QUERY_SINGLE=$PMARK_QUERY_SINGLE	
	QUERY_SPLIT_HMM=$PMARK_QUERY_SPLIT_HMM_FOLDER/query.${TASK_ID}.hmm
	QUERY_SPLIT_ALT=$PMARK_QUERY_SPLIT_ALT_FOLDER/query2.${TASK_ID}.hmm
	TARGET_POS=$PMARK_TARGET_POS
	TARGET_NEG=$PMARK_TARGET_NEG
	# data sizes
	N_TARGET=$PMARK_N_TARGET
	N_QUERY=$PMARK_N_QUERY
	N_QUERY_SPLIT=$PMARK_N_QUERY_SPLIT
	N_TARGET_POS=$PMARK_N_TARGET_POS
	N_TARGET_NEG=$PMARK_N_TARGET_NEG
}

echo "# setting environmental variables from 'set_env-db_profmark.sh'"

