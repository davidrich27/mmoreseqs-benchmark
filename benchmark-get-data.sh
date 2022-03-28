############################################################################
# - FILE: benchmark-get-data.sh
# - DESC: Retrieve and format data for benchmark test.
############################################################################

BENCH_DIR=$(pwd)
mkdir data
cd data

UNIPROT_URL=https://ftp.uniprot.org/pub/databases/uniprot/previous_releases/release-2020_05/knowledgebase/uniprot_sprot-only2020_05.tar.gz

# fetch raw data 
mkdir raw
cd raw
curl $UNIPROT_URL
curl 

# generate benchmarks from raw
