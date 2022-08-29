NUM_ARGS=$#
MY_ID=$1

if (( $NUM_ARGS < 1 ))
then 
	echo "Usage: <my_id>"
	exit
fi

ALPHAS=(8 10 12 14 16 18 20 22)
BETAS=(0 4 8 12)
GAMMAS=(5)

ALPHAS=(12)
BETAS=(16)

BENCHMARKS=(profmark soeding)
KSCORES=(k75 k80 k95)
OPTS=(cut all)

for ALPHA in ${ALPHAS[@]}
do
	for BETA in ${BETAS[@]}
	do 	
		sbatch sbatch_mseqs.sh $MY_ID $(
	done
done 

