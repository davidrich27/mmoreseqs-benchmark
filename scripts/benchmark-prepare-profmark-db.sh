############################################################################
# - FILE: benchmark-generate-profmark-db.sh
# - DESC: Retrieve and format data for benchmark test.
############################################################################

BENCH_DIR=$(pwd)
SCRIPT_DIR=${BENCH_DIR}/db/scripts
DB_TEST_DIR=${BENCH_DIR}/db/profmark 
cd ${DB_TEST_DIR}

# Temp files
TMP_DIR=${BENCH_DIR}/temp/profmark
mkdir -p -v ${TMP_DIR}/mmseqs
mkdir -p -v ${TMP_DIR}/hmmer
mkdir -p -v ${TMP_DIR}/mmoreseqs

# Rename links to match search convention
mv pmark.fa target.fa 
mv pmark.msa query.msa

# Prepare files for HMMER searches
esl-afetch --index query.msa
esl-sfetch --index target.fa 
hmmbuild query.hmm query.msa
hmmfetch --index query.hmm

# Prepare files for MMseqs searches
python ${SCRIPT_DIR}/mod_msa_ac2id.py query.msa query_renamed.msa
mmseqs convertmsa query_renamed.msa query.mm_msa
mmseqs msa2profile query.mm_msa query.p_mmdb
mmseqs createdb query.cons.fa query.s_mmdb
mmseqs createdb target.fa target.s_mmdb

# Build query consensus sequences
hmmemit -c query.hmm > query.cons.fa
sed -i 's/-consensus//g' query.cons.fa

# Split databases for more bite-size searches for HMMER.
mkdir query_hmm_singles
mv query_hmm_singles
ln -s ../query.hmm .
hmmfetch --index query.hmm
hmmstat query.hmm  | awk '!/^(#|$)/ {print $2}' | perl -lane 'print $_; `hmmfetch -o $_.hmm query.hmm  $_`'
rm query.hmm*
cd ../

# Split databases
mkdir query_hmm_split
cd query_hmm_split 
ln -s ../query.hmm .
python ${SCRIPT_DIR}/split_hmm.py query.hmm 100
cd ../

# mkdir target_fa_split
# cd target_fa_split 
# ln -s ../target.fa .
# python ${SCRIPT_DIR}/split_fasta.py target.fa 1000
# cd ../

# Prepare files for MMOREseqs searches
mmoreseqs index query.hmm target.fa query.hmm.idx target.fa.idx
