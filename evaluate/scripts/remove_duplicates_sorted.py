#!
#########################################################################
#   NAME:	eval_profmark.py
#   DESC: 	
########################################################################

import os, sys

# commandline args
if len(sys.argv) == 3:
	in_file = sys.argv[1]
	out_file = sys.argv[2]
else:
	print("# Usage: <in:m3_file> <out:m3t_file")
	sys.exit()


#######################################################################################################
################################               MAIN             #######################################
#######################################################################################################

in_fp = open(in_file, "r")
out_fp = open(out_file, "w")

print("# in_file: {}".format(in_file))
print("# out_file: {}".format(out_file))

truths = {}
# commented and exception counts
truths["#"] = 0
truths["X"] = 0
truths["D"] = 0

prv_query = ""
prv_target = ""

line_count = 0

for line in in_fp:
	
	line_count += 1
	if line_count % 1000 == 0:
		print("# line: {}".format(line_count))

	try:
		# ignore comment lines
		if line.startswith("#"):
			truths["#"] += 1
			continue
		line = line.strip()
		fields = line.split()

		query = fields[0]
		target = fields[1]

		if (query == prv_query) and (target == prv_target):
			truths["D"] += 1
			print("Dupes found on line: {}, dupes: ({},{})".format(line_count, query, target))
		else:
			out_fp.write("{}\n".format(line))
		
		prv_query = query
		prv_target = target
	except:
		print("ERROR: Exception occurred on line: {}".format(line_count))
		print("LINE: {}".format(line))
		truths["X"] += 1

in_fp.close()
out_fp.close()

print("# EVAL COMPLETED.")

print("# DUPES: {}".format(truths["D"]))
print("#")
print("# LINE ERRORS: {}".format(truths["X"]))
print("# COMMENTS: {}".format(truths["#"]))
print("# LINE_COUNT: {}".format(line_count))

print("# [ok.]")

