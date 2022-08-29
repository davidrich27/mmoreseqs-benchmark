#!/usr/bin/env python
###############################################################################
#  FILE:	grab_fasta.py
#  DESC:  Grab fasta entry from fasta file by name.
###############################################################################

import sys

# parse command line args
if len(sys.argv) == 3:
    filename = sys.argv[1]
    grep = sys.argv[2]
else:
    print("# Usage: <fasta_file> <seq_name>")
    sys.exit()

# checks if currently in desired fasta
in_hmm = False
line_cnt = 1
grep_file = grep.replace(".", "/")

#print("Searching for {} in {}...".format(grep, filename))

# open fasta
with open(filename, 'r') as f:
    line = f.readline()
    while line:

        if in_hmm:
            if line.startswith(">"):
                sys.exit()
            print(line, end="")
            pass

        if not in_hmm:
            if line.startswith(">"):
                #print(line_cnt, sp_line[len(sp_line)-1])
                if grep in line:
                    in_hmm = True
                    print(line, end="")
                pass

        prev_line = line
        line = f.readline()

        line_cnt += 1
        # if (line_cnt % 500 == 0):
        #print('line', line_cnt)
        # pass
