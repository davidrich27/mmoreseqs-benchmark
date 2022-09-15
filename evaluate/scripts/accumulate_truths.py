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
	print("# Usage: <in:m3t_file> <out:tf_file")
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
# truth counts
truths["T"] = 0
truths["F"] = 0
truths["?"] = 0

truth = "?"
line_count = 0

for line in in_fp:
	line_count += 1
	try:
		# ignore comment lines
		if line.startswith("#"):
			truths["#"] += 1
			continue
		line = line.strip()
		fields = line.split()

		query = fields[0]
		target = fields[1]
		truth = fields[3]

		truths[truth] += 1

		out_fp.write("{} {} {} {}\n".format(line, truths["T"], truths["F"], truths["?"]))
	except Exception as e:
		print("ERROR: Exception occurred on line: {}".format(line_count))
		print(e)
		print("LINE: {}".format(line))
	
		truths["X"] += 1

in_fp.close()
out_fp.close()

print("# EVAL COMPLETED.")

print("# TRUE: {}".format(truths["T"]))
print("# FALSE: {}".format(truths["F"]))
print("# UNKNOWN: {}".format(truths["?"]))
print("#")
print("# LINE ERRORS: {}".format(truths["X"]))
print("# COMMENTS: {}".format(truths["#"]))
print("# LINE_COUNT: {}".format(line_count))

print("# [ok.]")

