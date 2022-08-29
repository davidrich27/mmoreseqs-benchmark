############################################################################
# - FILE: benchmark-tools-install.sh
# - DESC: Install tools to path.
############################################################################

BENCH_DIR=$(pwd)
mkdir tools
TOOLS_DIR=$BENCH_DIR/tools

# install MMOREseqs 
cd ${TOOLS_DIR}/mmoreseqs
export PATH=$(pwd)/build

# install MMseqs2
cd ${TOOLS_DIR}/mmseqs
export PATH=$(pwd)/build/bin

# install HMMER
cd ${TOOLS_DIR}/hmmer-3.3.2
export PATH=$(pwd)/bin
export PATH=$(pwd)/easel
export PATH=$(pwd)/profmark

