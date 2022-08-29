#!/usr/bin/env python
#####################################################################
#  FILE:  hmm_getby.py
#  DESC:  Get all hmm's from hmm file by queries such as <index>
#####################################################################

import sys

# flag parsers
arg_flags = {
    "--name": "Name",
    "--length": "Length",
    "--index": "Index",
    "--range": "Range",
    "--limit": "Limit"
}
arg_terms = {
    "Name": [],
    "Length": [],
    "Index": [],
    "Range": [],
    "Limit": []
}

if len(sys.argv) < 2:
    print("Usage: <hmm_file>")
    sys.exit(0)

if sys.argv[1] == "--help":
    print("hmm_get.py: Get individual hmm models from a hmm model by one of the following queries:")
    for flag in arg_flags.keys():
        print("{}: \t<{}>".format(flag, arg_flags[flag]))
    sys.exit(0)

# required argument
filename = sys.argv[1]

i = 2
# print(sys.argv)

# parse commandline args
while (i < len(sys.argv)):
    flag = sys.argv[i]
    #print('flag=', flag, 'i=', i)
    #print('arg_flags_keys=', arg_flags.keys() )
    if flag == '--range':
        key = arg_flags[flag]
        i += 1
        while (i < len(sys.argv)):
            arg = sys.argv[i]
            if not (arg.startswith("-")):
                args = arg.split(",")
                if len(args) == 2:
                    begin = int(args[0])
                    end = int(args[1])
                    for i in range(begin, end+1):
                        arg_terms["Index"].append(i)
                else:
                    print("Error: range must be of form begin,end")
                    sys.exit(1)
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
    else:
        print("Error: {} is not a valid flag").format(flag)
        sys.exit(1)
    pass

# convert all indices to ints and sort
for i in range(len(arg_terms["Index"])):
    arg_terms["Index"][i] = int(arg_terms["Index"][i])
set(arg_terms["Index"])

# print args
# print("# ARGS:", arg_terms)
# sys.exit(0)

# checks if currently in desired hmm
in_header = True
in_hmm = False
keep_hmm = False
line_cnt = 0
hmm_cnt = 0
kept_model = 0
# data
data = []

# set minimum length
MAX = 10000000
if len(arg_terms["Length"]) > 0:
    min_length = int(arg_terms["Length"][0])
else:
    min_length = 0
# set maximum length
if len(arg_terms["Length"]) > 1:
    max_length = int(arg_terms["Length"][1])
else:
    max_length = MAX
# set keep limit
if len(arg_terms["Limit"]) > 0:
    keep_limit = int(arg_terms["Limit"][0])
else:
    keep_limit = MAX

# open hmm or fasta
with open(filename, 'r') as f:
    line = f.readline()
    while line:

        if not in_hmm:
            if line.startswith("HMMER3/f"):
                in_header = True
                keep_hmm = False
                data.append(line)
                line = f.readline()

                # if hmm in index range
                if hmm_cnt in arg_terms["Index"]:
                    keep_hmm = True
            pass

        if in_header:
            data.append(line)
            fields = line.split()

            if fields[0] == "NAME":
                if fields[1] in arg_terms["Name"]:
                    keep_hmm = True

            if fields[0] == "LENG" and len(arg_terms["Length"]) > 0:
                length = int(fields[1])
                # print("# COMPARE: hmm-len=", length, " term-len=", min_length)
                if length >= min_length and length <= max_length:
                    keep_hmm = True

            # HMM marks the end of the header and the beginning of the model
            if fields[0] == "HMM":
                in_header = False
                in_hmm = True

                # if we want to report the given hmm, output header
                if keep_hmm == True:
                    for line in data:
                        print(line, end="")
                    data = []
                    line = f.readline()
                    kept_model += 1
            pass

        if in_hmm:
            # only print every line if we are going to keep hmm
            if keep_hmm == True:
                print(line, end="")
                pass

            # // marks end of current hmm
            if line.startswith("//"):
                in_header = True
                in_hmm = False
                # print("# hmm_index: ", hmm_cnt)
                hmm_cnt += 1
                data = []
                # if we've reached the maximum number of limits
                if kept_model >= keep_limit:
                    sys.exit(0)
                pass

        line = f.readline()
        # print("# line_cnt: ", line_cnt)
        line_cnt += 1
