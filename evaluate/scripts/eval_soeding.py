#!
#########################################################################
#   NAME:	eval_soeding.py
#   DESC: 	
########################################################################

import os, sys

# load names file
def load_names( filename ):
    # dictionaries
    name2id = {}
    id2name = {}
    # open .names file
    fp  = open(filename, "r")
    for line in fp:
        # parse fields
        fields = line.split()
        myid    = fields[0]
        myname  = fields[1]
        # add to dicts
        name2id[myname]     = myid
        id2name[myid]       = myname
    # close file
    fp.close()
    return name2id

# load negative names list 
def load_negatives_list( file_in ):
	neg_list = []
	# input file 
	fp = open(file_in, "r")
	# read file
	for line in fp:
		# ignore comment lines 
		if line.startswith("#"):
			continue
		line.strip()
		fields = line.split()
		name = fields[1]
		neg_list.append(name)
	
	neg_list = set(neg_list)
	return neg_list

# load truth table
def load_truth_tbl( file_in ):
    truth_tbl = {}
    # input file
    fp = open(file_in, "r")
    # read file
    for line in fp:
        # ignore comment lines
        if line.startswith("#"):
            continue
        line.strip()
        sections = line.split("|")
        # first section
        q_sec = sections[0].split()
        q_id    = q_sec[0]
        #num_t  = q_sec[1]
        truth_tbl[q_id] = []
        # second section
        t_sec = sections[1].split()
        for t_id in t_sec:
            truth_tbl[q_id].append(t_id)
        # convert list to set
        truth_tbl[q_id] = set(truth_tbl[q_id])
    fp.close()
    return truth_tbl


#######################################################################################################
################################               MAIN             #######################################
#######################################################################################################

# commandline args
if len(sys.argv) == 3:
	in_file = sys.argv[1]
	out_file = sys.argv[2]
else:
	print("Desc: Evaluate .m3 results from soeding dataset as True, False, or Unknown.")
	print("Usage: <in:m3_file> <out:m3t_file>")
	sys.exit()

print("# IN_FILE: {}".format(in_file) )
print("# OUT_FILE: {}".format(out_file) )

# location of 
script_folder 	= os.path.realpath(__file__)
#print( script_folder )
data_folder 		= "/home/dr120778/Wheeler-Labs/benchmarks/general-benchmark/db/soeding/metadata/"  
query_file 			= data_folder + "query.names"
target_pos_file 	= data_folder + "target.pos.names"
target_neg_file1 	= data_folder + "target.neg.names"
target_neg_file2 	= data_folder + "target.neg.alt.names"

truth_tbl_file 		= data_folder + "truth.tbl"

print("# load query dict...")
query_dict 		= load_names( query_file )
print("# load target positives dict...")
target_pos_dict = load_names( target_pos_file )
print("# load target negatives list (part 1)...")
target_neg_list = load_negatives_list( target_neg_file1 )
print("# load target negatives list (part 2)...")
#target_neg_list2 = load_negatives_list( target_neg_file2 )
print("# merge negatives lists...")
#target_neg_list = target_neg_list.union( target_neg_list2 )
print("# load truth table...")
truth_tbl 		= load_truth_tbl( truth_tbl_file )

in_fp = open(in_file, "r")
out_fp = open(out_file, "w")

print("# IN_FILE: {}".format(in_file))
print("# OUT_FILE: {}".format(out_file))

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

print("# evaluating results...")
for line in in_fp:
	#print(line_count, line)
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

		# if target does not start with "annotated_", it is a decoy
		if not target.startswith("annotated"):
			truth = "F"
		#elif ( target in target_neg_list ):
		#	truth = "F"
		else:
			# grab query and target ids for referencing truth table
			q_id = query_dict[query]
			t_id = target_pos_dict[target]
			# if {q_id,t_id} exist in truth table, then its a match
			if t_id in truth_tbl[q_id]: 
				truth = "T"
			# otherwise we have two real sequences that have no known relation, so unknown
			else:
				truth = "?"

		out_fp.write("{} {}\n".format(line, truth))
		truths[truth] += 1
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

