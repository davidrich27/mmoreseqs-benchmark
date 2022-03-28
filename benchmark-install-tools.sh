############################################################################
# - FILE: benchmark-get-tools.sh
# - DESC: Retrieve and format tools for benchmark test.
############################################################################

BENCH_DIR=$(pwd)
mkdir tools
TOOLS_DIR=$BENCH_DIR/tools

# fetch and install MMOREseqs 
cd $TOOLS_DIR
git clone git@github.com:TravisWheelerLab/MMOREseqs.git mmoreseqs
cd mmoreseqs
cmake . -DCMAKE_BUILD_TYPE=RELEASE
make
export PATH=$(pwd)/build

# fetch and install MMSeqs2
cd $TOOLS_DIR
git clone https://github.com/soedinglab/MMseqs2.git mmseqs
cd mmseqs
mkdir build 
cd build 
cmake .. -DCMAKE_BUILD_TYPE=RELEASE 
make 
export PATH=$(pwd)/bin

# fetch and install HMMER
cd $TOOLS_DIR 
wget http://eddylab.org/software/hmmer/hmmer.tar.gz
tar zxf hmmer.tar.gz
cd hmmer-3.3.2
./configure --prefix /your/install/path
make

# install EASEL
cd easel
make install


