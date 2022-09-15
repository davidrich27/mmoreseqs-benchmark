#!/usr/bin/env python
################################################################
#	NAME: compare_m3_scores.py
#	DESC: Compare two m3 format eval/score tables.
################################################################

import sys,os

if len(sys.argv) != 3:
	print("ERROR: Improper number of args.")
	print("Usage: <i:hmmer_file> <i:mmore_file>")
	exit(-1)

my_args = {}
my_args["hmmer_file"]
my_args["mmore_file"]

matches = {}
hmmer = 1
mmore = 2
matches[hmmer] = {}
matches[mmore] = {}

fp = open(my_args["hmmer_file"], "r")
line = fp.readline()
while line:
	

	line = fp.readline()
fp.close()

fp = open(my_args["mmore_file"], "r")
line = fp.readline()
while line:


	line = fp.readline()
fp.close()
