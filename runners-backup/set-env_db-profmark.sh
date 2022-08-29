#!/bin/bash
#################################################################################################
# NAME: set-env-benchmark-{{ benchmark.name }}.sh
# DESC: For use with SLURM job scripts. 
# 		  Sets the environmental variables for the {{ benchmark.name }} benchmark.
#################################################################################################

# name of benchmark for output
BENCHMARK="{{ benchmark }}"
BENCHMARK_NAME="{{ benchmark.name }}"

# databases
DB_FOLDER="{{ benchmark.db_folder }}"
# query and target
TARGET="${DB_FOLDER}/target.fasta"
TARGET_FA="${DB_FOLDER}/target.fasta"
QUERY="${DB_FOLDER}/query.hmm"
QUERY_HMM="${DB_FOLDER}/query.hmm"
QUERY_ALT="${DB_FOLDER}/query2.hmm"
QUERY_FA="${DB_FOLDER}/query.cons.fasta"
QUERY_SINGLE="${DB_FOLDER}/query.single.hmm"
QUERY_HHM="${DB_FOLDER}/mmseqs/profileDB_FOLDER"
# other database resources
QUERY_CONSENSUS="${DB_FOLDER}/query.cons.fasta"
QUERY_SPLIT_HMM_FOLDER="${DB_FOLDER}/query_hmm_split/"
QUERY_SPLIT_ALT_FOLDER="${DB_FOLDER}/query2_hmm_split/"
# target split into true positive and true negative
TARGET_POS="${DB_FOLDER}/target.pos.fasta"
TARGET_NEG="${DB_FOLDER}/target.neg.fasta"

# sizes of databases
N_QUERY={{ profmark.n_query }}
N_QUERY_SPLIT={{ profmark.n_query_split }}
N_TARGET={{ profmark.n_target }}
N_TARGET_POS={{ profmark.n_target_pos }}
N_TARGET_NEG={{ profmark.n_target_neg }}

echo "# setting environmental variables from 'set_env-benchmark-{{ benchmark.name }}.sh'"

