############################################################################
# - FILE: benchmark-data-fetch.sh
# - DESC: Retrieve and format data for benchmark test.
############################################################################

BENCH_DIR=$(pwd)
mkdir data
cd data

# Pfam v33.1
PFAM_URL=https://ftp.ebi.ac.uk/pub/databases/Pfam/releases/Pfam33.1/Pfam-A.seed.gz
# UniProt v2020_05
UNIPROT_URL=https://ftp.uniprot.org/pub/databases/uniprot/previous_releases/release-2020_05/knowledgebase/uniprot_sprot-only2020_05.tar.gz

# fetch raw data 
mkdir raw
cd raw
curl $PFAM_URL --output Pfam-A.seed.gz
curl $UNIPROT_URL --output uniprot_sprot-only2020_05.tar.gz

# extract contents
gunzip Pfam-A.seed.gz 
tar -xf uniprot_sprot-only2020_05.tar.gz
gunzip uniprot_sprot.fasta.gz 
gunzip uniprot_sprot.dat.gz 
gunzip uniprot_sprot_varsplic.fasta
