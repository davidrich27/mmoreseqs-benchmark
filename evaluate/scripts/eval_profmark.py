#!
#########################################################################
#   NAME:	eval_profmark.py
#   DESC: 	
########################################################################

import os, sys

# commandline args
if len(sys.argv) >= 3:
	in_file = sys.argv[1]
	out_file = sys.argv[2]
else:
	print("eval_profmark.py: Evaluate .m3 results from profmark dataset.")
	print("Usage: <in:m3_file> <out:m3t_file> | <query_idx,target_idx>")
	sys.exit()

# options 
query_idx = 0
target_idx = 1

if len(sys.argv) == 4:
	arg = sys.argv[3]
	arg = arg.split(",")
	query_idx = int(arg[0])
	target_idx = int(arg[1])

max_idx = max(query_idx,target_idx)

#######################################################################################################
################################               MAIN             #######################################
#######################################################################################################

in_fp = open(in_file, "r")
out_fp = open(out_file, "w")

print("# in_file: {}".format(in_file))
print("# out_file: {}".format(out_file))
print("# query_idx: {}".format(query_idx))
print("# target_idx: {}".format(target_idx))
#exit()

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
	
	# ignore comment lines
	if line.startswith("#"):
		truths["#"] += 1
		continue
	line = line.strip()
	fields = line.split()

	try:
		truth = ""

		query = fields[query_idx]
		target = fields[target_idx]

		# ensure query is not a substring of another query
		query_search = query + "/"
		
		q_name = query.split("_")[0]
		#t_name = query.split("_")[1]
	
		if target.startswith("decoy"):
			truth = "F"
		elif target.startswith(query_search):
			truth = "T"
		#elif target.find(q_name) != -1:
		#	truth = "T"
		else:
			truth = "?"

		out_fp.write("{} {}\n".format(line, truth))
		truths[truth] += 1
	except:
		print("ERROR: Exception occurred on line: {}".format(line_count))
		print("LINE: {}".format(line))
		truths["X"] += 1

		if( len(fields) >= max_idx + 1 ):
			query = fields[query_idx]
			target = fields[target_idx]
			printf("QUERY: {} | TARGET: {}".format(query, target))

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

