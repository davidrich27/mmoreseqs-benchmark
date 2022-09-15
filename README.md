# MMORESEQS BENCHMARK

Runs comparisons of MMORESEQS vs alternative tools HMMER and MMSEQS.
Database generated using Profmark benchmarking tool.  Except where otherwise noted, these benchmarks can be performed by the copying the code snippets and executing them from the root directory of this benchmarking repository. 

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
- jupyter

## Usage / Walkthrough

- (1) build environment
- (2) fetch and extract raw data
- (3) fetch, build and install tools
- (4) use HMMER tool Profmark to create test database
- (5) run search tools against database
- (6) parse tool results
- (7) generate comparative results and visuals

### (1) Create Environment

These scripts install a conda virtual environment which should contain all the necessary dependencies for performing the 

```
conda env create --file environment.yml
conda activate mmoreseqs-benchmark
```

### (2) Fetch Data and Install Tools

These scripts retrieve the data and tools from online repositories, and build the tools needed for performing searches.

```
bash scripts/benchmark-data-fetch.sh
bash scripts/benchmark-tools-build.sh
bash scripts/benchmark-tools-install.sh
```

### (3) Build Profmark Test Database

These scripts generate a Profmark data set from the Pfam and Uniprot data.  This creates an MSA file from Pfam, then creates a FASTA file with a mix of decoy and true protein sequences.  The decoys and trues are generated from shuffling sequences from Uniprot, with the trues then being embedded with the sequences emitted from the Pfam MSA.  After that, the query MSA and target FASTA are then used to generate the HMMER HMM file and MMseqs database files needed to perform searches.

```
bash scripts/benchmark-generate-profmark-db.sh
bash scripts/benchmark-prepare-profmark-db.sh
```

#### (4) Run Searches Against Database

For these searches, there exists simple executable scripts that take commandline arguments for different search parameters for comparison.  In addition, there are SLURM job scripts that issues the searches as job arrays.  Note however, these scipts must be modified for the proper partition for your given environment.  The SLURM scripts request exclusive nodes and multi-threading is disabled on all searches for accurate runtime comparisons.

For different tested parameters, critical parameters can be passed as arguments, but some, such as kmer length, must modify the variables in the script.  E-value filtering thresholds was set very high (1000.0) to test thresholds for false discovery rate.  However, note this can negatively affect runtimes, so for normal use-case runtime comparisons, default E-values should be used.  Processes are timed using the linux `time` command and are captured by grepping `real` from the standard output file.

#### (4a) Run MMORESeqs

For MMORESeqs, there are two distinct phases: the MMseqs step, and the MMORE step.  They cannot be run concurrently.  The MMORE step can also split up the interrim results for smaller, more manageable jobs.  The SLURM script alreay iterates splits the subjobs into a job array.  

Looking inside the non-sbatch scripts, you can pass optional arguments for the various parameter choices: for the MMseqs stage, kmer/kscore were modified.  For the MMore stage, alpha/beta/gamma were modified. 

``` 
bash runners/mmoreseqs/mmoreseqs.mmseqs-search.sh
bash runners/mmoreseqs/mmoreseqs.mmore-search.sh
```
```
sbatch runners/mmoreseqs/sbatch_mmoreseqs.mmseqs-search.sh
sbatch runners/mmoreseqs/sbatch_mmoreseqs.mmore-search.sh
```

#### (4b) Run MMseqs 

For MMseqs, be aware that the MMseqs prefilter step can fail if there is insufficient memory (likewise for the MMseqs step of MMOREseqs).  This can take upwards of 10G of memory.  For smaller systems, can use a smaller kmer or allow default kmer length.

```
bash runners/mmseqs/mmseqs.sh
```
```
sbatch runners/mmseqs/sbatch_mmseqs.sh
```

#### (4c) Run HMMER

For HMMER, these scripts use split-up query files so that many smaller, more manageable searches can be run.

```
bash runners/hmmer/hmmer.sh 
```
```
sbatch runners/hmmer/sbatch_hmmer.sh
```

### (5) Process Results

For this process, we are converting various types of CSV files to a single format type for comparison I call `*.tflist`. It will create a list of results in sorted order according to E-value, the target/query names, whether the current entry is a true-positive, false-positive, or indeterminant.  Then cumulative totals for these categories for all entries with an E-value of this or better.  Then this list is down scaled to every nth line to be more manageable size.

For MMseqs and MMOREseqs, the raw results file is a `*.m8` format, for HMMER the raw results are in a `*.domtblout` format.  Results are stored in `/results/profmark/<search-method>/` folder, potentially across multiple subscripted files.  So the first step is to copy all results into a file.  Then use the following template (for this example, assumes that file is a HMMER domtblout file, but can change the script args accordingly):

```
cd evaluate
bash scripts/raw_to_m3_pipeline.sh \ 
  evaluate/results_raw/result.hmmer.domtblout \ 
  evaluate/results_m3/result.hmmer.m3 \ 
  domtblout profmark
bash evaluate/scripts/m3_to_tf_pipeline.sh \
  evaluate/results_m3/result.hmmer.m3 \ 
  evaluate/results_tf/result.hmmer.tf \ 
  profmark
```
