############################################################################
# - FILE: benchmark-generate-profmark-db.sh
# - DESC: Retrieve and format data for benchmark test.
############################################################################

BENCH_DIR=$(pwd)

PFAM_SEED=${BENCH_DIR}/data/raw/Pfam-A.seed 
UNIPROT=${BENCH_DIR}/data/raw/uniprot_sprot.fasta

mkdir ${BENCH_DIR}/data/pmark

# Generate Profmark
cd ${BENCH_DIR}/data
ln -s ${BENCH_DIR}/tools/hmmer-3.3.2/profmark/create-profmark .

cd ${BENCH_DIR}/data/raw
esl-afetch --index Pfam-A.seed
esl-sfetch --index uniprot_sprot.fasta

DB_SOURCE_DIR=${BENCH_DIR}/data/pmark
cd ${DB_SOURCE_DIR} 
HMMER_RNG_SEED=42
NUM_DECOY_SEQS=200000
../create-profmark --single -N ${NUM_DECOY_SEQS} --seed ${HMMER_RNG_SEED} pmark ../raw/Pfam-A.seed ../raw/uniprot_sprot.fasta

# Link source files to testing database
DB_TEST_DIR=${BENCH_DIR}/db/profmark 
mkdir -p ${DB_TEST_DIR}
cd ${DB_TEST_DIR}
for FILE in $(ls ${DB_SOURCE_DIR})
do 
  ln -s ${DB_SOURCE_DIR}/${FILE} .
done
