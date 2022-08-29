# MMORESEQS BENCHMARK

Runs comparisons of MMORESEQS vs alternative tools HMMER and MMSEQS.
Database generated using Profmark benchmarking tool

## Benchmark Data Sources

- Pfam v33.1
  - https://ftp.ebi.ac.uk/pub/databases/Pfam/releases/Pfam33.1/Pfam-A.seed.gz
- UniProt v2020_05
  - https://ftp.uniprot.org/pub/databases/uniprot/previous_releases/release-2020_05/knowledgebase/uniprot_sprot-only2020_05.tar.gz

## Tools

- MMOREseqs
  - https://github.com/TravisWheelerLab/MMOREseqs.git
- MMseqs
  - https://github.com/soedinglab/MMseqs2.git
- HMMER
  - http://eddylab.org/software/hmmer/hmmer.tar.gz


## Sofware Requirements

- conda
- Jinja2
- j2cli
- pyyaml

## Usage / Walkthrough

- (1) build environment
- (2) fetch and extract raw data
- (3) fetch, build and install tools
- (4) use HMMER tool Profmark to create test database
- (5) run search tools against database
- (6) parse tool results
- (7) generate comparative results and visuals

### (1) Create Environment

```
conda env create --file environment.yml
conda activate mmoreseqs-benchmark
```

### (2) Fetch Data and Install Tools

```
bash scripts/benchmark-data-fetch.sh
bash scripts/benchmark-tools-build.sh
bash scripts/benchmark-tools-install.sh
```

### (3) Build Profmark Test Database

```
bash scripts/benchmark-generate-profmark-db.sh
bash scripts/benchmark-prepare-profmark-db.sh
```

#### (4a) Run MMOREseqs

```

```

#### (4b) Run MMseqs 

```

```

#### (4c) Run HMMER

```

```

### (5) Process Results

```

```

### (6) Generate Visuals

```

```

### Wrap-Up

Warning: Only run this if you don't wish to preserve results.

```
bash scripts/benchmark-clean.sh
```
