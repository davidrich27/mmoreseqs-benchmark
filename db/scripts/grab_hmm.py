#!/usr/bin/env python
###############################################################################
#  FILE:	grab_hmm.py
#  DESC:  Grab hmm entry from hmm file by name.
###############################################################################

import sys

# parse command line args
if len(sys.argv) == 3:
    filename = sys.argv[1]
    grep = sys.argv[2]
else:
    print("Usage: <hmm_file> <seq_name>")
    sys.exit()

# checks if currently in desired hmm
in_hmm = False
line_cnt = 1

# open hmm
with open(filename, 'r') as f:
    line = f.readline()
    while line:

        if not in_hmm:
            if line.startswith("HMMER3/f"):
                pass
            if line.startswith("NAME"):
                sp_line = line.split("\t")
                #print(line_cnt, sp_line[len(sp_line)-1])
                if grep in sp_line[len(sp_line)-1]:
                    in_hmm = True
                    print(prev_line, end="")
                    print(line, end="")
                pass

        if in_hmm:
            print(line, end="")
            if line.startswith("//"):
                sys.exit()
            pass

        prev_line = line
        line = f.readline()

        line_cnt += 1
        # if (line_cnt % 500 == 0):
        #print('line', line_cnt)
        # pass
