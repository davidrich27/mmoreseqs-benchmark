#!/usr/bin/env python
##########################################################################
#   NAME:  
#   DESC:
##########################################################################

import numpy as np
import os,sys

script_name = os.path.basename(__file__)

if len(sys.argv) != 2:
	print("Usage: python {} <results_file>".format(script_name))
	sys.exit(0)

infile = sys.argv[1]

query_num = 5
target_num = 9

fp = open(infile, "r")
truth = "?"

# track counts
counts = {}
counts["T"] = 0
counts["F"] = 0
counts["?"] = 0

# read file
for line in fp:
	line = line.strip()
	fields = line.split()

	query = fields[0]
	target = fields[1]
	target_root = target.split("/")[0]	

	if target_root == query:
		truth = "T"
	elif target.startswith("decoy"):
		truth = "F"
	else: 
		truth = "?"

	counts[truth] += 1
	
	print("{} {}".format(line, truth))

fp.close()

print("# TP {}".format(counts["T"]))
print("# FP {}".format(counts["F"]))
print("# ?? {}".format(counts["?"]))

