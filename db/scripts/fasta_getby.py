#!/usr/bin/env python
##############################################################
#  FILE:  fasta_getby.py  
#  DESC:  Extract FASTA sequences from FASTA files by query.
##############################################################

import sys
import re
#import numpy as np

##############################################################
##  MAIN  ####################################################
##############################################################

# flag parsers
arg_desc = {
	"--name": 	"<name>\t[If <name> matches the first field in description]",
	"--begin": 	"<begin>\t[If <begin> starts with the first field in description]",
	"--length": "<length>\t[If fasta sequence is longer than <length>]",
	"--index": 	"<idx_1>,<idx_2>,...\t[Using 0-index counting, return given indexes]",
	"--range": 	"<begin>,<end>\t[Using 0-index counting, get indexes inside range]",
	"--limit": 	"<limit>/t[Search does not return more than this number of sequences]"
}
arg_flags = {
	"--name": 	"Name",
	"--begin": 	"Begin",
	"--length": "Length",
	"--index": 	"Index",
	"--range": 	"Range",
	"--limit": 	"Limit"
}
arg_terms = {
	"Name": [],
	"Begin": [],
	"Length": [],
	"Index": [],
	"Range": [],
	"Limit": [] 
}
arg_types = {
	"Name": str,
	"Begin": str,
	"Length": int,
	"Index": int,
	"Range": int,
	"Limit": int
}

# check for input file and help flag
if len(sys.argv) < 2:
	print("# Usage: <hmm_file>")
	sys.exit(0)

# help info
if sys.argv[1] == "-h":
	print("# fasta_getby.py: Extract FASTA sequences from FASTA files by query.")
	print("# Usage: <hmm_file>")
	print("# Options:")
	for key in arg_flags.keys():
		print("# \t{0: <10}\t{1: <10}".format(key, arg_flags[key]))
	sys.exit(0)

# required argument
filename = sys.argv[1]

i = 2

# parse commandline args
while (i < len(sys.argv)):
	flag = sys.argv[i]
	print('# flag=', flag, 'i=', i)
	# range is special case taking two args
	if flag == '--range':
		key = arg_flags[flag]
		i += 1
		while (i < len(sys.argv)):
			arg = sys.argv[i]
			#print('# arg=', arg)
			if not (arg.startswith("-")):
				args = arg.split(",")
				if len(args) == 2:
					begin = int(args[0])
					end = int(args[1])
					for i in range(begin,end+1):
						arg_terms["Index"].append(i)
				else:
					print("ERROR: range must be of form <begin>,<end>")
					sys.exit(1)
			else:
				break
	# any other flag
	elif flag in arg_flags.keys():
		key = arg_flags[flag]
		i += 1
		while (i < len(sys.argv)):
			arg = sys.argv[i]
			if not (arg.startswith("-")):
				args = arg.split(",")
				for a in args:
					arg_terms[key].append(a)
				i += 1
			else: 
				break
	# flag is not in dict
	else:
		print("ERROR: '{}' is not a valid flag".format(flag))
		sys.exit(1)
	pass



# convert all indices to ints and sort
for i in range(len(arg_terms["Index"])):
	arg_terms["Index"][i] = int(arg_terms["Index"][i])
arg_terms["Index"] = set(arg_terms["Index"])

# print args
#print("# ARGS:", arg_terms)
#sys.exit(0)

# checks if currently in desired hmm
in_header = True
in_model = False

# accounting vars
keep_model = False
kept_models = 0
line_cnt = 0
model_cnt = -1
model_length = 0
# temporary storage for model
data = []

# get minimum length
MAX_SIZE = 10000000
if len(arg_terms["Length"]) > 0:
	min_length = int(arg_terms["Length"][0])
else:
	#min_length = np.inf
	min_length = MAX_SIZE
# get maximum length
if len(arg_terms["Length"]) > 1:
	max_length = int(arg_terms["Length"][1])
else:
	#max_length = np.inf
	max_length = MAX_SIZE

# get maximum number of models to report
if len(arg_terms["Limit"]) > 0:
	max_keep = int(arg_terms["Limit"][0])
else:
	#max_keep = np.inf
	max_keep = MAX_SIZE
#print("# max_keep", max_keep)

# open hmm or fasta
with open(filename, 'r') as f:
	line = f.readline()
	while line:
		# if at beggining of new model
		if line.startswith(">"):
			#print("BEGIN LINE:", line )
			model_cnt += 1
			# check length of model
			# print("# MODEL LENGTH", model_length)
			if model_length >= min_length and model_length <= max_length:
				keep_model = True
			# check index
			if model_cnt in arg_terms["Index"]:
				keep_model = True
			# if keeping model, print it
			if keep_model:
				kept_models += 1
				for d in data:
					print(d, end="")
				# if we hit our limit
				# print("# kept=", kept_models, ", max=", max_keep) 
				if kept_models >= max_keep:
					sys.exit(0)			
			# reset data
			keep_model = False
			model_length = 0
			data = []
			data.append(line)
			# check for name
			fields = re.split(" |>", line)
			#print(fields)
			name = fields[1]
			if name in arg_terms["Name"]:
				keep_model = True
			for prefix in arg_terms["Begin"]:
				if name.startswith(prefix):
					keep_model = True
		# if in middle of model		
		else:
			data.append(line)
			model_length += len(line) - 1

		line = f.readline()
		#print("# line_cnt: ", line_cnt)
		line_cnt += 1

model_cnt += 1
if model_cnt in arg_terms["Index"]:
	keep_model = True
if keep_model:
	kept_models += 1
	for d in data:
		print(d, end="")

		
