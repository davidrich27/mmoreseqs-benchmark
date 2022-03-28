#!/bin/bash
#####################################################################################
# NAME: set-env_cluster.sh
# DESC: For use with SLURM job scripts. 
#		Sets the environmental variables specific to cluster.
#####################################################################################

# ==> functions <==

# ==> main <==

# determine which cluster we are on:
# MTech
if [[ $HOSTNAME == "oredigger.domain" ]]
then
	MY_HOST="mtech"
fi

# Griz
if [[ $HOSTNAME == "griz.gscc.umt.edu" ]] 
then
	MY_HOST="griz"
fi

# set variables
# Mtech
if [[ $MY_HOST == "mtech" ]]
then
	TOOLS=/data1/um/drich/tools/
	PARTITION="normal"
fi
# Griz
if [[ $MY_HOST == "griz" ]]
then
	TOOLS=/home/dr120778/tools/
	PARTITION="wheeler_lab_large_cpu"
fi

