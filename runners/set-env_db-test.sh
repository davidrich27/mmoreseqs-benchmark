#!/bin/bash -ex
###########################################################################################
# NAME: set-env_db-test.sh
# DESC: For use with SLURM job scripts. 
# 		Sets environmental variables for benchmarking.
###########################################################################################

# name of benchmark of output
TEST_BENCHMARK=test
TEST_BENCHMARK_NAME=test

# get databases
TEST_DB=$DATA_DIR/$TEST_BENCHMARK/ 
TEST_QUERY=$TEST_DB/query.fasta
TEST_QUERY_SPLIT_FOLDER=$TEST_DB/query_split/
TEST_TARGET=$TEST_DB/target.hmm
TEST_TARGET_CONS=$TEST_DB/target.cons.fa
# database size
TEST_N_QUERY=100
TEST_N_TARGET=100

# select current database
LOAD_TEST ()
{
	echo '# load test database.'
	TASK_ID=$1

	BENCHMARK=$TEST_BENCHMARK
	DB=$TEST_DB
	QUERY=$TEST_QUERY
	QUERY_SPLIT=$TEST_QUERY_SPLIT_FOLDER/query.${TASK_ID}.hmm
	TARGET=$TEST_TARGET
	TARGET_CONS=$TEST_TARGET_CONS
	# database size
	N_QUERY=100
	N_TARGET=100
}

echo "# setting environmental variables from 'set_env-db_test.sh'"

