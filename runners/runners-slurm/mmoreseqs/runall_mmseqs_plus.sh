NUM_ARGS=$#
MY_ID=$1

if (( $NUM_ARGS < 1 ))
then 
	echo "Usage: <my_id>"
	exit
fi

# test several alpha/betas
ALPHAS=(8 10 12 14)
BETAS=(0 4 8)
GAMMAS=(5)

# test single
#ALPHAS=(12)
#BETAS=(4)

for ALPHA in ${ALPHAS[@]}
do
	for BETA in ${BETAS[@]}
	do
		BETA_TOTAL=$((ALPHA + BETA))
		GAMMA=5

		echo "sbatch run_mmseqs_plus.sh $MY_ID $ALPHA $BETA_TOTAL $GAMMA"
		sbatch sbatch_mmseqs_plus.sh $MY_ID $ALPHA $BETA_TOTAL $GAMMA
	done
done 

